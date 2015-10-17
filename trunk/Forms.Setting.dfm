object fSetting: TfSetting
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #49444#51221
  ClientHeight = 313
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object lDrive: TLabel
    Left = 16
    Top = 16
    Width = 141
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #49884#54744#54624' '#46300#46972#51060#48652' : '
  end
  object lCurrRemain: TLabel
    Left = 116
    Top = 49
    Width = 41
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = '0 MB'
  end
  object lCurrRemainName: TLabel
    Left = 16
    Top = 49
    Width = 90
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #45224#51008' '#50857#47049' : '
  end
  object lLeft: TLabel
    Left = 16
    Top = 84
    Width = 90
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #45224#44600' '#50857#47049' : '
  end
  object lUnitSpeed: TLabel
    Left = 16
    Top = 125
    Width = 130
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #49549#46020' '#44592#47197' '#45800#50948' : '
  end
  object eDrive: TComboBox
    Left = 165
    Top = 13
    Width = 193
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
    OnChange = eDriveChange
  end
  object eLeft: TEdit
    Left = 116
    Top = 81
    Width = 162
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    CharCase = ecUpperCase
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    TabOrder = 1
    Text = '0'
    OnKeyPress = eLeftKeyPress
  end
  object cSelection: TComboBox
    Left = 288
    Top = 81
    Width = 70
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    ImeName = 'Microsoft IME 2010'
    ItemIndex = 0
    TabOrder = 2
    Text = 'GiB'
    Items.Strings = (
      'GiB'
      'MiB'
      '%')
  end
  object cUnitSpeed: TComboBox
    Left = 156
    Top = 122
    Width = 202
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    ImeName = 'Microsoft IME 2010'
    ItemIndex = 0
    TabOrder = 3
    Text = '0.1%'
    Items.Strings = (
      '0.1%'
      '1%')
  end
  object cCacheEffect: TCheckBox
    Left = 16
    Top = 163
    Width = 277
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #50952#46020' '#52880#49884' '#54952#44284' '#51201#50857
    TabOrder = 4
  end
  object cRepeat: TCheckBox
    Left = 16
    Top = 195
    Width = 278
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #47924#54620' '#48152#48373' '#51652#54665
    TabOrder = 5
  end
  object bStart: TButton
    Left = 16
    Top = 263
    Width = 342
    Height = 36
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #49884#51089
    TabOrder = 6
    OnClick = bStartClick
  end
  object cDelete: TCheckBox
    Left = 16
    Top = 228
    Width = 278
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #51333#47308' '#54980' '#54028#51068' '#49325#51228
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object sdText: TSaveDialog
    Filter = 'Text File(*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofCreatePrompt, ofEnableSizing]
    Left = 312
    Top = 189
  end
end
