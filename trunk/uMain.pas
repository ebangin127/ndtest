unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDiskFunctions, Vcl.StdCtrls, Math, Vcl.ComCtrls, MMSystem, uSSDInfo,
  Vcl.FileCtrl, uMTforDel;

const
  MaxHeight = 420;
  MinHeight = 350;
  MaxWidth = 640;
  MinWidth = 300;

  MaxBufSize = 20;
  CacheSize = 8388608;
  FourGigs = 4294967296;
  OneMega = 1048576;
  OneKilo = 1024;
  FileUnit = FourGigs div CacheSize;

type
  TUnitBuffer = Array of Byte;
  TRandomBuffer = Array[0..(MaxBufSize - 1)] of TUnitBuffer;
  PTRandomBuffer = ^TRandomBuffer;

procedure AddStringAtList(DestFile: TStreamWriter; DestList: TListBox; Contents: String);

type
  TfMain = class(TForm)
    bRand: TButton;
    pProgress: TProgressBar;
    lCurrFile: TLabel;
    bRandDel: TButton;
    bCancel: TButton;
    lCurrSpd: TLabel;
    lSpeed: TListBox;
    sdText: TSaveDialog;
    bIdle: TButton;
    ePage: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    lCurrRemain: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    eLeft: TEdit;
    cSelection: TComboBox;
    cAlignSize: TComboBox;
    lRand: TLabel;
    eRandomness: TEdit;
    Label7: TLabel;
    cRepeat: TCheckBox;
    eTimes: TEdit;
    Label6: TLabel;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    cUnitSpeed: TComboBox;
    Label1: TLabel;
    eDrive: TComboBox;
    cCacheEffect: TCheckBox;
    cEndurance: TCheckBox;
    procedure bRandClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bIdleClick(Sender: TObject);
    procedure cAlignSizeChange(Sender: TObject);
    procedure eDriveChange(Sender: TObject);
    procedure eLeftKeyPress(Sender: TObject; var Key: Char);
    procedure eRandomnessKeyPress(Sender: TObject; var Key: Char);
    procedure eRandomnessChange(Sender: TObject);
    procedure cEnduranceClick(Sender: TObject);
    procedure cEnduranceKeyPress(Sender: TObject; var Key: Char);
    procedure eTimesEnter(Sender: TObject);
  private
    procedure InitList(Sender: TObject; DriveName: String; AllMeg: Integer);
    procedure HideAndStartTest;
    procedure ShowAndEndTest;
    procedure FillBuffer(Buffer: PTRandomBuffer; RandomnessInString: String; MT: TMersenne);
    procedure SetCacheLength(Buffer: PTRandomBuffer);
    procedure DeleteCache(Buffer: PTRandomBuffer);
    function CompareBuffer(BufOne, BufTwo: TUnitBuffer): Integer;
    function CalculateMeg(MethodIndex: Integer; DriveName: String; LeftText: String): Integer;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;
  Canceled: Boolean;
  Idle: Boolean;
  RemainTimes: Integer;
  CurrTime: Integer;
  Recording: Boolean;
  LogPath: String;
  LogFileStream: TStreamWriter;

implementation

{$R *.dfm}

procedure AddStringAtList(DestFile: TStreamWriter; DestList: TListBox; Contents: String);
begin
  DestList.Items.Add(Contents);
  Contents := Contents;
  if DestFile <> nil then
  begin
    DestFile.WriteLine(Contents);
  end;
end;

procedure TfMain.bCancelClick(Sender: TObject);
begin
  Idle := false;
  Canceled := true;
  ShowMessage('��ҵǾ����ϴ�');
  bCancel.Visible := false;
end;

procedure TfMain.bIdleClick(Sender: TObject);
begin
  if Idle = false then
  begin
    Idle := true;
    bIdle.Caption := '�׽�Ʈ �簳';
  end
  else
  begin
    Idle := false;
    bIdle.Caption := '�Ͻ�����';
  end;
end;

