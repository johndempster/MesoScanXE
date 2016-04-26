unit LaserUnit;
// ========================================================================
// MesoScan: Laser control module
// (c) J.Dempster, Strathclyde Institute for Pharmacy & Biomedical Sciences
// ========================================================================
// 8.07.14

interface

uses
  System.SysUtils, System.Classes, Windows, FMX.Dialogs, math ;

const
    MaxLasers = 8 ;

type
  TLaser = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FLaserType : Integer ;            // Type of laser unit
    FComPort : Integer ;              // Com port #
    FComHandle : THandle ;     // Com port handle
    FControlPort : DWord ;    // Control port number
    FComPortOpen : Boolean ;          // Com port open flag
    FBaudRate : DWord ;       // Com port baud rate
    FShutterControlLine : Integer ;
    FShutterOpen : Boolean ;
    FShutterChangeTime : Double ;
    FIntensityControlLine : Integer ;
    FVMaxIntensity : Double ;
    Status : String ;         // Laser status report
    FControlState : Integer ;  // Laser control state
    FIntensity : Array[0..MaxLasers-1] of Double ;      // Laser intensity
    FLaserActive : Array[0..MaxLasers-1] of Boolean ;       // Laser On/Off status

    procedure SetCOMPort( Value : Integer ) ;
    procedure OpenCOMPort ;
    procedure CloseCOMPort ;
    procedure ResetCOMPort ;
    procedure SetLaserType( Value : Integer ) ;
    procedure SetControlPort( Value : DWord ) ;
    procedure SetBaudRate( Value : DWord ) ;
    procedure SetIntensity(
              Laser : Integer ;
              Value : Double ) ;
    function GetIntensity(
             Laser : Integer
             ) :Double  ;
    procedure SetLaserActive(
              Laser : Integer ;
              Value : Boolean ) ;
    function GetLaserActive(
             Laser : Integer
             ) : Boolean  ;


    procedure SetIntensityExternal(
              Laser : Integer ;    // Laser # (0..
              Value : Double ) ;  // Intensity (0-1.0)

  public
    { Public declarations }
    procedure GetLaserTypes( List : TStrings ) ;
    procedure GetShutterControlLines( List : TStrings ) ;
    procedure GetIntensityControlLines( List : TStrings ) ;
    procedure GetCOMPorts( List : TStrings ) ;
    procedure Open ;
    procedure Close ;
    procedure SetShutterOpen( Value : boolean ) ;
    procedure UpdateLasers ;
    Property LaserType : Integer read FLaserType write SetLaserType ;
    Property ControlPort : DWORD read FControlPort write SetControlPort ;
    Property BaudRate : DWORD read FBaudRate write SetBaudRate ;
    Property ShutterControlLine : Integer read FShutterControlLine write FShutterControlLine ;
    Property ShutterChangeTime : Double read FShutterChangeTime write FShutterChangeTime ;
    Property IntensityControlLine : Integer read FIntensityControlLine write FIntensityControlLine ;
    Property ShutterOpen : boolean read FShutterOpen write SetShutterOpen ;
    Property VMaxIntensity : Double read FVMaxIntensity write FVMaxIntensity ;
    Property Intensity[Laser : Integer] : Double read GetIntensity write SetIntensity ;
    Property LaserActive[Laser : Integer] : Boolean read GetLaserActive write SetLaserActive ;
  end;

var
  Laser: TLaser;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses LabIOUnit;

{$R *.dfm}
const
    lsNone = 0 ;
    lsDigitalTTL  = 1 ;
    lsOBIS = 2 ;

    csIdle = 0 ;

procedure TLaser.DataModuleCreate(Sender: TObject);
//
// Initialisation when module created
// ----------------------------------
var
    i : Integer ;
begin
  FLaserType := lsNone ;
  FCOMPort := 0 ;
  FShutterControlLine := 0 ;
  FIntensityControlLine := 0 ;
  FShutterOpen := False ;
  FShutterChangeTime := 0.5 ;
  VMaxIntensity := 5.0 ;

  for i := 0 to MaxLasers-1 do
      begin
      FIntensity[i] := 0.0 ;
      FLaserActive[i] := False ;
      end;
  end;

