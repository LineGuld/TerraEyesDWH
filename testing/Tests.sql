
/***	FACTS		***/
-- Den her tæller bare om vi får det rigtige antal rækker over
SELECT
	COUNT(id) AS [NumberOfMeasurementsInDB]
FROM TestSourceDb.dbo.Measurement
SELECT
	COUNT(T_ID) AS [NumberOfMeasurementsInEDW]
FROM [TerraeyesTESTdwh].[edw].[FactFiveMinuteSnapshotMeasurement]

-- Den her ser om gennemsnittet af temperaturerne har ændret sig
SELECT
	AVG(temperature) AS [AverageOfTemperaturesInDB]
FROM TestSourceDb.dbo.Measurement
SELECT
	AVG(Temperature) AS [AverageOfTemperaturesinEDW]
FROM [TerraeyesTESTdwh].[edw].[FactFiveMinuteSnapshotMeasurement]


/**		TERRARIUM		**/
SELECT
	COUNT(eui) AS [NumberTerrariaInDB]
FROM TestSourceDb.dbo.Terrarium
SELECT
	COUNT(EUI) AS [NumberOfTerrariaInEDW]
FROM [TerraeyesTESTdwh].[edw].[DimTerrarium]


-- minimum grænse kommer rigtigt over
SELECT
	[minTemperature] AS [MinTemperaturesInDB]
FROM TestSourceDb.dbo.Terrarium
WHERE eui = 'abc123'
SELECT
	[MinTemp] AS [MinTemperaturesinEDW]
FROM [TerraeyesTESTdwh].[edw].[DimTerrarium]
WHERE eui = 'abc123'


-- max grænse kommer rigtigt over
SELECT
	[maxTemperature] AS [MaxTemperaturesInDB]
FROM TestSourceDb.dbo.Terrarium
WHERE eui = 'abc123'
SELECT
	[MaxTemp] AS [MaxTemperaturesinEDW]
FROM [TerraeyesTESTdwh].[edw].[DimTerrarium]
WHERE eui = 'abc123'



/****		ANIMAL		***/
SELECT
	COUNT(id) AS [NumberAnimalsInDB]
FROM TestSourceDb.dbo.Animal
SELECT
	COUNT(AnimalID) AS [NumberOfAnimalsInEDW]
FROM [TerraeyesTESTdwh].[edw].[DimAnimal]




/****		USER		***/
SELECT
	COUNT(id) AS [NumberUsersInDB]
FROM TestSourceDb.dbo.[User]
SELECT
	COUNT(UserID) AS [NumberOfUsersInEDW]
FROM [TerraeyesTESTdwh].[edw].[DimUser]

-- Alle users der er i source databasen skulle gerne være registreret som aktive/valide users
SELECT
	COUNT(id) AS [NumberUsersInDB]
FROM TestSourceDb.dbo.[User]
SELECT
	COUNT(UserID) AS [NumberOfUsersInEDW]
FROM [TerraeyesTESTdwh].[edw].[DimUser]
WHERE [IsValid] = 1