procedure TfMain.bRandClick(Sender: TObject);
var
  Buffer, VeriBuf: TRandomBuffer;
  ReadBuf: TUnitBuffer;
  SizeNum, BitNum, ArrNum: Integer;
  StartFileName: Integer;
  AllMeg: Integer;
  CurrFile: THandle;
  SpdHeader: String;
  SeedText: TStringList;
  SpdPath, SeedPath: String;

  LeftPercent: Single;
  CurrSpd: Integer;

  PrevFreeSpace, FullCapacity: Int64;

  SpdStart, SpdEnd: Double;
  IdleStart, IdleEnd: Double;
  OvhdStart, OvhdEnd: Double;

  WriteUnit, WriteLoopCount: Cardinal;
  BytesWritten, TotalByteWritten: DWORD;
  Randomness: Integer;
  LastPercent, CurrPercent: String;

  RandomSeed, LastSeed: Int64;

  InfiniteLoop: Boolean;
  AllDrives: String;

  ErrorCount: Integer;
  Mersenne: TMersenne;

  Verifying: Boolean;
  CurrWrittenCache, WrittenCount, CurrUnit: Integer;
  CurrFileNum, LastVeriFile: Integer;

  CurrOverlapped: Overlapped;
  dwRes: DWORD;
  foffset: LARGE_INTEGER;

  Max, Min, Avg: Int64;
  AvgCount: Int64;

  MinFileNum, MaxFileNum: Cardinal;
