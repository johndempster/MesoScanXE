unit PMTUnit;
// --------------------------------------------------
// Photomultiplier tube and integrator control module
// --------------------------------------------------
// 19.02.18
// 05.06.19 Coms work wirh SIM900 (not fully tested)

interface

uses
    System.SysUtils, System.Classes, Windows, FMX.Dialogs, math, strutils,
  Vcl.ExtCtrls,PMTComThreadUnit ;

const
  MaxPMT = 3 ;


type
  TPMT = class(TDataModule)
    Timer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FActive : Boolean         ;  // TRUE = PMTs are active

    FIntegratorType : Integer ;  // Type of integrator
    FPMTIsOpen : Boolean ;       // PMTs open for use flag
    Status : String ;         // Z stage status report
    FNumPMTs : Integer ;
    FGainVMin : double ;      // PMT control voltage (V) at minimum gain
    FGainVMax : double ;      // PMT control voltage (V) at maximum gain
//    FEnabled : Array[0..MaxPMT] of Boolean ;
    FLaserNum : Array[0..MaxPMT] of Integer ;
    FADCDevice : Integer ;    // NI device used for A/D conversion of PMT signal
    ReplyBuf : String ;       // COM channel reply message buf

    ComThread : TPMTComThread ;

    procedure SetControlPort( Value : DWord ) ;
    procedure SetIntegratorType( Value : Integer ) ;
    function GetLaserNum( Chan : Integer ) : Integer ;
    procedure SetLaserNum( Chan : Integer ; Value : Integer ) ;
    procedure SetActive( Value : Boolean ) ;
    procedure StopComThread ;

  public
    { Public declarations }
    PMTEnabled : Array[0..MaxPMT] of Boolean ;
    PMTName : Array[0..MaxPMT] of String ;
    PMTPort : Array[0..MaxPMT] of Integer ;
    PMTGain : Array[0..MaxPMT] of Double ;

    ADCGainIndex : Array[0..MaxPMT] of Integer ;
    IntegratorID : string ;

    FControlPort : DWord ;    // Control port number
    CommandList : TstringList ;  // Light Source command list
    ReplyList : TstringList ;    // Light source replies

    procedure GetADCGainList( List : TStrings ) ;
    procedure SetSIM965(
              IntegrationTime : double ) ;  // Integration time (s)

    procedure GetIntegratorTypes( List : TStrings ) ;
    procedure GetIntegratorPorts( List : TStrings ) ;
    function IntegratorPortRequired : Boolean ;

    procedure Close ;
    procedure Open ;
    procedure SetIntegrationTime( IntegrationTime : double ) ;
    Property IntegratorType : Integer read FIntegratorType  write SetIntegratorType ;
    Property ControlPort : DWORD read FControlPort write SetControlPort ;
    Property NumPMTs : Integer read FNumPMTs write FNumPMTs ;
    Property GainVMin : double read FGainVMin write FGainVMin ;
    Property GainVMax : double read FGainVMax write FGainVMax ;
    Property LaserNum[Chan : Integer] : Integer read GetLaserNum Write SetLaserNum ;
    Property ADCDevice : Integer read FADCDevice write FADCDevice ;
    Property Active : Boolean read FActive write SetActive ;
  end;

var
  PMT: TPMT;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses LabIOUnit, mmsystem;

const
    csIdle = 0 ;
    csWaitingForPosition = 1 ;
    csWaitingForCompletion = 2 ;
    itgNone = 0 ;
    itgSIM965 = 1 ;

procedure TPMT.DataModuleCreate(Sender: TObject);
// ---------------------------------------
// Initialisations when module is created
// ---------------------------------------
var
  i: Integer;
begin

    FActive := False ;
    FIntegratorType := itgNone ;
    FPMTIsOpen := False ;
    FControlPort := 0 ;
    Status := '' ;
    FNumPMTs := 1 ;
    FGainVMin := 0.5 ;
    FGainVMax := 2.5 ;
    FADCDevice := 1 ;
    ReplyBuf := '' ;
    IntegratorID := '' ;

    for i := 0 to MaxPMT do
        begin
        PMTEnabled[i] := False ;
        PMTName[i] := format('PMT%d',[i]);
        PMTPort[i] := ControlDisabled ;
        PMTGain[i] := 1.0 ;
        ADCGainIndex[i] := 0 ;
        FLaserNum[i] := 0 ;
        end;

    // Create Com thread variables
    CommandList := TStringList.Create ;
    ReplyList := TStringList.Create ;
    ComThread := Nil ;

    end;


procedure TPMT.DataModuleDestroy(Sender: TObject);
// --------------------------------
// Tidy up when module is destroyed
// --------------------------------
begin

    StopComThread ;
    CommandList.Free ;
    ReplyList.Free ;

    end;


procedure TPMT.StopComThread ;
// ------------------------
// Stop and free COM thread
// ------------------------
begin
     if ComThread = Nil Then Exit ;
     ComThread.Terminate ;
     ComThread.WaitFor ;
     FreeAndNil(ComThread);
end;


procedure TPMT.SetControlPort( Value : DWord ) ;
// ----------------
// Set Control Port
//-----------------
begin

    FControlPort := Max(Value,0) ;

    // If stage is open for use, close and re-open
    if FPMTIsOpen then
       begin
       Close ;
       Open ;
       end;
    end;


