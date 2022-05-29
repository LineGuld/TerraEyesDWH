USE [TerraEyesDWH]

/****** Load to edw User  ******/
INSERT INTO [edw].[DimUser] (
	[UserID]
	,[IsValid]
	)
SELECT [UserID]
	,1
FROM [stage].[DimUser]

/****** Load to edw Terrarium  ******/
INSERT INTO [edw].[DimTerrarium] (
	[EUI]
	,[MinTemp]
	,[MaxTemp]
	,[MinHum]
	,[MaxHum]
	,[MaxCarbon]
	)
SELECT [EUI]
	,[MinTemp]
	,[MaxTemp]
	,[MinHum]
	,[MaxHum]
	,[MaxCarbon]
FROM [stage].[DimTerrarium]

/****** Load to edw animal  ******/
INSERT INTO [edw].[DimAnimal] (
	[AnimalID]
	,[EUI]
	,[Name]
	,[Age]
	,[Species]
	,[Sex]
	)
SELECT [AnimalID]
	,[EUI]
	,[Name]
	,[Age]
	,[Species]
	,[Sex]
FROM [stage].[DimAnimal]

/****** Load to edw TerrariumToAnimalBridge  ******/
INSERT INTO [edw].[TerrariumToAnimalBridge]
SELECT sb.[EUI]
	,CONCAT (
		sb.[AnimalID]
		,sb.[EUI]
		)
	,sb.[AnimalID]
FROM [stage].[TerrariumToAnimalBridge] sb

/****** Load to edw FactFifthteenMinuteSnapshotMeasurement  ******/
INSERT INTO [edw].[FactFiveMinuteSnapshotMeasurement] (
	[T_ID]
	,[D_ID]
	,[U_ID]
	,[TE_ID]
	,[Time]
	,[Date]
	,[UserID]
	,[EUI]
	,[Temperature]
	,[Humidity]
	,[Lumen]
	,[CarbonDioxid]
	,[Activity]
	,[ServoMoved]
	,[ServoMovedLabel]
	,[TemperatureOutOfRangeFlag]
	,[HumidityOutOfRangeFlag]
	,[CarbonDioxideOutOfRangeFlag]
	)
SELECT t.[T_ID]
	,d.[D_ID]
	,u.[U_ID]
	,te.[TE_ID]
	,f.[Time]
	,f.[Date]
	,f.[UserID]
	,f.[EUI]
	,f.[Temperature]
	,f.[Humidity]
	,f.[Lumen]
	,f.[CarbonDioxid]
	,f.[Activity]
	,f.[ServoMoved]
	,f.[ServoMovedLabel]
	,f.[TemperatureOutOfRangeFlag]
	,f.[HumidityOutOfRangeFlag]
	,f.[CarbonDioxideOutOfRangeFlag]
FROM [stage].[FactFiveMinuteSnapshotMeasurement] f
JOIN [edw].[DimTime] t ON f.[Time] = t.[Time]
JOIN [edw].[DimDate] d ON f.[Date] = d.[Date]
JOIN [edw].[DimUser] u ON f.[UserID] = u.[UserID]
JOIN [edw].[DimTerrarium] te ON f.[EUI] = te.[EUI]
--WHERE f.EUI = '0004A30B00259F36'

-- alter fact table -> add AnimalID on edw Fact
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
	