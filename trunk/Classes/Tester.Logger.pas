unit Tester.Logger;

interface

uses
  Classes;

type
  TTesterLogger = class
  private
    FLogFileStream: TStreamWriter;
    FLogList: TStringList;
    function GetItem(Index: Integer): String;
  public
    property Items[Index: Integer]: String read GetItem;
    constructor Create(const LogPath: String);
    destructor Destroy; override;
    procedure Add(const Value: String);
  end;
implementation

{ TTesterLogger }

procedure TTesterLogger.Add(const Value: String);
begin
  FLogFileStream.WriteLine(Value);
  FLogList.Add(Value);
end;

constructor TTesterLogger.Create(const LogPath: String);
begin
  FLogFileStream := TStreamWriter.Create(LogPath, false);
  FLogList := TStringList.Create;
end;

destructor TTesterLogger.Destroy;
begin
  FLogFileStream.Free;
  FLogList.Free;
  inherited;
end;

function TTesterLogger.GetItem(Index: Integer): String;
begin
  result := FLogList[Index];
end;

end.
