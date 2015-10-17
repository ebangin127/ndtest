unit Setting;

interface

type
  TLeftUnit = (LeaveByGiB, LeaveByMiB, LeaveByPercent);
  TUnitSpeed = (ZeroPointOnePercent, OnePercent);
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
  end;

implementation

end.
