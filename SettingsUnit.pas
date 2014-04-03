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
    cbZControlCOMPort: TComboBox;
    edMinPixelDwellTime: TValidatedEdit;
    Label9: TLabel;
    Label10: TLabel;
    edZStepsPerMicron: TValidatedEdit;
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
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsFrm: TSettingsFrm;

implementation

{$R *.dfm}

uses MainUnit, ZStageUnit;

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

    MainFrm.LaserControlComPort := cbLaserControlComPort.ItemIndex + 1 ;
    MainFrm.LaserControlEnabled := ckLaserControlEnabled.Checked ;

    ZStage.Enabled := ckZControlEnabled.Checked ;
    ZStage.ComPort := cbZControlComPort.ItemIndex + 1 ;
    ZStage.StepsPerMicron := edZStepsPerMicron.Value ;

    MainFrm.SetScanZoomToFullField ;

    Close ;
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

    cbLaserControlComPort.Clear ;
    for i := 1 to 16 do cbLaserControlComPort.Items.Add(format('COM%d',[i]));
    cbLaserControlComPort.ItemIndex := Min(Max(MainFrm.LaserControlComPort-1,0),cbLaserControlComPort.Items.Count-1);
    ckLaserControlEnabled.Checked := MainFrm.LaserControlEnabled ;

    // Z stage  control
    cbZControlComPort.Clear ;
    for i := 1 to 16 do cbZControlComPort.Items.Add(format('COM%d',[i]));
    cbZControlComPort.ItemIndex := Min(Max(ZStage.ComPort-1,0),cbZControlComPort.Items.Count-1);
    ckZControlEnabled.Checked := ZStage.Enabled ;
    edZStepsPerMicron.Value := ZStage.StepsPerMicron ;

    end;

end.
