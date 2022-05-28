USE [msdb]
GO

/****** Object:  Job [SetudTestDwh]    Script Date: 28-05-2022 17:21:32 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 28-05-2022 17:21:33 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'SetudTestDwh', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Sætter test dwh op og indsætter data', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'LAPTOP-6DQI3I6J\Line Guld', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [0_MakeDatabaseAndSchemas]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'0_MakeDatabaseAndSchemas', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
/****** Object:  Database [TerraeyesTESTdwh]    Script Date: 28-05-2022 12:21:03 ******/
DROP DATABASE [TerraeyesTESTdwh]
GO

/****** Object:  Database [TerraeyesTESTdwh]    Script Date: 28-05-2022 12:21:03 ******/
CREATE DATABASE [TerraeyesTESTdwh]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N''TerraeyesTESTdwh'', FILENAME = N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\TerraeyesTESTdwh.mdf'' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N''TerraeyesTESTdwh_log'', FILENAME = N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\TerraeyesTESTdwh_log.ldf'' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY(''IsFullTextInstalled''))
begin
EXEC [TerraeyesTESTdwh].[dbo].[sp_fulltext_database] @action = ''enable''
end
GO

ALTER DATABASE [TerraeyesTESTdwh] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET ARITHABORT OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET  DISABLE_BROKER 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET RECOVERY FULL 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET  MULTI_USER 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [TerraeyesTESTdwh] SET DB_CHAINING OFF 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [TerraeyesTESTdwh] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [TerraeyesTESTdwh] SET QUERY_STORE = OFF
GO

ALTER DATABASE [TerraeyesTESTdwh] SET  READ_WRITE 
GO

USE [TerraeyesTESTdwh]
GO
CREATE SCHEMA [stage]
GO

USE [TerraeyesTESTdwh]
GO
CREATE SCHEMA [edw]
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1_MakeStageDimensionsAndFacts]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1_MakeStageDimensionsAndFacts', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/****** Object:  Table [stage].[DimUser]    Script Date: 20-05-2022 12:17:22 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[stage].[DimUser]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [stage].[DimUser] ([UserID] [varchar](64))
GO

/****** Object:  Table [stage].[DimTerrarium]    Script Date: 20-05-2022 12:17:22 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[stage].[DimTerrarium]'')
			AND type IN (N''U'')
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
		WHERE object_id = OBJECT_ID(N''[stage].[DimAnimal]'')
			AND type IN (N''U'')
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
		WHERE object_id = OBJECT_ID(N''[stage].[TerrariumToAnimalBridge]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [stage].[TerrariumToAnimalBridge] (
		[EUI] [varchar](64),
		[AnimalID] [int]	)
GO


IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[stage].[FactFiveMinuteSnapshotMeasurement]'')
			AND type IN (N''U'')
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

', 
		@database_name=N'TerraeyesTESTdwh', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2_MakeEDWDimensions]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2_MakeEDWDimensions', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/****** Create User Table if it does not exist ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[edw].[DimUser]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [edw].[DimUser] (
		[U_ID] [int] identity NOT NULL
		,[UserID] [varchar](64)
		,[IsValid] [BIT] NOT NULL
		,CONSTRAINT [PK_DimUser] PRIMARY KEY CLUSTERED ([U_ID] ASC) WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,IGNORE_DUP_KEY = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
		) ON [PRIMARY]
GO

/****** Create Terrarium Table if it does not exist ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[edw].[DimTerrarium]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [edw].[DimTerrarium] (
		[TE_ID] [int] identity NOT NULL
		,[EUI] [varchar](64) NOT NULL
		,[MinTemp] [decimal](3, 1)
		,[MaxTemp] [decimal](3, 1)
		,[MinHum] [decimal](3, 1)
		,[MaxHum] [decimal](3, 1)
		,[MaxCarbon] [int]
		,[ValidFrom] [int]
		,[ValidTo][int]
		,CONSTRAINT [PK_DimTerrarium] PRIMARY KEY CLUSTERED ([TE_ID] ASC) WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,IGNORE_DUP_KEY = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
		) ON [PRIMARY]
GO

/****** Create Animal Table if it does not exist ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[edw].[DimAnimal]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [edw].[DimAnimal] (
		[A_ID] [int] identity NOT NULL
		,[AnimalID] [int]
		,[EUI] [varchar](64)
		,[Name] [varchar](64)
		,[Age] [int]
		,[Species] [varchar](128)
		,[Sex] [char]

		,[ClimateZone] [varchar](64)
		,CONSTRAINT [PK_DimAnimal] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,IGNORE_DUP_KEY = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
		) ON [PRIMARY]
GO

/****** Create Date Table if it does not exist ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[edw].[DimDate]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [edw].[DimDate] (
		[D_ID] [int] NOT NULL
		,[Date] [datetime] NOT NULL
		,[Day] [int] NOT NULL
		,[Month] [int] NOT NULL
		,[MonthName] [nvarchar](9) NOT NULL
		,[Week] [int] NOT NULL
		,[Quarter] [int] NOT NULL
		,[Year] [int] NOT NULL
		,[DayOfWeek] [int] NOT NULL
		,[WeekdayName] [nvarchar](9) NOT NULL
		,CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED ([D_ID] ASC) WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,IGNORE_DUP_KEY = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
		) ON [PRIMARY]

/****** Adding data from start of times until end of times... well not really... just the next 100 years, but that should be enough ******/
DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;

