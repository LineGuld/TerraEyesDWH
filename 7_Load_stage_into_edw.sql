USE [TerraEyesDWH]

/****** Load to edw User  ******/
INSERT INTO [edw].[DimUser] ([UserID], [IsValid])
SELECT [UserID], 1
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
	,[IsShedding]
	,[IsHibernating]
	,[HasOffspring]
	,[ValidFrom]
	,[ValidTo]
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
	,[ValidFrom]
	,[ValidTo]
FROM [stage].[DimAnimal]

/****** Load to edw FactFifthteenMinuteSnapshotMeasurement  ******/
INSERT INTO [edw].[FactFiveMinuteSnapshotMeasurement] (
[A_ID]
	,[T_ID]
	,[D_ID]
	,[U_ID]
	,[TE_ID],
	[AnimalID]
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
SELECT
a.[A_ID]
	,t.[T_ID]
	,d.[D_ID]
	,u.[U_ID]
	,te.[TE_ID],
	f.[AnimalID]
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
inner JOIN [edw].[DimAnimal]  a ON f.[AnimalID] = a.[AnimalID]
inner JOIN [edw].[DimTime]  t ON f.[Time] = t.[Time]
inner JOIN [edw].[DimDate]  d ON f.[Date] = d.[Date]
inner JOIN [edw].[DimUser]  u ON f.[UserID] = u.[UserID]
inner JOIN [edw].[DimTerrarium]  te ON f.[EUI] = te.[EUI]

 --2160