unit SettingsUnit;
// ------------------------------------
// MesoScan - Scan Settings dialog box
// ------------------------------------
// 1-6-12 MinPixelDwellTimeAdded
// 17.03.15 Scan now only set to full field when full field with changed.
// 27.06.16 Enabled property removed
// 26.10.16 Frame height/widths limited to 10-30K
// 10.05.17 ZPositionMin, ZPositionMax limits added
// 03.11.17 raw images folder can be changed by user
// 04.12.17 HRPixelSize added
// 23.01.20 CalibrationBarSize added
// 05.03.20 X and Y scale factor fields added

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ValidatedEdit, math,
  Vcl.ComCtrls, Vcl.ExtCtrls, strutils, Vcl.Samples.Spin ;

type
  TSettingsFrm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    StageTab: TPageControl;
    ScanTab: TTabSheet;
    gpCaptureImage: TGroupBox;
    Label37: TLabel;
    edHRPixelSize: TValidatedEdit;
    ScanGrp: TGroupBox;
    Label3: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    edPhaseShift: TValidatedEdit;
    edMinCyclePeriod: TValidatedEdit;
    edMinPixelDwellTime: TValidatedEdit;
    edFullFieldWidthMicrons: TValidatedEdit;
    GroupBox1: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    xscalelab: TLabel;
    Label5: TLabel;
    cbXGalvo: TComboBox;
    cbYGalvo: TComboBox;
    edXVoltsPerMicron: TValidatedEdit;
    edYVoltsPerMicron: TValidatedEdit;
    gpLiveImage: TGroupBox;
    Label4: TLabel;
    Label12: TLabel;
    edFastFrameWidth: TValidatedEdit;
    edFastFrameHeight: TValidatedEdit;
    gpIntegrator: TTabSheet;
    gpPMTs: TGroupBox;
    Label2: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    ckInvertPMTsignal: TCheckBox;
    edBlackLevel: TValidatedEdit;
    pnPMT0: TPanel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    spNumPMTs: TSpinEdit;
    pnPMT1: TPanel;
    Edit2: TEdit;
    ComboBox2: TComboBox;
    pnPMT2: TPanel;
    Edit3: TEdit;
    ComboBox3: TComboBox;
    pnPMT3: TPanel;
    Edit4: TEdit;
    ComboBox4: TComboBox;
    edPMTGainVMin: TValidatedEdit;
    edPMTGainVMax: TValidatedEdit;
    GroupBox5: TGroupBox;
    cbIntegratorType: TComboBox;
    pnIntegratorControlPort: TPanel;
    Label29: TLabel;
    cbIntegratorPort: TComboBox;
    edIntegratorID: TEdit;
    GroupBox6: TGroupBox;
    cbPMTADCPort: TComboBox;
    LasersTab: TTabSheet;
    grpLaserExternal: TGroupBox;
    Label28: TLabel;
    Label15: TLabel;
    Label7: TLabel;
    Label22: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label31: TLabel;
    edLaserShutterChangeTime: TValidatedEdit;
    ckLaserControlEnabled: TCheckBox;
    pnLaser0: TPanel;
    Edit6: TEdit;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ValidatedEdit5: TValidatedEdit;
    edMaxPower: TValidatedEdit;
    pnLaser1: TPanel;
    Edit7: TEdit;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ValidatedEdit6: TValidatedEdit;
    ValidatedEdit10: TValidatedEdit;
    pnLaser2: TPanel;
    Edit8: TEdit;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ValidatedEdit7: TValidatedEdit;
    ValidatedEdit11: TValidatedEdit;
    pnLaser3: TPanel;
    Edit9: TEdit;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ValidatedEdit8: TValidatedEdit;
    ValidatedEdit12: TValidatedEdit;
    pnLaser4: TPanel;
    Edit10: TEdit;
    ComboBox13: TComboBox;
    ComboBox14: TComboBox;
    ValidatedEdit9: TValidatedEdit;
    ValidatedEdit13: TValidatedEdit;
    spNumLasers: TSpinEdit;
    GroupBox4: TGroupBox;
    cbLaserType: TComboBox;
    pnLaserControlPort: TPanel;
    Label30: TLabel;
    cbLaserControlPort: TComboBox;
    edLaserControllerID: TEdit;
    TabSheet1: TTabSheet;
    MiscTab: TTabSheet;
    GroupBox3: TGroupBox;
    Label25: TLabel;
    Label17: TLabel;
    edImageJPath: TEdit;
    ckSaveAsMultipageTIFF: TCheckBox;
    edRawFileFolder: TEdit;
    edCalibrationBarSize: TValidatedEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label13: TLabel;
    Label8: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label23: TLabel;
    edZScaleFactor: TValidatedEdit;
    cbZStageType: TComboBox;
    edZStepTime: TValidatedEdit;
    edXScalefactor: TValidatedEdit;
    edYScaleFactor: TValidatedEdit;
    edZpositionMin: TValidatedEdit;
    edZPositionMax: TValidatedEdit;
    ControlPortPanel: TPanel;
    Label24: TLabel;
    cbZStagePort: TComboBox;
    SerialNumberPanel: TPanel;
    Label32: TLabel;
    edSerialNumber: TEdit;
    GroupBox7: TGroupBox;
    meStatus: TMemo;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure cbZStageTypeChange(Sender: TObject);
    procedure spNumPMTsChange(Sender: TObject);
    procedure spNumLasersChange(Sender: TObject);
    procedure cbLaserTypeChange(Sender: TObject);
    procedure cbIntegratorPortChange(Sender: TObject);
    procedure cbIntegratorTypeChange(Sender: TObject);
    procedure cbLaserControlPortChange(Sender: TObject);
  private
    { Private declarations }

    procedure ShowPMTPanels ;
    procedure ReadWritePMTPanel(
              Num : Integer ;
              Panel : TPanel ;
              RW : string ) ;

    procedure ShowLaserPanels ;
    procedure ReadWriteLaserPanel(
              Num : Integer ;
              Panel : TPanel ;
              RW : string ) ;


  public
    { Public declarations }
  end;