SET @StartDate = ''2020-01-01''
SET @EndDate = DATEADD(YEAR, 100, getdate())

WHILE @StartDate <= @EndDate
BEGIN
	INSERT INTO edw.[DimDate] (
		[D_ID]
		,[Date]
		,[Day]
		,[Month]
		,[MonthName]
		,[Week]
		,[Quarter]
		,[Year]
		,[DayOfWeek]
		,[WeekdayName]
		)
	SELECT CONVERT(CHAR(8), @StartDate, 112) AS D_ID
		,@StartDate AS [Date]
		,DATEPART(day, @StartDate) AS Day
		,DATEPART(month, @StartDate) AS Month
		,DATENAME(month, @StartDate) AS MonthName
		,DATEPART(week, @StartDate) AS Week
		,DATEPART(QUARTER, @StartDate) AS Quarter
		,DATEPART(YEAR, @StartDate) AS Year
		,DATEPART(WEEKDAY, @StartDate) AS DayOfWeek
		,DATENAME(weekday, @startDate) AS WeekdayName

	SET @StartDate = DATEADD(dd, 1, @StartDate)
END
GO

/****** Create Time Table if it does not exist ******/
/****** Object:  Table [edw].[DimTime]    Script Date: 20-05-2022 12:31:10 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[edw].[DimTime]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [edw].[DimTime] (
		[T_ID] [int] identity NOT NULL
		,[Time] [time] NOT NULL
		,CONSTRAINT [PK_DimTime] PRIMARY KEY CLUSTERED ([T_ID] ASC) WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,IGNORE_DUP_KEY = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
		) ON [PRIMARY]
GO

/****** Adding data from start of times until end of times... almost... ******/
-- Total antal timer declares
DECLARE @Size INTEGER

SET @Size = 23

-- Disse tre bruges til initial time values 
DECLARE @hour INTEGER
DECLARE @minute INTEGER
DECLARE @second INTEGER
-- Nedenst�ende bruges ved formateringstilpasning
DECLARE @Time VARCHAR(25)
DECLARE @Hour30 VARCHAR(4)
DECLARE @Minute30 VARCHAR(4)
DECLARE @Second30 VARCHAR(4)

SET @hour = 0
SET @minute = 0
SET @second = 0

WHILE (@hour <= @Size)
BEGIN
	-- 0 tilf�jes foran timer, minutter og sekunder under 10...
	IF (@hour < 10)
	BEGIN
		SET @Hour30 = ''0'' + cast(@hour AS VARCHAR(10))
	END
	ELSE
	BEGIN
		SET @Hour30 = @hour
	END

	WHILE (@minute <= 59)
	BEGIN
		WHILE (@second <= 59)
		BEGIN
			IF @minute < 10
			BEGIN
				SET @Minute30 = ''0'' + cast(@minute AS VARCHAR(10))
			END
			ELSE
			BEGIN
				SET @Minute30 = @minute
			END

			IF @second < 10
			BEGIN
				SET @Second30 = ''0'' + cast(@second AS VARCHAR(10))
			END
			ELSE
			BEGIN
				SET @Second30 = @second
			END

			--Concatenate values for Time30 
			SET @Time = @Hour30 + '':'' + @Minute30 + '':'' + @Second30
	INSERT into edw.[DimTime] ([Time]) 
VALUES (@Time) 
SET @second = @second + 1 
END 
SET @minute = @minute + 1 
SET @second = 0 
END 
SET @hour = @hour + 1 
SET @minute =0 
END 


