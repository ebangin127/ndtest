object fSetting: TfSetting
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #49444#51221
  ClientHeight = 337
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object lDrive: TLabel
    Left = 13
    Top = 13
    Width = 116
    Height = 19
    Caption = #49884#54744#54624' '#46300#46972#51060#48652' : '
  end
  object lCurrRemain: TLabel
    Left = 96
    Top = 40
    Width = 34
    Height = 19
    Caption = '0 MB'
  end
  object lCurrRemainName: TLabel
    Left = 13
    Top = 40
    Width = 74
    Height = 19
    Caption = #45224#51008' '#50857#47049' : '
  end
  object lLeft: TLabel
    Left = 13
    Top = 69
    Width = 74
    Height = 19
    Caption = #45224#44600' '#50857#47049' : '
  end
  object lUnitSpeed: TLabel
    Left = 13
    Top = 103
    Width = 107
    Height = 19
    Caption = #49549#46020' '#44592#47197' '#45800#50948' : '
  end
  object eDrive: TComboBox
    Left = 136
    Top = 11
    Width = 325
    Height = 27
    Style = csDropDownList
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
    OnChange = eDriveChange
  end
  object eLeft: TEdit
    Left = 96
    Top = 67
    Width = 299
    Height = 27
    CharCase = ecUpperCase
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    TabOrder = 1
    Text = '0'
    OnKeyPress = eLeftKeyPress
  end
  object cSelection: TComboBox
    Left = 403
    Top = 67
    Width = 58
    Height = 27
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
    Left = 129
    Top = 101
    Width = 332
    Height = 27
    Style = csDropDownList
    ImeName = 'Microsoft IME 2010'
    ItemIndex = 0
    TabOrder = 3
    Text = '0.1%'
    Items.Strings = (
      '0.1%'
      '1%'
      '10%')
  end
  object cCacheEffect: TCheckBox
    Left = 13
    Top = 135
    Width = 448
    Height = 18
    Caption = #50952#46020' '#52880#49884' '#54952#44284' '#51201#50857
    TabOrder = 4
  end
  object cRepeat: TCheckBox
    Left = 13
    Top = 164
    Width = 448
    Height = 25
    Caption = #47924#54620' '#48152#48373' '#51652#54665
    TabOrder = 5
  end
  object bStart: TButton
    Left = 13
    Top = 299
    Width = 448
    Height = 30
    Caption = #49884#51089
    TabOrder = 6
    OnClick = bStartClick
  end
  object cDelete: TCheckBox
    Left = 13
    Top = 197
    Width = 448
    Height = 26
    Caption = #51333#47308' '#54980' '#54028#51068' '#49325#51228
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object cDetailedRecord: TCheckBox
    Left = 13
    Top = 268
    Width = 117
    Height = 19
    Caption = #49345#49464' '#47196#44536' '#51200#51109
    TabOrder = 8
    OnKeyUp = cDetailedRecordKeyUp
    OnMouseUp = cDetailedRecordMouseUp
  end
  object cLogNeeded: TCheckBox
    Left = 13
    Top = 235
    Width = 89
    Height = 19
    Caption = #47196#44536' '#51200#51109
    TabOrder = 9
    OnKeyUp = cLogNeededKeyUp
    OnMouseUp = cLogNeededMouseUp
  end
  object eLogPath: TEdit
    Left = 109
    Top = 231
    Width = 305
    Height = 27
    CharCase = ecUpperCase
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 10
    OnClick = bLogNeededClick
  end
  object eDetailedLogPath: TEdit
    Left = 131
    Top = 265
    Width = 285
    Height = 27
    CharCase = ecUpperCase
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 11
    OnClick = bDetailedRecordClick
  end
  object bLogPath: TButton
    Left = 422
    Top = 231
    Width = 39
    Height = 26
    Caption = '...'
    TabOrder = 12
    OnClick = bLogNeededClick
  end
  object bDetailedLogPath: TButton
    Left = 422
    Top = 265
    Width = 39
    Height = 26
    Caption = '...'
    TabOrder = 13
    OnClick = bDetailedRecordClick
  end
  object sdText: TSaveDialog
    Filter = 'Text File(*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofCreatePrompt, ofEnableSizing]
    Left = 312
    Top = 189
  end
end