begin
  SeedText := TStringList.Create;
  Idle := false;
  InfiniteLoop := false;
  bIdle.Caption := '�Ͻ�����';
  AllDrives := eDrive.Text + '\';

  AllMeg := CalculateMeg(cSelection.ItemIndex, eDrive.Text, eLeft.Text);
  if AllMeg = -1 then exit;

  if cRepeat.Checked then
  begin
    InfiniteLoop := (eTimes.Text = '-1');
    if TryStrToInt(eTimes.Text, RemainTimes) = false then
    begin
      RemainTimes := 0;
      exit;
    end
    else
    begin
      CurrTime := 1;
    end;
  end
  else RemainTimes := 1;
  // Ż�� ���� �κ� ����

  // ���� ���� �κ�
  Canceled := false;
  HideAndStartTest;
  Recording := sdText.Execute;
  if Recording then
  begin
    SpdPath := sdText.FileName;
    LogPath := SpdPath;
    if ExtractFileExt(SpdPath) = '' then
    begin
      if sdText.FilterIndex = 1 then
        SpdPath := SpdPath + '.txt';
    end;
    Constraints.MinWidth := 0;
    Constraints.MaxWidth := 0;
    ClientWidth := MaxWidth;
    Constraints.MinWidth := Width;
    Constraints.MaxWidth := Width;

    LogFileStream := TStreamWriter.Create(SpdPath, false);
  end;

  //���� ���ϸ� ����
  StartFileName := 0;
  if cEndurance.Checked = false then
  begin
    while FileExists(AllDrives + 'Randomfile' + IntToStr(StartFileName)) do
      StartFileName := StartFileName + 1;
  end;

  //���� �׽�Ʈ�� ���� �õ� �޾ƿͼ� ���� ���� ����
  SeedPath := ExtractFilePath(Application.ExeName) + 'seed.txt';
  Verifying := cEndurance.Checked and FileExists(SeedPath);
  SetLength(ReadBuf, CacheSize);
  LastVeriFile := -1;
  if Verifying then
  begin
    SetCacheLength(@VeriBuf);
    SeedText.LoadFromFile(SeedPath);
    RandomSeed := StrToInt64(SeedText[0]);
    LastVeriFile := StrToInt(SeedText[1]);

    Mersenne := TMersenne.Create(RandomSeed);
    FillBuffer(@VeriBuf, eRandomness.Text, Mersenne);
    FreeAndNil(Mersenne);

    for CurrFileNum := 0 to LastVeriFile do
    begin
      Verifying := FileExists(AllDrives + 'Randomfile' + IntToStr(CurrFileNum));
      if Verifying = false then break;
    end;
  end
  else if FileExists(SeedPath) then
  begin
    DeleteFile(SeedPath);
  end;

  //���� �õ� �޾ƿ��� �� ���� ���� ����
  if QueryPerformanceCounter(RandomSeed) = false then
    RandomSeed := GetTickCount;

  Mersenne := TMersenne.Create(RandomSeed);
  SetCacheLength(@Buffer);
  FillBuffer(@Buffer, eRandomness.Text, Mersenne);
  FreeAndNil(Mersenne);

  //ĳ�� �뷮 ��� ���� ��� ���� ����
  WriteUnit := floor(CacheSize shr cAlignSize.ItemIndex);
  WriteLoopCount := floor(CacheSize / WriteUnit);

  //�ݺ� ����
  while (RemainTimes > 0) or (InfiniteLoop) do
  begin
    if RemainTimes >= 0 then
      RemainTimes := RemainTimes - 1;

    Max := -1;
    Min := -1;
    Avg := 0;
    AvgCount := 0;

    AllMeg := CalculateMeg(cSelection.ItemIndex, eDrive.Text, eLeft.Text);
    if AllMeg = -1 then exit;

    // �뷮 �޾ƿ���
    GetDiskFreeSpaceEx(PChar(AllDrives), PrevFreeSpace, FullCapacity, nil);
    PrevFreeSpace := floor(PrevFreeSpace / 1024 / 1024);
    FullCapacity := floor(FullCapacity / 1024 / 1024);

    InitList(Sender, AllDrives, AllMeg);
    MinFileNum := StartFileName;

    SpdStart := Now;
    TotalByteWritten := 0;
    for SizeNum := 0 to (floor(AllMeg / (CacheSize / OneMega)) - 1) do
    begin
      pProgress.Position := round((SizeNum / (AllMeg div (CacheSize div OneMega))) * 100);

      lCurrFile.Caption := '���� ä���� �뷮 : ' + Formatfloat('0.00', (((SizeNum * (CacheSize div OneMega)) + 1) / 1024)) + 'GiB / ' + Formatfloat('0.00', (AllMeg + 1) / 1024) + 'GiB';

      if (SizeNum mod FileUnit) = 0 then
      begin
        if CurrFile <> 0 then
          CloseHandle(CurrFile);

        CurrFileNum := StartFileName + ceil(SizeNum / FileUnit);
        MaxFileNum := CurrFileNum;
        CurrFile := CreateFile(PChar(AllDrives + 'Randomfile' + IntToStr(CurrFileNum)), GENERIC_READ or GENERIC_WRITE,
                                   FILE_SHARE_READ or FILE_SHARE_WRITE, nil, CREATE_NEW,
                                   (FILE_FLAG_NO_BUFFERING * (Integer(not cCacheEffect.Checked))) or FILE_FLAG_OVERLAPPED, 0);
        if CurrFile = INVALID_HANDLE_VALUE then
        begin
          CurrFile := CreateFile(PChar(AllDrives + 'Randomfile' + IntToStr(CurrFileNum)), GENERIC_READ or GENERIC_WRITE,
                                     FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING,
                                     FILE_FLAG_NO_BUFFERING * (Integer(not cCacheEffect.Checked)) or FILE_FLAG_OVERLAPPED, 0);
        end;
        foffset.QuadPart := 0;
        CurrOverlapped.Offset := foffset.LowPart;
        CurrOverlapped.OffsetHigh := foffset.HighPart;
      end;

      if (SizeNum mod (FileUnit shr 6) = 0) and (SizeNum > 0) then
      begin
        SpdEnd := Now;

        LeftPercent := ((PrevFreeSpace - (SizeNum * (CacheSize div OneMega))) /
                            FullCapacity) * 100;
        case cUnitSpeed.ItemIndex of
          0: CurrPercent := Formatfloat('0.0', LeftPercent);
          1: CurrPercent := Formatfloat('0', LeftPercent);
        end;

        if SpdEnd <> SpdStart then
        begin
          CurrSpd := floor(((TotalByteWritten / OneMega)) /
                           ((SpdEnd - SpdStart) * 24 * 3600));
          lCurrSpd.Caption := '�ӵ� : ' + IntToStr(CurrSpd) + 'MiB/s';

          if ((Max = -1) or (Max < CurrSpd)) then
            Max := CurrSpd;
          if ((Min = -1) or (Min > CurrSpd)) then
            Min := CurrSpd;
          Avg := Avg + CurrSpd;
          AvgCount := AvgCount + 1;

          if LastPercent <> CurrPercent then
          begin
            LastPercent := CurrPercent;
            SpdHeader := CurrPercent + '% ������ �ӵ� : ';

            if Recording then
            begin
              if ((lSpeed.Count = 0) or
                 (Copy(lSpeed.Items[lSpeed.Count - 1], 0, Length(SpdHeader)) <> SpdHeader)) then
              begin
                if CurrSpd > 0 then
                begin
                  AddStringAtList(LogFileStream, lSpeed, SpdHeader + IntToStr(CurrSpd) + 'MiB/s');
                end;
              end;
            end;
          end;
        end;

        if Idle then
        begin
          if Recording then
            AddStringAtList(LogFileStream, lSpeed, '- �Ͻ����� ���� -');
          lSpeed.TopIndex := lSpeed.Count - 1;

          IdleStart := Now;
          while Idle do
          begin
            Application.ProcessMessages;
            Sleep(10);
          end;
          IdleEnd := Now;

          if Recording then
          begin
            AddStringAtList(LogFileStream, lSpeed, '- �Ͻ����� �ð� : ' + IntToStr(ceil((IdleEnd - IdleStart)*24*3600)) + '�� -');
          end;
        end;

        if Recording then
        begin
          //���� �׽�Ʈ�� ���� �õ� ����
          if cEndurance.Checked then
          begin
            SeedText.Clear;
            SeedText.Add(IntToStr(RandomSeed));
            SeedText.Add(IntToStr(CurrFileNum - 1));
            SeedText.SaveToFile(SeedPath);
          end;
        end;

        SpdStart := Now;
        TotalByteWritten := 0;
      end;

      CurrWrittenCache := 0;
      WrittenCount := 0;
      if cEndurance.Checked then
      begin
        WriteUnit := floor(CacheSize shr cAlignSize.ItemIndex);
      end;

      CurrOverlapped.hEvent := CreateEvent(nil, FALSE, FALSE, nil);
      while (CurrWrittenCache < CacheSize) do
      begin
        OvhdStart := Now;
        OvhdEnd := Now;
        SpdStart := SpdStart + (OvhdEnd - OvhdStart);
        WriteFile(CurrFile, Buffer[SizeNum mod MaxBufSize][CurrWrittenCache], WriteUnit, BytesWritten, @CurrOverlapped);
        BytesWritten := WriteUnit;

        TotalByteWritten := TotalByteWritten + BytesWritten;
        CurrWrittenCache := CurrWrittenCache + BytesWritten;
        WrittenCount := WrittenCount + 1;
      end;
      foffset.QuadPart := foffset.QuadPart + CacheSize;
      CurrOverlapped.Offset := foffset.LowPart;
      CurrOverlapped.OffsetHigh := foffset.HighPart;
      dwRes := WaitForSingleObject(CurrOverlapped.hEvent, INFINITE);

      OvhdStart := Now;
      Application.ProcessMessages;
      if Recording then
      begin
        LogFileStream.Flush;
      end;
      OvhdEnd := Now;
      SpdStart := SpdStart + (OvhdEnd - OvhdStart);
      if Canceled then
      begin
        break;
      end;
    end;

    //�Ϸ� �� �۾���
    if AvgCount <> 0 then
    begin
      AddStringAtList(LogFileStream, lSpeed, '***************************************');
      AddStringAtList(LogFileStream, lSpeed, '�ִ� �ӵ� : ' + IntToStr(Max) + 'MiB/s');
      AddStringAtList(LogFileStream, lSpeed, '�ּ� �ӵ� : ' + IntToStr(Min) + 'MiB/s');
      AddStringAtList(LogFileStream, lSpeed, '��� �ӵ� : ' + IntToStr(Avg div AvgCount) + 'MiB/s');
    end;
    AddStringAtList(LogFileStream, lSpeed, '***************************************');
    AddStringAtList(LogFileStream, lSpeed, '');
    if CurrFile <> 0 then
    begin
      CloseHandle(CurrFile);
      CurrFile := 0;
    end;
    CurrTime := CurrTime + 1;

    lSpeed.Clear;
    if Canceled then Break;
    if (cEndurance.Checked) and (Canceled = false) then
    begin
      if Verifying then
      begin
        Verifying := false;
        DeleteCache(@VeriBuf);
      end;
    end;

    if (RemainTimes > -1) or (InfiniteLoop) and (Canceled = false) then
    begin
      for ArrNum := MinFileNum to MaxFileNum do
      begin
        DeleteFile(AllDrives + 'Randomfile' + IntToStr(ArrNum));
        sleep(5);
        while FileExists(AllDrives + 'Randomfile' + IntToStr(ArrNum)) do
        begin
          sleep(100);
          DeleteFile(AllDrives + 'Randomfile' + IntToStr(ArrNum));
        end;
      end;
    end;
  end;

  if Sender = bRandDel then
  begin
    for ArrNum := MinFileNum to MaxFileNum do
    begin
      DeleteFile(AllDrives + 'Randomfile' + IntToStr(ArrNum));
      sleep(5);
      while FileExists(AllDrives + 'Randomfile' + IntToStr(ArrNum)) do
      begin
        sleep(100);
        DeleteFile(AllDrives + 'Randomfile' + IntToStr(ArrNum));
      end;
    end;
  end;
  ShowAndEndTest;
  FreeAndNil(SeedText);

  if LogFileStream <> nil then
  begin
    FreeAndNil(LogFileStream);
  end;

  if Canceled then
    lCurrFile.Caption := '���� ä���� �뷮 : ' + TButton(Sender).Caption + ' �ߴ�'
  else
    lCurrFile.Caption := '���� ä���� �뷮 : ' + TButton(Sender).Caption + ' �Ϸ�';

  for ArrNum := 0 to (MaxBufSize - 1) do
    SetLength(Buffer[ArrNum], 0);

  eDriveChange(nil);