procedure TLaser.GetLaserTypes( List : TStrings ) ;
// ---------------------------------------
// Get list of supported laser controllers
// ---------------------------------------
begin
      List.Clear ;
      List.Add('None') ;
      List.Add('External Analogue/Digital') ;
      List.Add('Coherent OBIS') ;
      end;


procedure TLaser.GetShutterControlLines( List : TStrings ) ;
// -----------------------------------
// Get list of available control ports
// -----------------------------------
var
    i : Integer ;
  iDev: Integer;
begin
     List.Clear ;
     List.Add('None') ;
     for iDev := 1 to LabIO.NumDevices do
         begin
         for i := 0 to 7 do
             begin
             List.Add(Format('Dev%d:P0.%d',[iDev,i])) ;
             end;
          end;
     end ;


procedure TLaser.GetIntensityControlLines( List : TStrings ) ;
// -----------------------------------
// Get list of available control ports
// -----------------------------------
var
    i : Integer ;
  iDev: Integer;
begin
     List.Clear ;
     List.Add('None');
     for iDev := 1 to LabIO.NumDevices do
         for i := 0 to LabIO.NumDACs[iDev]-1 do
             begin
             List.Add(Format('Dev%d:AO%d',[iDev,i])) ;
             end;
     end;


procedure TLaser.GetCOMPorts( List : TStrings ) ;
// -------------------------------
// Get list of available COM ports
// -------------------------------
var
    i : Integer ;
begin
     List.Clear ;
     List.Add('None') ;
     for i := 1 to 8 do
         begin
         List.Add(Format('COM%d',[i])) ;
         end;
     end ;


procedure TLaser.Open ;
// -----------------------------------
// Open laser controller for operation
// -----------------------------------
begin
    // Close COM port (if open)
    if FComPortOpen then CloseComPort ;

    // Open com port (if required)
    case FLaserType of
        lsOBIS :
          begin
          OpenComPort ;
          end ;
        end;
    end;

procedure TLaser.Close ;
// ---------------------------
// Close down laser controller
// ---------------------------
begin
    if FComPortOpen then CloseComPort ;
    end;


procedure  TLaser.OpenCOMPort ;
// ----------------------------------------
// Establish communications with COM port
// ----------------------------------------
var
   DCB : TDCB ;           { Device control block for COM port }
   CommTimeouts : TCommTimeouts ;
begin
     if FComPortOpen then Exit ;

     { Open com port  }
     FComHandle :=  CreateFile( PCHar(format('COM%d',[FControlPort+1])),
                     GENERIC_READ or GENERIC_WRITE,
                     0,
                     Nil,
                     OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,
                     0) ;

     if FComHandle < 0 then Exit ;

     { Get current state of COM port and fill device control block }
     GetCommState( FComHandle, DCB ) ;
     { Change settings to those required for 1902 }
     DCB.BaudRate := CBR_9600 ;
     DCB.ByteSize := 8 ;
     DCB.Parity := NOPARITY ;
     DCB.StopBits := ONESTOPBIT ;

     { Update COM port }
     SetCommState( FComHandle, DCB ) ;

     { Initialise Com port and set size of transmit/receive buffers }
     SetupComm( FComHandle, 4096, 4096 ) ;

     { Set Com port timeouts }
     GetCommTimeouts( FComHandle, CommTimeouts ) ;
     CommTimeouts.ReadIntervalTimeout := $FFFFFFFF ;
     CommTimeouts.ReadTotalTimeoutMultiplier := 0 ;
     CommTimeouts.ReadTotalTimeoutConstant := 0 ;
     CommTimeouts.WriteTotalTimeoutMultiplier := 0 ;
     CommTimeouts.WriteTotalTimeoutConstant := 5000 ;
     SetCommTimeouts( FComHandle, CommTimeouts ) ;

     FComPortOpen := True ;
      Status := '' ;
    FControlState := csIdle ;

end ;


procedure  TLaser.CloseCOMPort ;
// ----------------------
// Close serial COM port
// ----------------------
begin
     if FComPortOpen then CloseHandle( FComHandle ) ;
     FComPortOpen := False ;
end ;


procedure TLaser.SetControlPort( Value : DWord ) ;
// ----------------
// Set Control Port
//-----------------
begin
    FControlPort := Max(Value,0) ;
    ResetCOMPort ;
    end;


procedure TLaser.SetBaudRate( Value : DWord ) ;
// ----------------------
// Set com Port baud rate
//-----------------------
begin
    if Value <= 0 then Exit ;
    FBaudRate := Value ;
    ResetCOMPort ;
    end;


