unit Forms.Setting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  uDiskFunctions;

type
  TfSetting = class(TForm)
    lDrive: TLabel;
    eDrive: TComboBox;
    lCurrRemain: TLabel;
    lCurrRemainName: TLabel;
    lLeft: TLabel;
    eLeft: TEdit;
    cSelection: TComboBox;
    cUnitSpeed: TComboBox;
    lUnitSpeed: TLabel;
    cCacheEffect: TCheckBox;
    cRepeat: TCheckBox;
    bStart: TButton;
    sdText: TSaveDialog;
    cDelete: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure eDriveChange(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure eLeftKeyPress(Sender: TObject; var Key: Char);
  private
    FIsSet: Boolean;
    FRecordPath: String;
    function AllOptionsSet: Boolean;
    function LeftSet: Boolean;
    procedure SetRecordPathAsSelectedFile;
    procedure FixSize;
    procedure GetFixedDrives;
  public
    property IsSet: Boolean read FIsSet;
    property RecordPath: String read FRecordPath;
  end;

var
  fSetting: TfSetting;

implementation

{$R *.dfm}

function TfSetting.LeftSet: Boolean;
var
  ToLeave: Integer;
begin
  result :=
    (eLeft.Text <> '') and
    (TryStrToInt(eLeft.Text, ToLeave));
end;

procedure TfSetting.SetRecordPathAsSelectedFile;
begin
  if sdText.Execute then
  begin
    FRecordPath := sdText.FileName;
    if ExtractFileExt(FRecordPath) = '' then
    begin
      if sdText.FilterIndex = 1 then
        FRecordPath := FRecordPath + '.txt';
    end;
  end;
end;

procedure TfSetting.FixSize;
begin
  Constraints.MaxHeight := Height;
  Constraints.MinHeight := Height;
  Constraints.MaxWidth := Width;
  Constraints.MinWidth := Width;
end;

procedure TfSetting.GetFixedDrives;
var
  Drives: TDriveLetters;
  CurrDrv: Integer;
begin
  FIsSet := false;
  Drives := GetFixedDrivesFunction;
  for CurrDrv := 0 to (Drives.LetterCount - 1) do
    eDrive.Items.Add(Drives.Letters[CurrDrv]);
  eDrive.ItemIndex := 0;
  eDriveChange(eDrive);
end;

function TfSetting.AllOptionsSet: Boolean;
begin
  result :=
    LeftSet;
end;

procedure TfSetting.bStartClick(Sender: TObject);
begin
  FIsSet := AllOptionsSet;
  if IsSet then
  begin
    SetRecordPathAsSelectedFile;
    Close;
  end;
end;

procedure TfSetting.eDriveChange(Sender: TObject);
begin
  lCurrRemain.Caption :=
    FormatFloat('0.0',
      DiskFree(Pos(eDrive.Items[eDrive.ItemIndex][1], VolumeNames)) /
        (1 shl 20)) + ' MiB(' +
    FormatFloat('0.0',
      DiskFree(Pos(eDrive.Items[eDrive.ItemIndex][1], VolumeNames)) /
        (1 shl 30)) + 'GiB)';
end;

procedure TfSetting.eLeftKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9']) then Key := #0;
end;

procedure TfSetting.FormCreate(Sender: TObject);
begin
  GetFixedDrives;
  FixSize;
end;

end.
