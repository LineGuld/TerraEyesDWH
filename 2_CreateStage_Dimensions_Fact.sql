USE TerraEyesDWH;

/****** Object:  Table [stage].[DimUser]    Script Date: 20-05-2022 12:17:22 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[DimUser]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[DimUser] ([UserID] [varchar](64))
GO

/****** Object:  Table [stage].[DimTerrarium]    Script Date: 20-05-2022 12:17:22 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[DimTerrarium]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[DimTerrarium] (
		[EUI] [varchar](64)
		,[MinTemp] [decimal](3, 1)
		,[MaxTemp] [decimal](3, 1)
		,[MinHum] [decimal](3, 1)
		,[MaxHum] [decimal](3, 1)
		,[MaxCarbon] [int]
		)
GO

/****** Object:  Table [stage].[DimAnimal]    Script Date: 20-05-2022 12:17:22 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[DimAnimal]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[DimAnimal] (
		[AnimalID] [int]
		,[EUI] [varchar](64)
		,[Name] [varchar](64)
		,[Age] [int]
		,[Species] [varchar](128)
		,[Sex] [char]
		)
GO

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


IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[FactFiveMinuteSnapshotMeasurement]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[FactFiveMinuteSnapshotMeasurement] (
		[Time] [Time] 
		,[Date] [Date] 
		,[UserID] [varchar](64) 
		,[EUI] [varchar](64) 
		,[Temperature] [decimal](3, 1)
		,[Humidity] [decimal](3, 1)
		,[Lumen] [int]
		,[CarbonDioxid] [int]
		,[Activity] [int]
		,[ServoMoved] [bit] 
		,[ServoMovedLabel] [varchar](15)
		,[TemperatureOutOfRangeFlag] [bit]
		,[HumidityOutOfRangeFlag] [bit]
		,[CarbonDioxideOutOfRangeFlag] [bit]
		)
GO


