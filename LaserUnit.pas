unit LaserUnit;
// ========================================================================
// MesoScan: Laser control module
// (c) J.Dempster, Strathclyde Institute for Pharmacy & Biomedical Sciences
// ========================================================================
// 8.07.14
// 15.02.18
// 02.10.18 Now uses LaserComThead for COM port message handling
// 24.06.19 OBIS laser control working but not completely tested
//          .Changed and .Initialised properties added
// 18.12.19 .Active flag now set correctly when .Active set to TRUE

interface

uses
  System.SysUtils, System.Classes, Windows, FMX.Dialogs, math, Vcl.ExtCtrls, LaserComThreadUnit ;

const
    MaxLaser = 5 ;
    lsNone = 0 ;
    lsOBIS = 1 ;

type
  TLaser = class(TDataModule)
    Timer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FInitialised : Boolean ;          // TRUR = initialisation complete
    InitState : Integer ;             // Initialisation state counter
    FChanged : Boolean ;              // Available lasers changed
    FActive : Boolean ;               // Lasers active flag
    FLaserType : Integer ;            // Type of laser unit

    FBaudRate : DWord ;               // Com port baud rate
    ComFailed : Boolean ;             // COM port communications failed flag
    FShutterOpen : Boolean ;
    FShutterChangeTime : Double ;
    FNumLasers : Integer ;            // No. lasers in use


    FName : Array[0..MaxLaser] of string ;                       // Laser name
    FIntensityControlPort : Array[0..MaxLaser] of Integer ;      // Laser intensity control port
    FIntensity : Array[0..MaxLaser] of Double ;                  // Laser intensity
    FVMaxIntensity: Array[0..MaxLaser] of Double ;               // Voltage at 100% intensity
    FMaxPower: Array[0..MaxLaser] of Double ;                    // Max. laser power (mW)
    FEnabledControlPort : Array[0..MaxLaser] of Integer ;         // Laser on/off control port
    FLaserEnabled : Array[0..MaxLaser] of Boolean ;               // Laser On/Off status

    FDescription : Array[0..MaxLaser] of string ;                // Laser description
    FLaserNum : Array[0..MaxLaser] of Integer ;                  // Laser ID number
    LaserNum : Integer ;
    FLaserCount : Integer ;                                       // No. of lasers detected

    ComThread : LaserComThread ;

    procedure SetLaserType( Value : Integer ) ;
    procedure SetControlPort( Value : DWord ) ;
    procedure SetBaudRate( Value : DWord ) ;
    procedure UpdateLasersExternal ;
    procedure OBISInitialize ;

    procedure SetIntensity(
              i : Integer ;
              Value : Double ) ;
    function GetIntensity(
             i : Integer
             ) :Double  ;

    function GetVMaxIntensity( i : Integer ) :Double  ;
    procedure SetVMaxIntensity( i : Integer ; Value : Double ) ;

    procedure SetLaserEnabled( i : Integer ; Value : Boolean ) ;
    function GetLaserEnabled( i : Integer) : Boolean  ;

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

    function GetMaxPower(i : Integer ) :Double  ;
    procedure SetMaxPower( i : Integer ; Value : Double ) ;

    procedure SetActive( Value : Boolean ) ;

    procedure OBISSetActive( Value : Boolean ) ;

  public
    { Public declarations }
    ControllerID : String ;                       // Laser controller ID                                   tive
    LaserID : Array[0..MaxLaser] of String ;      // Laser IDs
    CommandList : TstringList ;
    ReplyList : TstringList ;
//    FComPort : Integer ;              // Com port #
    FControlPort : DWord ;            // Control port number

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
    Property MaxPower[i : Integer] : Double read GetMaxPower write SetMaxPower ;
    Property Active : Boolean read FActive write SetActive ;
    Property Initialised : Boolean read FInitialised ;
    Property Changed : Boolean read FChanged write FChanged ;

  end;

var
  Laser: TLaser;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses LabIOUnit, mmsystem, strutils ;

{$R *.dfm}
const

    csIdle = 0 ;


procedure TLaser.DataModuleCreate(Sender: TObject);
// ----------------------------------
// Initialisation when module created
// ----------------------------------
var
    i : Integer ;
