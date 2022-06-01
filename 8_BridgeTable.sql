USE TerraEyesDWH;
go

/****** Create stage bridge table if it does not exist  ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[TerrariumToAnimalBridge]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[TerrariumToAnimalBridge] (
		[EUI] [varchar](64),
		[AnimalID] [int]	)
GO


/****** Create edw TerrariumToAnimalBridge Table if it does not exist ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[edw].[TerrariumToAnimalBridge]')
			AND type IN (N'U')
		)
	CREATE TABLE [edw].[TerrariumToAnimalBridge] (
		[EUI] [varchar](64),
		[EUI_AnimalID] [varchar](64),
		[AnimalID] [int],
		)
GO


/****** Load to stage TerrariumToAnimalBridge  ******/
TRUNCATE TABLE [stage].[TerrariumToAnimalBridge]

INSERT INTO [stage].[TerrariumToAnimalBridge]
select et.[EUI], st.[AnimalID]
from [stage].[DimAnimal] st
LEFT join [edw].[DimAnimal] et on st.[AnimalID] = et.[AnimalID]

/****** Load to edw TerrariumToAnimalBridge  ******/
INSERT INTO [edw].[TerrariumToAnimalBridge]
SELECT [EUI]
	,CONCAT (
		EUI,
		AnimalID
		)
	,[AnimalID]
FROM [stage].[TerrariumToAnimalBridge]

-- alter fact table -> add EUI_AnimalID on edw Fact
ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD [EUI_AnimalID] varchar(64);
GO

-- update fact table
UPDATE [edw].[FactFiveMinuteSnapshotMeasurement]
SET [EUI_AnimalID] = ISNULL(subq.[EUI_AnimalID], '0')
FROM [edw].[FactFiveMinuteSnapshotMeasurement] f
 left JOIN (
	SELECT 
	t.[EUI]
		,b.[EUI_AnimalID]
		,b.[AnimalID]
	FROM [edw].[TerrariumToAnimalBridge] b
	RIGHT JOIN [edw].[DimTerrarium] t ON b.[EUI] = t.[EUI]
	) AS subq ON f.[EUI] = subq.[EUI]