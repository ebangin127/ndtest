unit Tester.Thread;

interface

uses
  SysUtils, Classes, Windows, Math,
  Setting, RandomBuffer, Tester.ToView;

type
  TTesterThread = class(TThread)
  private
    FFileHandle: THandle;
    FTestSetting: TSetting;
    FRandomBuffer: TRandomBuffer;
    FMinFileNumber, FMaxFileNumber: Integer;
    FNeedToFillInMiB: Integer;
    FToView: TTesterToView;
    FFrequency: Int64;
    FIdle: Boolean;
    FCurrentTestCount: Integer;
    FTestStartTime: TDateTime;
    FTestHostWriteInMiB: UInt64;
    procedure PrepareTesterThread;
    function BuildFileName(const FileNumber: Integer): String;
    function NeedDelete: Boolean;
    procedure Test;
    procedure DeleteTestFiles;
    procedure SetupTest;
    procedure TeardownTest;
    function GetToFillMiB: Integer;
    procedure SetNeedToFill;
    procedure SetMinFileNumber;
    procedure SetMaxFileNumber;
    function WriteAndReturnLatency: Double;
    procedure ChangeFileHandlePer4GiB(const HostWriteInMiB: Integer);
    procedure EndTesterThread;
    procedure WaitForIdleEnd;
    const
      FourGiBInMiB = 4096;
  public
    constructor Create(const TestSetting: TSetting);
    destructor Destroy; override;
    procedure Execute; override;
    procedure ToggleIdle;
  end;

implementation

{ TTesterThread }

function TTesterThread.BuildFileName(const FileNumber: Integer): String;
begin
  result := FTestSetting.DrivePath + 'Randomfile' + IntToStr(FileNumber);
end;

constructor TTesterThread.Create(const TestSetting: TSetting);
var
  RandomSeed: Int64;
begin
  inherited Create(false);
  if QueryPerformanceCounter(RandomSeed) = false then
    RandomSeed := GetTickCount;
  FTestSetting := TestSetting;
  FRandomBuffer := TRandomBuffer.Create(RandomSeed);
  FToView := TTesterToView.Create(TestSetting);
end;

destructor TTesterThread.Destroy;
begin
  FToView.Free;
  FRandomBuffer.Free;
  inherited;
end;

procedure TTesterThread.Execute;
begin
  inherited;
  PrepareTesterThread;
  try
    repeat
      SetupTest;
      Test;
      TeardownTest;
    until (FTestSetting.InfiniteRepetition = false) or (Terminated);
  except
    on E: EArgumentException do
      DeleteTestFiles
    else
      raise;
  end;
  EndTesterThread;
end;

procedure TTesterThread.PrepareTesterThread;
const
  BufferSize = 8192;
  CompleteRandom = 100;
begin
  FRandomBuffer.CreateBuffer(BufferSize);
  FRandomBuffer.FillBuffer(CompleteRandom);
  QueryPerformanceFrequency(FFrequency);
  FCurrentTestCount := 1;
  FTestStartTime := now;
  FTestHostWriteInMiB := 0;
end;

procedure TTesterThread.EndTesterThread;
begin
  FToView.HideButtons;
end;

procedure TTesterThread.SetMinFileNumber;
begin
  FMinFileNumber := 0;
  while FileExists(BuildFileName(FMinFileNumber)) do
    FMinFileNumber := FMinFileNumber + 1;
end;

procedure TTesterThread.SetMaxFileNumber;
begin
  FMaxFileNumber := FMinFileNumber + (FNeedToFillInMiB div FourGiBInMiB);
end;

procedure TTesterThread.SetNeedToFill;
begin
  FNeedToFillInMiB := GetToFillMiB;
  if FNeedToFillInMiB = -1 then
    raise EArgumentException.Create('Invalid Setting');
end;

function TTesterThread.NeedDelete: Boolean;
begin
  result :=
    (FTestSetting.NeedDelete) or
    ((FTestSetting.InfiniteRepetition) and (not Terminated));
end;

function TTesterThread.WriteAndReturnLatency: Double;
var
  BytesWritten: Cardinal;
  StartPoint, EndPoint: Int64;
  WriteFileResult: Cardinal;
  OSException: EOSError;
  RawBuffer: TArrayBuffer;
begin
  QueryPerformanceCounter(StartPoint);
  RawBuffer := FRandomBuffer.GetRawBuffer;
  if not WriteFile(
    FFileHandle, RawBuffer[0], FRandomBuffer.GetLength, BytesWritten, nil) then
  begin
    WriteFileResult := GetLastError;
    OSException := EOSError.Create('WriteFileError: ' +
      UIntToStr(WriteFileResult));
    OSException.ErrorCode := WriteFileResult;
    raise OSException;
  end;
  QueryPerformanceCounter(EndPoint);
  result := (EndPoint - StartPoint) / FFrequency;