begin
  FLaserType := lsNone ;
  //FCOMPort := 0 ;
  FControlPort := 0 ;
  FShutterOpen := False ;
  FShutterChangeTime := 0.5 ;
  FNumLasers := 0 ;
  ComFailed := False ;
  InitState := 0 ;
  FInitialised := False ;
  FChanged := False ;

  for i := 0 to MaxLaser do
      begin
      FIntensity[i] := 0.0 ;
      FLaserEnabled[i] := False ;
      if i = 0 then FName[i] := 'None'
               else FName[i] := format('Laser %d',[i]);
      FIntensityControlPort[i] := ControlDisabled ;
      FDescription[i] := '' ;
      FVMaxIntensity[i] := 5.0 ;
      FMaxPower[i] := 0.0 ;
      FLaserNum[i] := 0 ;
      end;

  CommandList := TStringList.Create ;
  ReplyList := TStringList.Create ;
  ComThread := Nil ;

  end;

procedure TLaser.DataModuleDestroy(Sender: TObject);
// ---------------------------
// Tidy up when form destroyed
// ---------------------------
begin
  CommandList.Free ;
  ReplyList.Free ;
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
    if ComThread <> Nil then FreeAndNil(ComThread); ;

    // Open com port (if required)
    case FLaserType of
        lsOBIS :
          begin
          ComThread := LaserComThread.Create ;
          InitState := 0 ;
          FInitialised := False ;
          FLaserCount := 0 ;
//          FNumLasers := 0 ;
          end ;
        else FInitialised := True ;
        end;

    FChanged := True ;
    end;


procedure TLaser.Close ;
// ---------------------------
// Close down laser controller
// ---------------------------
begin
    if ComThread <> Nil then FreeAndNil(ComThread);
    end;


procedure TLaser.SetControlPort( Value : DWord ) ;
// ----------------
// Set Control Port
//-----------------
begin
    FControlPort := Max(Value,0) ;
//    ResetCOMPort ;
    end;


procedure TLaser.SetBaudRate( Value : DWord ) ;
// ----------------------
// Set com Port baud rate
//-----------------------
begin
    if Value <= 0 then Exit ;
    FBaudRate := Value ;
//    ResetCOMPort ;
    end;


{procedure TLaser.ResetCOMPort ;
// --------------------------
// Reset COM thread (if in use)
// --------------------------
begin
    case FLaserType of
        lsOBIS :
          begin
          if ComThread <> Nil then
             begin
             FreeAndNil(ComThread);
             ComThread := LaserComThread.Create ;
             InitState := 0 ;
             FNumLasers := 0 ;
             end;
          end;
        end;
    end;    }


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

function TLaser.GetMaxPower(
          i : Integer      // Laser # 0..
          ) : Double ;     // Intensity (0-1.0)
// -------------------
// Get laser max power
// -------------------
begin
     if (i >= 0) and (i <= MaxLaser) then Result := FMaxPower[i]
                                     else Result := 0.0 ;
     end ;


procedure TLaser.SetMaxPower(
          i : Integer ;       // Laser # (0..
          Value : Double ) ;  // Max. Power (mW)
// -----------------------------
// Set maximum laser power (mW)
// -----------------------------
begin
    if (i < 0) and (i > MaxLaser) then Exit ;
    case FLaserType of
        lsNone : FMaxPower[i] := Value ;
        end;
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
const
    GetLaserNames = 0 ;
    GetLaserPowers = 1 ;
    InitRequestLaserNames = 0 ;
    InitWaitForLaserNames = 1 ;
    InitRequestLaserPowers = 2 ;
    InitWaitForLaserPowers = 3 ;
    InitDisableCDRH = 4 ;
    InitWaitForDisableCDRH = 5 ;
    InitComplete = 6 ;

var
    i0,nc,i,iCode : Integer ;
begin

