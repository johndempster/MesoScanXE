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
    gpIntegrator: TTabSheet;
    LasersTab: TTabSheet;
    TabSheet1: TTabSheet;
    MiscTab: TTabSheet;
    ImageHRGrp: TGroupBox;
    Label1: TLabel;
    edHRFrameWidth: TValidatedEdit;
    ScanGrp: TGroupBox;
    Label3: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label24: TLabel;
    ckCorrectSineWaveDistortion: TCheckBox;
    edPhaseShift: TValidatedEdit;
    edMaxScanRate: TValidatedEdit;
    ckBidirectionalScan: TCheckBox;
    edMinPixelDwellTime: TValidatedEdit;
    edFullFieldWidthMicrons: TValidatedEdit;
    edFieldEdge: TValidatedEdit;
    Label4: TLabel;
    edFastFrameWidth: TValidatedEdit;
    Label12: TLabel;
    edFastFrameHeight: TValidatedEdit;
    gpPMTs: TGroupBox;
    Label2: TLabel;
    Label18: TLabel;
    Label23: TLabel;
    ckInvertPMTsignal: TCheckBox;
    edBlackLevel: TValidatedEdit;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    cbZStagePort: TComboBox;
    edZScaleFactor: TValidatedEdit;
    cbZStageType: TComboBox;
    edZStepTime: TValidatedEdit;
    GroupBox3: TGroupBox;
    Label25: TLabel;
    edImageJPath: TEdit;
    ckSaveAsMultipageTIFF: TCheckBox;
    Label14: TLabel;
    edZpositionMin: TValidatedEdit;
    Label16: TLabel;
    edZPositionMax: TValidatedEdit;
    Label17: TLabel;
    edRawFileFolder: TEdit;
    Label37: TLabel;
    edHRPixelSize: TValidatedEdit;
    GroupBox1: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    cbXGalvo: TComboBox;
    cbYGalvo: TComboBox;
    xscalelab: TLabel;
    edXVoltsPerMicron: TValidatedEdit;
    Label5: TLabel;
    edYVoltsPerMicron: TValidatedEdit;
    pnPMT0: TPanel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ValidatedEdit1: TValidatedEdit;
    spNumPMTs: TSpinEdit;
    pnPMT1: TPanel;
    Edit2: TEdit;
    ComboBox2: TComboBox;
    ValidatedEdit2: TValidatedEdit;
    pnPMT2: TPanel;
    Edit3: TEdit;
    ComboBox3: TComboBox;
    ValidatedEdit3: TValidatedEdit;
    pnPMT3: TPanel;
    Edit4: TEdit;
    ComboBox4: TComboBox;
    ValidatedEdit4: TValidatedEdit;
    Label19: TLabel;
    GroupBox5: TGroupBox;
    cbIntegratorType: TComboBox;
    edPMTGainVMin: TValidatedEdit;
    Label20: TLabel;
    Label21: TLabel;
    edPMTGainVMax: TValidatedEdit;
    grpLaserExternal: TGroupBox;
    Label28: TLabel;
    Label15: TLabel;
    edLaserShutterChangeTime: TValidatedEdit;
    ckLaserControlEnabled: TCheckBox;
    pnLaser0: TPanel;
    Edit6: TEdit;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ValidatedEdit5: TValidatedEdit;
    pnLaser1: TPanel;
    Edit7: TEdit;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ValidatedEdit6: TValidatedEdit;
    pnLaser2: TPanel;
    Edit8: TEdit;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ValidatedEdit7: TValidatedEdit;
    pnLaser3: TPanel;
    Edit9: TEdit;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ValidatedEdit8: TValidatedEdit;
    pnLaser4: TPanel;
    Edit10: TEdit;
    ComboBox13: TComboBox;
    ComboBox14: TComboBox;
    ValidatedEdit9: TValidatedEdit;
    Label7: TLabel;
    Label22: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    spNumLasers: TSpinEdit;
    GroupBox6: TGroupBox;
    cbPMTADCPort: TComboBox;
    pnIntegratorControlPort: TPanel;
    Label29: TLabel;
    cbIntegratorPort: TComboBox;
    edIntegratorID: TEdit;
    GroupBox4: TGroupBox;
    cbLaserType: TComboBox;
    pnLaserControlPort: TPanel;
    Label30: TLabel;
    cbLaserControlPort: TComboBox;
    edLaserControllerID: TEdit;
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
    MainFrm.HRFRameWidth := Round(edHRFRameWidth.Value) ;
    MainFrm.HRPixelSize := edHRPixelSize.Value ;
    MainFrm.FastFRameWidth := Round(edFastFRameWidth.Value) ;
    MainFrm.FastFRameHeight := Round(edFastFRameHeight.Value) ;
    MainFrm.BidirectionalScan := ckBidirectionalScan.Checked ;
    MainFrm.MaxScanRate := edMaxScanRate.Value ;
    MainFrm.MinPixelDwellTime := edMinPixelDwellTime.Value ;
    MainFrm.XVoltsPerMicron := edXVoltsPerMicron.Value ;
    MainFrm.YVoltsPerMicron := edYVoltsPerMicron.Value ;
    MainFrm.PhaseShift := edPhaseShift.Value ;
    MainFrm.CorrectSineWaveDistortion := ckCorrectSineWaveDistortion.Checked ;
    MainFrm.BlackLevel := Round(edBlackLevel.Value) ;

    // PMTs & Integrator
    PMT.IntegratorType := cbIntegratorType.ItemIndex ;
    PMT.IntegratorPort := cbIntegratorPort.ItemIndex ;
    PMT.NumPMTs := spNumPMTs.Value ;
    PMT.GainVMin := edPMTGainVMin.Value ;
    PMT.GainVMax := edPMTGainVMax.Value ;

    ReadWritePMTPanel( 0, pnPMT0, 'R' ) ;
    ReadWritePMTPanel( 1, pnPMT1, 'R' ) ;
    ReadWritePMTPanel( 2, pnPMT2, 'R' ) ;
    ReadWritePMTPanel( 3, pnPMT3, 'R' ) ;

    MainFrm.UpdatePMTSettings ;

    if (MainFrm.FullFieldWidthMicrons <> edFullFieldWidthMicrons.Value) or
       (MainFrm.FieldEdge <> edFieldEdge.Value)then
       begin
       MainFrm.FullFieldWidthMicrons := edFullFieldWidthMicrons.Value ;
       MainFrm.FieldEdge := edFieldEdge.Value ;
       MainFrm.SetScanZoomToFullField ;
       end;

    MainFrm.InvertPMTSignal := ckInvertPMTSignal.Checked ;

    Laser.LaserType := cbLaserType.ItemIndex ;

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
    ZStage.ZScaleFactor := edZScaleFactor.Value ;
    ZStage.ZStepTime := edZStepTime.Value ;
    ZStage.ZPositionMin := edZPositionMin.Value ;
    ZStage.ZPositionMax := edZPositionMax.Value ;

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
    PMT.IntegratorPort := cbIntegratorPort.ItemIndex ;
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

    edZScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edZScaleFactor.Value := ZStage.ZScaleFactor ;

    end;

