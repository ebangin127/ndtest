unit Tester.ToView;

interface

uses
  SysUtils, Classes, Math, Generics.Collections, VclTee.TeEngine, Threading,
  SyncObjs,
  Setting, Tester.Logger, uSSDInfo, uDiskFunctions, uDatasizeUnit;

type
  TTesterToView = class
  private
    FTestSetting: TSetting;
    FLastPercent: Double;
    FLogger: TTesterLogger;
    FDetailedLogger: TTesterLogger;
    FDiskSizeInMiB: Integer;
    FOriginalFilledSpaceInMiB: Int64;
    FMaxSpeed, FMinSpeed: Integer;
    FSumSpeed: UInt64;
    FCount: Integer;
    FStartTime: TDateTime;
    FToDeleteLogCount, FLastLogCount: Integer;
    FSpeedList: TList<Integer>;
    procedure RefreshSpeedStatus(const SpeedInMiB: Integer);
    procedure InitializeSpeed;
    procedure ClearSpeedSeries;
    procedure DeleteLastLog;
    procedure AddToChart(const FilledPercentInDriveChart: Double;
      const SpeedInMiB: Integer);
    procedure RefreshProgressAndLabel(const FilledInMiB: Integer;
      const NeedToFillInMiB, FilledPercentInTest: Integer);
    procedure RefreshSpeed(const FilledPercentInDrive: Double;
      const SpeedInMiB: Integer);
    function GetFilledPercentInDrive(const FilledInMiB: Integer): Double;
    function GetSlowPercent: Double;
    function GetHalfOfAverageSpeed: Integer;
    procedure RefreshHorizontalLine(const IsEnd: Boolean);
    function EnoughDelta(const CurrentPercent, LastPercent: Double): Boolean;
  public
    constructor Create(const TestSetting: TSetting);
    destructor Destroy; override;
    procedure AddStringAtList(const Value: String);
    procedure PrintInitialSetting(const TestCount: Integer;
      const FreeSizeInByte, TotalSizeInByte, ToFillInByte: Int64);
    procedure ApplyProgress(
      const HostWriteInMiB, NeedToFillInMiB, SpeedInMiB: Integer);
    procedure EndTest(const TestStartTime: TDateTime = 0;
      const TestHostWriteInMiB: UInt64 = 0);
    procedure HideButtons;
    procedure StartIdle;
    procedure EndIdle;
  end;

implementation

uses
  Forms.Main;

{ TTesterToView }

procedure TTesterToView.AddStringAtList(const Value: String);
begin
  TThread.Queue(TThread.CurrentThread, procedure
  begin
    fMain.lCurrentLog.Items.Add(Value);
    if fMain.lCurrentLog.Visible then
      fMain.lCurrentLog.TopIndex := fMain.lCurrentLog.Items.Count - 1;
    fMain.lLastAndCurrentLog.Items.Add(Value);
    if fMain.lLastAndCurrentLog.Visible then
      fMain.lLastAndCurrentLog.TopIndex :=
        fMain.lLastAndCurrentLog.Items.Count - 1;
    if FLogger <> nil then
      FLogger.Add(Value);
  end);
  Inc(FLastLogCount);
end;

function TTesterToView.EnoughDelta(
  const CurrentPercent, LastPercent: Double): Boolean;
begin
  if FTestSetting.UnitSpeed = TUnitSpeed.TenPercent then
    result := Abs(CurrentPercent - LastPercent) >= 10
  else
    result := LastPercent <> CurrentPercent;
end;

procedure TTesterToView.ApplyProgress(
  const HostWriteInMiB, NeedToFillInMiB, SpeedInMiB: Integer);
var
  FilledPercentInTest: Integer;
  FilledPercentInDrive: Double;
