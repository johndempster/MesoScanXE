unit PMTUnit;
// --------------------------------------------------
// Photomultiplier tube and integrator control module
// --------------------------------------------------
// 19.02.18

interface

uses
    System.SysUtils, System.Classes, Windows, FMX.Dialogs, math, strutils ;

const
  MaxPMT = 3 ;
  // Com port control flags
  dcb_Binary = $00000001;
  dcb_ParityCheck = $00000002;
  dcb_OutxCtsFlow = $00000004;
  dcb_OutxDsrFlow = $00000008;
  dcb_DtrControlMask = $00000030;
  dcb_DtrControlDisable = $00000000;
  dcb_DtrControlEnable = $00000010;
  dcb_DtrControlHandshake = $00000020;
  dcb_DsrSensivity = $00000040;
  dcb_TXContinueOnXoff = $00000080;
  dcb_OutX = $00000100;
  dcb_InX = $00000200;
  dcb_ErrorChar = $00000400;
  dcb_NullStrip = $00000800;
  dcb_RtsControlMask = $00003000;
  dcb_RtsControlDisable = $00000000;
  dcb_RtsControlEnable = $00001000;
  dcb_RtsControlHandshake = $00002000;
  dcb_RtsControlToggle = $00003000;
  dcb_AbortOnError = $00004000;
  dcb_Reserveds = $FFFF8000;
  CoolLEDRequestWavelengthsAtTick = 10 ;


type
  TPMT = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FActive : Boolean         ;  // TRUE = PMTs are active
    FIntegratorType : Integer ;  // Type of integrator
    ComHandle : THandle ;     // Com port handle
    ComPortOpen : Boolean ;   // Com port open flag
    FControlPort : DWord ;    // Control port number
    FBaudRate : DWord ;       // Com port baud rate
    ControlState : Integer ;  // Z stage control state
    ComFailed : Boolean ;
    Status : String ;         // Z stage status report
    FNumPMTs : Integer ;
    FGainVMin : double ;      // PMT control voltage (V) at minimum gain
    FGainVMax : double ;      // PMT control voltage (V) at maximum gain
    FEnabled : Array[0..MaxPMT] of Boolean ;
    FLaserNum : Array[0..MaxPMT] of Integer ;
    FADCDevice : Integer ;    // NI device used for A/D conversion of PMT signal


    OverLapStructure : POVERLAPPED ;

    procedure OpenCOMPort ;
    procedure CloseCOMPort ;
    procedure ResetCOMPort ;
    function SendCommand( const Line : string ) : Boolean ;
    function ReceiveBytes( var EndOfLine : Boolean ) : string ;
    procedure SetControlPort( Value : DWord ) ;
    procedure SetBaudRate( Value : DWord ) ;
    procedure SetIntegratorType( Value : Integer ) ;
    procedure WaitforCompletion ;
    function WaitforResponse(
             ResponseRequired : string
             ) : Boolean ;
    function GetLaserNum( Chan : Integer ) : Integer ;
    procedure SetLaserNum( Chan : Integer ; Value : Integer ) ;
    procedure SetActive( Value : Boolean ) ;

  public
    { Public declarations }
    PMTEnabled : Array[0..MaxPMT] of Boolean ;
    PMTName : Array[0..MaxPMT] of String ;
    PMTPort : Array[0..MaxPMT] of Integer ;
    PMTGain : Array[0..MaxPMT] of Double ;

    ADCGainIndex : Array[0..MaxPMT] of Integer ;
    procedure GetADCGainList( List : TStrings ) ;
    procedure SetSIM965(
              iChan : Integer ;             // Filter channel
              IntegrationTime : double ) ;  // Integration time (s)

    procedure GetIntegratorTypes( List : TStrings ) ;
    procedure Close ;
    procedure Open ;
    procedure SetIntegrationTime( IntegrationTime : double ) ;
    property IntegratorType : Integer read FIntegratorType write SetIntegratorType ;
    Property ControlPort : DWORD read FControlPort write SetControlPort ;
    Property BaudRate : DWORD read FBaudRate write SetBaudRate ;
    Property NumPMTs : Integer read FNumPMTs write FNumPMTs ;
    Property GainVMin : double read FGainVMax write FGainVMax ;
    Property GainVMax : double read FGainVMin write FGainVMin ;
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
    ComPortOpen := False ;
    FControlPort := 0 ;
    FBaudRate := 9600 ;
    Status := '' ;
    FNumPMTs := 1 ;
    FGainVMin := 0.5 ;
    FGainVMax := 2.5 ;
    FADCDevice := 1 ;
    ComFailed := False ;

    for i := 0 to MaxPMT do
        begin
        FEnabled[i] := False ;
        PMTName[i] := format('PMT%d',[i]);
        PMTPort[i] := ControlDisabled ;
        PMTGain[i] := 1.0 ;
        ADCGainIndex[i] := 0 ;
        FLaserNum[i] := 0 ;
        end;

    end;


