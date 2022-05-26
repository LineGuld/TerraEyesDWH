
USE [TerraEyesDWH]
GO

/****** Create User Table if it does not exist ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[edw].[DimUser]')
			AND type IN (N'U')
		)
	CREATE TABLE [edw].[DimUser] (
		[U_ID] [int] identity NOT NULL
		,[UserID] [varchar](64)
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
		WHERE object_id = OBJECT_ID(N'[edw].[DimTerrarium]')
			AND type IN (N'U')
		)
	CREATE TABLE [edw].[DimTerrarium] (
		[TE_ID] [int] identity NOT NULL
		,[EUI] [varchar](64) NOT NULL
		,[MinTemp] [decimal](3, 1)
		,[MaxTemp] [decimal](3, 1)
		,[MinHum] [decimal](3, 1)
		,[MaxHum] [decimal](3, 1)
		,[MaxCarbon] [int]
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
		WHERE object_id = OBJECT_ID(N'[edw].[DimAnimal]')
			AND type IN (N'U')
		)
	CREATE TABLE [edw].[DimAnimal] (
		[A_ID] [int] identity NOT NULL
		,[AnimalID] [int]
		,[EUI] [varchar](64)
		,[Name] [varchar](64)
		,[Age] [int]
		,[Species] [varchar](128)
		--,[Morph] [varchar](40)
		,[Sex] [char]
		,[IsShedding] [bit] NOT NULL
		,[IsHibernating] [bit] NOT NULL
		,[HasOffspring] [bit] NOT NULL
		,[ClimateZone] [varchar](64)
		,[ValidFrom] [int]
		,[ValidTo] [int]
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
		WHERE object_id = OBJECT_ID(N'[edw].[DimDate]')
			AND type IN (N'U')
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

SET @StartDate = '2020-01-01'
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
		WHERE object_id = OBJECT_ID(N'[edw].[DimTime]')
			AND type IN (N'U')
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
-- Nedenstående bruges ved formateringstilpasning
DECLARE @Time VARCHAR(25)
DECLARE @Hour30 VARCHAR(4)
DECLARE @Minute30 VARCHAR(4)
DECLARE @Second30 VARCHAR(4)

SET @hour = 0
SET @minute = 0
SET @second = 0

WHILE (@hour <= @Size)
BEGIN
	-- 0 tilføjes foran timer, minutter og sekunder under 10...
	IF (@hour < 10)
	BEGIN
		SET @Hour30 = '0' + cast(@hour AS VARCHAR(10))
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
				SET @Minute30 = '0' + cast(@minute AS VARCHAR(10))
			END
			ELSE
			BEGIN
				SET @Minute30 = @minute
			END

			IF @second < 10
			BEGIN
				SET @Second30 = '0' + cast(@second AS VARCHAR(10))
			END
			ELSE
			BEGIN
				SET @Second30 = @second
			END

			--Concatenate values for Time30 
			SET @Time = @Hour30 + ':' + @Minute30 + ':' + @Second30
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