/****** Create TerrariumToAnimalBridge Table if it does not exist ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[edw].[TerrariumToAnimalBridge]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [edw].[TerrariumToAnimalBridge] (
		[EUI] [varchar](64),
		[EUI_AnimalID] [varchar](64),
		[AnimalID] [int],
		)
GO', 
		@database_name=N'TerraeyesTESTdwh', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [3_MakeEDWFacts]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'3_MakeEDWFacts', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/****** Object:  Table [edw].[FactFiveMinuteSnapshotMeasurement]    Script Date: 20-05-2022 12:31:10 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[edw].[FactFiveMinuteSnapshotMeasurement]'')
			AND type IN (N''U'')
		)
	CREATE TABLE [edw].[FactFiveMinuteSnapshotMeasurement] (
		[T_ID] INT NOT NULL
		,[D_ID] INT NOT NULL
		,[U_ID] INT NOT NULL
		,[TE_ID] INT NOT NULL
		,[Time] [time]
		,[Date] [date]
		,[UserID] [varchar](64)
		,[EUI] [varchar](64)
		,[Temperature] [float]
		,[Humidity] [float]
		,[Lumen] [int]
		,[CarbonDioxid] [float]
		,[Activity] [int]
		,[ServoMoved] [bit]
		,[ServoMovedLabel] [varchar](15)
		,[TemperatureOutOfRangeFlag] [bit]
		,[HumidityOutOfRangeFlag] [bit]
		,[CarbonDioxideOutOfRangeFlag] [bit]
		);
GO

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT PK_FactSale PRIMARY KEY (
T_ID ASC
	,D_ID ASC
	,U_ID ASC
	,TE_ID ASC
	);


ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_1 FOREIGN KEY (D_ID) REFERENCES edw.DimDate (D_ID);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_2 FOREIGN KEY (T_ID) REFERENCES edw.DimTime (T_ID);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_3 FOREIGN KEY (U_ID) REFERENCES edw.DimUser (U_ID);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_4 FOREIGN KEY (TE_ID) REFERENCES edw.DimTerrarium (TE_ID);
', 
		@database_name=N'TerraeyesTESTdwh', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [4_InitialLoadToStage]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'4_InitialLoadToStage', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/****** Load to stage User  ******/
TRUNCATE TABLE [stage].[DimUser]

INSERT INTO [stage].[DimUser] ([UserID])
	SELECT
		[id]
	FROM TestSourceDb.dbo.[user];


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
	FROM TestSourceDb.dbo.[terrarium] te
	

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
	
	FROM TestSourceDb.dbo.animal a
	  JOIN TestSourceDb.dbo.[terrarium] te
		ON a.EUI = te.EUI

/****** Load to stage TerrariumToAnimalBridge  ******/
INSERT INTO [stage].[TerrariumToAnimalBridge]
select et.[EUI], st.[AnimalID]
from [stage].[DimAnimal] st
LEFT join [edw].[DimAnimal] et on st.[AnimalID] = et.[AnimalID]



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
		,IIF(m.[servomoved] = 1, ''Feeding'', ''No feeding'' ) as FeedingLabel
		,IIF(m.[temperature] NOT BETWEEN te.[mintemperature] AND te.[maxtemperature] , 1, 0) as TemperatureFlag
		,IIF(m.[humidity] NOT BETWEEN te.[minhumidity] AND te.[maxhumidity] , 1, 0) as HumidityFlag
		,IIF(m.[carbondioxide] > te.[maxcarbondioxide] , 1, 0) as CarbonFlag
	FROM TestSourceDb.dbo.measurement m
	inner JOIN TestSourceDb.dbo.terrarium te
		ON m.EUI = te.EUI
	 JOIN TestSourceDb.dbo.[user] u
		ON te.userid = u.id

', 
		@database_name=N'TerraeyesTESTdwh', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [5_DataCleansing]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'5_DataCleansing', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/** Tjek stage tabellerne for nulls, n�r de er blevet populated med data fra DB **/
/**		ANIMAL		**/
UPDATE stage.DimAnimal
SET [Name] = ''UNKNOWN''
WHERE [Name] IS NULL

UPDATE stage.DimAnimal
SET Age = - 1 --Sat til -1 fordi 0 jo bare kunne v�re en baby og et h�jt tal kunne v�re en skildpadde
WHERE Age IS NULL

UPDATE stage.DimAnimal
SET Species = ''UNKNOWN''
WHERE Species IS NULL

UPDATE stage.DimAnimal
SET Sex = ''N''
WHERE Sex IS NULL

--De nedenst�ende bliver sat til 0 hvis de er null, under antagelse af at brugeren ikke er interesseret i dem, hvis de ikke er indtastet
UPDATE stage.DimAnimal
SET AnimalID = 0 -- Betyder stadig intet dyr
WHERE AnimalID IS NULL


