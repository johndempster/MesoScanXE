unit LaserUnit;
// ========================================================================
// MesoScan: Laser control module
// (c) J.Dempster, Strathclyde Institute for Pharmacy & Biomedical Sciences
// ========================================================================
// 8.07.14
// 15.02.18

interface

uses
  System.SysUtils, System.Classes, Windows, FMX.Dialogs, math, Vcl.ExtCtrls ;

const
    MaxLaser = 5 ;
    lsNone = 0 ;
    lsOBIS = 1 ;

type
  TLaser = class(TDataModule)
    Timer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }

    Initialized : Boolean ;           // Laser controller initialized
    InitCounter : Integer ;           // Initialisation state counter
    FActive : Boolean ;               // Lasers active flag
    FLaserType : Integer ;            // Type of laser unit
    FComPort : Integer ;              // Com port #
    FComHandle : THandle ;            // Com port handle
    FControlPort : DWord ;            // Control port number
    FComPortOpen : Boolean ;          // Com port open flag
    FBaudRate : DWord ;               // Com port baud rate
    ComFailed : Boolean ;             // COM port communications failed flag
    FShutterOpen : Boolean ;
    FShutterChangeTime : Double ;
    FNumLasers : Integer ;            // No. lasers in use


    Status : String ;         // Laser status report
    FControlState : Integer ;  // Laser control state
    FIntensityControlPort : Array[0..MaxLaser] of Integer ;      // Laser intensity control port
    FIntensity : Array[0..MaxLaser] of Double ;                  // Laser intensity
    FVMaxIntensity: Array[0..MaxLaser] of Double ;               // Voltage at 100% intensity
    FEnabledControlPort : Array[0..MaxLaser] of Integer ;         // Laser on/off control port
    FLaserEnabled : Array[0..MaxLaser] of Boolean ;               // Laser On/Off status
    FName : Array[0..MaxLaser] of string ;                       // Laser name
    FDescription : Array[0..MaxLaser] of string ;                // Laser description

    OverLapStructure : POVERLAPPED ;
    ReplyMessage : string ;

    procedure OpenCOMPort ;
    procedure CloseCOMPort ;
    procedure ResetCOMPort ;
    procedure SetLaserType( Value : Integer ) ;
    procedure SetControlPort( Value : DWord ) ;
    procedure SetBaudRate( Value : DWord ) ;
    procedure UpdateLasersExternal ;
    procedure OBISInitialize ;
    function SendCommand( const Line : string ) : Boolean ;
    function ReceiveBytes( var EndOfLine : Boolean ) : string ;
    function WaitForMessage : string ;
    procedure WaitforCompletion ;
    function WaitforResponse(
             ResponseRequired : string
             ) : Boolean ;
    function WaitforReply : string ;

    procedure SetIntensity(
              i : Integer ;
              Value : Double ) ;
    function GetVMaxIntensity(
             i : Integer
             ) :Double  ;
    procedure SetVMaxIntensity(
              i : Integer ;
              Value : Double ) ;
    function GetIntensity(
             i : Integer
             ) :Double  ;
    procedure SetLaserEnabled(
              i : Integer ;
              Value : Boolean ) ;
    function GetLaserEnabled(
             i : Integer
             ) : Boolean  ;
    procedure SetLaserName(
              i : Integer ;
              Value : string ) ;
    function GetLaserName(
             i : Integer
             ) : string  ;
    procedure SetIntensityControlPort(
              i : Integer ;
              Value : Integer ) ;
    function GetIntensityControlPort(
             i : Integer
             ) : Integer  ;
    procedure SetEnabledControlPort(
              i : Integer ;
              Value : Integer ) ;
    function GetEnabledControlPort(
             i : Integer
             ) : Integer  ;
    procedure SetActive( Value : Boolean ) ;

    procedure OBISSetActive( Value : Boolean ) ;

  public
    { Public declarations }
    ControllerID : String ;                       // Laser controller ID
    LaserID : Array[0..MaxLaser] of String ;      // Laser IDs
    procedure GetLaserTypes( List : TStrings ) ;
    procedure GetEnabledControlLines( List : TStrings ) ;
    procedure GetIntensityControlLines( List : TStrings ) ;
    procedure GetCOMPorts( List : TStrings ) ;
    procedure Open ;
    procedure Close ;
    procedure GetLaserList( List : TStrings ) ;
    function ControlPortRequired : Boolean ;

    Property LaserType : Integer read FLaserType write SetLaserType ;
    Property ControlPort : DWORD read FControlPort write SetControlPort ;
    Property BaudRate : DWORD read FBaudRate write SetBaudRate ;
    Property NumLasers : Integer read FNumLasers write FNumLasers ;
    Property ShutterChangeTime : Double read FShutterChangeTime write FShutterChangeTime ;
    Property IntensityControlPort[Laser : Integer] : Integer read GetIntensityControlPort write SetIntensityControlPort ;
    Property EnabledControlPort[Laser : Integer] : Integer read GetEnabledControlPort write SetEnabledControlPort ;
    Property VMaxIntensity[i : Integer] : Double read GetVMaxIntensity write SetVMaxIntensity ;
    Property Intensity[i : Integer] : Double read GetIntensity write SetIntensity ;
    Property LaserEnabled[i : Integer] : Boolean read GetLaserEnabled write SetLaserEnabled ;
    Property LaserName[i : Integer] : String read GetLaserName write SetLaserName ;
    Property Active : Boolean read FActive write SetActive ;
  end;

