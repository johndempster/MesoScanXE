unit ZStageUnit;
// ========================================================================
// MesoScan: Z Stage control module
// (c) J.Dempster, Strathclyde Institute for Pharmacy & Biomedical Sciences
// ========================================================================
// 7/6/12 Supports Prior OptiScan II controller

interface

uses
  System.SysUtils, System.Classes, Windows, FMX.Dialogs, math ;

type
  TZStage = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FEnabled : Boolean ;      // Z stage Enabled/disabled flag
    ComHandle : THandle ;     // Com port handle
    ComPortOpen : Boolean ;   // Com port open flag
    FComPort : DWord ;      // Com port number
    FBaudRate : DWord ;       // Com port baud rate
    ControlState : Integer ;  // Z stage control state
    Status : String ;         // Z stage status report
    MoveToRequest : Boolean ;   // Go to requested flag
    MoveToPosition : Double ;   // Position (um) to go to
    OverLapStructure : POVERLAPPED ;

    procedure OpenCOMPort ;
    procedure CloseCOMPort ;
    procedure SendCommand( const Line : string ) ;
    function ReceiveBytes( var EndOfLine : Boolean ) : string ;
    procedure SetComPort( Value : DWord ) ;
    procedure SetBaudRate( Value : DWord ) ;
    procedure SetEnabled( Value : Boolean ) ;
  public
    { Public declarations }
    ZPosition : Double ;
    StepsPerMicron : Double ;
    procedure Open ;
    procedure Close ;
    procedure UpdateZPosition ;
    procedure MoveTo( Position : Double ) ;

  published
    Property ComPort : DWORD read FComPort write SetComPort ;
    Property BaudRate : DWORD read FBaudRate write SetBaudRate ;
    Property Enabled : Boolean read FEnabled write SetEnabled ;
  end;

var
  ZStage: TZStage;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

const
    csIdle = 0 ;
    csWaitingForPosition = 1 ;
    csWaitingForCompletion = 2 ;

procedure TZStage.DataModuleCreate(Sender: TObject);
// ---------------------------------------
// Initialisations when module is created
// ---------------------------------------
begin
    FEnabled := False ;
    ComPortOpen := False ;
    FComPort := 1 ;
    FBaudRate := 9600 ;
    Status := '' ;
    ControlState := csIdle ;
    ZPosition := 0.0 ;
    StepsPerMicron := 1.0 ;
    MoveToRequest := False ;
    MoveToPosition := 0.0 ;
end;

procedure TZStage.DataModuleDestroy(Sender: TObject);
// --------------------------------
// Tidy up when module is destroyed
// --------------------------------
begin
    if ComPortOpen then CloseComPort ;
end;


procedure TZStage.Open ;
// ---------------------------
// Open Z stage for operation
// ---------------------------
begin
    if ComPortOpen then CloseComPort ;
    OpenComPort ;
end;


procedure TZStage.Close ;
// ---------------------------
// Close down Z stage operation
// ---------------------------
begin
    if ComPortOpen then CloseComPort ;
end;


procedure TZStage.OpenCOMPort ;
// ----------------------------------------
// Establish communications with COM port
// ----------------------------------------
var
   DCB : TDCB ;           { Device control block for COM port }
   CommTimeouts : TCommTimeouts ;
begin
     if ComPortOpen then Exit ;

     { Open com port  }
     ComHandle :=  CreateFile( PCHar(format('COM%d',[COMPort])),
                     GENERIC_READ or GENERIC_WRITE,
                     0,
                     Nil,
                     OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,
                     0) ;

     if ComHandle < 0 then Exit ;

     { Get current state of COM port and fill device control block }
     GetCommState( ComHandle, DCB ) ;
     { Change settings to those required for 1902 }
     DCB.BaudRate := CBR_9600 ;
     DCB.ByteSize := 8 ;
     DCB.Parity := NOPARITY ;
     DCB.StopBits := ONESTOPBIT ;

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

end ;


procedure TZStage.CloseCOMPort ;
// ----------------------
// Close serial COM port
// ----------------------
begin
     if ComPortOpen then CloseHandle( ComHandle ) ;
     ComPortOpen := False ;
     end ;