procedure TPMT.Open ;
// --------------------------------------
// Open PMTs and integrator for operation
// --------------------------------------
begin

    // Close COM port (if open)
    if ComPortOpen then CloseComPort ;

    case FIntegratorType of
        itgSIM965 :
          begin
          OpenComPort ;
          S :=
          end;
        end;
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


procedure TPMT.OpenCOMPort ;
// ----------------------------------------
// Establish communications with COM port
// ----------------------------------------
var
   DCB : TDCB ;           { Device control block for COM port }
   CommTimeouts : TCommTimeouts ;
begin

     if ComPortOpen then Exit ;

     { Open com port  }
     ComHandle :=  CreateFile( PCHar(format('COM%d',[FControlPort+1])),
                     GENERIC_READ or GENERIC_WRITE,
                     0,
                     Nil,
                     OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,
                     0) ;

     if Integer(ComHandle) < 0 then
        begin
        ComPortOpen := False ;
        ShowMessage(format('CoolLED: Unable to open serial port: COM%d',[FControlPort+1]));
        Exit ;
        end;

     { Get current state of COM port and fill device control block }
     GetCommState( ComHandle, DCB ) ;
     { Change settings to those required for CoolLED }
     DCB.BaudRate := CBR_9600 ;
     DCB.ByteSize := 8 ;
     DCB.Parity := NOPARITY ;
     DCB.StopBits := ONESTOPBIT ;
     // Settings required to activate remote mode of CoolLED
     DCB.Flags := dcb_Binary or dcb_DtrControlEnable or dcb_RtsControlEnable ;

     { Update COM port }
     SetCommState( ComHandle, DCB ) ;

     { Initialise Com port and set size of transmit/receive buffers }
     SetupComm( ComHandle, 4096, 4096 ) ;

     { Set Com port timeouts }
     GetCommTimeouts( ComHandle, CommTimeouts ) ;
     CommTimeouts.ReadIntervalTimeout := $FFFFFFFF ;
     CommTimeouts.ReadTotalTimeoutMultiplier := 0 ;
     CommTimeouts.ReadTotalTimeoutConstant := 0 ;
     CommTimeouts.WriteTotalTimeoutMultiplier := 0 ;
     CommTimeouts.WriteTotalTimeoutConstant := 5000 ;
     SetCommTimeouts( ComHandle, CommTimeouts ) ;

     ComPortOpen := True ;
      Status := '' ;
    ControlState := csIdle ;
    ComFailed := False ;

    end ;


procedure TPMT.ResetCOMPort ;
// --------------------------
// Reset COM port (if in use)
// --------------------------
begin
    case FIntegratorType of
        itgSIM965 :
          begin
          if ComPortOpen then
             begin
             CloseComPort ;
             OpenComPort ;
             end;
          end;
        end;
    end;


procedure TPMT.SetControlPort( Value : DWord ) ;
// ----------------
// Set Control Port
//-----------------
begin
    FControlPort := Max(Value,0) ;
    ResetCOMPort ;
    end;


procedure TPMT.SetBaudRate( Value : DWord ) ;
// ----------------------
// Set com Port baud rate
//-----------------------
begin
    if Value <= 0 then Exit ;
    FBaudRate := Value ;
    ResetCOMPort ;
    end;


procedure TPMT.Close ;
// ---------------------------
// Close down Z stage operation
// ---------------------------
begin
    if ComPortOpen then CloseComPort ;
    end;


procedure TPMT.CloseCOMPort ;
// ----------------------
// Close serial COM port
// ----------------------
begin
     if ComPortOpen then CloseHandle( ComHandle ) ;
     ComPortOpen := False ;
     end ;

function TPMT.SendCommand(
          const Line : string   { Text to be sent to Com port }
          ) : Boolean ;
{ --------------------------------------
  Write a line of ASCII text to Com port
  --------------------------------------}
var
   i : Integer ;
   nWritten,nC : DWORD ;
   xBuf : array[0..258] of ansichar ;
   Overlapped : Pointer ;
   OK : Boolean ;
