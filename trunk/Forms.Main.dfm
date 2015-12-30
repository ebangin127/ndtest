object fMain: TfMain
  Left = 0
  Top = 0
  Caption = #45208#47000#50728' '#45908#54000' '#53580#49828#53944' 6.0.4'
  ClientHeight = 730
  ClientWidth = 1043
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object lCurrSpd: TLabel
    Left = 9
    Top = 62
    Width = 35
    Height = 15
    Caption = #49549#46020' : '
  end
  object lCurrFile: TLabel
    Left = 9
    Top = 40
    Width = 63
    Height = 15
    Caption = #54788#51116' '#54028#51068' : '
  end
  object pProgress: TProgressBar
    Left = 8
    Top = 8
    Width = 732
    Height = 24
    TabOrder = 0
  end
  object bIdle: TButton
    Left = 758
    Top = 8
    Width = 279
    Height = 27
    Caption = #51068#49884#51221#51648
    TabOrder = 1
    OnClick = bIdleClick
  end
  object bCancel: TButton
    Left = 758
    Top = 41
    Width = 279
    Height = 27
    Caption = #52712#49548#54616#44592
    TabOrder = 2
    OnClick = bCancelClick
  end
  object cLog: TChart
    Left = 8
    Top = 87
    Width = 1029
    Height = 268
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Foot.Font.Name = #47569#51008' '#44256#46357
    Legend.Font.Name = #47569#51008' '#44256#46357
    Legend.LegendStyle = lsSeries
    Legend.Title.Font.Name = #47569#51008' '#44256#46357
    SubFoot.Font.Name = #47569#51008' '#44256#46357
    SubTitle.Font.Name = #47569#51008' '#44256#46357
    Title.Font.Name = #47569#51008' '#44256#46357
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BottomAxis.Inverted = True
    BottomAxis.LabelsFormat.Font.Name = #47569#51008' '#44256#46357
    BottomAxis.Title.Caption = #45224#51008' '#50857#47049' (%)'
    BottomAxis.Title.Font.Name = #47569#51008' '#44256#46357
    DepthAxis.LabelsFormat.Font.Name = #47569#51008' '#44256#46357
    DepthAxis.Title.Font.Name = #47569#51008' '#44256#46357
    DepthTopAxis.LabelsFormat.Font.Name = #47569#51008' '#44256#46357
    DepthTopAxis.Title.Font.Name = #47569#51008' '#44256#46357
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.LabelsFormat.Font.Name = #47569#51008' '#44256#46357
    LeftAxis.Title.Caption = #49549#46020' (MiB/s)'
    LeftAxis.Title.Font.Name = #47569#51008' '#44256#46357
    RightAxis.LabelsFormat.Font.Name = #47569#51008' '#44256#46357
    RightAxis.Title.Font.Name = #47569#51008' '#44256#46357
    TopAxis.LabelsFormat.Font.Name = #47569#51008' '#44256#46357
    TopAxis.Title.Font.Name = #47569#51008' '#44256#46357
    View3D = False
    View3DOptions.Orthogonal = False
    Zoom.MouseWheel = pmwNormal
    TabOrder = 3
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object FSpeedSeries: TFastLineSeries
      Selected.Hover.Visible = True
      Marks.Font.Name = #47569#51008' '#44256#46357
      Title = 'FSpeedSeries'
      DrawAllPoints = False
      DrawAllPointsStyle = daMinMax
      FastPen = True
      LinePen.Color = 10708548
      TreatNulls = tnDontPaint
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {0000000000}
    end
    object FHorizontalLine: TChartShape
      Active = False
      Marks.Font.Name = #47569#51008' '#44256#46357
      SeriesColor = clRed
      Title = 'FHorizontalLine'
      Brush.Color = clRed
      Font.Name = #47569#51008' '#44256#46357
      Pen.Color = clRed
      Style = chasHorizLine
      Y0 = 25.000000000000000000
      Y1 = 25.000000000000000000
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {
        0102000000000000000000000000000000000039400000000000000000000000
        0000003940}
    end
  end
  object tSelectLogRange: TTabControl
    Left = 8
    Top = 359
    Width = 1030
    Height = 365
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 4
    Tabs.Strings = (
      #51060#51204' + '#54788#51116' '#54924#52264
      #54788#51116' '#54924#52264)
    TabIndex = 0
    OnChange = tSelectLogRangeChange
    object lCurrentLog: TListBox
      Left = 16
      Top = 27
      Width = 1012
      Height = 325
      BorderStyle = bsNone
      ItemHeight = 15
      TabOrder = 0
    end
    object lLastAndCurrentLog: TListBox
      Left = 2
      Top = 21
      Width = 1011
      Height = 325
      BorderStyle = bsNone
      ItemHeight = 15
      TabOrder = 1
    end
  end
end
