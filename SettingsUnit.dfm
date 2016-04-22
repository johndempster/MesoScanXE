object SettingsFrm: TSettingsFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = ' Scan Settings '
  ClientHeight = 620
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScanGrp: TGroupBox
    Left = 244
    Top = 8
    Width = 238
    Height = 241
    Caption = ' Scan Settings'
    TabOrder = 0
    object Label3: TLabel
      Left = 73
      Top = 110
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Phase delay'
    end
    object xscalelab: TLabel
      Left = 66
      Top = 136
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'X scale factor'
    end
    object Label5: TLabel
      Left = 66
      Top = 160
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Y scale factor'
    end
    object Label6: TLabel
      Left = 59
      Top = 184
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = 'Max. scan rate'
    end
    object Label9: TLabel
      Left = 36
      Top = 208
      Width = 95
      Height = 13
      Alignment = taRightJustify
      Caption = 'Min. pixel dwell time'
    end
    object Label11: TLabel
      Left = 78
      Top = 18
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Field Width'
    end
    object Label24: TLabel
      Left = 82
      Top = 44
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Field Edge'
    end
    object ckCorrectSineWaveDistortion: TCheckBox
      Left = 26
      Top = 88
      Width = 201
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Correct Sine Wave Distortion'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object edPhaseShift: TValidatedEdit
      Left = 137
      Top = 110
      Width = 90
      Height = 21
      Text = ' 0 ms'
      Scale = 1000.000000000000000000
      Units = 'ms'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 20000.000000000000000000
    end
    object edXVoltsPerMicron: TValidatedEdit
      Left = 137
      Top = 136
      Width = 90
      Height = 21
      Text = ' 1 V/um'
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      Units = 'V/um'
      NumberFormat = '%.4g'
      LoLimit = 0.000009999999747379
      HiLimit = 1.000000000000000000
    end
    object edYVoltsPerMicron: TValidatedEdit
      Left = 137
      Top = 160
      Width = 90
      Height = 21
      Text = ' 1 V/um'
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      Units = 'V/um'
      NumberFormat = '%.4g'
      LoLimit = 0.000009999999747379
      HiLimit = 10.000000000000000000
    end
    object edMaxScanRate: TValidatedEdit
      Left = 137
      Top = 184
      Width = 90
      Height = 21
      Text = ' 100.0 Hz'
      Value = 100.000000000000000000
      Scale = 1.000000000000000000
      Units = 'Hz'
      NumberFormat = '%.1f'
      LoLimit = 1.000000000000000000
      HiLimit = 500.000000000000000000
    end
    object ckBidirectionalScan: TCheckBox
      Left = 26
      Top = 65
      Width = 201
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Bi-directional scan'
      TabOrder = 5
    end
    object edMinPixelDwellTime: TValidatedEdit
      Left = 137
      Top = 205
      Width = 90
      Height = 21
      Text = ' 0.5 us'
      Value = 0.000000499999998738
      Scale = 1000000.000000000000000000
      Units = 'us'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000000000000000
    end
    object edFullFieldWidthMicrons: TValidatedEdit
      Left = 137
      Top = 18
      Width = 90
      Height = 21
      Hint = 'Maximum width of scanning field (um)'
      ShowHint = True
      Text = ' 5000 um'
      Value = 5000.000000000000000000
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.0f'
      LoLimit = 100.000000000000000000
      HiLimit = 10000.000000000000000000
    end
    object edFieldEdge: TValidatedEdit
      Left = 137
      Top = 43
      Width = 90
      Height = 21
      Hint = 
        'Additional non-imaging region at edge of field (% of field width' +
        ')'
      ShowHint = True
      Text = ' 5 %'
      Value = 0.050000000745058060
      Scale = 100.000000000000000000
      Units = '%'
      NumberFormat = '%.0f'
      HiLimit = 0.200000002980232200
    end
  end
  object bOK: TButton
    Left = 8
    Top = 487
    Width = 65
    Height = 25
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 79
    Top = 487
    Width = 72
    Height = 20
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
    OnClick = bCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 247
    Top = 268
    Width = 230
    Height = 177
    Caption = ' Laser Control '
    TabOrder = 3
    object Label7: TLabel
      Left = 88
      Top = 18
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'COM Port'
    end
    object Label14: TLabel
      Left = 20
      Top = 96
      Width = 114
      Height = 13
      Alignment = taRightJustify
      Caption = 'Shutter Control Output '
    end
    object Label15: TLabel
      Left = 33
      Top = 122
      Width = 101
      Height = 13
      Alignment = taRightJustify
      Caption = 'Shutter Change Time'
    end
    object Label17: TLabel
      Left = 16
      Top = 41
      Width = 118
      Height = 13
      Alignment = taRightJustify
      Caption = 'Intensity Control Output'
    end
    object Label16: TLabel
      Left = 7
      Top = 69
      Width = 127
      Height = 13
      Alignment = taRightJustify
      Caption = 'Voltage at 100% Intensity'
    end
    object ckLaserControlEnabled: TCheckBox
      Left = 147
      Top = 149
      Width = 65
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Enabled'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cbLaserControlComPort: TComboBox
      Left = 140
      Top = 14
      Width = 81
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object cbLaserShutterControlLine: TComboBox
      Left = 140
      Top = 96
      Width = 81
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
    object edLaserShutterChangeTime: TValidatedEdit
      Left = 140
      Top = 122
      Width = 81
      Height = 21
      Text = ' 500 ms'
      Value = 0.500000000000000000
      Scale = 1000.000000000000000000
      Units = 'ms'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1000000.000000000000000000
    end
    object cbLaserIntensityControlLine: TComboBox
      Left = 140
      Top = 41
      Width = 81
      Height = 21
      Style = csDropDownList
      TabOrder = 4
    end
    object edLaserVMaxIntensity: TValidatedEdit
      Left = 140
      Top = 69
      Width = 81
      Height = 21
      Text = ' 5 V'
      Value = 5.000000000000000000
      Scale = 1.000000000000000000
      Units = 'V'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 10.000000000000000000
    end
  end
  object GroupBox2: TGroupBox
    Left = 247
    Top = 451
    Width = 230
    Height = 161
    Caption = ' Z position Control'
    TabOrder = 4
    object Label8: TLabel
      Left = 56
      Top = 43
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Control Port'
    end
    object Label10: TLabel
      Left = 49
      Top = 68
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z scale factor'
    end
    object Label13: TLabel
      Left = 61
      Top = 95
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z step time'
    end
    object ckZControlEnabled: TCheckBox
      Left = 147
      Top = 127
      Width = 65
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Enabled'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cbZStagePort: TComboBox
      Left = 120
      Top = 43
      Width = 97
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object edZScaleFactor: TValidatedEdit
      Left = 120
      Top = 68
      Width = 97
      Height = 21
      Text = ' 1 steps/um'
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      Units = 'steps/um'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1000000.000000000000000000
    end
    object cbZStageType: TComboBox
      Left = 8
      Top = 16
      Width = 209
      Height = 21
      TabOrder = 3
      Text = 'cbZStageType'
      OnChange = cbZStageTypeChange
    end
    object edZStepTime: TValidatedEdit
      Left = 120
      Top = 95
      Width = 97
      Height = 21
      Text = ' 100 ms'
      Value = 0.100000001490116100
      Scale = 1000.000000000000000000
      Units = 'ms'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1000000.000000000000000000
    end
  end
  object PMTgrp: TGroupBox
    Left = 8
    Top = 150
    Width = 230
    Height = 235
    Caption = ' PMT '
    TabOrder = 5
    object Label2: TLabel
      Left = 20
      Top = 17
      Width = 103
      Height = 13
      Alignment = taRightJustify
      Caption = 'No. of PMTs available'
    end
    object Label18: TLabel
      Left = 74
      Top = 201
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Black level'
    end
    object Label19: TLabel
      Left = 20
      Top = 44
      Width = 103
      Height = 13
      Alignment = taRightJustify
      Caption = 'PMT0 Voltage Control'
    end
    object Label20: TLabel
      Left = 20
      Top = 71
      Width = 103
      Height = 13
      Alignment = taRightJustify
      Caption = 'PMT1 Voltage Control'
    end
    object Label21: TLabel
      Left = 20
      Top = 98
      Width = 103
      Height = 13
      Alignment = taRightJustify
      Caption = 'PMT2 Voltage Control'
    end
    object Label22: TLabel
      Left = 20
      Top = 125
      Width = 103
      Height = 13
      Alignment = taRightJustify
      Caption = 'PMT3 Voltage Control'
    end
    object Label23: TLabel
      Left = 19
      Top = 152
      Width = 104
      Height = 13
      Alignment = taRightJustify
      Caption = 'PMT voltage at 100%'
    end
    object edNumPMTs: TValidatedEdit
      Left = 130
      Top = 17
      Width = 90
      Height = 21
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 4.000000000000000000
    end
    object ckInvertPMTsignal: TCheckBox
      Left = 111
      Top = 180
      Width = 108
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Invert PMT signal'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object edBlackLevel: TValidatedEdit
      Left = 130
      Top = 201
      Width = 90
      Height = 21
      Text = ' 10 '
      Value = 10.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = -32768.000000000000000000
      HiLimit = 32767.000000000000000000
    end
    object cbPMTControl0: TComboBox
      Left = 130
      Top = 44
      Width = 90
      Height = 21
      Style = csDropDownList
      TabOrder = 3
    end
    object cbPMTControl1: TComboBox
      Left = 130
      Top = 71
      Width = 90
      Height = 21
      Style = csDropDownList
      TabOrder = 4
    end
    object cbPMTControl2: TComboBox
      Left = 130
      Top = 98
      Width = 90
      Height = 21
      Style = csDropDownList
      TabOrder = 5
    end
    object cbPMTControl3: TComboBox
      Left = 130
      Top = 125
      Width = 90
      Height = 21
      Style = csDropDownList
      TabOrder = 6
    end
    object edPMTMaxVolts: TValidatedEdit
      Left = 130
      Top = 152
      Width = 90
      Height = 21
      Text = ' 5 V'
      Value = 5.000000000000000000
      Scale = 1.000000000000000000
      Units = 'V'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 10.000000000000000000
    end
  end
  object ImageHRGrp: TGroupBox
    Left = 8
    Top = 8
    Width = 230
    Height = 53
    Caption = ' Image (hi. res. scan)'
    TabOrder = 6
    object Label1: TLabel
      Left = 84
      Top = 18
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = 'Pixels/line'
    end
    object edHRFrameWidth: TValidatedEdit
      Left = 137
      Top = 18
      Width = 90
      Height = 21
      Text = ' 1000 '
      Value = 1000.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 100.000000000000000000
      HiLimit = 30000.000000000000000000
    end
  end
  object ImageFastGrp: TGroupBox
    Left = 8
    Top = 67
    Width = 230
    Height = 77
    Caption = ' Image (fast scan)'
    TabOrder = 7
    object Label12: TLabel
      Left = 69
      Top = 42
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Caption = 'Lines / image'
    end
    object Label4: TLabel
      Left = 84
      Top = 18
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = 'Pixels/line'
    end
    object edFastFrameHeight: TValidatedEdit
      Left = 137
      Top = 42
      Width = 90
      Height = 21
      Text = ' 50 '
      Value = 50.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 1000000.000000000000000000
    end
    object edFastFrameWidth: TValidatedEdit
      Left = 137
      Top = 18
      Width = 90
      Height = 21
      Text = ' 500 '
      Value = 500.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 100.000000000000000000
      HiLimit = 1000000.000000000000000000
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 392
    Width = 230
    Height = 89
    TabOrder = 8
    object Label25: TLabel
      Left = 8
      Top = 8
      Width = 107
      Height = 13
      Caption = 'Image-J Program Path'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edImageJPath: TEdit
      Left = 8
      Top = 26
      Width = 217
      Height = 21
      TabOrder = 0
      Text = 'edImageJPath'
    end
    object ckSaveAsMultipageTIFF: TCheckBox
      Left = 64
      Top = 50
      Width = 161
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Save stacks as multipage TIFF'
      TabOrder = 1
    end
  end
end
