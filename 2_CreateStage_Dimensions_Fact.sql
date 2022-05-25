USE TerraEyesDWH;

/****** Object:  Table [stage].[DimUser]    Script Date: 20-05-2022 12:17:22 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[DimUser]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[DimUser] ([UserID] [varchar](64) PRIMARY KEY NOT NULL)
GO

/****** Object:  Table [stage].[DimTerrarium]    Script Date: 20-05-2022 12:17:22 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[DimTerrarium]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[DimTerrarium] (
		[EUI] [varchar](64) PRIMARY KEY NOT NULL
		,[UserID] [varchar](64) NOT NULL
		,[MinTemp] [decimal](3, 1)
		,[MaxTemp] [decimal](3, 1)
		,[MinHum] [decimal](3, 1)
		,[MaxHum] [decimal](3, 1)
		,[MaxCarbon] [int]
		-- ClimateZone varchar(64)
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
		[AnimalID] [int] PRIMARY KEY NOT NULL
		,[EUI] [varchar](64)
		,[Name] [varchar](64)
		,[Age] [int]
		,[Species] [varchar](128)
		--,[Morph] [varchar](40)
		,[Sex] [char]
		,[IsShedding] [bit] NOT NULL
		,[IsHibernating] [bit] NOT NULL
		,[HasOffspring] [bit] NOT NULL
		,[ValidFrom] [DATE]
		,[ValidTo] [DATE]
		)
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[stage].[FactFiveMinuteSnapshotMeasurement]')
			AND type IN (N'U')
		)
	CREATE TABLE [stage].[FactFiveMinuteSnapshotMeasurement] (
		[AnimalID] [int]
		,[Time] [Time] NOT NULL
		,[Date] [Date] NOT NULL
		,[UserID] [varchar](64) NOT NULL
		,[EUI] [varchar](64) NOT NULL
		,[Temperature] [decimal](3, 1)
		,[Humidity] [decimal](3, 1)
		,[Lumen] [int]
		,[CarbonDioxid] [int]
		,[Activity] [int] NOT NULL
		,[ServoMoved] [bit] NOT NULL
		,[ServoMovedLabel] [varchar](15)
		,[TemperatureOutOfRangeFlag] [bit]
		,[HumidityOutOfRangeFlag] [bit]
		,[CarbonDioxideOutOfRangeFlag] [bit]
		)
GO


