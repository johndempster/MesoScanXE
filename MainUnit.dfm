object MainFrm: TMainFrm
  Left = 794
  Top = 357
  Caption = 'MesoScan V1.5.3 64 bit 19/01/15'
  ClientHeight = 1146
  ClientWidth = 812
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageGrp: TGroupBox
    Left = 287
    Top = 13
    Width = 500
    Height = 288
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lbReadout: TLabel
      Left = 8
      Top = 217
      Width = 55
      Height = 14
      Caption = 'lbReadout'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ZSectionPanel: TPanel
      Left = 159
      Top = 243
      Width = 154
      Height = 22
      BevelOuter = bvNone
      TabOrder = 0
      object lbZSection: TLabel
        Left = 81
        Top = 0
        Width = 24
        Height = 14
        Caption = 'xxxx'
      end
      object scZSection: TScrollBar
        Left = 0
        Top = 0
        Width = 75
        Height = 15
        PageSize = 0
        TabOrder = 0
        OnChange = scZSectionChange
      end
    end
    object Panel1: TPanel
      Left = 3
      Top = 3
      Width = 86
      Height = 20
      BevelOuter = bvNone
      TabOrder = 1
    end
    object ZoomPanel: TPanel
      Left = 16
      Top = 237
      Width = 105
      Height = 20
      BevelOuter = bvNone
      TabOrder = 2
      object lbZoom: TLabel
        Left = 1
        Top = 0
        Width = 56
        Height = 14
        Caption = 'Zoom (X1)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object bZoomIn: TButton
        Left = 63
        Top = 0
        Width = 17
        Height = 17
        Hint = 'Magnify displayed imaged'
        Caption = '+'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bZoomInClick
      end
      object bZoomOut: TButton
        Left = 82
        Top = 0
        Width = 17
        Height = 17
        Hint = 'Reduce image magnification'
        Caption = '-'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = bZoomOutClick
      end
    end
    object ImagePage: TPageControl
      Left = 3
      Top = 3
      Width = 294
      Height = 217
      ActivePage = TabImage1
      TabOrder = 3
      object TabImage0: TTabSheet
        Caption = 'PMT0'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Image0: TImage
          Left = 2
          Top = 1
          Width = 281
          Height = 178
          ParentShowHint = False
          ShowHint = False
          Stretch = True
          OnDblClick = Image0DblClick
          OnMouseDown = Image0MouseDown
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
      object TabImage1: TTabSheet
        Caption = 'TabImage1'
        ImageIndex = 1
        object Image1: TImage
          Left = 0
          Top = 0
          Width = 281
          Height = 185
          ParentShowHint = False
          ShowHint = False
          Stretch = True
          OnDblClick = Image0DblClick
          OnMouseDown = Image0MouseDown
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
      object TabImage2: TTabSheet
        Caption = 'TabImage2'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Image2: TImage
          Left = 0
          Top = 0
          Width = 281
          Height = 185
          ParentShowHint = False
          ShowHint = False
          Stretch = True
          OnDblClick = Image0DblClick
          OnMouseDown = Image0MouseDown
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
      object TabImage3: TTabSheet
        Caption = 'TabImage3'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Image3: TImage
          Left = 0
          Top = 0
          Width = 281
          Height = 185
          Stretch = True
          OnDblClick = Image0DblClick
          OnMouseDown = Image0MouseDown
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
    end
  end
  object ImageSizeGrp: TGroupBox
    Left = 8
    Top = 167
    Width = 273
    Height = 188
    Caption = ' Image '
    TabOrder = 1
    object Label4: TLabel
      Left = 60
      Top = 14
      Width = 103
      Height = 13
      Alignment = taRightJustify
      Caption = 'No. averages / image'
    end
    object edNumAverages: TValidatedEdit
      Left = 169
      Top = 15
      Width = 33
      Height = 21
      Hint = 'No. of images to be averaged'
      ShowHint = True
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 20000.000000000000000000
    end
    object ZStackGrp: TGroupBox
      Left = 12
      Top = 42
      Width = 189
      Height = 139
      TabOrder = 1
      object Label5: TLabel
        Left = 56
        Top = 16
        Width = 59
        Height = 13
        Alignment = taRightJustify
        Caption = 'No. sections'
      end
      object Label6: TLabel
        Left = 4
        Top = 43
        Width = 111
        Height = 13
        Alignment = taRightJustify
        Caption = 'Section spacing (pixels)'
      end
      object Label1: TLabel
        Left = 16
        Top = 70
        Width = 99
        Height = 13
        Alignment = taRightJustify
        Caption = 'Section spacing (um)'
      end
      object edNumZSections: TValidatedEdit
        Left = 121
        Top = 16
        Width = 57
        Height = 21
        Hint = 'No. of sections in Z stage'
        ShowHint = True
        Text = ' 1 '
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.0f'
        LoLimit = 1.000000000000000000
        HiLimit = 20000.000000000000000000
      end
      object edNumPixelsPerZStep: TValidatedEdit
        Left = 121
        Top = 43
        Width = 57
        Height = 21
        Hint = 'Z increment between sections'
        OnKeyPress = edNumPixelsPerZStepKeyPress
        Text = ' 1.000 '
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.3f'
        LoLimit = -100.000000000000000000
        HiLimit = 100.000000000000000000
      end
      object edMicronsPerZStep: TValidatedEdit
        Left = 121
        Top = 70
        Width = 57
        Height = 21
        Hint = 'Z increment between sections'
        OnKeyPress = edMicronsPerZStepKeyPress
        Text = ' 0.000 um'
        Scale = 1.000000000000000000
        Units = 'um'
        NumberFormat = '%.3f'
        LoLimit = -100.000000000000000000
        HiLimit = 100.000000000000000000
      end
    end
    object LineScanGrp: TGroupBox
      Left = 12
      Top = 42
      Width = 190
      Height = 104
      TabOrder = 2
      object Label2: TLabel
        Left = 74
        Top = 16
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'No. lines'
      end
      object edLineScanFrameHeight: TValidatedEdit
        Left = 121
        Top = 16
        Width = 57
        Height = 21
        Hint = 'No. lines in line scan image'
        ShowHint = True
        Text = ' 1000 '
        Value = 1000.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.0f'
        LoLimit = 10.000000000000000000
        HiLimit = 30000.000000000000000000
      end
    end
  end
  object ZStageGrp: TGroupBox
    Left = 8
    Top = 354
    Width = 273
    Height = 75
    Caption = 'Z Position '
    TabOrder = 2
    object edZTop: TValidatedEdit
      Left = 12
      Top = 17
      Width = 192
      Height = 21
      Hint = 'Stage position on Z axis'
      ShowHint = True
      Text = ' 0.00 um'
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.2f'
      LoLimit = -10.000000000000000000
      HiLimit = 10.000000000000000000
    end
    object edGotoZPosition: TValidatedEdit
      Left = 103
      Top = 42
      Width = 102
      Height = 21
      Hint = 'Z axis position to move to'
      OnKeyPress = edGotoZPositionKeyPress
      ShowHint = True
      Text = ' 0.00 um'
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.2f'
      LoLimit = -1000000.000000000000000000
      HiLimit = 1000000.000000000000000000
    end
    object bGotoZPosition: TButton
      Left = 16
      Top = 44
      Width = 81
      Height = 17
      Hint = 'Move stage to specified Z axis position'
      Caption = 'Go To'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = bGotoZPositionClick
    end
  end
  object PMTGrp: TGroupBox
    Left = 8
    Top = 435
    Width = 273
    Height = 393
    Caption = ' PMT Channels  '
    TabOrder = 3
    object gpPMT1: TGroupBox
      Left = 8
      Top = 110
      Width = 251
      Height = 86
      TabOrder = 0
      object Label8: TLabel
        Left = 70
        Top = 6
        Width = 22
        Height = 13
        Caption = 'Gain'
      end
      object Label16: TLabel
        Left = 125
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object Label17: TLabel
        Left = 24
        Top = 50
        Width = 39
        Height = 13
        Caption = 'Intensity'
      end
      object CheckBox1: TCheckBox
        Left = 7
        Top = 22
        Width = 65
        Height = 17
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object ComboBox1: TComboBox
        Tag = 1
        Left = 70
        Top = 20
        Width = 49
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'X1'
        OnChange = cbPMTGain0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object ComboBox2: TComboBox
        Tag = 2
        Left = 125
        Top = 20
        Width = 116
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'X1'
        OnChange = cbLaserChange
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar3: TTrackBar
        Tag = 3
        Left = 70
        Top = 50
        Width = 124
        Height = 25
        Max = 1000
        Position = 100
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object ValidatedEdit2: TValidatedEdit
        Tag = 4
        Left = 190
        Top = 50
        Width = 50
        Height = 21
        OnKeyPress = ValidatedEdit1KeyPress
        Text = ' 100 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.0f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
    object gpPMT2: TGroupBox
      Left = 8
      Top = 200
      Width = 251
      Height = 86
      TabOrder = 1
      object Label18: TLabel
        Left = 70
        Top = 6
        Width = 22
        Height = 13
        Caption = 'Gain'
      end
      object Label19: TLabel
        Left = 125
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object Label20: TLabel
        Left = 24
        Top = 50
        Width = 39
        Height = 13
        Caption = 'Intensity'
      end
      object CheckBox2: TCheckBox
        Left = 7
        Top = 22
        Width = 65
        Height = 17
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object ComboBox3: TComboBox
        Tag = 1
        Left = 70
        Top = 20
        Width = 49
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'X1'
        OnChange = cbPMTGain0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object ComboBox4: TComboBox
        Tag = 2
        Left = 125
        Top = 20
        Width = 116
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'X1'
        OnChange = cbLaserChange
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar4: TTrackBar
        Tag = 3
        Left = 70
        Top = 50
        Width = 124
        Height = 25
        Max = 1000
        Position = 100
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object ValidatedEdit3: TValidatedEdit
        Tag = 4
        Left = 190
        Top = 50
        Width = 50
        Height = 21
        OnKeyPress = ValidatedEdit1KeyPress
        Text = ' 100 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.0f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
    object gpPMT0: TGroupBox
      Left = 8
      Top = 20
      Width = 251
      Height = 86
      TabOrder = 2
      object Label15: TLabel
        Left = 70
        Top = 6
        Width = 22
        Height = 13
        Caption = 'Gain'
      end
      object Label3: TLabel
        Left = 125
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object Label7: TLabel
        Left = 24
        Top = 50
        Width = 39
        Height = 13
        Caption = 'Intensity'
      end
      object ckEnablePMT0: TCheckBox
        Left = 7
        Top = 22
        Width = 65
        Height = 17
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object cbPMTGain0: TComboBox
        Tag = 1
        Left = 70
        Top = 20
        Width = 49
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'X1'
        OnChange = cbPMTGain0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object cbLaser: TComboBox
        Tag = 2
        Left = 125
        Top = 20
        Width = 116
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'X1'
        OnChange = cbLaserChange
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar2: TTrackBar
        Tag = 3
        Left = 69
        Top = 50
        Width = 124
        Height = 25
        Max = 1000
        Position = 100
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object ValidatedEdit1: TValidatedEdit
        Tag = 4
        Left = 190
        Top = 50
        Width = 50
        Height = 21
        OnKeyPress = ValidatedEdit1KeyPress
        Text = ' 100 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.0f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
    object gpPMT3: TGroupBox
      Left = 8
      Top = 290
      Width = 251
      Height = 86
      TabOrder = 3
      object Label21: TLabel
        Left = 70
        Top = 6
        Width = 22
        Height = 13
        Caption = 'Gain'
      end
      object Label22: TLabel
        Left = 125
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object Label23: TLabel
        Left = 24
        Top = 50
        Width = 39
        Height = 13
        Caption = 'Intensity'
      end
      object CheckBox3: TCheckBox
        Left = 7
        Top = 22
        Width = 65
        Height = 17
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object ComboBox5: TComboBox
        Tag = 1
        Left = 70
        Top = 20
        Width = 49
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'X1'
        OnChange = cbPMTGain0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object ComboBox6: TComboBox
        Tag = 2
        Left = 125
        Top = 20
        Width = 116
        Height = 24
        Hint = 'PMT amplifier gain'
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'X1'
        OnChange = cbLaserChange
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar5: TTrackBar
        Tag = 3
        Left = 70
        Top = 50
        Width = 124
        Height = 25
        Max = 1000
        Position = 100
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object ValidatedEdit4: TValidatedEdit
        Tag = 4
        Left = 190
        Top = 50
        Width = 50
        Height = 21
        OnKeyPress = ValidatedEdit1KeyPress
        Text = ' 100 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.0f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
  end
  object DisplayGrp: TGroupBox
    Left = 1
    Top = 834
    Width = 273
    Height = 165
    Caption = ' Display '
    TabOrder = 4
    object Splitter1: TSplitter
      Left = 2
      Top = 15
      Height = 148
      ExplicitHeight = 176
    end
    object cbPalette: TComboBox
      Left = 11
      Top = 15
      Width = 193
      Height = 21
      Hint = 'Display colour palette'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = cbPaletteChange
    end
    object ContrastPage: TPageControl
      Left = 10
      Top = 42
      Width = 196
      Height = 117
      ActivePage = RangeTab
      MultiLine = True
      TabOrder = 1
      object RangeTab: TTabSheet
        Caption = 'Display Contrast'
        object bFullScale: TButton
          Left = 2
          Top = 4
          Width = 70
          Height = 17
          Hint = 'Set display intensity range to cover full camera range'
          Caption = 'Full Range'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = bFullScaleClick
        end
        object bMaxContrast: TButton
          Left = 3
          Top = 23
          Width = 70
          Height = 17
          Hint = 'Set display range to min. - max.  intensities within image'
          Caption = 'Best'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bMaxContrastClick
        end
        object edDisplayIntensityRange: TRangeEdit
          Left = 78
          Top = 4
          Width = 104
          Height = 20
          Hint = 'Range of intensities displayed within image'
          OnKeyPress = edDisplayIntensityRangeKeyPress
          AutoSize = False
          ShowHint = True
          Text = ' 4096 - 4096 '
          LoValue = 4096.000000000000000000
          HiValue = 4096.000000000000000000
          HiLimit = 1.000000015047466E30
          Scale = 1.000000000000000000
          NumberFormat = '%.0f - %.0f'
        end
        object ckContrast6SDOnly: TCheckBox
          Left = 2
          Top = 63
          Width = 105
          Height = 17
          Hint = 
            'Set maximum contrast range to 6 standard deviations rather than ' +
            'min-max range'
          Caption = '6 x s.d. only'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object ckAutoOptimise: TCheckBox
          Left = 2
          Top = 46
          Width = 119
          Height = 17
          Caption = 'Auto adjust'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
      end
      object SlidersTab: TTabSheet
        Caption = 'Sliders'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label9: TLabel
          Left = 14
          Top = 0
          Width = 49
          Height = 15
          Caption = 'Contrast'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label10: TLabel
          Left = 14
          Top = 40
          Width = 62
          Height = 15
          Caption = 'Brightness'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label11: TLabel
          Left = 2
          Top = 18
          Width = 9
          Height = 19
          Caption = '+'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label13: TLabel
          Left = 2
          Top = 58
          Width = 9
          Height = 19
          Caption = '+'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label12: TLabel
          Left = 175
          Top = 16
          Width = 6
          Height = 19
          Caption = '-'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Bodoni MT Black'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label14: TLabel
          Left = 175
          Top = 56
          Width = 6
          Height = 19
          Caption = '-'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Bodoni MT Black'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object sbContrast: TScrollBar
          Left = 17
          Top = 17
          Width = 155
          Height = 17
          Hint = 'Display contrast control slider'
          LargeChange = 10
          PageSize = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = sbContrastChange
        end
        object sbBrightness: TScrollBar
          Left = 17
          Top = 61
          Width = 155
          Height = 17
          Hint = 'Display brightness control slider'
          LargeChange = 10
          PageSize = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = sbContrastChange
        end
      end
    end
  end
  object StatusGrp: TGroupBox
    Left = 1
    Top = 1039
    Width = 278
    Height = 81
    TabOrder = 5
    object meStatus: TMemo
      Left = 8
      Top = 10
      Width = 200
      Height = 61
      Lines.Strings = (
        'meStatus')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 153
    Caption = ' Image Capture  '
    TabOrder = 6
    object bCaptureImage: TButton
      Left = 8
      Top = 56
      Width = 140
      Height = 27
      Hint = 'Capture high resolution images'
      Caption = 'Capture Image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bCaptureImageClick
    end
    object bStopScan: TButton
      Left = 8
      Top = 112
      Width = 140
      Height = 28
      Hint = 'Stop scanning'
      Caption = 'Stop'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bStopImageClick
    end
    object ckRepeat: TCheckBox
      Left = 210
      Top = 111
      Width = 60
      Height = 17
      Hint = 'Repeated image scanning'
      Caption = 'Repeat'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object cbImageMode: TComboBox
      Left = 8
      Top = 84
      Width = 140
      Height = 21
      Hint = 'Image acquisition mode'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnChange = cbImageModeChange
    end
    object bLiveSCan: TButton
      Left = 8
      Top = 20
      Width = 140
      Height = 30
      Hint = 'Acquire high speed low resolution image of full imaging field'
      Caption = 'Live Image (Fast)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = bLiveSCanClick
    end
    object CCDAreaGrp: TGroupBox
      Left = 154
      Top = 15
      Width = 110
      Height = 114
      Caption = ' Scanning Area '
      TabOrder = 5
      object bEnterScanArea: TButton
        Left = 8
        Top = 70
        Width = 83
        Height = 25
        Hint = 'Specify coordinates of R.O.I.'
        Caption = 'Set ROI Area'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object bScanFullField: TButton
        Left = 8
        Top = 20
        Width = 96
        Height = 20
        Hint = 'Acquire high speed low resolution image of region of interest'
        Caption = 'Use Full Field'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = bScanFullFieldClick
      end
      object bScanROI: TButton
        Left = 11
        Top = 44
        Width = 96
        Height = 20
        Hint = 'Acquire high speed low resolution image of region of interest'
        Caption = 'Use ROI'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = bScanROIClick
      end
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 296
    Top = 928
  end
  object ImageFile: TImageFile
    XResolution = 1.000000000000000000
    YResolution = 1.000000000000000000
    ZResolution = 1.000000000000000000
    TResolution = 1.000000000000000000
    Left = 328
    Top = 928
  end
  object SaveDialog: TSaveDialog
    Left = 400
    Top = 928
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 928
    object File1: TMenuItem
      Caption = 'File'
      object mnSaveImage: TMenuItem
        Caption = '&Save Image To File'
        OnClick = mnSaveImageClick
      end
      object SavetoImageJ1: TMenuItem
        Caption = 'Save to Image-&J'
        OnClick = SavetoImageJ1Click
      end
      object mnExit: TMenuItem
        Caption = '&Exit'
        OnClick = mnExitClick
      end
    end
    object mnSetup: TMenuItem
      Caption = 'Setup'
      object mnScanSettings: TMenuItem
        Caption = '&Scan Settings'
        OnClick = mnScanSettingsClick
      end
    end
  end
end
