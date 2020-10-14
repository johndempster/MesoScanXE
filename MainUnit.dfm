object MainFrm: TMainFrm
  Left = 8
  Top = 50
  Caption = 'MesoScan V2.0.0 '
  ClientHeight = 1189
  ClientWidth = 1109
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageGrp: TGroupBox
    Left = 383
    Top = 8
    Width = 698
    Height = 288
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 3
      Top = 3
      Width = 86
      Height = 20
      BevelOuter = bvNone
      TabOrder = 0
    end
    object ImagePage: TPageControl
      Left = 0
      Top = 3
      Width = 681
      Height = 217
      ActivePage = TabImage1
      TabOrder = 1
      OnChange = ImagePageChange
      object TabImage0: TTabSheet
        Caption = 'PMT0'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Image0: TImage
          Left = 3
          Top = 1
          Width = 281
          Height = 178
          ParentShowHint = False
          ShowHint = False
          Stretch = True
          OnMouseDown = Image0MouseDown
          OnMouseLeave = Image0MouseLeave
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
      object TabImage1: TTabSheet
        Caption = 'PMT1'
        ImageIndex = 1
        object Image1: TImage
          Left = 3
          Top = 0
          Width = 281
          Height = 185
          ParentShowHint = False
          ShowHint = False
          Stretch = True
          OnMouseDown = Image0MouseDown
          OnMouseLeave = Image0MouseLeave
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
      object TabImage2: TTabSheet
        Caption = 'PMT2'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Image2: TImage
          Left = 3
          Top = 0
          Width = 281
          Height = 185
          ParentShowHint = False
          ShowHint = False
          Stretch = True
          OnMouseDown = Image0MouseDown
          OnMouseLeave = Image0MouseLeave
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
      object TabImage3: TTabSheet
        Caption = 'PMT3'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Image3: TImage
          Left = 3
          Top = 0
          Width = 281
          Height = 185
          Stretch = True
          OnMouseDown = Image0MouseDown
          OnMouseLeave = Image0MouseLeave
          OnMouseMove = Image0MouseMove
          OnMouseUp = Image0MouseUp
        end
      end
    end
    object ZoomPanel: TPanel
      Left = 16
      Top = 237
      Width = 105
      Height = 30
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
    object pnZSection: TPanel
      Left = 127
      Top = 239
      Width = 170
      Height = 30
      BevelOuter = bvNone
      Caption = 'pnZSection'
      TabOrder = 3
      object lbZSection: TLabel
        Left = 0
        Top = 2
        Width = 28
        Height = 16
        Caption = 'xxxx'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object scZSection: TScrollBar
        Left = 40
        Top = 0
        Width = 121
        Height = 24
        PageSize = 0
        TabOrder = 0
        OnChange = scZSectionChange
      end
    end
    object pnTPoint: TPanel
      Left = 303
      Top = 239
      Width = 190
      Height = 30
      BevelOuter = bvNone
      Caption = 'pnTPoint'
      TabOrder = 4
      object lbTPoint: TLabel
        Left = 0
        Top = 2
        Width = 28
        Height = 16
        Caption = 'xxxx'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object scTPoint: TScrollBar
        Left = 40
        Top = 0
        Width = 121
        Height = 24
        PageSize = 0
        TabOrder = 0
        OnChange = scZSectionChange
      end
    end
    object pnRepeat: TPanel
      Left = 496
      Top = 239
      Width = 190
      Height = 30
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 5
      object lbRepeat: TLabel
        Left = 0
        Top = 2
        Width = 31
        Height = 16
        Caption = 'R:1/1'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object scRepeat: TScrollBar
        Left = 40
        Top = 0
        Width = 121
        Height = 24
        PageSize = 0
        TabOrder = 0
        OnChange = scZSectionChange
      end
    end
  end
  object PMTGrp: TGroupBox
    Left = 8
    Top = 538
    Width = 369
    Height = 370
    Caption = ' PMT Channels  '
    TabOrder = 1
    object gpPMT0: TGroupBox
      Left = 8
      Top = 22
      Width = 350
      Height = 80
      TabOrder = 0
      object Label15: TLabel
        Tag = 10
        Left = 66
        Top = 6
        Width = 48
        Height = 13
        Caption = 'PMT Gain'
      end
      object Label3: TLabel
        Tag = 10
        Left = 180
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object ckEnablePMT0: TCheckBox
        Left = 7
        Top = 22
        Width = 50
        Height = 17
        Hint = 'Enable PMT Channel'
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object cbPMTGain0: TComboBox
        Tag = 1
        Left = 67
        Top = 20
        Width = 107
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
      object cbPMTLaser0: TComboBox
        Tag = 2
        Left = 181
        Top = 22
        Width = 162
        Height = 24
        Hint = 'Excitation laser selected for this PMT channel'
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
        OnChange = cbPMTLaser0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar2: TTrackBar
        Tag = 3
        Left = 62
        Top = 50
        Width = 60
        Height = 22
        Hint = 'PMT gain (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object edPMTLaserIntensity0: TValidatedEdit
        Tag = 6
        Left = 292
        Top = 50
        Width = 50
        Height = 21
        Hint = 'Excitation laser intensity (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
      object tbPMTLaserIntensity0: TTrackBar
        Tag = 5
        Left = 179
        Top = 50
        Width = 110
        Height = 22
        Hint = 'Excitation laser intensity (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 5
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = tbPMTLaserIntensity0Change
      end
      object ValidatedEdit5: TValidatedEdit
        Tag = 4
        Left = 123
        Top = 50
        Width = 50
        Height = 21
        Hint = 'PMT Gain (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
    object gpPMT1: TGroupBox
      Left = 8
      Top = 108
      Width = 350
      Height = 80
      TabOrder = 1
      object Label7: TLabel
        Tag = 10
        Left = 66
        Top = 6
        Width = 48
        Height = 13
        Caption = 'PMT Gain'
      end
      object Label8: TLabel
        Tag = 10
        Left = 180
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object CheckBox1: TCheckBox
        Left = 7
        Top = 22
        Width = 50
        Height = 17
        Hint = 'Enable PMT Channel'
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object ComboBox1: TComboBox
        Tag = 1
        Left = 66
        Top = 22
        Width = 107
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
      object cbPMTLaser1: TComboBox
        Tag = 2
        Left = 179
        Top = 22
        Width = 162
        Height = 24
        Hint = 'Excitation laser selected for this PMT channel'
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
        OnChange = cbPMTLaser0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar3: TTrackBar
        Tag = 3
        Left = 62
        Top = 50
        Width = 60
        Height = 22
        Hint = 'PMT gain (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object edPMTLaserIntensity1: TValidatedEdit
        Tag = 6
        Left = 292
        Top = 50
        Width = 50
        Height = 21
        Hint = 'Excitation laser intensity (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
      object tbPMTLaserIntensity1: TTrackBar
        Tag = 5
        Left = 175
        Top = 50
        Width = 110
        Height = 22
        Hint = 'Excitation laser intensity (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 5
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = tbPMTLaserIntensity0Change
      end
      object ValidatedEdit3: TValidatedEdit
        Tag = 4
        Left = 123
        Top = 50
        Width = 50
        Height = 21
        Hint = 'PMT Gain (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
    object gpPMT2: TGroupBox
      Left = 8
      Top = 194
      Width = 350
      Height = 80
      TabOrder = 2
      object Label16: TLabel
        Tag = 10
        Left = 66
        Top = 6
        Width = 48
        Height = 13
        Caption = 'PMT Gain'
      end
      object Label17: TLabel
        Tag = 10
        Left = 180
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object CheckBox2: TCheckBox
        Left = 7
        Top = 22
        Width = 50
        Height = 17
        Hint = 'Enable PMT Channel'
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object ComboBox3: TComboBox
        Tag = 1
        Left = 66
        Top = 22
        Width = 107
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
      object cbPMTLaser2: TComboBox
        Tag = 2
        Left = 180
        Top = 22
        Width = 162
        Height = 24
        Hint = 'Excitation laser selected for this PMT channel'
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
        OnChange = cbPMTLaser0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar5: TTrackBar
        Tag = 3
        Left = 62
        Top = 50
        Width = 60
        Height = 22
        Hint = 'PMT gain (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object edPMTLaserIntensity2: TValidatedEdit
        Tag = 6
        Left = 292
        Top = 50
        Width = 50
        Height = 21
        Hint = 'Excitation laser intensity (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
      object tbPMTLaserIntensity2: TTrackBar
        Tag = 5
        Left = 175
        Top = 50
        Width = 110
        Height = 22
        Hint = 'Excitation laser intensity (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 5
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = tbPMTLaserIntensity0Change
      end
      object ValidatedEdit6: TValidatedEdit
        Tag = 4
        Left = 123
        Top = 50
        Width = 50
        Height = 21
        Hint = 'PMT Gain (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
    object gpPMT3: TGroupBox
      Left = 8
      Top = 280
      Width = 350
      Height = 80
      TabOrder = 3
      object Label18: TLabel
        Tag = 10
        Left = 66
        Top = 6
        Width = 48
        Height = 13
        Caption = 'PMT Gain'
      end
      object Label19: TLabel
        Tag = 10
        Left = 180
        Top = 6
        Width = 26
        Height = 13
        Caption = 'Laser'
      end
      object CheckBox3: TCheckBox
        Left = 7
        Top = 22
        Width = 50
        Height = 17
        Hint = 'Enable PMT Channel'
        Caption = 'Ch.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ckEnablePMT0Click
      end
      object ComboBox5: TComboBox
        Tag = 1
        Left = 66
        Top = 22
        Width = 107
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
      object cbPMTLaser3: TComboBox
        Tag = 2
        Left = 180
        Top = 22
        Width = 162
        Height = 24
        Hint = 'Excitation laser selected for this PMT channel'
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
        OnChange = cbPMTLaser0Change
        Items.Strings = (
          'X1'
          'X2'
          'X5')
      end
      object TrackBar7: TTrackBar
        Tag = 3
        Left = 62
        Top = 50
        Width = 60
        Height = 22
        Hint = 'PMT gain (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 3
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = TrackBar2Change
      end
      object edPMTLaserIntensity3: TValidatedEdit
        Tag = 6
        Left = 292
        Top = 50
        Width = 50
        Height = 21
        Hint = 'Excitation laser intensity (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
      object tbPMTLaserIntensity3: TTrackBar
        Tag = 5
        Left = 175
        Top = 50
        Width = 110
        Height = 22
        Hint = 'Excitation laser intensity (% of maximum)'
        Max = 1000
        ParentShowHint = False
        Position = 100
        ShowHint = True
        TabOrder = 5
        ThumbLength = 14
        TickStyle = tsManual
        OnChange = tbPMTLaserIntensity0Change
      end
      object ValidatedEdit8: TValidatedEdit
        Tag = 4
        Left = 123
        Top = 50
        Width = 50
        Height = 21
        Hint = 'PMT Gain (% of maximum)'
        OnKeyPress = edPMTLaserIntensity0KeyPress
        ShowHint = True
        Text = ' 100.0 %'
        Value = 1.000000000000000000
        Scale = 100.000000000000000000
        Units = '%'
        NumberFormat = '%.1f'
        LoLimit = 0.000000999999997475
        HiLimit = 100.000000000000000000
      end
    end
  end
  object DisplayGrp: TGroupBox
    Left = 8
    Top = 898
    Width = 365
    Height = 138
    Caption = ' Display '
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 2
      Top = 15
      Height = 121
      ExplicitHeight = 176
    end
    object cbPalette: TComboBox
      Left = 11
      Top = 15
      Width = 346
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
      Width = 347
      Height = 87
      ActivePage = RangeTab
      MultiLine = True
      TabOrder = 1
      object RangeTab: TTabSheet
        Caption = 'Display Contrast'
        object bFullScale: TButton
          Left = 10
          Top = 3
          Width = 90
          Height = 25
          Hint = 'Set display intensity range to cover full camera range'
          Caption = 'Full Range'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = bFullScaleClick
        end
        object bMaxContrast: TButton
          Left = 106
          Top = 3
          Width = 90
          Height = 25
          Hint = 'Set display range to min. - max.  intensities within image'
          Caption = 'Best'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bMaxContrastClick
        end
        object edDisplayIntensityRange: TRangeEdit
          Left = 202
          Top = 3
          Width = 127
          Height = 24
          Hint = 'Range of intensities displayed within image'
          OnKeyPress = edDisplayIntensityRangeKeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ShowHint = True
          Text = ' 4096 - 4096 '
          LoValue = 4096.000000000000000000
          HiValue = 4096.000000000000000000
          HiLimit = 1.000000015047466E30
          Scale = 1.000000000000000000
          NumberFormat = '%.0f - %.0f'
        end
        object ckContrast6SDOnly: TCheckBox
          Left = 202
          Top = 33
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
          Left = 106
          Top = 34
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
          Left = 186
          Top = -1
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
          Top = 20
          Width = 5
          Height = 19
          Caption = '-'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label13: TLabel
          Left = 328
          Top = 20
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
          Left = 160
          Top = 16
          Width = 11
          Height = 19
          Caption = '+'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Bodoni MT Black'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label14: TLabel
          Left = 174
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
        object sbContrast: TScrollBar
          Left = 14
          Top = 20
          Width = 140
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
          Left = 186
          Top = 20
          Width = 140
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
    Left = 8
    Top = 1042
    Width = 365
    Height = 81
    TabOrder = 3
    object meStatus: TMemo
      Left = 8
      Top = 10
      Width = 345
      Height = 61
      Lines.Strings = (
        'meStatus')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object ImageCaptureGrp: TGroupBox
    Left = 8
    Top = 8
    Width = 369
    Height = 404
    Caption = ' Image Capture  '
    TabOrder = 4
    object Label4: TLabel
      Left = 282
      Top = 190
      Width = 66
      Height = 16
      Alignment = taRightJustify
      Caption = 'No. Averages'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
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
      Top = 111
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
      OnClick = bStopScanClick
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
      TabOrder = 2
      OnChange = cbImageModeChange
    end
    object CCDAreaGrp: TGroupBox
      Left = 160
      Top = 12
      Width = 200
      Height = 164
      Caption = ' Scanning Area '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object rbFullField: TRadioButton
        Left = 8
        Top = 18
        Width = 145
        Height = 24
        Hint = 'Scan whole microscope image field'
        Caption = 'Full Field'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        OnMouseUp = rbFullFieldMouseUp
      end
      object rbScanROI: TRadioButton
        Left = 8
        Top = 36
        Width = 145
        Height = 24
        Hint = 'Scan area defined by region of interest om image'
        Caption = 'Scan Region '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnMouseUp = rbScanROIMouseUp
      end
      object rbScanRange: TRadioButton
        Left = 8
        Top = 55
        Width = 145
        Height = 25
        Hint = 'Scan area defined by user-entered X and Y range'
        Caption = 'Scan Range'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnMouseUp = rbScanRangeMouseUp
      end
      object AreaGrp: TGroupBox
        Left = 26
        Top = 80
        Width = 167
        Height = 71
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        object Label25: TLabel
          Left = 8
          Top = 38
          Width = 12
          Height = 16
          Alignment = taRightJustify
          Caption = 'Y:'
        end
        object Label24: TLabel
          Left = 8
          Top = 10
          Width = 11
          Height = 16
          Alignment = taRightJustify
          Caption = 'X:'
        end
        object edYRange: TRangeEdit
          Left = 24
          Top = 38
          Width = 134
          Height = 24
          Hint = 'Y Axis scanning area (um)'
          ShowHint = True
          Text = ' 0.0 - 1.0 um'
          HiValue = 1.000000000000000000
          HiLimit = 5000.000000000000000000
          Scale = 1.000000000000000000
          Units = 'um'
          NumberFormat = '%.1f - %.1f'
        end
        object edXRange: TRangeEdit
          Left = 24
          Top = 10
          Width = 134
          Height = 24
          Hint = 'X Axis scanning range (um)'
          ShowHint = True
          Text = ' 5000.0 - 5000.0 um'
          LoValue = 5000.000000000000000000
          HiValue = 5000.000000000000000000
          HiLimit = 5000.000000000000000000
          Scale = 1.000000000000000000
          Units = 'um'
          NumberFormat = '%.1f - %.1f'
        end
      end
    end
    object edNumRepeats: TValidatedEdit
      Left = 282
      Top = 212
      Width = 66
      Height = 24
      Hint = 'No. of images to be averaged'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ShowHint = True
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 20000.000000000000000000
    end
    object bLiveSCan: TButton
      Left = 8
      Top = 20
      Width = 140
      Height = 30
      Hint = 'Acquire repeated high speed low resolution image'
      Caption = 'Live Image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = bLiveSCanClick
    end
    object ckKeepRepeats: TCheckBox
      Left = 279
      Top = 242
      Width = 80
      Height = 42
      Hint = 'Tick to save sections in file for later off-line averaging'
      Alignment = taLeftJustify
      Caption = 'Keep images for later averaging'
      TabOrder = 8
      WordWrap = True
    end
    object TimeLapseGrp: TGroupBox
      Left = 8
      Top = 180
      Width = 265
      Height = 81
      Caption = ' Time Lapse '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      object Label20: TLabel
        Left = 87
        Top = 18
        Width = 93
        Height = 16
        Alignment = taRightJustify
        Caption = 'No. Time Points'
      end
      object Label21: TLabel
        Left = 68
        Top = 48
        Width = 111
        Height = 16
        Alignment = taRightJustify
        Caption = 'Time Lapse Interval'
      end
      object rbTimeLapseOn: TRadioButton
        Left = 8
        Top = 16
        Width = 41
        Height = 25
        Caption = 'On'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object tbTimeLapseOff: TRadioButton
        Left = 8
        Top = 40
        Width = 41
        Height = 25
        Hint = 'Time lapse disabled'
        Caption = 'Off'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
      end
      object edNumTPoints: TValidatedEdit
        Left = 186
        Top = 18
        Width = 60
        Height = 24
        Hint = 'No. of time points to acquire'
        ShowHint = True
        Text = ' 1000 '
        Value = 1000.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.0f'
        LoLimit = 1.000000000000000000
        HiLimit = 30000.000000000000000000
      end
      object edTPointInterval: TValidatedEdit
        Left = 185
        Top = 48
        Width = 60
        Height = 24
        Hint = 'Time interval between points'
        ShowHint = True
        Text = ' 1000 s'
        Value = 1000.000000000000000000
        Scale = 1.000000000000000000
        Units = 's'
        NumberFormat = '%.0f'
        LoLimit = 1.000000000000000000
        HiLimit = 30000.000000000000000000
      end
    end
    object LineScanGrp: TGroupBox
      Left = 8
      Top = 270
      Width = 262
      Height = 123
      Caption = ' Line Scan '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      object Label2: TLabel
        Left = 129
        Top = 18
        Width = 51
        Height = 16
        Alignment = taRightJustify
        Caption = 'No. lines'
      end
      object edLineScanFrameHeight: TValidatedEdit
        Left = 186
        Top = 18
        Width = 60
        Height = 24
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
    object ZStackGrp: TGroupBox
      Left = 8
      Top = 270
      Width = 262
      Height = 119
      Caption = ' Z Stack '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      object Label5: TLabel
        Left = 84
        Top = 17
        Width = 75
        Height = 16
        Alignment = taRightJustify
        Caption = 'No. Sections'
      end
      object Label6: TLabel
        Left = 18
        Top = 46
        Width = 141
        Height = 16
        Alignment = taRightJustify
        Caption = 'Section Spacing (pixels)'
      end
      object Label1: TLabel
        Left = 34
        Top = 74
        Width = 125
        Height = 16
        Alignment = taRightJustify
        Caption = 'Section Spacing (um)'
      end
      object edNumZSteps: TValidatedEdit
        Left = 165
        Top = 17
        Width = 80
        Height = 24
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
        Left = 165
        Top = 46
        Width = 80
        Height = 24
        Hint = 'Z increment between sections'
        OnKeyPress = edNumPixelsPerZStepKeyPress
        ShowHint = True
        Text = ' 1.000 '
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.3f'
        LoLimit = -100.000000000000000000
        HiLimit = 100.000000000000000000
      end
      object edMicronsPerZStep: TValidatedEdit
        Left = 165
        Top = 74
        Width = 80
        Height = 24
        Hint = 'Z increment between sections'
        OnKeyPress = edMicronsPerZStepKeyPress
        ShowHint = True
        Text = ' 0.000 um'
        Scale = 1.000000000000000000
        Units = 'um'
        NumberFormat = '%.3f'
        LoLimit = -100.000000000000000000
        HiLimit = 100.000000000000000000
      end
    end
  end
  object StagePositionGrp: TGroupBox
    Left = 8
    Top = 418
    Width = 369
    Height = 118
    Caption = ' Stage Position '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object edGotoXPosition: TValidatedEdit
      Left = 90
      Top = 56
      Width = 90
      Height = 28
      Hint = 'Z axis position to move to'
      OnKeyPress = edGotoXPositionKeyPress
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ShowHint = True
      Text = ' 0.00 um'
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.2f'
      LoLimit = -1000000.000000000000000000
      HiLimit = 1000000.000000000000000000
    end
    object Button1: TButton
      Left = 8
      Top = 86
      Width = 80
      Height = 25
      Hint = 'Move stage to specified Z axis position'
      Caption = 'Go to Z='
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bGotoZPositionClick
    end
    object edGotoYPosition: TValidatedEdit
      Left = 272
      Top = 56
      Width = 90
      Height = 28
      Hint = 'Z axis position to move to'
      OnKeyPress = edGotoYPositionKeyPress
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ShowHint = True
      Text = ' 0.00 um'
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.2f'
      LoLimit = -1000000.000000000000000000
      HiLimit = 1000000.000000000000000000
    end
    object edGotoZPosition: TValidatedEdit
      Left = 90
      Top = 86
      Width = 90
      Height = 28
      Hint = 'Z axis position to move to'
      OnKeyPress = edGotoZPositionKeyPress
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ShowHint = True
      Text = ' 0.00 um'
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.2f'
      LoLimit = -1000000.000000000000000000
      HiLimit = 1000000.000000000000000000
    end
    object edXYZPosition: TEdit
      Left = 8
      Top = 18
      Width = 353
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object bGoToXPosition: TButton
      Left = 8
      Top = 56
      Width = 80
      Height = 24
      Hint = 'Move stage to specified X axis position'
      Caption = 'Go to X='
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = bGoToXPositionClick
    end
    object bGoToYPosition: TButton
      Left = 190
      Top = 56
      Width = 80
      Height = 24
      Hint = 'Move stage to specified Y axis position'
      Caption = 'Go to Y='
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = bGoToYPositionClick
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 536
    Top = 1064
  end
  object ImageFile: TImageFile
    XResolution = 1.000000000000000000
    YResolution = 1.000000000000000000
    ZResolution = 1.000000000000000000
    TResolution = 1.000000000000000000
    Left = 408
    Top = 872
  end
  object SaveDialog: TSaveDialog
    Left = 456
    Top = 864
  end
  object MainMenu1: TMainMenu
    Left = 520
    Top = 864
    object File1: TMenuItem
      Caption = '&File'
      object mnLoadImage: TMenuItem
        Caption = '&Load Image'
        OnClick = mnLoadImageClick
      end
      object mnSaveImage: TMenuItem
        Caption = '&Save Image'
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
      Caption = '&Setup'
      object mnScanSettings: TMenuItem
        Caption = '&Instrument Settings'
        OnClick = mnScanSettingsClick
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Help2: TMenuItem
        Caption = '&Help'
        OnClick = Help2Click
      end
      object About1: TMenuItem
        Caption = '&About'
      end
    end
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 592
    Top = 864
  end
end
