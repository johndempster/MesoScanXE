object SettingsFrm: TSettingsFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = ' Scan Settings '
  ClientHeight = 512
  ClientWidth = 571
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
  object bOK: TButton
    Left = 8
    Top = 479
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
    TabOrder = 0
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 79
    Top = 482
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
    TabOrder = 1
    OnClick = bCancelClick
  end
  object StageTab: TPageControl
    Left = 8
    Top = 6
    Width = 553
    Height = 467
    ActivePage = gpIntegrator
    TabOrder = 2
    object ScanTab: TTabSheet
      Caption = 'Scanning'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ImageHRGrp: TGroupBox
        Left = 8
        Top = 10
        Width = 253
        Height = 131
        Caption = ' Image (hi. res. scan)'
        TabOrder = 0
        object Label4: TLabel
          Left = 31
          Top = 46
          Width = 119
          Height = 15
          Alignment = taRightJustify
          Caption = 'Live Image Pixels/line'
        end
        object Label12: TLabel
          Left = 18
          Top = 74
          Width = 132
          Height = 15
          Alignment = taRightJustify
          Caption = 'Live Image Lines/image'
        end
        object Label37: TLabel
          Left = 99
          Top = 18
          Width = 51
          Height = 15
          Alignment = taRightJustify
          Caption = 'Pixel size'
        end
        object edFastFrameWidth: TValidatedEdit
          Left = 156
          Top = 46
          Width = 90
          Height = 23
          Text = ' 500 '
          Value = 500.000000000000000000
          Scale = 1.000000000000000000
          NumberFormat = '%.0f'
          LoLimit = 10.000000000000000000
          HiLimit = 30000.000000000000000000
        end
        object edFastFrameHeight: TValidatedEdit
          Left = 156
          Top = 74
          Width = 90
          Height = 23
          Text = ' 50 '
          Value = 50.000000000000000000
          Scale = 1.000000000000000000
          NumberFormat = '%.0f'
          LoLimit = 10.000000000000000000
          HiLimit = 30000.000000000000000000
        end
        object edHRPixelSize: TValidatedEdit
          Left = 156
          Top = 18
          Width = 90
          Height = 23
          Text = ' 0.25 um'
          Value = 0.250000000000000000
          Scale = 1.000000000000000000
          Units = 'um'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000000000000000
        end
      end
      object ScanGrp: TGroupBox
        Left = 268
        Top = 3
        Width = 235
        Height = 294
        Caption = ' Scan Settings'
        TabOrder = 1
        object Label3: TLabel
          Left = 63
          Top = 110
          Width = 68
          Height = 15
          Alignment = taRightJustify
          Caption = 'Phase delay'
        end
        object Label6: TLabel
          Left = 53
          Top = 184
          Width = 78
          Height = 15
          Alignment = taRightJustify
          Caption = 'Max. scan rate'
        end
        object Label9: TLabel
          Left = 22
          Top = 209
          Width = 109
          Height = 15
          Alignment = taRightJustify
          Caption = 'Min. pixel dwell time'
        end
        object Label11: TLabel
          Left = 70
          Top = 18
          Width = 61
          Height = 15
          Alignment = taRightJustify
          Caption = 'Field Width'
        end
        object Label24: TLabel
          Left = 72
          Top = 44
          Width = 59
          Height = 15
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
          Height = 23
          Text = ' 0 ms'
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 20000.000000000000000000
        end
        object edMaxScanRate: TValidatedEdit
          Left = 137
          Top = 184
          Width = 90
          Height = 23
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
          TabOrder = 3
        end
        object edMinPixelDwellTime: TValidatedEdit
          Left = 137
          Top = 209
          Width = 90
          Height = 23
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
          Height = 23
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
          Height = 23
          Hint = 
            'Additional non-imaging region at edge of field (% of field width' +
            ')'
          ShowHint = True
          Text = ' 5 %'
          Value = 0.050000000745058060
          Scale = 100.000000000000000000
          Units = '%'
          NumberFormat = '%.0f'
          LoLimit = -1.000000015047466E30
          HiLimit = 0.200000002980232200
        end
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 147
        Width = 258
        Height = 150
        Caption = ' Scanning Galvanometer Control '
        TabOrder = 2
        object Label40: TLabel
          Left = 72
          Top = 20
          Width = 84
          Height = 15
          Alignment = taRightJustify
          Caption = 'X Mirror Control'
        end
        object Label41: TLabel
          Left = 72
          Top = 79
          Width = 84
          Height = 15
          Alignment = taRightJustify
          Caption = 'Y Mirror Control'
        end
        object xscalelab: TLabel
          Left = 78
          Top = 49
          Width = 78
          Height = 15
          Alignment = taRightJustify
          Caption = 'X Scale Factor'
        end
        object Label5: TLabel
          Left = 78
          Top = 108
          Width = 78
          Height = 15
          Alignment = taRightJustify
          Caption = 'Y Scale Factor'
        end
        object cbXGalvo: TComboBox
          Left = 162
          Top = 20
          Width = 90
          Height = 23
          Style = csDropDownList
          TabOrder = 0
        end
        object cbYGalvo: TComboBox
          Left = 162
          Top = 79
          Width = 90
          Height = 23
          Style = csDropDownList
          TabOrder = 1
        end
        object edXVoltsPerMicron: TValidatedEdit
          Left = 162
          Top = 46
          Width = 90
          Height = 23
          Text = ' 1 V/um'
          Value = 1.000000000000000000
          Scale = 1.000000000000000000
          Units = 'V/um'
          NumberFormat = '%.4g'
          LoLimit = 0.000009999999747379
          HiLimit = 1.000000000000000000
        end
        object edYVoltsPerMicron: TValidatedEdit
          Left = 162
          Top = 106
          Width = 90
          Height = 23
          Text = ' 1 V/um'
          Value = 1.000000000000000000
          Scale = 1.000000000000000000
          Units = 'V/um'
          NumberFormat = '%.4g'
          LoLimit = 0.000009999999747379
          HiLimit = 10.000000000000000000
        end
      end
    end
    object gpIntegrator: TTabSheet
      Caption = 'PM Tubes'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object gpPMTs: TGroupBox
        Left = 259
        Top = 8
        Width = 238
        Height = 306
        Caption = ' Photomultiplier Tubes '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label2: TLabel
          Left = 69
          Top = 27
          Width = 104
          Height = 16
          Alignment = taRightJustify
          Caption = 'No. of PMTs available'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ParentFont = False
        end
        object Label18: TLabel
          Left = 63
          Top = 273
          Width = 62
          Height = 16
          Alignment = taRightJustify
          Caption = 'Black level'
        end
        object Label23: TLabel
          Left = 177
          Top = 105
          Width = 25
          Height = 15
          Alignment = taRightJustify
          Caption = 'Gain'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label19: TLabel
          Left = 79
          Top = 105
          Width = 86
          Height = 15
          Alignment = taRightJustify
          Caption = 'Voltage Control'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label20: TLabel
          Left = 56
          Top = 50
          Width = 117
          Height = 16
          Alignment = taRightJustify
          Caption = 'PMT Voltage (Min. Gain)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ParentFont = False
        end
        object Label21: TLabel
          Left = 52
          Top = 79
          Width = 121
          Height = 16
          Alignment = taRightJustify
          Caption = 'PMT Voltage (Max. Gain)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ParentFont = False
        end
        object ckInvertPMTsignal: TCheckBox
          Left = 98
          Top = 250
          Width = 123
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Invert PMT signal'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object edBlackLevel: TValidatedEdit
          Left = 131
          Top = 271
          Width = 90
          Height = 24
          Text = ' 10 '
          Value = 10.000000000000000000
          Scale = 1.000000000000000000
          NumberFormat = '%.0f'
          LoLimit = -32768.000000000000000000
          HiLimit = 32767.000000000000000000
        end
        object pnPMT0: TPanel
          Left = 18
          Top = 126
          Width = 217
          Height = 28
          BevelOuter = bvNone
          TabOrder = 2
          object Edit1: TEdit
            Left = 1
            Top = 0
            Width = 57
            Height = 24
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial Narrow'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox1: TComboBox
            Tag = 1
            Left = 63
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ValidatedEdit1: TValidatedEdit
            Tag = 2
            Left = 159
            Top = 0
            Width = 50
            Height = 24
            Text = ' 100 %'
            Value = 1.000000000000000000
            Scale = 100.000000000000000000
            Units = '%'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000000000000000
          end
        end
        object spNumPMTs: TSpinEdit
          Left = 179
          Top = 18
          Width = 50
          Height = 26
          Hint = 'Number of PMTS installed in system'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          MaxValue = 4
          MinValue = 1
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Value = 1
          OnChange = spNumPMTsChange
        end
        object pnPMT1: TPanel
          Left = 18
          Top = 156
          Width = 217
          Height = 28
          BevelOuter = bvNone
          TabOrder = 4
          object Edit2: TEdit
            Left = 0
            Top = 0
            Width = 57
            Height = 24
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial Narrow'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox2: TComboBox
            Tag = 1
            Left = 63
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ValidatedEdit2: TValidatedEdit
            Tag = 2
            Left = 159
            Top = 0
            Width = 50
            Height = 24
            Text = ' 100 %'
            Value = 1.000000000000000000
            Scale = 100.000000000000000000
            Units = '%'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000000000000000
          end
        end
        object pnPMT2: TPanel
          Left = 18
          Top = 186
          Width = 217
          Height = 28
          BevelOuter = bvNone
          TabOrder = 5
          object Edit3: TEdit
            Left = 0
            Top = 0
            Width = 57
            Height = 24
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial Narrow'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox3: TComboBox
            Tag = 1
            Left = 63
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ValidatedEdit3: TValidatedEdit
            Tag = 2
            Left = 159
            Top = 0
            Width = 50
            Height = 24
            Text = ' 100 %'
            Value = 1.000000000000000000
            Scale = 100.000000000000000000
            Units = '%'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000000000000000
          end
        end
        object pnPMT3: TPanel
          Left = 18
          Top = 216
          Width = 217
          Height = 28
          BevelOuter = bvNone
          TabOrder = 6
          object Edit4: TEdit
            Left = 0
            Top = 0
            Width = 57
            Height = 24
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial Narrow'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox4: TComboBox
            Tag = 1
            Left = 63
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ValidatedEdit4: TValidatedEdit
            Tag = 2
            Left = 159
            Top = 0
            Width = 50
            Height = 24
            Text = ' 100 %'
            Value = 1.000000000000000000
            Scale = 100.000000000000000000
            Units = '%'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000000000000000
          end
        end
        object edPMTGainVMin: TValidatedEdit
          Left = 177
          Top = 49
          Width = 50
          Height = 24
          Hint = 'PMT control voltage at minimum gain'
          ShowHint = True
          Text = ' 5 V'
          Value = 5.000000000000000000
          Scale = 1.000000000000000000
          Units = 'V'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 10.000000000000000000
        end
        object edPMTGainVMax: TValidatedEdit
          Left = 177
          Top = 79
          Width = 50
          Height = 24
          Hint = 'PMT control voltage at maximum gain'
          ShowHint = True
          Text = ' 5 V'
          Value = 5.000000000000000000
          Scale = 1.000000000000000000
          Units = 'V'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 10.000000000000000000
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 233
        Height = 120
        Caption = ' PMT Integrator '
        TabOrder = 1
        object cbIntegratorType: TComboBox
          Left = 8
          Top = 20
          Width = 215
          Height = 24
          TabOrder = 0
          Text = 'cbIntegratorType'
          OnChange = cbIntegratorTypeChange
        end
        object pnIntegratorControlPort: TPanel
          Left = 8
          Top = 48
          Width = 217
          Height = 30
          BevelOuter = bvNone
          TabOrder = 1
          object Label29: TLabel
            Left = 45
            Top = 0
            Width = 69
            Height = 16
            Alignment = taRightJustify
            Caption = 'Control Port'
          end
          object cbIntegratorPort: TComboBox
            Left = 120
            Top = 0
            Width = 97
            Height = 24
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbIntegratorPortChange
          end
        end
        object edIntegratorID: TEdit
          Left = 8
          Top = 80
          Width = 217
          Height = 24
          ReadOnly = True
          TabOrder = 2
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 130
        Width = 233
        Height = 56
        Caption = ' A/D Converter '
        TabOrder = 2
        object cbPMTADCPort: TComboBox
          Left = 8
          Top = 20
          Width = 215
          Height = 24
          TabOrder = 0
          Text = 'cbPMTADCDevice'
        end
      end
    end
    object LasersTab: TTabSheet
      Caption = 'Lasers '
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grpLaserExternal: TGroupBox
        Left = 3
        Top = 134
        Width = 534
        Height = 294
        Caption = ' Lasers '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label28: TLabel
          Left = 8
          Top = 56
          Width = 33
          Height = 15
          Caption = 'Name'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label15: TLabel
          Left = 1
          Top = 259
          Width = 122
          Height = 16
          Alignment = taRightJustify
          Caption = 'Shutter Change Time'
        end
        object Label7: TLabel
          Left = 216
          Top = 56
          Width = 36
          Height = 15
          Caption = 'On/Off'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label22: TLabel
          Left = 312
          Top = 56
          Width = 48
          Height = 15
          Caption = 'Intensity'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label26: TLabel
          Left = 408
          Top = 56
          Width = 46
          Height = 15
          Caption = 'V(100%)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label27: TLabel
          Left = 8
          Top = 20
          Width = 108
          Height = 16
          Alignment = taRightJustify
          Caption = 'No. of Lasers available'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ParentFont = False
        end
        object Label31: TLabel
          Left = 113
          Top = 56
          Width = 67
          Height = 15
          Caption = 'Max. Power'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edLaserShutterChangeTime: TValidatedEdit
          Left = 129
          Top = 259
          Width = 81
          Height = 24
          Text = ' 500 ms'
          Value = 0.500000000000000000
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1000000.000000000000000000
        end
        object ckLaserControlEnabled: TCheckBox
          Left = 216
          Top = 263
          Width = 65
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Enabled'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object pnLaser0: TPanel
          Left = 8
          Top = 75
          Width = 500
          Height = 27
          BevelOuter = bvNone
          TabOrder = 2
          object Edit6: TEdit
            Left = 0
            Top = 0
            Width = 99
            Height = 24
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox5: TComboBox
            Tag = 2
            Left = 209
            Top = 2
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ComboBox6: TComboBox
            Tag = 3
            Left = 305
            Top = 2
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 2
          end
          object ValidatedEdit5: TValidatedEdit
            Tag = 4
            Left = 401
            Top = 2
            Width = 50
            Height = 24
            Text = ' 5 V'
            Value = 5.000000000000000000
            Scale = 1.000000000000000000
            Units = 'V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 10.000000000000000000
          end
          object edMaxPower: TValidatedEdit
            Tag = 1
            Left = 105
            Top = 0
            Width = 81
            Height = 24
            Text = ' 1E004 mW'
            Value = 10.000000000000000000
            Scale = 1000.000000000000000000
            Units = 'mW'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object pnLaser1: TPanel
          Left = 8
          Top = 108
          Width = 500
          Height = 27
          BevelOuter = bvNone
          TabOrder = 3
          object Edit7: TEdit
            Left = 0
            Top = 0
            Width = 99
            Height = 24
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox7: TComboBox
            Tag = 2
            Left = 209
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ComboBox8: TComboBox
            Tag = 3
            Left = 305
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 2
          end
          object ValidatedEdit6: TValidatedEdit
            Tag = 4
            Left = 401
            Top = 0
            Width = 50
            Height = 24
            Text = ' 5 V'
            Value = 5.000000000000000000
            Scale = 1.000000000000000000
            Units = 'V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 10.000000000000000000
          end
          object ValidatedEdit10: TValidatedEdit
            Tag = 1
            Left = 105
            Top = 0
            Width = 81
            Height = 24
            Text = ' 1E004 mW'
            Value = 10.000000000000000000
            Scale = 1000.000000000000000000
            Units = 'mW'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object pnLaser2: TPanel
          Left = 8
          Top = 141
          Width = 500
          Height = 27
          BevelOuter = bvNone
          TabOrder = 4
          object Edit8: TEdit
            Left = 0
            Top = 0
            Width = 99
            Height = 24
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox9: TComboBox
            Tag = 2
            Left = 208
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ComboBox10: TComboBox
            Tag = 3
            Left = 304
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 2
          end
          object ValidatedEdit7: TValidatedEdit
            Tag = 4
            Left = 400
            Top = 0
            Width = 50
            Height = 24
            Text = ' 5 V'
            Value = 5.000000000000000000
            Scale = 1.000000000000000000
            Units = 'V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 10.000000000000000000
          end
          object ValidatedEdit11: TValidatedEdit
            Tag = 1
            Left = 105
            Top = 0
            Width = 81
            Height = 24
            Text = ' 1E004 mW'
            Value = 10.000000000000000000
            Scale = 1000.000000000000000000
            Units = 'mW'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object pnLaser3: TPanel
          Left = 8
          Top = 174
          Width = 500
          Height = 27
          BevelOuter = bvNone
          TabOrder = 5
          object Edit9: TEdit
            Left = 0
            Top = 0
            Width = 99
            Height = 24
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox11: TComboBox
            Tag = 2
            Left = 209
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ComboBox12: TComboBox
            Tag = 3
            Left = 305
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 2
          end
          object ValidatedEdit8: TValidatedEdit
            Tag = 4
            Left = 401
            Top = 0
            Width = 50
            Height = 24
            Text = ' 5 V'
            Value = 5.000000000000000000
            Scale = 1.000000000000000000
            Units = 'V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 10.000000000000000000
          end
          object ValidatedEdit12: TValidatedEdit
            Tag = 1
            Left = 105
            Top = 0
            Width = 81
            Height = 24
            Text = ' 1E004 mW'
            Value = 10.000000000000000000
            Scale = 1000.000000000000000000
            Units = 'mW'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object pnLaser4: TPanel
          Left = 8
          Top = 204
          Width = 500
          Height = 27
          BevelOuter = bvNone
          TabOrder = 6
          object Edit10: TEdit
            Left = 0
            Top = 0
            Width = 99
            Height = 24
            TabOrder = 0
            Text = 'edLaserName0'
          end
          object ComboBox13: TComboBox
            Tag = 2
            Left = 209
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 1
          end
          object ComboBox14: TComboBox
            Tag = 3
            Left = 305
            Top = 0
            Width = 90
            Height = 24
            Style = csDropDownList
            TabOrder = 2
          end
          object ValidatedEdit9: TValidatedEdit
            Tag = 4
            Left = 401
            Top = 0
            Width = 50
            Height = 24
            Text = ' 5 V'
            Value = 5.000000000000000000
            Scale = 1.000000000000000000
            Units = 'V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 10.000000000000000000
          end
          object ValidatedEdit13: TValidatedEdit
            Tag = 1
            Left = 105
            Top = 0
            Width = 81
            Height = 24
            Text = ' 1E004 mW'
            Value = 10.000000000000000000
            Scale = 1000.000000000000000000
            Units = 'mW'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object spNumLasers: TSpinEdit
          Left = 129
          Top = 20
          Width = 50
          Height = 26
          Hint = 'Number of lasers installed in system'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          MaxValue = 4
          MinValue = 1
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          Value = 1
          OnChange = spNumLasersChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 8
        Width = 534
        Height = 120
        Caption = ' Laser Control Unit '
        TabOrder = 1
        object cbLaserType: TComboBox
          Left = 3
          Top = 21
          Width = 518
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = cbLaserTypeChange
        end
        object pnLaserControlPort: TPanel
          Left = 304
          Top = 48
          Width = 217
          Height = 30
          BevelOuter = bvNone
          TabOrder = 1
          object Label30: TLabel
            Left = 56
            Top = 0
            Width = 58
            Height = 13
            Alignment = taRightJustify
            Caption = 'Control Port'
          end
          object cbLaserControlPort: TComboBox
            Left = 120
            Top = 0
            Width = 97
            Height = 21
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbLaserControlPortChange
          end
        end
        object edLaserControllerID: TEdit
          Left = 8
          Top = 84
          Width = 513
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'XYZ Stage Control'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 3
      ParentFont = False
      object GroupBox2: TGroupBox
        Left = 8
        Top = 3
        Width = 281
        Height = 191
        Caption = ' Z position Control'
        TabOrder = 0
        object Label8: TLabel
          Left = 103
          Top = 43
          Width = 65
          Height = 15
          Alignment = taRightJustify
          Caption = 'Control Port'
        end
        object Label10: TLabel
          Left = 95
          Top = 68
          Width = 73
          Height = 15
          Alignment = taRightJustify
          Caption = 'Z scale factor'
        end
        object Label13: TLabel
          Left = 107
          Top = 95
          Width = 61
          Height = 15
          Alignment = taRightJustify
          Caption = 'Z step time'
        end
        object Label14: TLabel
          Left = 46
          Top = 122
          Width = 122
          Height = 15
          Alignment = taRightJustify
          Caption = 'Z Position Lower Limit'
        end
        object Label16: TLabel
          Left = 46
          Top = 149
          Width = 122
          Height = 15
          Alignment = taRightJustify
          Caption = 'Z Position Upper Limit'
        end
        object cbZStagePort: TComboBox
          Left = 176
          Top = 43
          Width = 97
          Height = 23
          Style = csDropDownList
          TabOrder = 0
        end
        object edZScaleFactor: TValidatedEdit
          Left = 176
          Top = 68
          Width = 97
          Height = 23
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
          Width = 265
          Height = 23
          TabOrder = 2
          Text = 'cbZStageType'
          OnChange = cbZStageTypeChange
        end
        object edZStepTime: TValidatedEdit
          Left = 176
          Top = 95
          Width = 97
          Height = 23
          Text = ' 100 ms'
          Value = 0.100000001490116100
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1000000.000000000000000000
        end
        object edZpositionMin: TValidatedEdit
          Left = 176
          Top = 122
          Width = 97
          Height = 23
          Text = ' -10000 um'
          Value = -10000.000000000000000000
          Scale = 1.000000000000000000
          Units = 'um'
          NumberFormat = '%.0f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1000000.000000000000000000
        end
        object edZPositionMax: TValidatedEdit
          Left = 176
          Top = 149
          Width = 97
          Height = 23
          Text = ' 10000 um'
          Value = 10000.000000000000000000
          Scale = 1.000000000000000000
          Units = 'um'
          NumberFormat = '%.0f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1000000.000000000000000000
        end
      end
    end
    object MiscTab: TTabSheet
      Caption = 'Miscellaneous'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 8
        Top = 10
        Width = 532
        Height = 199
        TabOrder = 0
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
        object Label17: TLabel
          Left = 8
          Top = 57
          Width = 99
          Height = 13
          Caption = 'Raw Data File Folder'
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
          Width = 518
          Height = 21
          TabOrder = 0
          Text = 'edImageJPath'
        end
        object ckSaveAsMultipageTIFF: TCheckBox
          Left = 8
          Top = 105
          Width = 170
          Height = 17
          Caption = 'Save stacks as multipage TIFF'
          TabOrder = 1
        end
        object edRawFileFolder: TEdit
          Left = 8
          Top = 76
          Width = 518
          Height = 21
          TabOrder = 2
          Text = 'edImageJPath'
        end
      end
    end
  end
end
