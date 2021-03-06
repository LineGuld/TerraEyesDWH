USE [TerraEyesDWH]

/****** Load to stage User  ******/
TRUNCATE TABLE [stage].[DimUser]

INSERT INTO [stage].[DimUser] ([UserID])
	SELECT
		[id]
	FROM [POSTGRESTE].[terraeyes].[terraeyes].[user];


/****** Load to stage Terrarium  ******/
TRUNCATE TABLE [stage].[DimTerrarium]

INSERT INTO [stage].[DimTerrarium] ([EUI]
, [MinTemp]
, [MaxTemp]
, [MinHum]
, [MaxHum]
, [MaxCarbon])
	SELECT
		te.[EUI]
	   ,te.[MinTemperature]
	   ,te.[MaxTemperature]
	   ,te.[MinHumidity]
	   ,te.[MaxHumidity]
	   ,te.[MaxCarbondioxide]
	FROM [POSTGRESTE].[terraeyes].[terraeyes].[terrarium] te
	

/****** Load to stage Animal  ******/
TRUNCATE TABLE [stage].[DimAnimal]

INSERT INTO [stage].[DimAnimal] ([AnimalID]
, [EUI]
, [Name]
, [Age]
, [Species]
, [Sex]
)
	SELECT
		a.[id]
	   ,te.[EUI]
	   ,a.[Name]
	   ,a.[Age]
	   ,a.[Species]
	   ,a.[Sex]
	
	FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.animal') a
	  JOIN [POSTGRESTE].[terraeyes].[terraeyes].[terrarium] te
		ON a.EUI = te.EUI

/****** Load to stage FactFiveMinuteSnapshotMeasurement  ******/
TRUNCATE TABLE [stage].[FactFiveMinuteSnapshotMeasurement]

INSERT INTO [stage].[FactFiveMinuteSnapshotMeasurement] 
( [Date]
, [Time]
, [UserID]
, [EUI]
, [Temperature]
, [Humidity]
,[Lumen]
, [CarbonDioxid]
, [Activity]
, [ServoMoved]
,[ServoMovedLabel]
,[TemperatureOutOfRangeFlag]
,[HumidityOutOfRangeFlag]
,[CarbonDioxideOutOfRangeFlag]
)
	SELECT
	   CAST(m.[timestamp] AS DATE) as [date]
	   ,CAST(m.[timestamp] AS TIME) as [time]
	   ,u.[id]
	   ,te.[EUI]
	   ,m.[temperature]
	   ,m.[humidity]
	,m.[Lumen]
	   ,m.[carbondioxide]
	   ,m.[activity]
	   ,m.[servomoved]
		,IIF(m.[servomoved] = 1, 'Feeding', 'No feeding' ) as FeedingLabel
		,IIF(m.[temperature] NOT BETWEEN te.[mintemperature] AND te.[maxtemperature] , 1, 0) as TemperatureFlag
		,IIF(m.[humidity] NOT BETWEEN te.[minhumidity] AND te.[maxhumidity] , 1, 0) as HumidityFlag
		,IIF(m.[carbondioxide] > te.[maxcarbondioxide] , 1, 0) as CarbonFlag
	FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.measurement') m
	inner JOIN OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.terrarium') te
		ON m.EUI = te.EUI
	 JOIN [POSTGRESTE].[terraeyes].[terraeyes].[user] u
		ON te.userid = u.id


