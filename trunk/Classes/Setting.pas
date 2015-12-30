unit Setting;

interface

type
  TLeftUnit = (LeaveByGiB, LeaveByMiB, LeaveByPercent);
  TUnitSpeed = (ZeroPointOnePercent, OnePercent, TenPercent);
  TSetting = record
    IsSet: Boolean;
    DrivePath: String;
    ToLeft: Int64;
    ToLeftUnit: TLeftUnit;
    UnitSpeed: TUnitSpeed;
    NeedCache: Boolean;
    InfiniteRepetition: Boolean;
    NeedDelete: Boolean;
    RecordPath: String;
    DetailedRecordPath: String;
  end;

implementation

end.
