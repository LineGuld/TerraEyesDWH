USE [TerraEyesDWH]

/****** Load to edw User  ******/
INSERT INTO [edw].[DimUser] ([UserID])
SELECT [UserID]
FROM [stage].[DimUser]

/****** Load to edw Terrarium  ******/
INSERT INTO [edw].[DimTerrarium] (
	[EUI]
	,[UserID]
	,[MinTemp]
	,[MaxTemp]
	,[MinHum]
	,[MaxHum]
	,[MaxCarbon]
	)
SELECT [EUI]
	,[UserID]
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
	,[Morph]
	,[Sex]
	,[IsShedding]
	,[IsHibernating]
	,[HasOffspring]
	,[IsCurrent]
	)
SELECT [AnimalID]
	,[EUI]
	,[Name]
	,[Age]
	,[Species]
	,[Sex]
	,[IsShedding]
	,[IsHibernating]
	,[HasOffspring]
	,[IsCurrent]
FROM [stage].[DimAnimal]

/****** Load to edw FactFifthteenMinuteSnapshotMeasurement  ******/
INSERT INTO [edw].[FactFifthteenMinuteSnapshotMeasurement] (
	[A_ID]
	,[T_ID]
	,[D_ID]
	,[U_ID]
	,[TE_ID]
	,[Temperature]
	,[Humidity]
	,[Light]
	,[CarbonDioxid]
	,[ActivityBit]
	,[ActivityLabel]
	,[ServoMoved]
	,[ServoMovedLabel]
	)
SELECT a.[A_ID]
	,t.[T_ID]
	,d.[D_ID]
	,u.[U_ID]
	,te.[TE_ID]
	,f.[Temperature]
	,f.[Humidity]
	,f.[Light]
	,f.[CarbonDioxid]
	,f.[ActivityBit]
	,f.[ActivityLabel]
	,f.[ServoMoved]
	,f.[ServoMovedLabel]
FROM [stage].[FactFifthteenMinuteSnapshotMeasurement] f
INNER JOIN [edw].[DimAnimal] AS a ON f.[AnimalID] = a.[AnimalID]
INNER JOIN [edw].[DimTime] AS t ON f.[Time] = t.[Time]
INNER JOIN [edw].[DimDate] AS d ON f.[Date] = d.[Date]
INNER JOIN [edw].[DimUser] AS u ON f.[UserID] = u.[UserID]
INNER JOIN [edw].[DimTerrarium] AS te ON f.[EUI] = te.[EUI]
