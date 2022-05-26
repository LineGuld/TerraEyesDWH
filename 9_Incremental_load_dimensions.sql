USE TerraEyesDWH
GO

DECLARE @LastLoadDate INT
DECLARE @NewLoadDate INT
DECLARE @FutureDate INT

SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
SET @FutureDate = 99990101
/****		USER		****/
SET @LastLoadDate = (
		SELECT MAX([LastLoadDate])
		FROM [etl].[LogUpdate]
		WHERE [TableName] = 'DimUser'
		)

/**		Nye Users	**/
INSERT INTO [edw].[DimUser] (
	UserID
	,IsValid
	)
SELECT [UserID]
	,1
FROM [stage].[DimUser]
WHERE UserID IN (
		SELECT UserID
		FROM [stage].[DimUser]
		
		EXCEPT
		
		SELECT UserID
		FROM [edw].[DimUser]
		)

/**		Slettede Users		**/
UPDATE [edw].[DimUser]
SET IsValid = 0 --Hvis brugeren er i EDW men ikke i stage, er den blevet slettet og valid s�ttes til 0
WHERE UserID IN (
		SELECT UserID
		FROM edw.DimUser
		
		EXCEPT
		
		SELECT UserID
		FROM stage.DimUser
		)
	AND IsValid = 1

/**		Late arriving users		**/
UPDATE [edw].[FactFiveMinuteSnapshotMeasurement]
-- UserID s�ttes der, hvor DimUser er late arriving
SET UserID = ( 
-- De l�kre friske users bliver snupser vi
		SELECT sf.UserID 
		FROM [stage].[FactFiveMinuteSnapshotMeasurement] sf 
		-- Vi joiner de nye stage eui'er (som har sf.userID) til gamle facts i edw, som ikke har sf.userID
		JOIN edw.FactFiveMinuteSnapshotMeasurement ef ON ef.EUI = sf.EUI
		-- Alle nye users, hvor id'et ikke er -1 
		WHERE sf.UserID IN (
				SELECT UserID
				FROM [stage].[DimUser]
				Where UserID != '-1'

				EXCEPT
				
				SELECT UserID
				FROM [edw].[DimUser]
				)
		) WHERE UserID = '-1' --Men s�t den kun hvis bruger-ID i EDW er det vi har brugt til late arriving users

/**			TERRARIUM		**/
SET @LastLoadDate = (
		SELECT MAX([LastLoadDate])
		FROM [etl].[LogUpdate]
		WHERE [TableName] = 'DimTerrarium'
		)

/** De nye terrarier **/
INSERT INTO edw.DimTerrarium (
	EUI
	,MinTemp
	,MaxTemp
	,MinHum
	,MaxHum
	,MaxCarbon
	,ValidFrom
	,ValidTo
	)
SELECT EUI
	,MinTemp
	,MaxTemp
	,MinHum
	,MaxHum
	,MaxCarbon
	,@NewLoadDate
	,@FutureDate
FROM stage.DimTerrarium
WHERE EUI IN (
		SELECT EUI
		FROM stage.DimTerrarium
		
		EXCEPT
		
		SELECT EUI
		FROM edw.DimTerrarium
		WHERE ValidTo = @FutureDate
		)