/***		TERRARIUM		***/
UPDATE stage.DimTerrarium
SET MinTemp = 5 -- https://www.sciencedaily.com/releases/2020/10/201021085119.htm reptiler i Miami kan generelt klare ned til 5 grader
WHERE MinTemp IS NULL

UPDATE stage.DimTerrarium
SET MaxTemp = 40 -- https://www.jabberwockreptiles.com/news/temperature-range-for-reptiles/ der er noget variation, men 40 virker som om det er til den varme side
WHERE MaxTemp IS NULL

UPDATE stage.DimTerrarium
SET MinHum = 10 -- https://www.sensorpush.com/articles/temperature-and-humidity-monitoring-for-pet-reptiles-and-amphibians det kommer virkelig meget an p� dyret
WHERE MinHum IS NULL

UPDATE stage.DimTerrarium
SET MaxHum = 80 -- Igen meget bredt
WHERE MaxHum IS NULL

UPDATE stage.DimTerrarium
SET MaxCarbon = 5000 -- s� f�lger vi OSHA guidelines for vores dyr https://www.fsis.usda.gov/sites/default/files/media_file/2020-08/Carbon-Dioxide.pdf
WHERE MaxCarbon IS NULL

/***		FACT		***/
/* UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET AnimalID = 0 -- Betyder stadig intet dyr
WHERE [AnimalID] IS NULL */

/**
UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [Time] = ''00:00''
WHERE [Time] IS NULL **/

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [Date] = ''9999-01-01''
WHERE [Date] IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [UserID] = ''-1''
WHERE [UserID] IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET EUI = ''UNKOWN TERRARIUM''
WHERE EUI IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET Temperature = - 99.9
WHERE Temperature IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET Humidity = - 1
WHERE Humidity IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET CarbonDioxid = - 1
WHERE CarbonDioxid IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [Activity] = 0
WHERE [Activity] IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [Lumen] = -1
WHERE [Lumen] IS NULL

-- Servo Moved
UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET ServoMoved = 0
WHERE ServoMoved IS NULL
	-- Servo label, vil altid v�re sat fordi den er beregnet i DWH
	-- Temp flag, vil altid v�re sat fordi den er beregnet i DWH
	-- Hum flag, vil altid v�re sat fordi den er beregnet i DWH
	-- Carbon flag, vil altid v�re sat fordi den er beregnet i DWH', 
		@database_name=N'TerraeyesTESTdwh', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [6_LoadIntoEDW]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'6_LoadIntoEDW', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/****** Load to edw User  ******/
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

-- alter fact table -> add AnimalID on edw Fact
ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD [EUI_AnimalID] varchar(64);
GO

-- update fact table
UPDATE [edw].[FactFiveMinuteSnapshotMeasurement]
SET [EUI_AnimalID] = ISNULL(subq.[EUI_AnimalID], ''0'')
FROM [edw].[FactFiveMinuteSnapshotMeasurement] f
 left JOIN (
	SELECT 
	t.[EUI]
		,b.[EUI_AnimalID]
		,b.[AnimalID]
	FROM [edw].[TerrariumToAnimalBridge] b
	RIGHT JOIN [edw].[DimTerrarium] t ON b.[EUI] = t.[EUI]
	) AS subq ON f.[EUI] = subq.[EUI]
	', 
		@database_name=N'TerraeyesTESTdwh', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [7_AddSlowlyChangingDimensions]    Script Date: 28-05-2022 17:21:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'7_AddSlowlyChangingDimensions', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/***	ETL Log Table		**/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N''[etl].[LogUpdate]'')
			AND type IN (N''U'')
		)
CREATE Table etl.[LogUpdate](
	[TableName] nvarchar(50)
	,[LastLoadDate] INT
)


INSERT INTO etl.LogUpdate(TableName, LastLoadDate)
VALUES (''DimAnimal'', 20222505)
,(''DimTerrarium'', 20222505)
, (''DimUser'', 20222505)
, (''DimDate'', 20222505)
, (''DimTime'' ,20222505)
, (''FactFiveMinuteSnapshotMeasurement'' ,20222505)

ALTER table edw.DimTerrarium ADD ValidFrom int, ValidTo int 
ALTER table edw.DimAnimal ADD ValidFrom int, ValidTo int 
GO

/*
ALTER table edw.DimUser add IsValid bit 
GO*/

UPDATE edw.DimTerrarium SET ValidFrom = 20222505, ValidTo = 99990101 
UPDATE edw.DimAnimal SET ValidFrom = 20222505, ValidTo = 99990101 
--UPDATE edw.DimUser SET IsValid = 1', 
		@database_name=N'TerraeyesTESTdwh', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 2
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