end;

procedure TTesterThread.ChangeFileHandlePer4GiB(const HostWriteInMiB: Integer);
begin
  if HostWriteInMiB mod FourGiBInMiB = 0 then
  begin
    if FFileHandle > 0 then
      CloseHandle(FFileHandle);
    FFileHandle :=
      CreateFile(PChar(
        BuildFileName(FMinFileNumber + (HostWriteInMiB div FourGiBInMiB))),
        GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE,
        nil, CREATE_NEW,
        FILE_FLAG_NO_BUFFERING * (Integer(not FTestSetting.NeedCache)), 0);
  end;
end;

procedure TTesterThread.Test;
var
  HostWriteInMiB: Integer;
  RemainToFillInMiB: Integer;
  Latency: Double;
  BufferLengthInMiB: Integer;
  PinnedNeedToFillInMiB: Integer;
begin
  HostWriteInMiB := 0;
  RemainToFillInMiB := FNeedToFillInMiB;
  BufferLengthInMiB := FRandomBuffer.GetLength shr 20;
  PinnedNeedToFillInMiB := FNeedToFillInMiB;
  while RemainToFillInMiB > BufferLengthInMiB do
  begin
    ChangeFileHandlePer4GiB(HostWriteInMiB);
    Latency := WriteAndReturnLatency;
    Dec(RemainToFillInMiB, FRandomBuffer.GetLength shr 20);
    Inc(HostWriteInMiB, FRandomBuffer.GetLength shr 20);
    FToView.ApplyProgress(HostWriteInMiB, PinnedNeedToFillInMiB,
      round((FRandomBuffer.GetLength shr 20) / Latency));
    if FIdle then
      WaitForIdleEnd;
    if Terminated then
      break;
  end;
  Inc(FTestHostWriteInMiB, HostWriteInMiB);
end;

procedure TTesterThread.SetupTest;
begin
  SetNeedToFill;
  SetMinFileNumber;
  SetMaxFileNumber;
end;

procedure TTesterThread.ToggleIdle;
begin
  FIdle := not FIdle;
end;

procedure TTesterThread.WaitForIdleEnd;
begin
  FToView.StartIdle;
  while FIdle do
  begin
    if Terminated then
      break;
    Sleep(100);
  end;
  FToView.EndIdle;
end;

function TTesterThread.GetToFillMiB: Integer;
var
  FreeSizeInMiB, TotalSizeInMiB: Int64;
  FreeSizeInByte, TotalSizeInByte: Int64;
  DriveNamePChar: PChar;
begin
  DriveNamePChar := PChar(Copy(FTestSetting.DrivePath, 1, 2));
  GetDiskFreeSpaceEx(DriveNamePChar, FreeSizeInByte, TotalSizeInByte, nil);

  FreeSizeInMiB := floor(FreeSizeInByte / 1024 / 1024);
  TotalSizeInMiB := floor(TotalSizeInByte / 1024 / 1024);

  case FTestSetting.ToLeftUnit of
  TLeftUnit.LeaveByGiB:
    result := FreeSizeInMiB - 1 - (FTestSetting.ToLeft * 1024);
  TLeftUnit.LeaveByMiB:
    result := FreeSizeInMiB - 1 - FTestSetting.ToLeft;
  TLeftUnit.LeaveByPercent:
  begin
    if FTestSetting.ToLeft <= 100 then
      result := floor(
        FreeSizeInMiB - 1 - (TotalSizeInMiB * FTestSetting.ToLeft / 100))
    else
      result := -1;
  end;
  else
    result := -1;
  end;
  FToView.PrintInitialSetting(FCurrentTestCount,
    FreeSizeInByte, TotalSizeInByte, result);
end;

procedure TTesterThread.TeardownTest;
begin
  if FFileHandle > 0 then
    CloseHandle(FFileHandle);
  FFileHandle := 0;
  if NeedDelete then
    DeleteTestFiles;
  if FTestSetting.InfiniteRepetition then
    FToView.EndTest(FTestStartTime, FTestHostWriteInMiB)
  else
    FToView.EndTest;
  Inc(FCurrentTestCount);
end;

procedure TTesterThread.DeleteTestFiles;
var
  FileNumber: Integer;
  CurrentFileName: String;
begin
  for FileNumber := FMinFileNumber to FMaxFileNumber do
  begin
    CurrentFileName := BuildFileName(FileNumber);
    DeleteFile(PChar(CurrentFileName));
    Sleep(5);
    while FileExists(CurrentFileName) do
    begin
      Sleep(100);
      DeleteFile(PChar(CurrentFileName));
    end;
  end;
end;

end.