procedure TLaser.ResetCOMPort ;
// --------------------------
// Reset COM port (if in use)
// --------------------------
begin
    case FLaserType of
        lsOBIS :
          begin
          if FComPortOpen then
             begin
             CloseComPort ;
             OpenComPort ;
             end;
          end;
        end;
    end;


procedure TLaser.SetShutterOpen( Value : boolean ) ;
// ------------------------
// Open/close laser shutter
// ------------------------
var
    iLine,iBit,iDev,i : Integer ;
begin

     FShutterOpen := Value ;

     // Set laser intensity
     if FShutterOpen then SetIntensity( FIntensity )
                     else SetIntensity( 0.0 ) ;

     if FShutterControlLine <= 0 then Exit ;

     iLine := 1 ;
     for iDev := 1 to LabIO.NumDevices do
         begin
         iBit := 1 ;
         for i := 0 to 7 do
             begin
             if iLine = FShutterControlLine then
                begin
                LabIO.DigOutState[iDev] := LabIO.DigOutState[iDev] and (not iBit) ;
                if FShutterOpen then LabIO.DigOutState[iDev] := LabIO.DigOutState[iDev] or iBit ;
                LabIO.WriteToDigitalOutPutPort( iDev, LabIO.DigOutState[iDev] ) ;
                end ;
             iBit := iBit*2 ;
             Inc(iLine) ;
             end;
          end;

     end;

procedure TLaser.SetIntensity(
          Laser : Integer ;    // Laser # (0..
          Value : Double ) ;  // Intensity (0-1.0)
// -------------------
// Set laser intensity
// -------------------
begin
     if (Laser < 0) and (Laser >= MaxLasers) then Exit ;
     Intensity[Laser] := Value ;
     UpdateLasers ;
end ;


function TLaser.GetIntensity(
          Laser : Integer // Laser # 0..
          ) : Double ;     // Intensity (0-1.0)
// -------------------
// Get laser intensity
// -------------------
begin
     if (Laser >= 0) and (Laser < MaxLasers) then Result := Intensity[Laser]
                                             else Result := 0.0 ;
end ;


procedure TLaser.SetLaserActive(
          Laser : Integer ;    // Laser # (0..
          Value : Boolean ) ;  // True=ON,False=OFF
// -----------------
// Set laser on/off
// -----------------
begin
     if (Laser < 0) and (Laser >= MaxLasers) then Exit ;
     FLaserActive[Laser] := Value ;
     UpdateLasers ;
end ;


function TLaser.GetLaserActive(
          Laser : Integer // Laser # 0..
          ) : Boolean ;   // True=ON,False=OFF
// ----------------------
// Get laser on/off state
// ----------------------
begin
     if (Laser >= 0) and (Laser < MaxLasers) then Result := FLaserActive[Laser]
                                             else Result := 0.0 ;
end ;


procedure TLaser.UpdateLasers ;
// ---------------------
// Update laser settings
// ---------------------
begin
    case FLaserType of
//        lsOBIS :
        lsExternal : UpdateLasersExternal ;
        end;
    end;
end;

procedure TLaser.UpdateLasersExternal ;
// ----------------------------------------
// Update laser settings (external control)
var
    iLine,iDev,Ch : Integer ;
begin

  FIntensity := Min(Max(Value,0),100);
  if FIntensityControlLine <= 0 then Exit ;

  iLine := 1 ;
  for iDev := 1 to LabIO.NumDevices do
      begin
      for Ch := 0 to LabIO.NumDACs[iDev]-1 do
          begin
          if iLine = FIntensityControlLine then
             begin
             LabIO.WriteDAC( iDev, (Value*0.01)/VMaxIntensity, Ch ) ;
             end ;
          Inc(iLine) ;
          end;
      end;
  end;


procedure TLaser.SetLaserType( Value : Integer ) ;
// ----------------------------
// Set type of laser controller
// ----------------------------
begin
      // Close existing stage
      Close ;
      FLaserType := Value ;
      // Reopen new stage
      Open ;
      end;


procedure TLaser.SetCOMPort( Value : Integer ) ;
// --------------------------
// Set laser control COM port
// --------------------------
begin
    FCOMPort := Value ;
    end;
    end.