var
  SettingsFrm: TSettingsFrm;

implementation

{$R *.dfm}

uses MainUnit, ZStageUnit, LaserUnit, LabIOUnit, PMTUnit;

procedure TSettingsFrm.bCancelClick(Sender: TObject);
// ---------------------
// Cancel and close form
// ---------------------
begin
     Close
     end;

procedure TSettingsFrm.bOKClick(Sender: TObject);
// --------------------------
// Update program settings
// --------------------------
var
    i : Integer ;
begin

    MainFrm.HRPixelSize := edHRPixelSize.Value ;
    MainFrm.FastFRameWidth := Round(edFastFRameWidth.Value) ;
    MainFrm.FastFRameHeight := Round(edFastFRameHeight.Value) ;
    MainFrm.MinCyclePeriod := edMinCyclePeriod.Value ;
    MainFrm.MinPixelDwellTime := edMinPixelDwellTime.Value ;
    MainFrm.XVoltsPerMicron := edXVoltsPerMicron.Value ;
    MainFrm.YVoltsPerMicron := edYVoltsPerMicron.Value ;
    MainFrm.PhaseShift := Abs(edPhaseShift.Value) ;
    MainFrm.BlackLevel := Round(edBlackLevel.Value) ;
    MainFrm.CalibrationBarSize := edCalibrationBarSize.Value ;

    // PMTs & Integrator
    PMT.ADCDevice := cbPMTADCPort.ItemIndex ;
    PMT.IntegratorType := cbIntegratorType.ItemIndex ;
    PMT.ControlPort := cbIntegratorPort.ItemIndex ;
    PMT.NumPMTs := spNumPMTs.Value ;
    PMT.GainVMin := edPMTGainVMin.Value ;
    PMT.GainVMax := edPMTGainVMax.Value ;

    ReadWritePMTPanel( 0, pnPMT0, 'R' ) ;
    ReadWritePMTPanel( 1, pnPMT1, 'R' ) ;
    ReadWritePMTPanel( 2, pnPMT2, 'R' ) ;
    ReadWritePMTPanel( 3, pnPMT3, 'R' ) ;

    MainFrm.UpdatePMTSettings ;

    if (MainFrm.FullFieldWidthMicrons <> edFullFieldWidthMicrons.Value)then
       begin
       MainFrm.FullFieldWidthMicrons := edFullFieldWidthMicrons.Value ;
       MainFrm.SetScanZoomToFullField ;
       end;

    MainFrm.InvertPMTSignal := ckInvertPMTSignal.Checked ;

    //Laser.LaserType := cbLaserType.ItemIndex ;

    // Set laser control line menus (for external control)
    Laser.NumLasers := spNumLasers.Value ;
    ReadWriteLaserPanel( 1, pnLaser0, 'R' ) ;
    ReadWriteLaserPanel( 2, pnLaser1, 'R' ) ;
    ReadWriteLaserPanel( 3, pnLaser2, 'R' ) ;
    ReadWriteLaserPanel( 4, pnLaser3, 'R' ) ;
    ReadWriteLaserPanel( 5, pnLaser4, 'R' ) ;

    Laser.ShutterChangeTime := edLaserShutterChangeTime.Value ;

    // XY galvo control
    MainFrm.XGalvoControl := Integer(cbXGalvo.Items.Objects[cbXGalvo.ItemIndex]);
    MainFrm.YGalvoControl := Integer(cbYGalvo.Items.Objects[cbYGalvo.ItemIndex]);

    ZStage.ControlPort := cbZStagePort.ItemIndex ;
    ZStage.XScaleFactor := edXScaleFactor.Value ;
    ZStage.YScaleFactor := edYScaleFactor.Value ;
    ZStage.ZScaleFactor := edZScaleFactor.Value ;
    ZStage.ZStepTime := edZStepTime.Value ;
    ZStage.ZPositionMin := edZPositionMin.Value ;
    ZStage.ZPositionMax := edZPositionMax.Value ;

    ZStage.SerialNumber := edSerialNumber.Text ;

    MainFrm.ImageJPath := edImageJPath.Text ;
    MainFrm.SaveAsMultipageTIFF := ckSaveAsMultipageTIFF.Checked ;

    MainFrm.RawImagesFileName := edRawFileFolder.Text + '\mesoscan.raw' ;
    // Ensure no duplications of \
    for i := 1 to 3 do MainFrm.RawImagesFileName := ANSIReplaceStr(  MainFrm.RawImagesFileName, '\\', '\');


    Close ;
    end;


procedure TSettingsFrm.cbIntegratorPortChange(Sender: TObject);
// -----------------------
// Integrator port changed
// -----------------------
begin
    PMT.ControlPort := cbIntegratorPort.ItemIndex ;

    edIntegratorID.Text := PMT.IntegratorID ;
    end;


procedure TSettingsFrm.cbIntegratorTypeChange(Sender: TObject);
// -----------------------
// Integrator type changed
// -----------------------
begin
    PMT.IntegratorType := cbIntegratorType.ItemIndex ;
    pnIntegratorControlPort.Visible := PMT.IntegratorPortRequired ;

    end;

procedure TSettingsFrm.cbLaserControlPortChange(Sender: TObject);
// --------------------------
// Laser control port changed
// --------------------------
begin
    Laser.ControlPort := cbLaserControlPort.ItemIndex ;
    edLaserControllerID.Text := Laser.ControllerID ;
    end;

procedure TSettingsFrm.cbLaserTypeChange(Sender: TObject);
// ------------------
// Laser type changed
// ------------------
begin
    Laser.LaserType := cbLaserType.ItemIndex ;
    pnLaserControlPort.Visible := Laser.ControlPortRequired ;
    end;


procedure TSettingsFrm.cbZStageTypeChange(Sender: TObject);
//
// Zstage type changed
//
begin
    ZStage.StageType := cbZStageType.ItemIndex ;
    ZStage.GetControlPorts(cbZStagePort.Items);
    cbZStagePort.ItemIndex := Min(Max(ZStage.ControlPort,0),cbZStagePort.Items.Count-1) ;

    edXScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edXScaleFactor.Value := ZStage.XScaleFactor ;
    edYScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edYScaleFactor.Value := ZStage.YScaleFactor ;
    edZScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edZScaleFactor.Value := ZStage.ZScaleFactor ;

    // Show optional controls
    ControlPortPanel.Visible :=  ZStage.IsControlPortRequired ;
    SerialNumberPanel.Visible :=  ZStage.IsSerialNumberRequired ;

    end;


procedure TSettingsFrm.FormShow(Sender: TObject);
// --------------------------
// Initialise form on display
// --------------------------
var
    i : Integer ;
begin

    edFastFrameWidth.Value := MainFrm.FastFrameWidth ;
    edFastFrameHeight.Value := MainFrm.FastFrameHeight ;

    edPhaseShift.Value := Abs(MainFrm.PhaseShift) ;
    edMinCyclePeriod.Value := MainFrm.MinCyclePeriod ;
    edMinPixelDwellTime.Value := MainFrm.MinPixelDwellTime ;
    edXVoltsPerMicron.Value := MainFrm.XVoltsPerMicron ;
    edYVoltsPerMicron.Value := MainFrm.YVoltsPerMicron ;
    edBlackLevel.Value := MainFrm.BlackLevel ;
    edFullFieldWidthMicrons.Value := MainFrm.FullFieldWidthMicrons ;
    ckInvertPMTSignal.Checked := MainFrm.InvertPMTSignal ;
    edHRPixelSize.Value := MainFrm.HRPixelSize ;
    edCalibrationBarSize.Value := MainFrm.CalibrationBarSize ;

    // Integrator type
    PMT.GetIntegratorTypes( cbIntegratorType.Items ) ;
    cbIntegratorType.ItemIndex := PMT.IntegratorType ;
    PMT.GetIntegratorPorts( cbIntegratorPort.Items ) ;
    cbIntegratorPort.ItemIndex := PMT.ControlPort ;
    edIntegratorID.Text := PMT.IntegratorID ;
    pnIntegratorControlPort.Visible := PMT.IntegratorPortRequired ;

    // PMT A/D input port
    LabIO.GetAIPorts( cbPMTADCPort.Items ) ;
    cbPMTADCPort.ItemIndex := Max(PMT.ADCDevice,0) ;

    spNumPMTs.MaxValue := MaxPMT + 1 ;
    spNumPMTs.Value := PMT.NumPMTs ;

    edPMTGainVMin.Value := PMT.GainVMin ;
    edPMTGainVMax.Value := PMT.GainVMax ;

    ShowPMTPanels ;
    ReadWritePMTPanel( 0, pnPMT0, 'W' ) ;
    ReadWritePMTPanel( 1, pnPMT1, 'W' ) ;
    ReadWritePMTPanel( 2, pnPMT2, 'W' ) ;
    ReadWritePMTPanel( 3, pnPMT3, 'W' ) ;

    // Laser control
    Laser.GetLaserTypes(cbLaserType.Items) ;
    cbLaserType.ItemIndex := Laser.LaserType ;
    spNumLasers.MaxValue := MaxLaser ;
    spNumLasers.Value :=  Laser.NumLasers ;
    Laser.GetCOMPorts( cbLaserControlPort.Items ) ;
    cbLaserControlPort.ItemIndex := Laser.ControlPort ;
    pnLaserControlPort.Visible := Laser.ControlPortRequired ;

    // Set laser control line menus (for external control)

    ShowLaserPanels ;
    ReadWriteLaserPanel( 1, pnLaser0, 'W' ) ;
    ReadWriteLaserPanel( 2, pnLaser1, 'W' ) ;
    ReadWriteLaserPanel( 3, pnLaser2, 'W' ) ;
    ReadWriteLaserPanel( 4, pnLaser3, 'W' ) ;
    ReadWriteLaserPanel( 5, pnLaser4, 'W' ) ;

    // Galvanometer control
    cbXGalvo.Clear ;
    LabIO.GetAOPorts(cbXGalvo.Items);
    cbXGalvo.ItemIndex := cbXGalvo.Items.IndexOfObject(Tobject(MainFrm.XGalvoControl));
    LabIO.GetAOPorts(cbYGalvo.Items);
    cbYGalvo.ItemIndex := cbYGalvo.Items.IndexOfObject(Tobject(MainFrm.YGalvoControl));

    // Z stage control
    ZStage.GetZStageTypes(cbZStageType.Items);
    cbZStageType.ItemIndex := Min(Max(ZStage.StageType,0),cbZStageType.Items.Count-1) ;

    ZStage.GetControlPorts(cbZStagePort.Items);
    cbZStagePort.ItemIndex := Min(Max(ZStage.ControlPort,0),cbZStagePort.Items.Count-1) ;

    edXScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edXScaleFactor.Value := ZStage.XScaleFactor ;
    edYScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edYScaleFactor.Value := ZStage.YScaleFactor ;
    edZScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edZScaleFactor.Value := ZStage.ZScaleFactor ;

    edZStepTime.Value := ZStage.ZStepTime ;
    edZPositionMin.Value := ZStage.ZPositionMin ;
    edZPositionMax.Value := ZStage.ZPositionMax ;

    edSerialNumber.Text := ZStage.SerialNumber ;

    edImageJPath.Text := MainFrm.ImageJPath ;
    ckSaveAsMultipageTIFF.Checked := MainFrm.SaveAsMultipageTIFF ;

    edRawFileFolder.Text := ExtractFilePath(MainFrm.RawImagesFileName) ;

    // Show optional controls
    ControlPortPanel.Visible :=  ZStage.IsControlPortRequired ;
    SerialNumberPanel.Visible :=  ZStage.IsSerialNumberRequired ;

    // Display available device list
    meStatus.Clear ;
    for i := 1 to LabIO.NumDevices do
        meStatus.Lines.Add(LabIO.DeviceName[i] + ': ' + LabIO.DeviceBoardName[i] ) ;

    end;


procedure TSettingsFrm.ReadWritePMTPanel(
          Num : Integer ;
          Panel : TPanel ;
          RW : string ) ;
// ---------------------------------
// Read PMT settings panel controls
// ---------------------------------
var
    i : Integer ;
    edName : TEdit ;
    cbPort : TComboBox ;
begin

      for i := 0 to Panel.ControlCount-1 do
          begin
          case Panel.Controls[i].Tag of
              0 : edName := TEdit(Panel.Controls[i]) ;
              1 : cbPort := TComboBox(Panel.Controls[i]) ;
              end ;
          end ;

      if ANSIContainsText( RW, 'W') then
         begin
         // Write panel
         edName.Text := PMT.PMTName[Num] ;
         LabIO.GetAOPorts( cbPort.Items ) ;
         cbPort.ItemIndex := Max(cbPort.Items.IndexofObject(TObject(PMT.PMTPort[Num])),0) ;
         end
      else begin
         // Read panel
         PMT.PMTName[Num] := edName.Text ;
         PMT.PMTPort[Num] := Integer(cbPort.Items.Objects[cbPort.ItemIndex]) ;
         end ;

      end;


procedure TSettingsFrm.ShowPMTPanels ;
// ----------------------------------
// Make installed PMT panels visible
// ----------------------------------
begin

    pnPMT0.Visible := False ;
    pnPMT1.Visible := False ;
    pnPMT2.Visible := False ;
    pnPMT3.Visible := False ;

    if spNumPMTs.Value >= 4 then pnPMT3.Visible := True ;
    if spNumPMTs.Value >= 3 then pnPMT2.Visible := True ;
    if spNumPMTs.Value >= 2 then pnPMT1.Visible := True ;
    if spNumPMTs.Value >= 1 then pnPMT0.Visible := True ;

    end;



procedure TSettingsFrm.spNumLasersChange(Sender: TObject);
// ----------------
// No. lasers changed
// ----------------
begin
    // Make installed makes visible
    ShowLaserPanels ;
    end;


procedure TSettingsFrm.spNumPMTsChange(Sender: TObject);
// ----------------
// No. PMTs changed
// ----------------
begin
    // Make installed makes visible
    ShowPMTPanels ;
    end;

procedure TSettingsFrm.ReadWriteLaserPanel(
          Num : Integer ;
          Panel : TPanel ;
          RW : string ) ;
// -----------------------------------------
// Read/write laser settings panel controls
// -----------------------------------------
var
    i : Integer ;
    edName : TEdit ;
    cbOnOffPort,cbIntensityPort : TComboBox ;
    edVMax,edMaxPower : TValidatedEdit ;
begin

      for i := 0 to Panel.ControlCount-1 do
          begin
          case Panel.Controls[i].Tag of
              0 : edName := TEdit(Panel.Controls[i]) ;
              1 : edMaxPower := TValidatedEdit(Panel.Controls[i]) ;
              2 : cbOnOffPort := TComboBox(Panel.Controls[i]) ;
              3 : cbIntensityPort := TComboBox(Panel.Controls[i]) ;
              4 : edVMax := TValidatedEdit(Panel.Controls[i]) ;
              end ;
          end ;

      if ANSIContainsText( RW, 'W') then
         begin
         // Write panel
         edName.Text := Laser.LaserName[Num] ;
         LabIO.GetPOPorts( cbOnOffPort.Items ) ;
         cbOnOffPort.ItemIndex := Max(cbOnOffPort.Items.IndexofObject(TObject(Laser.EnabledControlPort[Num])),0) ;
         LabIO.GetAOPorts( cbIntensityPort.Items ) ;
         cbIntensityPort.ItemIndex := Max(cbIntensityPort.Items.IndexofObject(TObject(Laser.IntensityControlPort[Num])),0) ;
         edVMax.Value := Laser.VMaxIntensity[Num] ;
         edMaxPower.Value := Laser.MaxPower[Num] ;
         end
      else begin
         // Read panel
         Laser.LaserName[Num] := edName.Text ;
         Laser.EnabledControlPort[Num] := Integer(cbOnOffPort.Items.Objects[cbOnOffPort.ItemIndex]) ;
         Laser.IntensityControlPort[Num] := Integer(cbIntensityPort.Items.Objects[cbIntensityPort.ItemIndex]) ;
         Laser.VMaxIntensity[Num] := edVMax.Value ;
         Laser.MaxPower[Num] := edMaxPower.Value ;
         end ;

      end;


procedure TSettingsFrm.ShowLaserPanels ;
// ----------------------------------
// Make installed laser panels visible
// ----------------------------------
begin

    pnLaser0.Visible := False ;
    pnLaser1.Visible := False ;
    pnLaser2.Visible := False ;
    pnLaser3.Visible := False ;
    pnLaser4.Visible := False ;

    if spNumLasers.Value >= 5 then pnLaser4.Visible := True ;
    if spNumLasers.Value >= 4 then pnLaser3.Visible := True ;
    if spNumLasers.Value >= 3 then pnLaser2.Visible := True ;
    if spNumLasers.Value >= 2 then pnLaser1.Visible := True ;
    if spNumLasers.Value >= 1 then pnLaser0.Visible := True ;

    end;


end.
