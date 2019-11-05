object SetScanAreaFrm: TSetScanAreaFrm
  Tag = 37
  Left = 777
  Top = 526
  BorderStyle = bsDialog
  Caption = 'Set Scan Area'
  ClientHeight = 135
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AreaGrp: TGroupBox
    Left = 8
    Top = 2
    Width = 223
    Height = 80
    Caption = ' CCD readout area '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 30
      Top = 20
      Width = 48
      Height = 16
      Alignment = taRightJustify
      Caption = 'X Range'
    end
    object Label2: TLabel
      Left = 28
      Top = 48
      Width = 50
      Height = 16
      Alignment = taRightJustify
      Caption = 'Y Range'
    end
    object edXRange: TRangeEdit
      Left = 84
      Top = 20
      Width = 130
      Height = 24
      Text = ' 0 - 1 um'
      HiValue = 1.000000000000000000
      HiLimit = 5000.000000000000000000
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.0f - %.0f'
    end
    object edYRange: TRangeEdit
      Left = 84
      Top = 48
      Width = 130
      Height = 24
      Text = ' 0 - 1 um'
      HiValue = 1.000000000000000000
      HiLimit = 5000.000000000000000000
      Scale = 1.000000000000000000
      Units = 'um'
      NumberFormat = '%.0f - %.0f'
    end
  end
  object bOK: TButton
    Left = 8
    Top = 88
    Width = 40
    Height = 25
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 50
    Top = 88
    Width = 48
    Height = 17
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = bCancelClick
  end
end