var
  Laser: TLaser;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses LabIOUnit, mmsystem ;

{$R *.dfm}
const

    csIdle = 0 ;
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


procedure TLaser.DataModuleCreate(Sender: TObject);
//
// Initialisation when module created
// ----------------------------------
var
    i : Integer ;
begin
  FLaserType := lsNone ;
  FCOMPort := 0 ;
  FShutterOpen := False ;
  FShutterChangeTime := 0.5 ;
  FNumLasers := 1 ;
  ComFailed := False ;
  Initialized := False ;
  InitCounter := 0 ;

  for i := 0 to MaxLaser do
      begin
      FIntensity[i] := 0.0 ;
      FLaserEnabled[i] := False ;
      if i = 0 then FName[i] := 'None'
               else FName[i] := format('Laser %d',[i]);
      FIntensityControlPort[i] := ControlDisabled ;
      FDescription[i] := '' ;
      FVMaxIntensity[i] := 5.0 ;
      end;
  end;

procedure TLaser.GetLaserTypes( List : TStrings ) ;
// ---------------------------------------
// Get list of supported laser controllers
// ---------------------------------------
begin
      List.Clear ;
      List.Add('None') ;
      List.Add('Coherent OBIS (USB)') ;
      end;


function TLaser.ControlPortRequired : Boolean ;
// ---------------------------------
// Integrator control port required
// ---------------------------------
begin
    case FLaserType of
        lsOBIS : Result := True ;
        else Result := False ;
        end ;
    end;



procedure TLaser.GetEnabledControlLines( List : TStrings ) ;
// -----------------------------------
// Get list of available control ports
// -----------------------------------
begin
     LabIO.GetPOPorts( List ) ;
     end ;


procedure TLaser.GetIntensityControlLines( List : TStrings ) ;
// -------------------------------------------
// Get list of available analogue output ports
// -------------------------------------------
begin
     LabIO.GetAOPorts( List ) ;
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



procedure TLaser.OpenCOMPort ;
// ----------------------------------------
// Establish communications with COM port
// ----------------------------------------
var
   DCB : TDCB ;           { Device control block for COM port }
   CommTimeouts : TCommTimeouts ;
begin

     if FComPortOpen then Exit ;

     ComFailed := True ;
     if FControlPort < 1 then Exit ;

     { Open com port  }
     FComHandle :=  CreateFile( PCHar(format('COM%d',[FControlPort+1])),
                     GENERIC_READ or GENERIC_WRITE,
                     0,
                     Nil,
                     OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,
                     0) ;

     if Integer(FComHandle) < 0 then
        begin
        FComPortOpen := False ;
        ShowMessage(format('OBIS: Unable to open serial port: COM%d',[FControlPort+1]));
        Exit ;
        end;

     { Get current state of COM port and fill device control block }
     GetCommState( FComHandle, DCB ) ;
     { Change settings to those required for CoolLED }
     DCB.BaudRate := CBR_9600 ;
     DCB.ByteSize := 8 ;
     DCB.Parity := NOPARITY ;
     DCB.StopBits := ONESTOPBIT ;
     // Settings required to activate remote mode of CoolLED
     DCB.Flags := dcb_Binary or dcb_DtrControlEnable or dcb_RtsControlEnable ;

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
     ComFailed := False ;
     InitCounter := 0 ;
     Initialized := False ;

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


