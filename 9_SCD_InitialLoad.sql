USE [TerraEyesDWH]
GO

/***	ETL Log Table		**/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[etl].[LogUpdate]')
			AND type IN (N'U')
		)
CREATE Table etl.[LogUpdate](
	[TableName] nvarchar(50)
	,[LastLoadDate] INT
)

DECLARE @InitialLoadDate INT
SET @InitialLoadDate = CONVERT(CHAR(8), GETDATE(), 112)

INSERT INTO etl.LogUpdate(TableName, LastLoadDate)
VALUES ('DimAnimal', @InitialLoadDate)
,('DimTerrarium', @InitialLoadDate)
, ('DimUser', @InitialLoadDate)
, ('DimDate', @InitialLoadDate)
, ('DimTime' , @InitialLoadDate)
, ('TerrariumToAnimalBridge', @InitialLoadDate)
, ('FactFiveMinuteSnapshotMeasurement' , @InitialLoadDate)

ALTER table [edw].[DimTerrarium] ADD ValidFrom int, ValidTo int 
ALTER table [edw].[DimAnimal] ADD ValidFrom int, ValidTo int 
ALTER table [edw].[TerrariumToAnimalBridge] ADD ValidFrom int, ValidTo int 
GO

UPDATE [edw].[DimTerrarium] SET ValidFrom = @InitialLoadDate, ValidTo = 99990101 
UPDATE [edw].[DimAnimal] SET ValidFrom = @InitialLoadDate, ValidTo = 99990101 
UPDATE [edw].[TerrariumToAnimalBridge] SET ValidFrom = @InitialLoadDate, ValidTo = 99990101 
