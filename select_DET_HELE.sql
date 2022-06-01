


select * from stage.DimAnimal


select * from edw.DimAnimal
select * from edw.DimTime
select * from edw.DimDate
select * from edw.DimUser
select * from edw.DimTerrarium

select * from stage.TerrariumToAnimalBridge
select * from edw.TerrariumToAnimalBridge

select * from stage.FactFiveMinuteSnapshotMeasurement where AnimalID is not null

select * from edw.FactFiveMinuteSnapshotMeasurement