begin
  FilledPercentInTest := round((HostWriteInMiB / NeedToFillInMiB) * 100);
  FilledPercentInDrive := GetFilledPercentInDrive(HostWriteInMiB);
  RefreshProgressAndLabel(HostWriteInMiB, NeedToFillInMiB, FilledPercentInTest);
  FSpeedList.Add(SpeedInMiB);
  if FDetailedLogger <> nil then
    FDetailedLogger.Add(
      FloatToStr((FDiskSizeInMiB -
        (FOriginalFilledSpaceInMiB + HostWriteInMiB)) /
        FDiskSizeInMiB * 100) + ',' + IntToStr(SpeedInMiB));
  AddToChart(
    round(((FDiskSizeInMiB - (FOriginalFilledSpaceInMiB + HostWriteInMiB)) /
      FDiskSizeInMiB) * 10000) / 100, SpeedInMiB);
  RefreshSpeedStatus(SpeedInMiB);
  RefreshHorizontalLine(false);
  if EnoughDelta(FLastPercent, FilledPercentInDrive) then
    RefreshSpeed(FilledPercentInDrive, SpeedInMiB);
end;

procedure TTesterToView.RefreshHorizontalLine(const IsEnd: Boolean);
begin
  TThread.Queue(TThread.CurrentThread, procedure
  begin
    if (fMain.FSpeedSeries.GetHorizAxis.Minimum = 0) or (IsEnd) then
      fMain.FSpeedSeries.GetHorizAxis.AdjustMaxMin;
    fMain.FHorizontalLine.Y0 := GetHalfOfAverageSpeed;
    fMain.FHorizontalLine.Y1 := fMain.FHorizontalLine.Y0;
    fMain.FHorizontalLine.X0 := fMain.FSpeedSeries.GetHorizAxis.Minimum;
    fMain.FHorizontalLine.X1 := fMain.FSpeedSeries.GetHorizAxis.Maximum;
    if not fMain.FHorizontalLine.Active then
      fMain.FHorizontalLine.Active := true;
  end);
end;

procedure TTesterToView.RefreshSpeedStatus(const SpeedInMiB: Integer);
begin
  if FMaxSpeed < SpeedInMiB then
    FMaxSpeed := SpeedInMiB;
  if (FMinSpeed > SpeedInMiB) or (FMinSpeed = 0) then
    FMinSpeed := SpeedInMiB;
  Inc(FSumSpeed, SpeedInMiB);
  Inc(FCount);
end;

constructor TTesterToView.Create(const TestSetting: TSetting);
begin
  FTestSetting := TestSetting;
  FSpeedList := TList<Integer>.Create;
  if FTestSetting.RecordPath <> '' then
    FLogger := TTesterLogger.Create(FTestSetting.RecordPath);
  if FTestSetting.DetailedRecordPath <> '' then
    FDetailedLogger := TTesterLogger.Create(FTestSetting.DetailedRecordPath);
end;

destructor TTesterToView.Destroy;
begin
  FLogger.Free;
  FSpeedList.Free;
  FDetailedLogger.Free;
  inherited;
end;

procedure TTesterToView.DeleteLastLog;
var
  PinnedLogCountToDelete: Integer;
begin
  PinnedLogCountToDelete := FToDeleteLogCount;
  TThread.Queue(TThread.CurrentThread, procedure
  begin
    fMain.lCurrentLog.Clear;
    fMain.lLastAndCurrentLog.Items.BeginUpdate;
    while PinnedLogCountToDelete > 0 do
    begin
      fMain.lLastAndCurrentLog.Items.Delete(0);
      Dec(PinnedLogCountToDelete);
    end;
    fMain.lLastAndCurrentLog.Items.EndUpdate;
  end);
  FToDeleteLogCount := FLastLogCount;
  FLastLogCount := 0;
end;

procedure TTesterToView.PrintInitialSetting(const TestCount: Integer;
  const FreeSizeInByte, TotalSizeInByte, ToFillInByte: Int64);
var
  SSDInfo: TSSDInfo;
  MotherDriveInString: String;
