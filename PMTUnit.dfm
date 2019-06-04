object PMT: TPMT
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object Timer: TTimer
    Interval = 100
    Left = 8
    Top = 112
  end
end