begin

     Result := False ;
     if not ComPortOpen then Exit ;
     if ComFailed then Exit ;

     { Copy command line to be sent to xMit buffer and and a CR character }
     nC := Length(Line) ;
     for i := 1 to nC do xBuf[i-1] := ANSIChar(Line[i]) ;
     xBuf[nC] := #13 ;
     Inc(nC) ;

    Overlapped := Nil ;
    OK := WriteFile( ComHandle, xBuf, nC, nWritten, Overlapped ) ;
    if (not OK) or (nWRitten <> nC) then
        begin
 //      ShowMessage( ' Error writing to COM port ' ) ;
        Result := False ;
        end
     else Result := True ;

     end ;


procedure TPMT.WaitforCompletion ;
var
  Status : string ;
  Timeout : Cardinal ;
  EndOfLine : Boolean ;
begin

   if not ComPortOpen then Exit ;
   TimeOut := timegettime + 5000 ;
   repeat
     Status := ReceiveBytes( EndOfLine ) ;
     Until EndOfLine or (timegettime > TimeOut) ;
     if not EndOfLine then outputDebugstring(pchar('Time out'));

     end ;


function TPMT.WaitforResponse(
         ResponseRequired : string
          ) : Boolean ;
var
  Response : string ;
  EndOfLine : Boolean ;
  Timeout : Cardinal ;
begin

   if not ComPortOpen then Exit ;

   Response := '' ;
   TimeOut := timegettime + 5000 ;
   if not ComPortOpen then Exit ;
   repeat
     Response := Response + ReceiveBytes( EndOfLine ) ;
   until EndOfLine or (TimeGetTime > TimeOut) ;

   if Response = ResponseRequired then Result := True
                                  else Result := False ;
   end ;


function TPMT.ReceiveBytes(
          var EndOfLine : Boolean
          ) : string ;          { bytes received }
{ -------------------------------------------------------
  Read bytes from Com port until a line has been received
  -------------------------------------------------------}
var
   Line : string ;
   rBuf : array[0..255] of ansichar ;
   ComState : TComStat ;
   PComState : PComStat ;
   NumBytesRead,ComError,NumRead : DWORD ;
begin

     if not ComPortOpen then Exit ;

     PComState := @ComState ;
     Line := '' ;
     rBuf[0] := ' ' ;
     NumRead := 0 ;
     EndOfLine := False ;
     Result := '' ;

     { Find out if there are any characters in receive buffer }
     ClearCommError( ComHandle, ComError, PComState )  ;

     // Read characters until CR is encountered
     while (NumRead < ComState.cbInQue) and (RBuf[0] <> #13) do
         begin
         ReadFile( ComHandle,rBuf,1,NumBytesRead,OverlapStructure ) ;
         if rBuf[0] <> #13 then Line := Line + String(rBuf[0])
                           else EndOfLine := True ;
         //outputdebugstring(pwidechar(RBuf[0]));
         Inc( NumRead ) ;
         end ;

     Result := Line ;

     end ;

procedure TPMT.SetIntegrationTime( IntegrationTime : double ) ;
// ------------------------
// Set PMT integration time
// ------------------------
var
    i : Integer ;
begin

    case FIntegratorType of
        itgSIM965 :
          begin
          for I := 1 to 4 do SetSIM965( i, IntegrationTime ) ;
          end;
        end;

end;

procedure TPMT.SetSIM965(
          iChan : Integer ;             // Filter channel
          IntegrationTime : double ) ;  // Integration time (s)
// -----------------------
// Set SIM965 filter unit
// -----------------------
var
    Freq3dBCutOff : double ;
begin
    // Filter type
    SendCommand( format('SNDT %d, "FILTER BESSEL"',[iChan]));
    // Low/pass
    SendCommand( format('SNDT %d, "PASS LOWPASS"',[iChan]));
    // roll-off
    SendCommand( format('SNDT %d, "SLOPE 12"',[iChan]));
    // AC/DC coupling
    SendCommand( format('SNDT %d, "COUP DC"',[iChan]));
    // Cutoff frequency
    Freq3dBCutOff := 1.0 / (2.0*pi()*(IntegrationTime/3.0)) ;
    SendCommand( format('SNDT %d, "FILTER FREQ %.0f"',[iChan,Freq3dBCutOff]));

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
      for i := 0 to NumPMTs-1 do if FEnabled[i] and (PMTPort[i] <> ControlDisabled) then
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
