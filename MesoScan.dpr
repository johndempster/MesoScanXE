program MesoScan;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainFrm},
  nidaqmxlib in 'nidaqmxlib.pas',
  LabIOUnit in 'LabIOUnit.pas' {LabIO: TDataModule},
  SettingsUnit in 'SettingsUnit.pas' {SettingsFrm},
  ZStageUnit in 'ZStageUnit.pas' {ZStage: TDataModule},
  LaserUnit in 'LaserUnit.pas' {Laser: TDataModule},
  PMTUnit in 'PMTUnit.pas' {PMT: TDataModule},
  LaserComThreadUnit in 'LaserComThreadUnit.pas',
  ZStageComThreadUnit in 'ZStageComThreadUnit.pas',
  PMTComThreadUnit in 'PMTComThreadUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TLabIO, LabIO);
  Application.CreateForm(TSettingsFrm, SettingsFrm);
  Application.CreateForm(TZStage, ZStage);
  Application.CreateForm(TLaser, Laser);
  Application.CreateForm(TPMT, PMT);
  Application.Run;
end.