end;

procedure TfMain.cAlignSizeChange(Sender: TObject);
begin
  if cAlignSize.ItemIndex = 0 then
  begin
    cCacheEffect.Enabled := true;
  end
  else
  begin
    cCacheEffect.Checked := false;
    cCacheEffect.Enabled := false;
  end;
end;

procedure TfMain.cEnduranceClick(Sender: TObject);
begin
  if cEndurance.Checked then
  begin
    cRepeat.Checked := true;
    eTimes.Text := '-1';
    eRandomness.Text := '100';
    cCacheEffect.Checked := false;
    cAlignSize.ItemIndex := 0;

    cRepeat.Enabled := false;
    eTimes.Enabled := false;
    eRandomness.Enabled := false;
    cCacheEffect.Enabled := false;
    cAlignSize.Enabled := false;
    bRand.Enabled := false;
  end
  else
  begin
    cRepeat.Enabled := true;
    eTimes.Enabled := true;
    eRandomness.Enabled := true;
    cCacheEffect.Enabled := true;
    cAlignSize.Enabled := true;
    bRand.Enabled := true;
  end;
end;

procedure TfMain.cEnduranceKeyPress(Sender: TObject; var Key: Char);
begin
  cEnduranceClick(cEndurance);
end;

procedure TfMain.eRandomnessChange(Sender: TObject);
begin
  if (eRandomness.Text <> '') and (StrToInt(eRandomness.Text) > 100) then
  begin
    eRandomness.Text := '100';
  end;