procedure TLaser.SetIntensity(
          i : Integer ;    // Laser # (0..
          Value : Double ) ;  // Intensity (0-1.0)
// -------------------
// Set laser intensity
// -------------------
begin
     if (i < 0) and (i > MaxLaser) then Exit ;
     FIntensity[i] := Value ;
end ;


function TLaser.GetIntensity(
          i : Integer // Laser # 0..
          ) : Double ;     // Intensity (0-1.0)
// -------------------
// Get laser intensity
// -------------------
begin
     if (i >= 0) and (i <= MaxLaser) then Result := FIntensity[i]
                                         else Result := 0.0 ;
end ;


procedure TLaser.SetVMaxIntensity(
          i : Integer ;    // Laser # (0..
          Value : Double ) ;  // Intensity (0-1.0)
// --------------------------------------
// Set Voltage at maximum laser intensity
// --------------------------------------
begin
     if (i < 0) and (i > MaxLaser) then Exit ;
     FVMaxIntensity[i] := Value ;
     end ;


procedure TLaser.TimerTimer(Sender: TObject);
// -------------------
// COM Message monitor
// -------------------
begin
    case FLaserType of
        lsOBIS : OBISInitialize ;
    end;
end;


procedure TLaser.OBISInitialize ;
// ----------------------------------------------
// Handles messages received from OBIS controller
// ----------------------------------------------
var
    EndOfLine : Boolean ;
begin

      if InitCounter >= 11 then Initialized := True ;
      if Initialized then Exit ;
      if not FComPortOpen then Exit ;


      // Send command
      case InitCounter of
           0 : SendCommand('*IDN0?');
           2 : SendCommand('*IDN1?');
           4 : SendCommand('*IDN2?');
           6 : SendCommand('*IDN3?');
           8 : SendCommand('*IDN4?');
           10 : SendCommand('*IDN5?');
           end ;

      if (InitCounter and 1) = 0 then
         begin
         Inc(InitCounter) ;
         ReplyMessage := '' ;
         end
       else begin
         ReplyMessage := ReceiveBytes( EndOfLine ) ;
         if EndOfLine then
            begin
            case InitCounter of
                 0 : ControllerID := ReplyMessage ;
                 2 : LaserID[0] := ReplyMessage ;
                 4 : LaserID[1] := ReplyMessage ;
                 6 : LaserID[2] := ReplyMessage ;
                 8 : LaserID[3] := ReplyMessage ;
                 10 : LaserID[4] := ReplyMessage ;
                 end ;
            Inc(InitCounter) ;
            end;
         end;

       end;


function TLaser.GetVMaxIntensity(
          i : Integer // Laser # 0..
          ) : Double ;     // Intensity (0-1.0)
// --------------------------------------
// Get Voltage at maximum laser intensity
// --------------------------------------
begin
     if (i >= 0) and (i <= MaxLaser) then Result := FVMaxIntensity[i]
                                     else Result := 0.0 ;
     end ;


procedure TLaser.SetLaserEnabled(
          i : Integer ;    // Laser # (0..
          Value : Boolean ) ;  // True=ON,False=OFF
// -----------------
// Set laser on/off
// -----------------
begin
     if (i < 0) and (i > MaxLaser) then Exit ;
     FLaserEnabled[i] := Value ;
     end ;


function TLaser.GetLaserEnabled(
          i : Integer // Laser # 0..
          ) : Boolean ;   // True=ON,False=OFF
// ----------------------
// Get laser on/off state
// ----------------------
begin
     if (i >= 0) and (i <= MaxLaser) then Result := FLaserEnabled[i]
                                     else Result := False ;
     end ;


procedure TLaser.SetEnabledControlPort(
          i : Integer ;    // Laser # (0..
          Value : Integer ) ;  // Control line #
