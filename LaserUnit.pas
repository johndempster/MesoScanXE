unit LaserUnit;
// ========================================================================
// MesoScan: Laser control module
// (c) J.Dempster, Strathclyde Institute for Pharmacy & Biomedical Sciences
// ========================================================================
// 8.07.14

interface

uses
  System.SysUtils, System.Classes, math ;

type
  TLaser = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FComPort : Integer ;
    FShutterControlLine : Integer ;
    FShutterOpen : Boolean ;
    FShutterChangeTime : Double ;
    FIntensityControlLine : Integer ;
    FVMaxIntensity : Double ;
    FIntensity : Double ;
    procedure SetIntensity( Value : double) ;
    procedure SetCOMPort( Value : Integer ) ;
  public
    { Public declarations }
    procedure GetShutterControlLines( List : TStrings ) ;
    procedure GetIntensityControlLines( List : TStrings ) ;
    procedure GetCOMPorts( List : TStrings ) ;
    procedure SetShutterOpen( Value : boolean ) ;
    Property ComPort : Integer read FCOMPort write SetComPort ;
    Property ShutterControlLine : Integer read FShutterControlLine write FShutterControlLine ;
    Property ShutterChangeTime : Double read FShutterChangeTime write FShutterChangeTime ;
    Property IntensityControlLine : Integer read FIntensityControlLine write FIntensityControlLine ;
    Property ShutterOpen : boolean read FShutterOpen write SetShutterOpen ;
    Property VMaxIntensity : Double read FVMaxIntensity write FVMaxIntensity ;
    Property Intensity : Double read FIntensity write SetIntensity ;
  end;

var
  Laser: TLaser;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses LabIOUnit;

{$R *.dfm}

procedure TLaser.DataModuleCreate(Sender: TObject);
//
// Initialisation when module created
// ----------------------------------
begin
  FCOMPort := 0 ;
  FShutterControlLine := 0 ;
  FIntensityControlLine := 0 ;
  FShutterOpen := False ;
  FShutterChangeTime := 0.5 ;
  VMaxIntensity := 5.0 ;
  FIntensity := 0.0 ;
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
     for iDev := 1 to LabIO.NumDevices do begin
         for i := 0 to 7 do begin
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
         for i := 0 to LabIO.NumDACs[iDev]-1 do begin
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
     for i := 1 to 8 do begin
         List.Add(Format('COM%d',[i])) ;
          end;
     end ;


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
     for iDev := 1 to LabIO.NumDevices do begin
         iBit := 1 ;
         for i := 0 to 7 do begin
             if iLine = FShutterControlLine then begin
                LabIO.DigOutState[iDev] := LabIO.DigOutState[iDev] and (not iBit) ;
                if FShutterOpen then LabIO.DigOutState[iDev] := LabIO.DigOutState[iDev] or iBit ;
                LabIO.WriteToDigitalOutPutPort( iDev, LabIO.DigOutState[iDev] ) ;
                end ;
             iBit := iBit*2 ;
             Inc(iLine) ;
             end;
          end;


     end;

procedure TLaser.SetIntensity( Value : double) ;
// -------------------
// Set laser intensity
// -------------------
var
    iLine,iDev,Ch : Integer ;
begin

  FIntensity := Min(Max(Value,0),100);
  if FIntensityControlLine <= 0 then Exit ;

  iLine := 1 ;
  for iDev := 1 to LabIO.NumDevices do begin
      for Ch := 0 to LabIO.NumDACs[iDev]-1 do begin
          if iLine = FIntensityControlLine then begin
             LabIO.WriteDAC( iDev, (Value*0.01)/VMaxIntensity, Ch ) ;
             end ;
          Inc(iLine) ;
          end;
      end;
  end;


procedure TLaser.SetCOMPort( Value : Integer ) ;
// --------------------------
// Set laser control COM port
// --------------------------
begin
    FCOMPort := Value ;
    end;
    end.
