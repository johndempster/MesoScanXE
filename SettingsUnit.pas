unit SettingsUnit;
// ------------------------------------
// MesoScan - Scan Settings dialog box
// ------------------------------------
// 1-6-12 MinPixelDwellTimeAdded

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ValidatedEdit, math ;

type
  TSettingsFrm = class(TForm)
    ScanGrp: TGroupBox;
    Label3: TLabel;
    xscalelab: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ckCorrectSineWaveDistortion: TCheckBox;
    edPhaseShift: TValidatedEdit;
    edXVoltsPerMicron: TValidatedEdit;
    edYVoltsPerMicron: TValidatedEdit;
    edMaxScanRate: TValidatedEdit;
    bOK: TButton;
    bCancel: TButton;
    ckBidirectionalScan: TCheckBox;
    GroupBox1: TGroupBox;
    ckLaserControlEnabled: TCheckBox;
    cbLaserControlComPort: TComboBox;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    ckZControlEnabled: TCheckBox;
    cbZStagePort: TComboBox;
    edMinPixelDwellTime: TValidatedEdit;
    Label9: TLabel;
    Label10: TLabel;
    edZScaleFactor: TValidatedEdit;
    Label11: TLabel;
    edFullFieldWidthMicrons: TValidatedEdit;
    PMTgrp: TGroupBox;
    Label2: TLabel;
    edADCInput: TValidatedEdit;
    ckInvertPMTsignal: TCheckBox;
    Label18: TLabel;
    edBlackLevel: TValidatedEdit;
    ImageHRGrp: TGroupBox;
    ImageFastGrp: TGroupBox;
    Label1: TLabel;
    edHRFrameWidth: TValidatedEdit;
    Label12: TLabel;
    edFastFrameHeight: TValidatedEdit;
    Label4: TLabel;
    edFastFrameWidth: TValidatedEdit;
    cbZStageType: TComboBox;
    edZStepTime: TValidatedEdit;
    Label13: TLabel;
    cbLaserShutterControlLine: TComboBox;
    Label14: TLabel;
    Label15: TLabel;
    edLaserShutterChangeTime: TValidatedEdit;
    cbLaserIntensityControlLine: TComboBox;
    Label17: TLabel;
    Label16: TLabel;
    edLaserVMaxIntensity: TValidatedEdit;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure cbZStageTypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsFrm: TSettingsFrm;

implementation

{$R *.dfm}

uses MainUnit, ZStageUnit, LaserUnit;

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
begin
    MainFrm.HRFRameWidth := Round(edHRFRameWidth.Value) ;
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
    MainFrm.ADCInput := Round(edADCInput.Value) ;

    MainFrm.FullFieldWidthMicrons := edFullFieldWidthMicrons.Value ;


    MainFrm.InvertPMTSignal := ckInvertPMTSignal.Checked ;

    Laser.ComPort := cbLaserControlComPort.ItemIndex ;
    Laser.ShutterControlLine := cbLaserShutterControlLine.ItemIndex ;
    Laser.ShutterChangeTime := edLaserShutterChangeTime.Value ;

    Laser.IntensityControlLine := cbLaserIntensityControlLine.ItemIndex ;
    Laser.VMaxIntensity := edLaserVMaxIntensity.Value ;

    ZStage.Enabled := ckZControlEnabled.Checked ;
    ZStage.ControlPort := cbZStagePort.ItemIndex ;
    ZStage.ZScaleFactor := edZScaleFactor.Value ;
    ZStage.ZStepTime := edZStepTime.Value ;

    MainFrm.SetScanZoomToFullField ;

    Close ;
    end;

procedure TSettingsFrm.cbZStageTypeChange(Sender: TObject);
//
// Zstage type changed
//
begin
    ZStage.StageType := cbZStageType.ItemIndex ;
    ZStage.GetControlPorts(cbZStagePort.Items);
    cbZStagePort.ItemIndex := Min(Max(ZStage.ControlPort,0),cbZStagePort.Items.Count-1) ;

    ckZControlEnabled.Checked := ZStage.Enabled ;
    edZScaleFactor.Units := ZStage.ZScaleFactorUnits ;
    edZScaleFactor.Value := ZStage.ZScaleFactor ;

    end;

procedure TSettingsFrm.FormShow(Sender: TObject);
// --------------------------
// Initialise form on display
// --------------------------
var
    i : Integer ;
begin

    edHRFrameWidth.Value := MainFrm.HRFrameWidth ;
    edFastFrameWidth.Value := MainFrm.FastFrameWidth ;
    edFastFrameHeight.Value := MainFrm.FastFrameHeight ;

    edADCInput.Value := MainFrm.ADCInput ;
    edPhaseShift.Value := MainFrm.PhaseShift ;
    ckBidirectionalScan.Checked :=  MainFrm.BidirectionalScan ;
    edMaxScanRate.Value := MainFrm.MaxScanRate ;
    edMinPixelDwellTime.Value := MainFrm.MinPixelDwellTime ;
    edXVoltsPerMicron.Value := MainFrm.XVoltsPerMicron ;
    edYVoltsPerMicron.Value := MainFrm.YVoltsPerMicron ;
    ckCorrectSineWaveDistortion.Checked := MainFrm.CorrectSineWaveDistortion ;
    edBlackLevel.Value := MainFrm.BlackLevel ;
    edFullFieldWidthMicrons.Value := MainFrm.FullFieldWidthMicrons ;
    ckInvertPMTSignal.Checked := MainFrm.InvertPMTSignal ;

    // Laser control
    Laser.GetCOMPorts( cbLaserControlComPort.Items ) ;
    cbLaserControlComPort.ItemIndex := Laser.ComPort ;
    ckLaserControlEnabled.Checked := MainFrm.LaserControlEnabled ;

    Laser.GetShutterControlLines( cbLaserShutterControlLine.Items ) ;
    cbLaserShutterControlLine.ItemIndex := Laser.ShutterControlLine ;
    edLaserShutterChangeTime.Value := Laser.ShutterChangeTime ;

    Laser.GetIntensityControlLines( cbLaserIntensityControlLine.Items ) ;
    cbLaserIntensityControlLine.ItemIndex := Laser.IntensityControlLine ;
    edLaserVMaxIntensity.Value := Laser.VMaxIntensity ;

    // Z stage control
    ZStage.GetZStageTypes(cbZStageType.Items);
    cbZStageType.ItemIndex := Min(Max(ZStage.StageType,0),cbZStageType.Items.Count-1) ;

    ZStage.GetControlPorts(cbZStagePort.Items);
    cbZStagePort.ItemIndex := Min(Max(ZStage.ControlPort,0),cbZStagePort.Items.Count-1) ;


    ckZControlEnabled.Checked := ZStage.Enabled ;
    edZScaleFactor.Units := ZStage.ZScaleFactorUnits ;
    edZScaleFactor.Value := ZStage.ZScaleFactor ;
    edZStepTime.Value := ZStage.ZStepTime ;

    end;

end.