procedure TZStage.SendCommand(
          const Line : string   { Text to be sent to Com port }
          ) ;
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

     if not FEnabled then Exit ;

     { Copy command line to be sent to xMit buffer and and a CR character }
     nC := Length(Line) ;
     for i := 1 to nC do xBuf[i-1] := ANSIChar(Line[i]) ;
     xBuf[nC] := #13 ;
     Inc(nC) ;
//     xBuf[nC] := chr(10) ;
//     Inc(nC) ;

    Overlapped := Nil ;
    OK := WriteFile( ComHandle, xBuf, nC, nWritten, Overlapped ) ;
    if (not OK) or (nWRitten <> nC) then begin
        //ShowMessage( ' Error writing to COM port ' ) ;
        FEnabled := False ;
    end;
     end ;


function TZStage.ReceiveBytes(
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

     if not FEnabled then Exit ;

     PComState := @ComState ;
     Line := '' ;
     rBuf[0] := ' ' ;
     NumRead := 0 ;
     EndOfLine := False ;
     Result := '' ;

     { Find out if there are any characters in receive buffer }
     ClearCommError( ComHandle, ComError, PComState )  ;

     // Read characters until CR is encountered
     while (NumRead < ComState.cbInQue) and (RBuf[0] <> #13) do begin
         ReadFile( ComHandle,rBuf,1,NumBytesRead,OverlapStructure ) ;
         if rBuf[0] <> #13 then Line := Line + String(rBuf[0])
                           else EndOfLine := True ;
         //outputdebugstring(pwidechar(RBuf[0]));
         Inc( NumRead ) ;
     end ;

     Result := Line ;

     end ;


procedure TZStage.UpdateZPosition ;
// --------------------------
// Update position of Z stage
// --------------------------
var
    EndOfLine : Boolean ;
begin

    case ControlState of

        csIdle : begin
          if MoveToRequest then begin
             // Go to required position
             SendCommand(format('U %d',[Round((MoveToPosition-ZPosition)*StepsPerMicron)])) ;
             ControlState := csWaitingForCompletion ;
             MoveToRequest := False ;
          end
          else begin
            // Request stage position
            SendCommand( 'PZ' ) ;
            ControlState := csWaitingForPosition ;
          end ;
        end;

        csWaitingForPosition : begin
          Status := Status + ReceiveBytes( EndOfLine ) ;
          if EndOfLine then begin
             StepsPerMicron := Max(StepsPerMicron,1E-3) ;
             ZPosition := StrToInt64(Status)/StepsPerMicron ;
             Status := '' ;
             ControlState := csIdle ;
          end;
        end ;

        csWaitingForCompletion : begin
          Status := ReceiveBytes( EndOfLine ) ;
          if EndOfLine then begin
             Status := '' ;
             ControlState := csIdle ;
          end;

        end;
    end;
end;


procedure TZStage.MoveTo( Position : Double ) ;
// ----------------
// Go to Z position
// ----------------
begin
    MoveToPosition := Position ;
    MoveToRequest := True ;
end;

procedure TZStage.SetComPort( Value : DWord ) ;
// ------------
// Set Com Port
//-------------
begin
    if Value <= 0 then Exit ;
    FComPort := Value ;
    if ComPortOpen then begin
       CloseComPort ;
       OpenComPort ;
    end;
end;


procedure TZStage.SetBaudRate( Value : DWord ) ;
// ----------------------
// Set com Port baud rate
//-----------------------
begin
    if Value <= 0 then Exit ;
    FBaudRate := Value ;
    if ComPortOpen then begin
       CloseComPort ;
       OpenComPort ;
    end;
end;


procedure TZStage.SetEnabled( Value : Boolean ) ;
// ------------------------------
// Enable/disable Z stage control
//-------------------------------
begin

    FEnabled := Value ;
    if FEnabled and (not ComPortOpen) then OpenComPort
    else if (not FEnabled) and ComPortOpen then CloseComPort ;

end;


end.
