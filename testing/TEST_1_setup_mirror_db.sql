USE [master]
GO

/****** Object:  Database [TestSourceDB]    Script Date: 27-05-2022 12:34:22 ******/
DROP DATABASE [TestSourceDB]
GO

/****** Object:  Database [TestSourceDB]    Script Date: 27-05-2022 12:34:22 ******/
CREATE DATABASE [TestSourceDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestSourceDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\TestSourceDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TestSourceDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\TestSourceDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TestSourceDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [TestSourceDB] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [TestSourceDB] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [TestSourceDB] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [TestSourceDB] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [TestSourceDB] SET ARITHABORT OFF 
GO

ALTER DATABASE [TestSourceDB] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [TestSourceDB] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [TestSourceDB] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [TestSourceDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [TestSourceDB] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [TestSourceDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [TestSourceDB] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [TestSourceDB] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [TestSourceDB] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [TestSourceDB] SET  DISABLE_BROKER 
GO

ALTER DATABASE [TestSourceDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [TestSourceDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [TestSourceDB] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [TestSourceDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [TestSourceDB] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [TestSourceDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [TestSourceDB] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [TestSourceDB] SET RECOVERY FULL 
GO

ALTER DATABASE [TestSourceDB] SET  MULTI_USER 
GO

ALTER DATABASE [TestSourceDB] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [TestSourceDB] SET DB_CHAINING OFF 
GO

ALTER DATABASE [TestSourceDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [TestSourceDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [TestSourceDB] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [TestSourceDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [TestSourceDB] SET QUERY_STORE = OFF
GO

ALTER DATABASE [TestSourceDB] SET  READ_WRITE 
GO

USE TestSourceDB
Go

CREATE TABLE [User] (
    [id] [VARCHAR](64) PRIMARY KEY
);

CREATE TABLE Terrarium (
    [eui] VARCHAR(64) PRIMARY KEY,
    [userId] VARCHAR(64) NOT NULL,
    [minTemperature] DECIMAL(3, 1),
    [maxTemperature] DECIMAL(3, 1),
    [minHumidity] DECIMAL(3, 1),
    [maxHumidity] DECIMAL(3, 1),
    [maxCarbonDioxide] int,
);

CREATE TABLE Measurement (
    [id] INT IDENTITY,
    [eui] VARCHAR(64) NOT NULL,
    [timestamp] TIMESTAMP,
    [temperature] DECIMAL(3, 1),
    [humidity] DECIMAL(3, 1),
    [carbonDioxide] int,
    [servoMoved] bit NOT NULL,
    [activity] int,
    [lumen] int,
);

CREATE TABLE Animal (
    [id] INT IDENTITY,
    [eui] VARCHAR(64),
    [name] VARCHAR(64),
    [age] int,
    [species] VARCHAR(128),
    [sex] CHAR,
    [isShedding] bit NOT NULL,
    [isHibernating] bit NOT NULL,
    [hasOffspring] bit NOT NULL,
);


USE [TestSourceDB]
GO

-- MEASUREMENTS FØRST
SET IDENTITY_INSERT dbo.Measurement ON
INSERT INTO [dbo].[Measurement]
           ([id]
		   ,[eui]
           ,[temperature]
           ,[humidity]
           ,[carbonDioxide]
           ,[servoMoved]
           ,[activity]
           ,[lumen])
     SELECT
	 [id]
           ,[eui]
           ,[temperature]
           ,[humidity]
           ,[carbonDioxide]
           ,[servoMoved]
           ,[activity]
           ,[lumen]
FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.measurement')
WHERE id%10 = 3
SET IDENTITY_INSERT dbo.Measurement OFF
GO


INSERT INTO [dbo].[Terrarium]
           ([eui]
           ,[userId]
           ,[minTemperature]
           ,[maxTemperature]
           ,[minHumidity]
           ,[maxHumidity]
           ,[maxCarbonDioxide])
		   SELECT
		   [eui]
           ,[userId]
           ,[minTemperature]
           ,[maxTemperature]
           ,[minHumidity]
           ,[maxHumidity]
           ,[maxCarbonDioxide]
     FROM [POSTGRESTE].[terraeyes].[terraeyes].[terrarium]
	 WHERE [eui] in (
		SELECT DISTINCT eui
		FROM dbo.Measurement
	 )
GO

INSERT INTO [dbo].[User]
           ([id])
    SELECT
	[id]
	FROM [POSTGRESTE].[terraeyes].[terraeyes].[user]
	WHERE id IN (
	SELECT DISTINCT userId
	FROM Terrarium
	)
GO


SET IDENTITY_INSERT dbo.Animal ON
INSERT INTO [dbo].[Animal]
           ([id]
           ,[eui]
           ,[name]
           ,[age]
           ,[species]
           ,[sex]
           ,[isShedding]
           ,[isHibernating]
           ,[hasOffspring])
     SELECT
        [id]
           ,[eui]
           ,[name]
           ,[age]
           ,[species]
           ,[sex]
           ,[isShedding]
           ,[isHibernating]
           ,[hasOffspring]
		FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.animal')
		WHERE eui IN (
	SELECT DISTINCT eui
	FROM Measurement
	)
SET IDENTITY_INSERT dbo.Animal OFF
GO

