USE [TerraEyesDWH]

/****** Load to stage User  ******/
TRUNCATE TABLE [stage].[DimUser]

INSERT INTO [stage].[DimUser] (
	[UserID]
	)
SELECT [id]
FROM [POSTGRESTE].[terraeyes].[terraeyes].[User];


/****** Load to stage Terrarium  ******/
TRUNCATE TABLE [stage].[DimTerrarium]

INSERT INTO [stage].[DimTerrarium] (
	[EUI] 
		,[UserID] 
		,[MinTemp] 
		,[MaxTemp] 
		,[MinHum] 
		,[MaxHum]
		,[MaxCarbon]
	)
SELECT te.[EUI] 
		,u.[id] 
		,te.[MinTemperature] 
		,te.[MaxTemperature] 
		,te.[MinHumidity] 
		,te.[MaxHumidity]
		,te.[MaxCarbondioxide]
FROM [POSTGRESTE].[terraeyes].[terraeyes].[terrarium] te
inner join [POSTGRESTE].[terraeyes].[terraeyes].[User] u
on te.UserID = u.id


/****** Load to stage Animal  ******/
TRUNCATE TABLE [stage].[DimAnimal]

INSERT INTO [stage].[DimAnimal] (
	[AnimalID]
	,[EUI]
	,[Name]
	,[Age]
	,[Species]
	--,[Morph]
	,[Sex]
	,[IsShedding]
	,[IsHibernating]
	,[HasOffspring]
--	,[ClimateZone]
	--,[IsCurrent]
	)
SELECT a.[id]
,te.[EUI]
	,a.[Name]
	,a.[Age]
	,a.[Species]
	--,[Morph]
	,a.[Sex]
	,a.[IsShedding]
	,a.[IsHibernating]
	,a.[HasOffspring]
	--,[ClimateZone]
	--,[IsCurrent]
FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.animal') a
inner join [POSTGRESTE].[terraeyes].[terraeyes].[terrarium] te
on a.EUI = te.EUI

/****** Load to stage FactFivenMinuteSnapshotMeasurement  ******/
TRUNCATE TABLE [stage].[FactFiveMinuteSnapshotMeasurement]

INSERT INTO [stage].[FactFiveMinuteSnapshotMeasurement] (
	[AnimalID]
	,[Date]
	--,[Time]
	,[UserID]
	,[EUI]
	,[Temperature]
	,[Humidity]
	--,[Light]
	,[CarbonDioxid]
	,[Activity]
	--,[ActivityLabel]
	,[ServoMoved]
	--,[ServoMovedLabel]
	)
SELECT a.[id],
	STRING_SPLIT(m.[timestamp], ' ') as [time]
	,u.[id]
	,te.[EUI]
	,m.[temperature]
	,m.[humidity]
	--,[Light]
	,m.[carbondioxide]
	,m.[activity]
	--,[ActivityLabel]
	,m.[servomoved]
	--,[ServoMovedLabel]
FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.measurement') m
inner join OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.terrarium') te
on m.EUI = te.EUI
inner join OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.animal') a
on te.EUI = a.EUI
inner join [POSTGRESTE].[terraeyes].[terraeyes].[User] u
on te.userid = u.id