function TPMT.IntegratorPortRequired : Boolean ;
// ---------------------------------
// Integrator control port required
// ---------------------------------
begin
    case FIntegratorType of
        itgSIM965 : Result := True ;
        else Result := False ;
        end ;
    end;


procedure TPMT.Open ;
// --------------------------------------
// Open PMTs and integrator for operation
// --------------------------------------
begin

    // Close COM thread (if open)
    StopComThread ;

    IntegratorID := '' ;

    case FIntegratorType of
        itgSIM965 :
          begin
          ComThread := TPMTComThread.Create ;
          CommandList.Add( '*IDN?' ) ;
          // Enable Channels 1 - 4 for broadcasts
          CommandList.Add( format('BRER %d',[2 or 4 or 8 or 16]));
          end;
        end;

    FPMTIsOpen := True ;

    end;


procedure TPMT.GetIntegratorTypes( List : TStrings ) ;
// -----------------------------------
// Get list of supported integrators
// -----------------------------------
begin
      List.Clear ;
      List.Add('None') ;
      List.Add('SRS SIM965') ;
      end;


procedure TPMT.SetIntegratorType( Value : Integer ) ;
// ------------------------------
// Set type of PMT integrator
// ------------------------------
begin
      // Close existing stage
      Close ;
      FIntegratorType := Value ;
      // Reopen new stage
      Open ;
      end;


procedure TPMT.GetIntegratorPorts( List : TStrings ) ;
// -----------------------------------
// Get list of available control ports
// -----------------------------------
var
    i : Integer ;
begin
     List.Clear ;
     // COM ports
     List.Add('None');
     for i := 1 to 16 do List.Add(format('COM%d',[i]));
     end;


procedure TPMT.GetADCGainList( List : TStrings ) ;
// -------------------------------
// Get type of available ADC gains
// -------------------------------
var
    Gain : Integer ;
    i : Integer ;
begin
     List.Clear ;
     for i  := 0 to LabIO.NumADCVoltageRanges[FADCDevice]-1 do
         begin
         Gain := Round(LabIO.ADCVoltageRanges[FADCDevice,0]/LabIO.ADCVoltageRanges[FADCDevice,i]) ;
         List.AddObject(format('X%d',[Gain]),TObject(Gain));
         end;
    end;





procedure TPMT.Close ;
// ---------------------------
// Close down Z stage operation
// ---------------------------
begin
    // Close COM thread (if open)
    StopComThread ;
    end;



procedure TPMT.SetIntegrationTime( IntegrationTime : double ) ;
// ------------------------
// Set PMT integration time
// ------------------------
begin

    case FIntegratorType of
        itgSIM965 : SetSIM965( IntegrationTime ) ;
        end;

end;

procedure TPMT.SetSIM965(
          IntegrationTime : double ) ;  // Integration time (s)
// -----------------------
// Set SIM965 filter unit
// -----------------------
var
    Freq3dBCutOff : double ;
begin

    // Bessel filter
    CommandList.Add('BRDT "TYPE BESSEL"');
    // Low/pass
    CommandList.Add( 'BRDT "PASS LOWPASS"');
    // 12 dB roll-off
    CommandList.Add( 'BRDT "SLPE 12"');
    // DC coupling
    CommandList.Add( 'BRDT "COUP DC"');
    // Cutoff frequency
    Freq3dBCutOff := 1.0 / (2.0*pi()*(IntegrationTime/3.0)) ;
    CommandList.Add( format('BRDT "FREQ %.0f"',[Freq3dBCutOff]));

    end;


procedure TPMT.SetActive( Value : Boolean ) ;
// ------------------------------------------------------------------------
// Apply gain voltage to enabled PMTs on if Value = TRUE Min. gain if FALSE
// ------------------------------------------------------------------------
var
    i,iDev,AOCHan : Integer ;
    V : Single ;
begin
      // If PMT is enabled and an AO control port is defined,
      // apply selected gain control voltage to PMT
      for i := 0 to NumPMTs-1 do if PMTEnabled[i] and (PMTPort[i] <> ControlDisabled) then
          begin
          if Value = TRUE then V := FGainVMin + (FGainVMax - FGainVMin)*PMTGain[i]
                          else V := FGainVMin ;
          iDev := LabIO.Resource[PMTPort[i]].Device ;
          AOChan := LabIO.Resource[PMTPort[i]].StartChannel ;
          LabIO.WriteDAC(iDev,V,AOChan);
          end;
      end;


function TPMT.GetLaserNum( Chan : Integer ) : Integer ;
// -------------------------------
// Get Laser # associated with PMT
// -------------------------------
begin
    if (Chan >= 0) and (Chan <= MaxPMT) then Result := FLaserNum[Chan]
                                        else Result := 0 ;
    end;


procedure TPMT.SetLaserNum( Chan : Integer ; Value : Integer ) ;
// -------------------------------
// Set Laser # associated with PMT
// -------------------------------
begin
    if (Chan >= 0) and (Chan <= MaxPMT) then FLaserNum[Chan] := Value ;
    end;



end.
