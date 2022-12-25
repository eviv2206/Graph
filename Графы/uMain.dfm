object frmMain: TfrmMain
  Left = 1200
  Top = 243
  Caption = 'Graph_Lab'
  ClientHeight = 559
  ClientWidth = 875
  Color = clGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 13
  object AskLabel: TLabel
    Left = 24
    Top = 24
    Width = 239
    Height = 21
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1095#1080#1089#1083#1086' '#1074#1077#1088#1096#1080#1085' '#1075#1088#1072#1092#1072':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object MatrixLabel: TLabel
    Left = 16
    Top = 238
    Width = 168
    Height = 21
    Caption = #1052#1072#1090#1088#1080#1094#1072' '#1089#1084#1077#1078#1085#1086#1089#1090#1080':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 496
    Top = 0
    Width = 22
    Height = 23
    Caption = #1048#1079
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 656
    Top = 0
    Width = 11
    Height = 23
    Caption = #1042
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblLong: TLabel
    Left = 24
    Top = 96
    Width = 174
    Height = 21
    Caption = #1057#1072#1084#1099#1081' '#1076#1083#1080#1085#1085#1099#1081' '#1087#1091#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object lblShort: TLabel
    Left = 24
    Top = 136
    Width = 177
    Height = 21
    Caption = #1057#1072#1084#1099#1081' '#1082#1086#1088#1086#1090#1082#1080#1081' '#1087#1091#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object lblCenter: TLabel
    Left = 24
    Top = 176
    Width = 104
    Height = 21
    Caption = #1062#1077#1085#1090#1088' '#1075#1088#1072#1092#1072':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 520
    Top = 84
    Width = 40
    Height = 21
    Caption = #1055#1091#1090#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object VerticeEdit: TSpinEdit
    Left = 269
    Top = 21
    Width = 121
    Height = 32
    EditorEnabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    MaxValue = 15
    MinValue = 1
    ParentFont = False
    TabOrder = 0
    Value = 1
    OnChange = VerticeEditChange
  end
  object sgMatrix: TStringGrid
    Left = 16
    Top = 268
    Width = 305
    Height = 283
    ColCount = 2
    DefaultColWidth = 36
    DefaultRowHeight = 36
    RowCount = 2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
  end
  object eStart: TSpinEdit
    Left = 448
    Top = 29
    Width = 121
    Height = 32
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    MaxValue = 15
    MinValue = 0
    ParentFont = False
    TabOrder = 2
    Value = 1
  end
  object eFinish: TSpinEdit
    Left = 598
    Top = 29
    Width = 121
    Height = 32
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    MaxValue = 15
    MinValue = 0
    ParentFont = False
    TabOrder = 3
    Value = 1
  end
  object btnStart: TButton
    Left = 725
    Top = 28
    Width = 113
    Height = 33
    Caption = #1042#1074#1086#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnStartClick
  end
  object mRoutes: TMemo
    Left = 524
    Top = 111
    Width = 331
    Height = 93
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'mRoutes')
    ParentFont = False
    TabOrder = 5
  end
  object brnDraw: TButton
    Left = 725
    Top = 72
    Width = 113
    Height = 33
    Caption = #1053#1072#1088#1080#1089#1086#1074#1072#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = brnDrawClick
  end
end