begin
  InitializeSpeed;
  DeleteLastLog;
  SSDInfo := TSSDInfo.Create;
  SSDInfo.ATAorSCSI := DetermineModel;
  SSDInfo.UsedByService := true;
  MotherDriveInString :=
    IntToStr(GetMotherDrive(Copy(FTestSetting.DrivePath, 1, 2)).Extents[0].
      DiskNumber);
  SSDInfo.SetDeviceName('PhysicalDrive' + MotherDriveInString);
  FDiskSizeInMiB := GetDiskSize(MotherDriveInString) shr 20;
  FOriginalFilledSpaceInMiB := FDiskSizeInMiB - (FreeSizeInByte shr 20);
  ClearSpeedSeries;
  FStartTime := now;
  AddStringAtList('***************************************');
  AddStringAtList('나래온 더티 테스트 6.0.3');
  AddStringAtList('제작자 : 이방인');
  AddStringAtList('테스트 일시 : ' +
    FormatDateTime('yyyy/mm/dd hh:mm', FStartTime));
  AddStringAtList('테스트 회차 : ' + IntToStr(TestCount));
  AddStringAtList('***************************************');
  AddStringAtList('- 테스트 드라이브 상세 -');
  AddStringAtList('모델명 : ' + SSDInfo.Model);
  AddStringAtList('드라이브 : ' + FTestSetting.DrivePath);
  AddStringAtList('전체 용량 : ' +
    IntToStr(round(FDiskSizeInMiB * 1.024 * 1.024 / 1000)) + 'GB');
  AddStringAtList('');
  AddStringAtList('- 드라이브 내 테스트 구간 -');
  AddStringAtList('테스트 구간 : ' +
    IntToStr(round(
      FreeSizeInByte / 1000 / 1000 / 1000)) + 'GB ~ ' +
    IntToStr(round((
      (FreeSizeInByte / 1000 / 1000)  -
      (ToFillInByte * 1.024 * 1.024)) / 1000)) + 'GB');
  AddStringAtList('파티션 용량 : ' +
    IntToStr(round(
      TotalSizeInByte / 1000 / 1000 / 1000)) + 'GB');
  AddStringAtList('');
  AddStringAtList('- 모드 적용 사항 -');
  if FTestSetting.NeedCache then
    AddStringAtList('윈도 캐시 효과 : 적용')
  else
    AddStringAtList('윈도 캐시 효과 : 미적용');
  if FTestSetting.InfiniteRepetition then
    AddStringAtList('무한 반복 : 적용')
  else
    AddStringAtList('무한 반복 : 미적용');
  AddStringAtList('***************************************');
  FreeAndNil(SSDInfo);
end;

procedure TTesterToView.StartIdle;
begin
  AddStringAtList('- ' + FormatDateTime('yy/mm/dd hh:mm:ss', Now) +
    '에 일시정지 시작 -');
end;

procedure TTesterToView.EndIdle;
begin
  AddStringAtList('- ' + FormatDateTime('yy/mm/dd hh:mm:ss', Now) +
    '에 일시정지 종료 -');
end;

function TTesterToView.GetSlowPercent: Double;
var
  HalfOfAverage: Integer;
  ResultInCount: Integer;
begin
  HalfOfAverage := GetHalfOfAverageSpeed;
  ResultInCount := 0;
  TParallel.For(0, FSpeedList.Count - 1, procedure (CurrentIndex: Integer)
  begin
    if FSpeedList[CurrentIndex] <= HalfOfAverage then
      TInterlocked.Increment(ResultInCount);
  end);
  if FCount = 0 then
    exit(0);
  result := ResultInCount / FCount * 100;
end;

procedure TTesterToView.EndTest(const TestStartTime: TDateTime = 0;
  const TestHostWriteInMiB: UInt64 = 0);
var
  SlowPercent: Double;
const
  BinaryInteger: TFormatSizeSetting =
    (FNumeralSystem: Binary; FPrecision: 0);
  OneDayInSecond = 86400;