procedure TSettingsFrm.FormShow(Sender: TObject);
// --------------------------
// Initialise form on display
// --------------------------
var
    i,iDev : Integer ;
begin

    edHRFrameWidth.Value := MainFrm.HRFrameWidth ;
    edFastFrameWidth.Value := MainFrm.FastFrameWidth ;
    edFastFrameHeight.Value := MainFrm.FastFrameHeight ;

    edPhaseShift.Value := MainFrm.PhaseShift ;
    ckBidirectionalScan.Checked :=  MainFrm.BidirectionalScan ;
    edMaxScanRate.Value := MainFrm.MaxScanRate ;
    edMinPixelDwellTime.Value := MainFrm.MinPixelDwellTime ;
    edXVoltsPerMicron.Value := MainFrm.XVoltsPerMicron ;
    edYVoltsPerMicron.Value := MainFrm.YVoltsPerMicron ;
    ckCorrectSineWaveDistortion.Checked := MainFrm.CorrectSineWaveDistortion ;
    edBlackLevel.Value := MainFrm.BlackLevel ;
    edFullFieldWidthMicrons.Value := MainFrm.FullFieldWidthMicrons ;
    edFieldEdge.Value := MainFrm.FieldEdge ;
    ckInvertPMTSignal.Checked := MainFrm.InvertPMTSignal ;
    edHRPixelSize.Value := MainFrm.HRPixelSize ;

    // Integrator type
    PMT.GetIntegratorTypes( cbIntegratorType.Items ) ;
    cbIntegratorType.ItemIndex := PMT.IntegratorType ;
    PMT.GetIntegratorPorts( cbIntegratorPort.Items ) ;
    cbIntegratorPort.ItemIndex := PMT.IntegratorPort ;
    edIntegratorID.Text := PMT.IntegratorID ;
    pnIntegratorControlPort.Visible := PMT.IntegratorPortRequired ;

    // PMT A/D input port
    LabIO.GetAIPorts( cbPMTADCPort.Items ) ;
    cbPMTADCPort.ItemIndex := PMT.ADCDevice ;

    spNumPMTs.MaxValue := MaxPMT ;
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

    edZScaleFactor.Units := ZStage.ScaleFactorUnits ;
    edZScaleFactor.Value := ZStage.ZScaleFactor ;
    edZStepTime.Value := ZStage.ZStepTime ;
    edZPositionMin.Value := ZStage.ZPositionMin ;
    edZPositionMax.Value := ZStage.ZPositionMax ;

    edImageJPath.Text := MainFrm.ImageJPath ;
    ckSaveAsMultipageTIFF.Checked := MainFrm.SaveAsMultipageTIFF ;

    edRawFileFolder.Text := ExtractFilePath(MainFrm.RawImagesFileName) ;

    end;


