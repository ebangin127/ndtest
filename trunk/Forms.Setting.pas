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
    cDetailedRecord: TCheckBox;
    cLogNeeded: TCheckBox;
    eLogPath: TEdit;
    eDetailedLogPath: TEdit;
    bLogPath: TButton;
    bDetailedLogPath: TButton;
    procedure FormCreate(Sender: TObject);
    procedure eDriveChange(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure eLeftKeyPress(Sender: TObject; var Key: Char);
    procedure bLogNeededClick(Sender: TObject);
    procedure bDetailedRecordClick(Sender: TObject);
    procedure cDetailedRecordMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cLogNeededMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cLogNeededKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cDetailedRecordKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FIsSet: Boolean;
    FRecordPath: String;
    FDetailedRecordPath: String;
    function AllOptionsSet: Boolean;
    function LeftSet: Boolean;
    procedure FixSize;
    procedure GetFixedDrives;
    function GetTextPath: String;
  public
    property IsSet: Boolean read FIsSet;
    property RecordPath: String read FRecordPath;
    property DetailedRecordPath: String read FDetailedRecordPath;
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

function TfSetting.GetTextPath: String;
begin
  result := '';
  if sdText.Execute then
  begin
    result := sdText.FileName;
    if ExtractFileExt(result) = '' then
    begin
      if sdText.FilterIndex = 1 then
        result := result + '.txt';
    end;
  end;
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
    Close;
end;

procedure TfSetting.cDetailedRecordKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  cDetailedRecordMouseUp(Sender, TMouseButton.mbLeft, Shift, 0, 0);
end;

procedure TfSetting.cDetailedRecordMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if cDetailedRecord.Checked = false then
  begin
    cDetailedRecord.Checked := false;
    eDetailedLogPath.Text := '';
  end
  else
    bDetailedRecordClick(Sender);
end;

procedure TfSetting.cLogNeededKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  cLogNeededMouseUp(Sender, TMouseButton.mbLeft, Shift, 0, 0);
end;

procedure TfSetting.cLogNeededMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if cLogNeeded.Checked = false then
  begin
    cLogNeeded.Checked := false;
    eLogPath.Text := '';
  end
  else
    bLogNeededClick(Sender);
end;

procedure TfSetting.bDetailedRecordClick(Sender: TObject);
begin
  sdText.Title := '상세 로그 저장 위치';
  eDetailedLogPath.Text := GetTextPath;
  FDetailedRecordPath := eDetailedLogPath.Text;
  if cDetailedRecord.Checked <> (eDetailedLogPath.Text <> '') then
    cDetailedRecord.Checked := eDetailedLogPath.Text <> '';
end;

procedure TfSetting.bLogNeededClick(Sender: TObject);
begin
  sdText.Title := '로그 저장 위치';
  eLogPath.Text := GetTextPath;
  FRecordPath := eLogPath.Text;
  if cLogNeeded.Checked <> (eLogPath.Text <> '') then
    cLogNeeded.Checked := eLogPath.Text <> '';
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
  if not CharInSet(Key, [#8, '0'..'9']) then Key := #0;
end;

procedure TfSetting.FormCreate(Sender: TObject);
begin
  GetFixedDrives;
  FixSize;
end;

end.