// -----------------------------
// Set laser on/off control port
// -----------------------------
begin
     if (i < 0) and (i > MaxLaser) then Exit ;
     FEnabledControlPort[i] := Value ;
     end ;


function TLaser.GetEnabledControlPort(
          i : Integer // Laser # 0..
          ) : Integer ;   // Control line #
// -----------------------------
// Get laser on/off control port
// -----------------------------
begin
     if (i >= 0) and (i <= MaxLaser) then Result := FEnabledControlPort[i]
                                     else Result := MaxResources ;
     end ;


procedure TLaser.SetIntensityControlPort(
          i : Integer ;    // Laser # (0..
          Value : Integer ) ;  // Control line #
// --------------------------------
// Set laser intensity control port
// --------------------------------
begin
     if (i < 0) and (i >= MaxLaser) then Exit ;
     FIntensityControlPort[i] := Value ;
     end ;


function TLaser.GetIntensityControlPort(
          i : Integer // Laser # 0..
          ) : Integer ;   // Control line #
// -----------------------------
// Get laser intensity control port
// -----------------------------
begin
     if (i >= 0) and (i <= MaxLaser) then Result := FIntensityControlPort[i]
                                     else Result := MaxResources ;
     end ;


procedure TLaser.SetLaserName(
          i : Integer ;    // Laser # (0..
          Value : string ) ;   // Name
// --------------
// Set laser name
// --------------
begin
     if (i < 0) and (i > MaxLaser) then Exit ;
     FName[i] := Value ;
     end ;


function TLaser.GetLaserName(
          i : Integer // Laser # 0..
          ) : string ;    // name
// --------------
// Get laser name
// --------------
begin
     if ((i >= 0) and (i <= MaxLaser)) then Result := FName[i]
                                       else Result := 'Error' ;
end ;


procedure TLaser.UpdateLasersExternal ;
// ----------------------------------------
// Update laser settings (external control)
// ----------------------------------------
var
    iLaser,i : Integer ;
    V : Double ;
begin

  for iLaser := 0 to MaxLaser do
      begin
      // Intensity control
      i := FIntensityControlPort[iLaser] ;
      if  i < MaxResources then
          begin
          if FLaserEnabled[iLaser] then V := FIntensity[iLaser]*VMaxIntensity[iLaser]
                                  else V := 0.0 ;
          LabIO.WriteDAC( LabIO.Resource[i].Device,V,LabIO.Resource[i].StartChannel);
          end;

      // On/off control
      if i < MaxResources then
          begin
          i := FEnabledControlPort[iLaser] ;
          LabIO.WriteBit( LabIO.Resource[i].Device,
                          FLaserEnabled[iLaser],
                          LabIO.Resource[i].StartChannel);
          end;
      end ;

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


procedure TLaser.GetLaserList( List : TStrings ) ;
// -------------------------------
// Get type of available ADC gains
// -------------------------------
var
    i : Integer ;
begin
     List.Clear ;
     for i := 0 to FNumLasers do
         begin
         List.Add( FName[i] ) ;
         end;

    end;


procedure TLaser.SetActive( Value : Boolean ) ;
// -----------------------------------------------------
// Activate/inactivate enabled lasers and set intensity
// -----------------------------------------------------
begin

    case FLaserType of
        lsOBIS : OBISSetActive(Value) ;
        end ;

    // Update external analogue and/or digital control of lasers (if ports are enabled)
    UpdateLasersExternal

    end;


procedure TLaser.OBISSetActive( Value : Boolean ) ;
// -----------------------------------------------------
// Activate/inactivate enabled OBIS lasers and set intensity
// -----------------------------------------------------
var
    i,iCode : Integer ;
    Power,MinPower,MaxPower : single ;
    s : string ;
begin

    // Set laser power
    for i := 0 to NumLasers do if FLaserEnabled[i] then
        begin
        // Get max. power
        SendCommand( format('SOUR%d:POW:LIM:HIGH',[i+1]) ) ;
        s := WaitForReply ;
        Val(s,MaxPower,iCode) ;
        // Get min. power
        SendCommand( format('SOUR%d:POW:LIM:LOW',[i+1])) ;
        s := WaitForReply ;
        Val(s,MinPower,iCode) ;
        // Set power
        Power := Max(FIntensity[i]*MaxPower,MinPower);
        SendCommand( format('SOUR%d:POW:LEV:IMM:AMPL %.2f',[i+1,Power])) ;
        WaitForResponse( 'OK' ) ;
        end;

    // Enable lasers
    for i := 0 to NumLasers do
        begin
        if FLaserEnabled[i] and Value then SendCommand( format('SOUR%d:STAT ON',[i+1]))
                                      else SendCommand( format('SOUR%d:STAT OFF',[i+1]));
        WaitForResponse( 'OK' ) ;
        end;

    end;


