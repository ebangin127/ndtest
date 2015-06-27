object fMain: TfMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #45208#47000#50728' '#45908#54000' '#53580#49828#53944' 5.0.3'
  ClientHeight = 458
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object lCurrFile: TLabel
    Left = 12
    Top = 395
    Width = 73
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #54788#51116' '#54028#51068' : '
  end
  object lCurrSpd: TLabel
    Left = 12
    Top = 424
    Width = 41
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #49549#46020' : '
  end
  object bRand: TButton
    Left = 10
    Top = 305
    Width = 182
    Height = 36
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #52292#50864#44592
    TabOrder = 0
    OnClick = bRandClick
  end
  object pProgress: TProgressBar
    Left = 10
    Top = 349
    Width = 372
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
  end
  object bRandDel: TButton
    Left = 200
    Top = 305
    Width = 182
    Height = 36
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #52292#50864#44256' '#51648#50864#44592
    TabOrder = 2
    OnClick = bRandClick
  end
  object bCancel: TButton
    Left = 10
    Top = 501
    Width = 372
    Height = 35
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #52712#49548#54616#44592
    TabOrder = 3
    Visible = False
    OnClick = bCancelClick
  end
  object lSpeed: TListBox
    Left = 408
    Top = 21
    Width = 409
    Height = 518
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ItemHeight = 17
    TabOrder = 4
  end
  object bIdle: TButton
    Left = 10
    Top = 456
    Width = 372
    Height = 37
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = #51068#49884#51221#51648
    TabOrder = 5
    Visible = False
    OnClick = bIdleClick
  end
  object ePage: TPageControl
    Left = 10
    Top = 13
    Width = 372
    Height = 286
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabSheet1
    TabOrder = 6
    object TabSheet1: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #52292#50864#44592' '#49444#51221
      object Label3: TLabel
        Left = 16
        Top = 80
        Width = 73
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #45224#44600' '#50857#47049' : '
      end
      object lCurrRemain: TLabel
        Left = 152
        Top = 47
        Width = 30
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '0 MB'
      end
      object Label2: TLabel
        Left = 16
        Top = 47
        Width = 73
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #45224#51008' '#50857#47049' : '
      end
      object Label5: TLabel
        Left = 16
        Top = 115
        Width = 87
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #52292#50864#44592' '#45800#50948' : '
      end
      object lRand: TLabel
        Left = 16
        Top = 152
        Width = 55
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #47004#45924#47456' : '
      end
      object Label7: TLabel
        Left = 224
        Top = 150
        Width = 14
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '%'
      end
      object Label6: TLabel
        Left = 222
        Top = 186
        Width = 119
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #54924' (-1'#51008' '#47924#54620' '#48152#48373')'
      end
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 115
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #51201#50857#54624' '#46300#46972#51060#48652' : '
      end
      object eLeft: TEdit
        Left = 152
        Top = 76
        Width = 65
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CharCase = ecUpperCase
        ImeName = 'Microsoft IME 2010'
        NumbersOnly = True
        TabOrder = 0
        Text = '0'
        OnKeyPress = eLeftKeyPress
      end
      object cSelection: TComboBox
        Left = 225
        Top = 76
        Width = 69
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        ImeName = 'Microsoft IME 2010'
        ItemIndex = 0
        TabOrder = 1
        Text = 'GiB'
        Items.Strings = (
          'GiB'
          'MiB'
          '%')
      end
      object cAlignSize: TComboBox
        Left = 152
        Top = 111
        Width = 142
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        ImeName = 'Microsoft IME 2010'
        ItemIndex = 0
        TabOrder = 2
        Text = '8 MiB (Seq)'
        OnChange = cAlignSizeChange
        Items.Strings = (
          '8 MiB (Seq)'
          '4 MiB'
          '2 MiB'
          '1 MiB'
          '512 KiB'
          '256 KiB'
          '128 KiB'
          '64 KiB'
          '32 KiB'
          '16 KiB'
          '8 KiB'
          '4 KiB (AF Sect.)'
          '512 B (LBA Sect.)')
      end
      object eRandomness: TEdit
        Left = 150
        Top = 146
        Width = 66
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CharCase = ecUpperCase
        ImeName = 'Microsoft IME 2010'
        NumbersOnly = True
        TabOrder = 3
        Text = '100'
        OnChange = eRandomnessChange
        OnKeyPress = eRandomnessKeyPress
      end
      object cRepeat: TCheckBox
        Left = 16
        Top = 184
        Width = 127
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #48152#48373' '#51652#54665
        TabOrder = 4
      end
      object eTimes: TEdit
        Left = 150
        Top = 182
        Width = 66
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CharCase = ecUpperCase
        ImeName = 'Microsoft IME 2010'
        NumbersOnly = True
        TabOrder = 5
        Text = '-1'
        OnEnter = eTimesEnter
      end
      object eDrive: TComboBox
        Left = 150
        Top = 12
        Width = 143
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        ImeName = 'Microsoft IME 2010'
        TabOrder = 6
        OnChange = eDriveChange
      end
      object cEndurance: TCheckBox
        Left = 16
        Top = 217
        Width = 341
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #49688#47749' '#47784#46300
        TabOrder = 7
        OnClick = cEnduranceClick
        OnKeyPress = cEnduranceKeyPress
      end
    end
    object TabSheet2: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #44208#44284' '#54840#54872#49457
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label8: TLabel
        Left = 16
        Top = 16
        Width = 105
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #49549#46020' '#44592#47197' '#45800#50948' : '
      end
      object cUnitSpeed: TComboBox
        Left = 150
        Top = 12
        Width = 143
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        ImeName = 'Microsoft IME 2010'
        ItemIndex = 0
        TabOrder = 0
        Text = '0.1%'
        Items.Strings = (
          '0.1%'
          '1%')
      end
      object cCacheEffect: TCheckBox
        Left = 16
        Top = 47
        Width = 325
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #50952#46020' '#52880#49884' '#54952#44284' '#51201#50857
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
    end
  end
  object sdText: TSaveDialog
    Filter = 'Text File(*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofCreatePrompt, ofEnableSizing]
    Left = 256
    Top = 333
  end
end