//      if InitCounter >= 11 then Initialized := True ;
      if InitState >= InitComplete then
         begin
         if not FInitialised then FChanged := True ;
         FInitialised := True ;
         FNumLasers := FLaserCount ;
         Exit ;
         end;

      if ComThread = Nil then Exit ;

      case InitState of

          InitRequestLaserNames :
            begin
            // Disable 5 second CDRH compliance delay on start of laser emission
            //CommandList.Add( 'syst1:cdrh off' ) ;
            // Request names of available lasers from controller
            FLaserCount := 0 ;
            for i := 1 to 6 do CommandList.Add( format('*idn%d?',[i]));
            LaserNum := 1 ;
            InitState := InitWaitForLaserNames ;
            end;

          InitWaitForLaserNames :
            begin
            // Read laser names returned by controller
            if ReplyList.Count > 0 then
               begin
               if ContainsText(ReplyList[0],'OK') or ContainsText(ReplyList[0],'ERR') then
                  begin
                  Inc(LaserNum) ;
                  if LaserNum > 6 then InitState := InitRequestLaserPowers ;
                  end
               else
                  begin
                  Inc(FLaserCount) ;
                  LaserID[FLaserCount] := ReplyList[0] ;
                  i0 := Pos('Inc - ',ReplyList[0]) + 6 ;
                  nc := Pos(' - V',ReplyList[0]) - i0 ;
                  FName[FLaserCount] := MidStr(ReplyList[0],i0,nc);
                  FLaserNum[FLaserCount] := LaserNum ;
                  end ;
               outputdebugstring(pchar('rx: ' + ReplyList[0]));
               ReplyList.Delete(0);
               end ;
            end ;

          InitRequestLaserPowers :
            begin
            // Request laser max. powers from controller
            for i := 1 to FLaserCount do
                CommandList.Add( format('syst%d:inf:pow?',[FLaserNum[i]]));
            LaserNum := 1 ;
            InitState := InitWaitForLaserPowers ;
            end ;

          InitWaitForLaserPowers :
            if ReplyList.Count > 0 then
               begin
               // Wait for max powers returned by controller
               if ContainsText(ReplyList[0],'OK') or ContainsText(ReplyList[0],'ERR') then
                  begin
                  Inc(LaserNum) ;
                  if LaserNum > FLaserCount then InitState := InitDisableCDRH ;
                  end
               else
                  begin
                  Val(ReplyList[0],FMaxPower[LaserNum],iCode);
                  end ;
               outputdebugstring(pchar('rx: ' + ReplyList[0]));
               ReplyList.Delete(0);
               end ;

          InitDisableCDRH :
            begin
            // Disable CDRH compliance delays for lasers
            for i := 1 to FLaserCount do
                CommandList.Add( format('syst%d:cdrh off',[FLaserNum[i]]));
            LaserNum := 1 ;
            InitState := InitWaitForDisableCDRH ;
            end ;

          InitWaitForDisableCDRH :
            if ReplyList.Count > 0 then
               begin
               // Wait OK replies returned by controller
               if ContainsText(ReplyList[0],'OK') or ContainsText(ReplyList[0],'ERR') then
                  begin
                  Inc(LaserNum) ;
                  if LaserNum > FLaserCount then InitState := InitComplete ;
                  end ;
               outputdebugstring(pchar('rx: ' + ReplyList[0]));
               ReplyList.Delete(0);
               end ;


            end ;


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
     //if (i < 0) and (i > MaxLaser) then Exit ;
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
     Result := FName[i]
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
      if  (i >=0) and (i < MaxResources) then
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
// ----------------------------
// Get type of available lasers
// ----------------------------
var
    i : Integer ;
begin
    List.Clear ;
    for i := 0 to Min(FNumLasers,High(FName)) do List.Add( FName[i] ) ;
    end;


procedure TLaser.SetActive( Value : Boolean ) ;
// -----------------------------------------------------
// Activate/inactivate enabled lasers and set intensity
// -----------------------------------------------------
begin

    FActive := Value ;

    case FLaserType of
        lsOBIS : OBISSetActive(Value) ;
        end ;

    // Update external analogue and/or digital control of lasers (if ports are enabled)
    UpdateLasersExternal ;

    end;


procedure TLaser.OBISSetActive( Value : Boolean ) ;
// -----------------------------------------------------
// Activate/inactivate enabled OBIS lasers and set intensity
// -----------------------------------------------------
var
    i : Integer ;
    Power : single ;
begin

    // Set laser power
    for i := 1 to NumLasers do if FLaserEnabled[i] then
        begin
        // Set power
        Power := Min(FIntensity[i],1.0)*FMaxPower[i] ;
        CommandList.Add( format('SOUR%d:POW:LEV:IMM:AMPL %.4f',[FLaserNum[i],Power])) ;
        end;

    // Enable lasers
    for i := 1 to NumLasers do
        begin
        if FLaserEnabled[i] and Value then CommandList.Add( format('SOUR%d:AM:STAT ON',[FLaserNum[i]]))
                                      else CommandList.Add( format('SOUR%d:AM:STAT OFF',[FLaserNum[i]]));
        end;

    end;


end.