end;

procedure TfMain.eRandomnessKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9']) then Key := #0;
end;

procedure TfMain.eTimesEnter(Sender: TObject);
begin
  cRepeat.Checked := true;
end;

procedure TfMain.eDriveChange(Sender: TObject);
begin
  lCurrRemain.Caption := FormatFloat('0.0', DiskFree(Pos(eDrive.Items[eDrive.ItemIndex][1], VolumeNames)) / 1024 / 1024) + ' MiB(' +
                        FormatFloat('0.0', DiskFree(Pos(eDrive.Items[eDrive.ItemIndex][1], VolumeNames)) / 1024 / 1024 / 1024) + 'GiB)';
end;

procedure TfMain.eLeftKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9']) then Key := #0;
end;

procedure TfMain.FillBuffer(Buffer: PTRandomBuffer; RandomnessInString: String; MT: TMersenne);
var
  ArrNumAnd3: Integer;
  ArrNum, BitNum, Randomness: Integer;
  RandomInt: TRandom4int;
begin
  Randomness := Round(CacheSize * (StrToInt(RandomnessInString) / 100));
  for ArrNum := 0 to (MaxBufSize - 1) do
  begin
    for BitNum := 0 to (CacheSize - 1) do
    begin
      if (BitNum >= Randomness) then
      begin
        Buffer[ArrNum][BitNum] := 0;
      end
      else
      begin
        ArrNumAnd3 := BitNum and 3;
        if ArrNumAnd3 = 0 then
        begin
          RandomInt.RandomInt := MT.genrand_int32;
        end;
        Buffer[ArrNum][BitNum] := RandomInt.RandomChar[ArrNumAnd3];
      end;
    end;
  end;
end;

procedure TfMain.SetCacheLength(Buffer: PTRandomBuffer);
var
  ArrNum: Integer;
begin
  for ArrNum := 0 to (MaxBufSize - 1) do
  begin
    SetLength(Buffer[ArrNum], CacheSize);
  end;
end;

procedure TfMain.DeleteCache(Buffer: PTRandomBuffer);
var
  ArrNum: Integer;
