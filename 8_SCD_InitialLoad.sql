USE [TerraEyesDWH]
GO

/***	ETL Log Table		**/
CREATE Table etl.[LogUpdate](
	[TableName] nvarchar(50)
	,[LastLoadDate] INT
)


INSERT INTO etl.LogUpdate(TableName, LastLoadDate)
VALUES ('DimAnimal', 20222505)
,('DimTerrarium', 20222505)
, ('DimUser', 20222505)
, ('DimDate', 20222505)
, ('DimTime' ,20222505)
, ('FactFiveMinuteSnapshotMeasurement' ,20222505)

ALTER table edw.DimTerrarium ADD ValidFrom int, ValidTo int 
GO

ALTER table edw.DimUser add IsValid bit 
GO

UPDATE edw.DimTerrarium SET ValidFrom = 20222505, ValidTo = 99990101 
UPDATE edw.DimAnimal SET ValidFrom = 20222505, ValidTo = 99990101 
UPDATE edw.DimUser SET IsValid = 1