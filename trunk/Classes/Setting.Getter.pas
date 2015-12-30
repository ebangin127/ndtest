unit Setting.Getter;

interface

uses
  SysUtils,
  Forms.Setting, Setting;

function GetSettingFromForm: TSetting;

implementation

function GetToLeftUnit: TLeftUnit;
begin
  case fSetting.cSelection.ItemIndex of
  0: result := TLeftUnit.LeaveByGiB;
  1: result := TLeftUnit.LeaveByMiB;
  2: result := TLeftUnit.LeaveByPercent;
  else
    raise EArgumentException.Create('Wrong ItemIndex at cSelection: ' +
      IntToStr(fSetting.cSelection.ItemIndex));
  end;
end;

function GetUnitSpeed: TUnitSpeed;
begin
  case fSetting.cUnitSpeed.ItemIndex of
  0: result := TUnitSpeed.ZeroPointOnePercent;
  1: result := TUnitSpeed.OnePercent;
  2: result := TUnitSpeed.TenPercent;
  else
    raise EArgumentException.Create('Wrong ItemIndex at cUnitSpeed: ' +
      IntToStr(fSetting.cSelection.ItemIndex));
  end;
end;

function GetSettingFromForm: TSetting;
begin
  if fSetting = nil then
    exit;

  result.IsSet := fSetting.IsSet;
  if not result.IsSet then
    exit;

  result.DrivePath := fSetting.eDrive.Text + '\';
  result.ToLeft := StrToInt(fSetting.eLeft.Text);
  result.ToLeftUnit := GetToLeftUnit;
  result.UnitSpeed := GetUnitSpeed;
  result.NeedCache := fSetting.cCacheEffect.Checked;
  result.InfiniteRepetition := fSetting.cRepeat.Checked;
  result.NeedDelete := fSetting.cDelete.Checked;
  result.RecordPath := fSetting.RecordPath;
  result.DetailedRecordPath := fSetting.DetailedRecordPath;
end;

end.
