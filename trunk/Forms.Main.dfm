object fMain: TfMain
  Left = 0
  Top = 0
  Caption = #45208#47000#50728' '#45908#54000' '#53580#49828#53944' 6.0.2'
  ClientHeight = 973
  ClientWidth = 1391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object lCurrSpd: TLabel
    Left = 12
    Top = 82
    Width = 43
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #49549#46020' : '
  end
  object lCurrFile: TLabel
    Left = 12
    Top = 53
    Width = 77
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #54788#51116' '#54028#51068' : '
  end
  object pProgress: TProgressBar
    Left = 10
    Top = 10
    Width = 976
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
  end
  object bIdle: TButton
    Left = 1011
    Top = 10
    Width = 371
    Height = 37
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #51068#49884#51221#51648
    TabOrder = 1
    OnClick = bIdleClick
  end
  object bCancel: TButton
    Left = 1011
    Top = 55
    Width = 371
    Height = 35
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #52712#49548#54616#44592
    TabOrder = 2
    OnClick = bCancelClick
  end
  object cLog: TChart
    Left = 11
    Top = 116
    Width = 1372
    Height = 357
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BottomAxis.Title.Caption = #45224#51008' '#50857#47049' (%)'
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Title.Caption = #49549#46020' (MiB/s)'
    View3D = False
    View3DOptions.Orthogonal = False
    Zoom.MouseWheel = pmwNormal
    TabOrder = 3
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object FSpeedSeries: TLineSeries
      Legend.Visible = False
      ShowInLegend = False
      Title = 'FSpeedSeries'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {0000000000}
    end
  end
  object tSelectLogRange: TTabControl
    Left = 10
    Top = 479
    Width = 1374
    Height = 486
    TabOrder = 4
    Tabs.Strings = (
      #51060#51204' + '#54788#51116' '#54924#52264
      #54788#51116' '#54924#52264)
    TabIndex = 0
    OnChange = tSelectLogRangeChange
    object lCurrentLog: TListBox
      Left = 21
      Top = 36
      Width = 1349
      Height = 433
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BorderStyle = bsNone
      TabOrder = 0
    end
    object lLastAndCurrentLog: TListBox
      Left = 2
      Top = 28
      Width = 1349
      Height = 433
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BorderStyle = bsNone
      TabOrder = 1
    end
  end
end
