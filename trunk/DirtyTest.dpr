program DirtyTest;

uses
  Vcl.Forms,
  uSSDInfo in 'SSDInfo\uSSDInfo.pas',
  uSSDVersion in 'SSDInfo\uSSDVersion.pas',
  uDiskFunctions in 'Modules\uDiskFunctions.pas',
  uIntFunctions in 'Modules\uIntFunctions.pas',
  uLanguageSettings in 'Modules\uLanguageSettings.pas',
  uLogSystem in 'Modules\uLogSystem.pas',
  uRegFunctions in 'Modules\uRegFunctions.pas',
  uTrimCommand in 'Modules\uTrimCommand.pas',
  uMTforDel in 'Modules\uMTforDel.pas',
  Forms.Setting in 'Forms.Setting.pas' {fSetting},
  Setting in 'Classes\Setting.pas',
  Setting.Getter in 'Classes\Setting.Getter.pas',
  Forms.Main in 'Forms.Main.pas' {fMain},
  Tester.Thread in 'Classes\Tester.Thread.pas',
  Tester.ToView in 'Classes\Tester.ToView.pas',
  Tester.Logger in 'Classes\Tester.Logger.pas',
  RandomBuffer in 'Classes\RandomBuffer.pas',
  uDatasizeUnit in 'Modules\uDatasizeUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
