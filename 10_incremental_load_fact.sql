USE TerraEyesDWH
GO

DECLARE @LastLoadDate INT
DECLARE @NewLoadDate INT
DECLARE @FutureDate INT

SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
SET @FutureDate = 99990101

SET @LastLoadDate = (SELECT
		MAX([LastLoadDate])
	FROM [etl].[LogUpdate]
	WHERE [TableName] = 'FactFiveMinuteSnapshotMeasurement')

	-- Staging newly arrived facts 
	TRUNCATE TABLE stage.FactFiveMinuteSnapshotMeasurement

INSERT INTO stage.FactFiveMinuteSnapshotMeasurement (
 [Date]
, [Time]
, UserID
, EUI
, Temperature
, Humidity
, Lumen
, CarbonDioxid
, Activity
, ServoMoved
, ServoMovedLabel
, TemperatureOutOfRangeFlag
, HumidityOutOfRangeFlag
, CarbonDioxideOutOfRangeFlag)
	SELECT
		a.[id]
	   ,CAST(m.[timestamp] AS DATE) AS [date]
	   ,CAST(m.[timestamp] AS TIME) AS [time]
	   ,u.[id]
	   ,te.[EUI]
	   ,m.[temperature]
	   ,m.[humidity]
	   ,m.[Lumen]
	   ,m.[carbondioxide]
	   ,m.[activity]
	   ,m.[servomoved]
	   ,IIF(m.[servomoved] = 1, 'Feeding', 'No feeding') AS FeedingLabel
	   ,IIF(m.[temperature] NOT BETWEEN te.[mintemperature] AND te.[maxtemperature], 1, 0) AS TemperatureFlag
	   ,IIF(m.[humidity] NOT BETWEEN te.[minhumidity] AND te.[maxhumidity], 1, 0) AS HumidityFlag
	   ,IIF(m.[carbondioxide] > te.[maxcarbondioxide], 1, 0) AS CarbonFlag
	FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.measurement') m
	INNER JOIN OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.terrarium') te
		ON m.EUI = te.EUI
	FULL JOIN OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.animal') a
		ON te.EUI = a.EUI
	INNER JOIN [POSTGRESTE].[terraeyes].[terraeyes].[User] u
		ON te.userid = u.id

		-- Fact cleansing
UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [Date] = '9999-01-01'
WHERE [Date] IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [UserID] = '-1'
WHERE [UserID] IS NULL

UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET EUI = 'UNKOWN TERRARIUM'
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
SET ServoMoved = 0
WHERE ServoMoved IS NULL

-- OG så det nye ind i edw
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
SELECT
	t.[T_ID]
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
 JOIN [edw].[DimTime] AS t ON f.[Time] = t.[Time]
 JOIN [edw].[DimDate] AS d ON f.[Date] = d.[Date]
 JOIN [edw].[DimUser] AS u ON f.[UserID] = u.[UserID]
 JOIN [edw].[DimTerrarium] AS te ON f.[EUI] = te.[EUI]
 AND u.IsValid = 1
 AND te.ValidTo = @FutureDate