function TLaser.WaitforResponse(
         ResponseRequired : string
          ) : Boolean ;
var
  Response : string ;
  EndOfLine : Boolean ;
  Timeout : Cardinal ;
begin

   Result := False ;
   if not FComPortOpen then Exit ;

   Response := '' ;
   TimeOut := timegettime + 5000 ;

   repeat
     Response := Response + ReceiveBytes( EndOfLine ) ;
   until EndOfLine or (TimeGetTime > TimeOut) ;

   // Check if required response received
   if not EndOfLine then Result := False
   else if ResponseRequired = '' then Result := True
   else if Response = ResponseRequired then Result := True ;

   end ;


function TLaser.SendCommand(
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
     if not FComPortOpen then Exit ;
     if ComFailed then Exit ;

     { Copy command line to be sent to xMit buffer and and a CR character }
     nC := Length(Line) ;
     for i := 1 to nC do xBuf[i-1] := ANSIChar(Line[i]) ;
     xBuf[nC] := #13 ;
     Inc(nC) ;
     xBuf[nC] := #10 ;
     Inc(nC) ;

    Overlapped := Nil ;
    OK := WriteFile( FComHandle, xBuf, nC, nWritten, Overlapped ) ;
    if (not OK) or (nWRitten <> nC) then
        begin
 //      ShowMessage( ' Error writing to COM port ' ) ;
        Result := False ;
        end
     else Result := True ;

     end ;


procedure TLaser.WaitforCompletion ;
var
  Status : string ;
  Timeout : Cardinal ;
  EndOfLine : Boolean ;
begin

   if not FComPortOpen then Exit ;
   TimeOut := timegettime + 5000 ;
   repeat
     Status := ReceiveBytes( EndOfLine ) ;
     Until EndOfLine or (timegettime > TimeOut) ;
     if not EndOfLine then outputDebugstring(pchar('Time out'));

     end ;


function TLaser.WaitforReply : string ;
// -------------------------------
// Wait for message to be returned
// -------------------------------
var
  EndOfLine : Boolean ;
  Timeout : Cardinal ;
begin

   if not FComPortOpen then Exit ;

   Result := '' ;
   TimeOut := timegettime + 1000 ;

   repeat
     Result := Result + ReceiveBytes( EndOfLine ) ;
   until EndOfLine or (TimeGetTime > TimeOut) ;

   end ;


function TLaser.WaitForMessage : string ;
// ------------------------------
// Wait for message from COM port
// ------------------------------
var
  EndOfLine : Boolean ;
  Timeout : Cardinal ;
begin

   Result := '' ;
   if not FComPortOpen then Exit ;

   TimeOut := timegettime + 5000 ;
   repeat
     Result := Result + ReceiveBytes( EndOfLine ) ;
   until EndOfLine or (TimeGetTime > TimeOut) ;

   end ;



function TLaser.ReceiveBytes(
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

     if not FComPortOpen then Exit ;

     PComState := @ComState ;
     Line := '' ;
     rBuf[0] := ' ' ;
     NumRead := 0 ;
     EndOfLine := False ;
     Result := '' ;

     { Find out if there are any characters in receive buffer }
     ClearCommError( FComHandle, ComError, PComState )  ;

     // Read characters until CR is encountered
     while (NumRead < ComState.cbInQue) and (RBuf[0] <> #13) do
         begin
         ReadFile( FComHandle,rBuf,1,NumBytesRead,OverlapStructure ) ;
         if rBuf[0] <> #13 then Line := Line + String(rBuf[0])
                           else EndOfLine := True ;
         //outputdebugstring(pwidechar(RBuf[0]));
         Inc( NumRead ) ;
         end ;

     Result := Line ;

     end ;



    end.