begin
  for ArrNum := 0 to (MaxBufSize - 1) do
  begin
    SetLength(Buffer[ArrNum], 0);
  end;
end;

function TfMain.CompareBuffer(BufOne, BufTwo: TUnitBuffer): Integer;
var
  BitNum: Integer;
begin
  result := 0;
  for BitNum := 0 to (CacheSize - 1) do
  begin
    result := result + Integer(not(BufOne[BitNum] = BufTwo[BitNum]));
  end;
end;

procedure TfMain.InitList(Sender: TObject; DriveName: String; AllMeg: Integer);
var
  NewSSDInfo: TSSDInfo;
  FreeSizeMeg, PercentSizeMeg: Int64;
  DriveNamePChar: PChar;
begin
  if DriveName[Length(DriveName)] = '\' then
    DriveName := Copy(DriveName, 1, Length(DriveName) - 1);

  NewSSDInfo := TSSDInfo.Create();
  NewSSDInfo.ATAorSCSI := DetermineModel;
  NewSSDInfo.UsedByService := true;
  NewSSDInfo.SetDeviceName('PhysicalDrive' + IntToStr(GetMotherDrive(DriveName).Extents[0].DiskNumber));

  DriveNamePChar := PChar(DriveName);
  GetDiskFreeSpaceEx(DriveNamePChar, FreeSizeMeg, PercentSizeMeg, nil);

  AddStringAtList(LogFileStream, lSpeed, '***************************************');
  AddStringAtList(LogFileStream, lSpeed, Caption);
  AddStringAtList(LogFileStream, lSpeed, '������ : �̹���');
  AddStringAtList(LogFileStream, lSpeed, '�׽�Ʈ �Ͻ� : ' + FormatDateTime('yyyy/mm/dd hh:mm', now));
  AddStringAtList(LogFileStream, lSpeed, '***************************************');
  AddStringAtList(LogFileStream, lSpeed, '- �׽�Ʈ ����̺� �� -');
  AddStringAtList(LogFileStream, lSpeed, '�𵨸� : ' + NewSSDInfo.Model);
  AddStringAtList(LogFileStream, lSpeed, '����̺� : ' + DriveName);
  AddStringAtList(LogFileStream, lSpeed, '��ü �뷮 : ' + IntToStr(round(NewSSDInfo.UserSize / 2 / 1024 / 1000 / 1000 * 1024 * 1.024)) + 'GB');
  AddStringAtList(LogFileStream, lSpeed, '');

  AddStringAtList(LogFileStream, lSpeed, '- ����̺� �� �׽�Ʈ ���� -');
  AddStringAtList(LogFileStream, lSpeed, '�׽�Ʈ ���� : ' + IntToStr(round(FreeSizeMeg / 1000 / 1000 / 1000)) + 'GB ~ ' +
                                          IntToStr(round(((FreeSizeMeg / 1000 / 1000)  - (AllMeg * 1.024 * 1.024))/ 1000)) + 'GB');
  AddStringAtList(LogFileStream, lSpeed, '��Ƽ�� �뷮 : ' + IntToStr(round(PercentSizeMeg / 1000 / 1000 / 1000)) + 'GB');
  AddStringAtList(LogFileStream, lSpeed, '');

  AddStringAtList(LogFileStream, lSpeed, '- ä������ ������ �� -');
  AddStringAtList(LogFileStream, lSpeed, 'I/O ������ : ' + cAlignSize.Text + ' ���� / ' + TButton(Sender).Caption);
  AddStringAtList(LogFileStream, lSpeed, '������ : ' + eRandomness.Text + '%');
  AddStringAtList(LogFileStream, lSpeed, '');

  AddStringAtList(LogFileStream, lSpeed, '- ���� ��� ���� ���� -');
  if cEndurance.Checked then
  begin
    AddStringAtList(LogFileStream, lSpeed, '���� ��� : ����');
  end
  else
  begin
    AddStringAtList(LogFileStream, lSpeed, '���� ��� : ������');
  end;

  if cCacheEffect.Checked then
  begin
    AddStringAtList(LogFileStream, lSpeed, '���� ĳ�� ȿ�� : ����');
  end
  else
  begin
    AddStringAtList(LogFileStream, lSpeed, '���� ĳ�� ȿ�� : ������');
  end;
  AddStringAtList(LogFileStream, lSpeed, '');

  AddStringAtList(LogFileStream, lSpeed, '- �ݺ� ���� ���� -');
  if cRepeat.Checked then
  begin
    if RemainTimes <> -1 then
    begin
      AddStringAtList(LogFileStream, lSpeed, '�ݺ� �ܿ� ȸ�� (-1�̸� ������) : ' + IntToStr(RemainTimes));
    end
    else
    begin
      AddStringAtList(LogFileStream, lSpeed, '�ݺ� �ܿ� ȸ�� : ������');
      AddStringAtList(LogFileStream, lSpeed, '���� �ݺ� ȸ�� : ' + IntToStr(CurrTime));
    end;
  end;
  AddStringAtList(LogFileStream, lSpeed, '***************************************');
  FreeAndNil(NewSSDInfo);
