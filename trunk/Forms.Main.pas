unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Controls, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series,
  Math,
  Forms.Setting, Setting, Setting.Getter, Tester.Thread;

const
  WM_AFTER_CREATE = WM_USER + 300;

type
  TfMain = class(TForm)
    lCurrSpd: TLabel;
    lCurrFile: TLabel;
    pProgress: TProgressBar;
    bIdle: TButton;
    bCancel: TButton;
    cLog: TChart;
    FSpeedSeries: TLineSeries;
    tSelectLogRange: TTabControl;
    lCurrentLog: TListBox;
    lLastAndCurrentLog: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure bIdleClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCancelClick(Sender: TObject);
    procedure tSelectLogRangeChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FTestSetting: TSetting;
    FTesterThread: TTesterThread;
    procedure WmAfterCreate(var Msg: TMessage); message WM_AFTER_CREATE;
    procedure StartTestBySetting;
    procedure EndTest;
    procedure AlignTopGroup;
    procedure AlignButtons;
    procedure AlignTopLabels;
    procedure AlignBottomGroup;
    procedure AlignTab;
    procedure AlignChart(const HeightLeft: Integer);
    procedure AlignListBoxes;
  private
    const
      NormalPadding = 10;
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.WmAfterCreate(var Msg: TMessage);
begin
  fSetting := TfSetting.Create(self);
  fSetting.ShowModal;
  FTestSetting := GetSettingFromForm;
  FreeAndNil(fSetting);
  if FTestSetting.IsSet = false then
    Close
  else
    StartTestBySetting;
end;

procedure TfMain.StartTestBySetting;
begin
  FTesterThread := TTesterThread.Create(FTestSetting);
end;

procedure TfMain.tSelectLogRangeChange(Sender: TObject);
begin
  lLastAndCurrentLog.Visible := tSelectLogRange.TabIndex = 0;
  lCurrentLog.Visible := tSelectLogRange.TabIndex = 1;
end;

procedure TfMain.bCancelClick(Sender: TObject);
begin
  EndTest;
end;

procedure TfMain.bIdleClick(Sender: TObject);
begin
  FTesterThread.ToggleIdle;
  if bIdle.Caption = '일시정지' then
    bIdle.Caption := '재개'
  else
    bIdle.Caption := '일시정지';
end;

procedure TfMain.EndTest;
begin
  if FTesterThread <> nil then
  begin
    FTesterThread.Terminate;
    while not (WaitForSingleObject(FTesterThread.Handle, 0) = ERROR_SUCCESS) do
      Application.ProcessMessages;
    FreeAndNil(FTesterThread);
  end;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EndTest;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := true;
  PostMessage(Self.Handle, WM_AFTER_CREATE, 0, 0);
end;

procedure TfMain.AlignTopGroup;
begin
  pProgress.Width := floor(ClientWidth / 5 * 4 - pProgress.Left -
    NormalPadding);
  AlignButtons;
  AlignTopLabels;
end;

procedure TfMain.AlignButtons;
begin
  bIdle.Left := pProgress.Left + pProgress.Width + NormalPadding;
  bIdle.Width := ClientWidth - bIdle.Left - NormalPadding;
  bCancel.Left := bIdle.Left;
  bCancel.Top := bIdle.Top + bIdle.Height + NormalPadding;
  bCancel.Width := bIdle.Width;
end;

procedure TfMain.AlignTopLabels;
begin
  lCurrFile.Top := pProgress.Top + pProgress.Height + NormalPadding;
  lCurrSpd.Top := lCurrFile.Top + lCurrFile.Height + NormalPadding;
end;

procedure TfMain.AlignBottomGroup;
var
  HeightLeft: Integer;
begin
  HeightLeft := ClientHeight - lCurrSpd.Top - lCurrSpd.Height - NormalPadding;
  AlignChart(HeightLeft);
  AlignTab;
end;

procedure TfMain.AlignTab;
begin
  tSelectLogRange.Top := cLog.Top + cLog.Height + (NormalPadding shl 1);
  tSelectLogRange.Height := cLog.Height;
  tSelectLogRange.Width := cLog.Width;
  AlignListBoxes;
end;

procedure TfMain.AlignChart(const HeightLeft: Integer);
begin
  cLog.Top := lCurrSpd.Top + lCurrSpd.Height + (NormalPadding shl 1);
  cLog.Height := (HeightLeft shr 1) - (NormalPadding shl 1);
  cLog.Width := ClientWidth - (NormalPadding shl 1);
end;

procedure TfMain.AlignListBoxes;
begin
  lLastAndCurrentLog.Left := 2;
  lLastAndCurrentLog.Top := tSelectLogRange.Canvas.TextHeight(
    tSelectLogRange.Tabs[0]) + 8;
  lLastAndCurrentLog.Height := tSelectLogRange.Height -
    tSelectLogRange.Canvas.TextHeight(tSelectLogRange.Tabs[0]) - 12;
  lLastAndCurrentLog.Width := tSelectLogRange.Width - 6;
  lCurrentLog.Left := lLastAndCurrentLog.Left;
  lCurrentLog.Top := lLastAndCurrentLog.Top;
  lCurrentLog.Width := lLastAndCurrentLog.Width;
  lCurrentLog.Height := lLastAndCurrentLog.Height;
end;

procedure TfMain.FormResize(Sender: TObject);
begin
  AlignTopGroup;
  AlignBottomGroup;
end;

end.