begin
  SlowPercent := GetSlowPercent;
  if FCount = 0 then
    exit;
  TThread.Synchronize(TThread.CurrentThread, procedure
  var
    EndTime: TDateTime;
    OverallTestTime: TDateTime;
    OverallTestDay: Integer;
    OverallTestBelowDay: TDateTime;
  begin
    RefreshHorizontalLine(true);
    EndTime := now;
    AddStringAtList('***************************************');
    AddStringAtList('종료 시간 : ' +
      FormatDateTime('yyyy/mm/dd hh:mm', EndTime));
    AddStringAtList('테스트 시간 : ' +
      FormatDateTime('hh:mm:ss', EndTime - FStartTime));
    if TestStartTime > 0 then
    begin
      OverallTestTime := EndTime - TestStartTime;
      OverallTestDay := floor(OverallTestTime / OneDayInSecond);
      OverallTestBelowDay := OverallTestTime -
        (OverallTestDay * OneDayInSecond);
      AddStringAtList('전체 테스트 시간 : ' + IntToStr(OverallTestDay) +
        ':' + FormatDateTime('hh:mm:ss', OverallTestBelowDay));
    end;
    if TestHostWriteInMiB > 0 then
      AddStringAtList('전체 호스트 쓰기 : ' +
        FormatSizeInMB(TestHostWriteInMiB, BinaryInteger));
    AddStringAtList('***************************************');
    AddStringAtList('최대 속도 : ' + IntToStr(FMaxSpeed) + 'MiB/s');
    AddStringAtList('최소 속도 : ' + IntToStr(FMinSpeed) + 'MiB/s');
    AddStringAtList('평균 속도 : ' + IntToStr(FSumSpeed div FCount) +
      'MiB/s');
    AddStringAtList('평균 속도 50% 미만 구간 : ' +
      FormatFloat('0.0', SlowPercent) + '%');
    AddStringAtList('***************************************');
  end);
end;

procedure TTesterToView.HideButtons;
begin
  TThread.Synchronize(TThread.CurrentThread, procedure
  begin
    fMain.pProgress.Width :=
      fMain.bIdle.Left + fMain.bIdle.Width - fMain.pProgress.Left;
    fMain.bIdle.Visible := false;
    fMain.bCancel.Visible := false;
  end);
end;

function TTesterToView.GetHalfOfAverageSpeed: Integer;
begin
  if FCount = 0 then
    exit(0);
  result := (FSumSpeed div FCount) shr 1;
end;

function TTesterToView.GetFilledPercentInDrive(const FilledInMiB: Integer):
  Double;
begin
  result := (FDiskSizeInMiB - (FOriginalFilledSpaceInMiB + FilledInMiB)) /
    FDiskSizeInMiB;
  if (FTestSetting.UnitSpeed = TUnitSpeed.TenPercent) or
     (FTestSetting.UnitSpeed = TUnitSpeed.OnePercent) then
    result := round(result * 100)
  else
    result := round(result * 1000) / 10;
end;

procedure TTesterToView.RefreshSpeed(const FilledPercentInDrive: Double;
  const SpeedInMiB: Integer);
begin
  FLastPercent := FilledPercentInDrive;
  AddStringAtList(FormatFloat('0.0', FilledPercentInDrive) +
    '% 에서의 속도 : ' + IntToStr(SpeedInMiB) + 'MiB/s');
  TThread.Queue(TThread.CurrentThread, procedure
  begin
    fMain.lCurrSpd.Caption := '속도 : ' + IntToStr(SpeedInMiB) + 'MiB/s';
  end);
end;

procedure TTesterToView.RefreshProgressAndLabel(const FilledInMiB: Integer;
  const NeedToFillInMiB, FilledPercentInTest: Integer);
begin
  TThread.Queue(TThread.CurrentThread, procedure
  begin
    fMain.pProgress.Position := FilledPercentInTest;
    fMain.lCurrFile.Caption :=
      '현재 채워진 용량 : ' +
      FormatFloat('0.00', (FilledInMiB / 1024)) + 'GiB / ' +
      FormatFloat('0.00', (NeedToFillInMiB / 1024)) + 'GiB';
  end);
end;

procedure TTesterToView.AddToChart(const FilledPercentInDriveChart: Double;
  const SpeedInMiB: Integer);
begin
  TThread.Queue(TThread.CurrentThread, procedure
  begin
    fMain.cLog.Series[0].AddXY(FilledPercentInDriveChart, SpeedInMiB, '',
      clTeeColor);
  end);
end;

procedure TTesterToView.ClearSpeedSeries;
begin
  FSpeedList.Clear;
  TThread.Queue(TThread.CurrentThread, procedure
  begin
    fMain.cLog.Series[0].Clear;
  end);
end;

procedure TTesterToView.InitializeSpeed;
begin
  FMaxSpeed := 0;
  FMinSpeed := 0;
  FSumSpeed := 0;
  FCount := 0;
  FLastPercent := 0;
end;

end.