end;

procedure TfMain.HideAndStartTest;
begin
  bRand.Enabled := false;
  bRandDel.Enabled := false;
  cSelection.Enabled := false;
  cAlignSize.Enabled := false;
  cRepeat.Enabled := false;
  eTimes.Enabled := false;
  eLeft.Enabled := false;
  eDrive.Enabled := false;
  cCacheEffect.Enabled := false;
  cEndurance.Enabled := false;
  eRandomness.Enabled := false;

  bCancel.Visible := true;
  bIdle.Visible := true;

  Constraints.MaxHeight := 0;
  Constraints.MaxWidth := 0;
  Constraints.MinHeight := 0;
  Constraints.MinWidth := 0;
  ClientHeight := MaxHeight;
  Constraints.MaxHeight := Height;
  Constraints.MaxWidth := Width;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  lSpeed.Clear;
end;

procedure TfMain.ShowAndEndTest;
begin
  cSelection.Enabled := true;
  cAlignSize.Enabled := true;
  bRand.Enabled := true;
  bRandDel.Enabled := true;
  cRepeat.Enabled := true;
  eTimes.Enabled := true;
  eLeft.Enabled := true;
  eDrive.Enabled := true;
  if cAlignSize.ItemIndex = 0 then
    cCacheEffect.Enabled := true;
  cEndurance.Enabled := true;
  eRandomness.Enabled := true;

  bCancel.Visible := false;
  bIdle.Visible := false;

  Constraints.MaxHeight := 0;
  Constraints.MaxWidth := 0;
  Constraints.MinHeight := 0;
  Constraints.MinWidth := 0;
  ClientWidth := MinWidth;
  ClientHeight := MinHeight;
  Constraints.MaxHeight := Height;
  Constraints.MaxWidth := Width;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  pProgress.Position := 0;
  cEnduranceClick(cEndurance);
end;

function TfMain.CalculateMeg(MethodIndex: Integer; DriveName: String; LeftText: String): Integer;
var
  FreeSizeMeg, PercentSizeMeg: Int64;
  DriveNamePChar: PChar;
begin
  DriveName := DriveName;
  DriveNamePChar := PChar(DriveName);
  GetDiskFreeSpaceEx(DriveNamePChar, FreeSizeMeg, PercentSizeMeg, nil);

  FreeSizeMeg := floor(FreeSizeMeg / 1024 / 1024);
  PercentSizeMeg := floor(PercentSizeMeg / 1024 / 1024);

  case MethodIndex of
    0:
    begin
      result := FreeSizeMeg - 1 - (StrToInt(LeftText) * 1024);
    end;

    1:
    begin
      result := FreeSizeMeg - 1 - StrToInt(eLeft.Text);
    end;

    2:
    begin
      if StrToInt(LeftText) <= 100 then
      begin
        result := floor(FreeSizeMeg - 1 - (PercentSizeMeg * StrToInt(LeftText) / 100));
      end
      else
      begin
        result := -1;
      end;
    end;

    else
    begin
      ShowMessage('����ġ ���� ���� �Է����� ���� ����˴ϴ�.');
      result := -1;
    end;
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
  Drives: TDriveLetters;
  CurrDrv: Integer;
begin
  ReportMemoryLeaksOnShutdown := true;

  Drives := GetFixedDrivesFunction;
  for CurrDrv := 0 to (Drives.LetterCount - 1) do
    eDrive.Items.Add(Drives.Letters[CurrDrv]);
  eDrive.ItemIndex := 0;
  eDriveChange(eDrive);

  Constraints.MaxHeight := Height;
  Constraints.MaxWidth := Width;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  Idle := false;
end;

end.