procedure TSettingsFrm.ReadWritePMTPanel(
          Num : Integer ;
          Panel : TPanel ;
          RW : string ) ;
// -----------------------------------------
// Read PMT settings panel controls
// -----------------------------------------
var
    i,iDev : Integer ;
    edName : TEdit ;
    cbPort : TComboBox ;
    edGain : TValidatedEdit ;
begin

      for i := 0 to Panel.ControlCount-1 do
          begin
          case Panel.Controls[i].Tag of
              0 : edName := TEdit(Panel.Controls[i]) ;
              1 : cbPort := TComboBox(Panel.Controls[i]) ;
              2 : edGain := TValidatedEdit(Panel.Controls[i]) ;
              end ;
          end ;

      if ANSIContainsText( RW, 'W') then
         begin
         // Write panel
         edName.Text := PMT.PMTName[Num] ;
         LabIO.GetAOPorts( cbPort.Items ) ;
         cbPort.ItemIndex := Max(cbPort.Items.IndexofObject(TObject(PMT.PMTPort[Num])),0) ;
         edGain.Value := PMT.PMTGain[Num] ;
         end
      else begin
         // Read panel
         PMT.PMTName[Num] := edName.Text ;
         PMT.PMTPort[Num] := Integer(cbPort.Items.Objects[cbPort.ItemIndex]) ;
         PMT.PMTGain[Num] := edGain.Value ;
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
    i,iDev : Integer ;
    edName : TEdit ;
    cbOnOffPort,cbIntensityPort : TComboBox ;
    edVMax : TValidatedEdit ;
begin

      for i := 0 to Panel.ControlCount-1 do
          begin
          case Panel.Controls[i].Tag of
              0 : edName := TEdit(Panel.Controls[i]) ;
              1 : cbOnOffPort := TComboBox(Panel.Controls[i]) ;
              2 : cbIntensityPort := TComboBox(Panel.Controls[i]) ;
              3 : edVMax := TValidatedEdit(Panel.Controls[i]) ;
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
         end
      else begin
         // Read panel
         Laser.LaserName[Num] := edName.Text ;
         Laser.EnabledControlPort[Num] := Integer(cbOnOffPort.Items.Objects[cbOnOffPort.ItemIndex]) ;
         Laser.IntensityControlPort[Num] := Integer(cbIntensityPort.Items.Objects[cbIntensityPort.ItemIndex]) ;
         Laser.VMaxIntensity[Num] := edVMax.Value ;
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
