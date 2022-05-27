USE TerraEyesDWH
GO

DECLARE @LastLoadDate INT
DECLARE @NewLoadDate INT
DECLARE @FutureDate INT

SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
SET @FutureDate = 99990101
/****		USER		****/
SET @LastLoadDate = (SELECT
		MAX([LastLoadDate])
	FROM [etl].[LogUpdate]
	WHERE [TableName] = 'DimUser')

/**		Nye Users	**/
INSERT INTO [edw].[DimUser] (UserID
, IsValid)
	SELECT
		[UserID]
	   ,1
	FROM [stage].[DimUser]
	WHERE UserID IN (SELECT
			UserID
		FROM [stage].[DimUser]

		EXCEPT

		SELECT
			UserID
		FROM [edw].[DimUser])

/**		Slettede Users		**/
UPDATE [edw].[DimUser]
SET IsValid = 0 --Hvis brugeren er i EDW men ikke i stage, er den blevet slettet og valid sættes til 0
WHERE UserID IN (SELECT
		UserID
	FROM edw.DimUser

	EXCEPT

	SELECT
		UserID
	FROM stage.DimUser)
AND IsValid = 1

/**		Late arriving users		**/
UPDATE [edw].[FactFiveMinuteSnapshotMeasurement]
-- UserID sættes der, hvor DimUser er late arriving
SET UserID = (
	-- De lækre friske users bliver snupser vi
	SELECT
		sf.UserID
	FROM [stage].[FactFiveMinuteSnapshotMeasurement] sf
	-- Vi joiner de nye stage eui'er (som har sf.userID) til gamle facts i edw, som ikke har sf.userID
	JOIN edw.FactFiveMinuteSnapshotMeasurement ef
		ON ef.EUI = sf.EUI
	-- Alle nye users, hvor id'et ikke er -1 
	WHERE sf.UserID IN (SELECT
			UserID
		FROM [stage].[DimUser]
		WHERE UserID != '-1'

		EXCEPT

		SELECT
			UserID
		FROM [edw].[DimUser]))
WHERE UserID = '-1' --Men sæt den kun hvis bruger-ID i EDW er det vi har brugt til late arriving users

/**			TERRARIUM		**/
SET @LastLoadDate = (SELECT
		MAX([LastLoadDate])
	FROM [etl].[LogUpdate]
	WHERE [TableName] = 'DimTerrarium')

/** De nye terrarier **/
INSERT INTO edw.DimTerrarium (EUI
, MinTemp
, MaxTemp
, MinHum
, MaxHum
, MaxCarbon
, ValidFrom
, ValidTo)
	SELECT
		EUI
	   ,MinTemp
	   ,MaxTemp
	   ,MinHum
	   ,MaxHum
	   ,MaxCarbon
	   ,@NewLoadDate
	   ,@FutureDate
	FROM stage.DimTerrarium
	WHERE EUI IN (SELECT
			EUI
		FROM stage.DimTerrarium

		EXCEPT

		SELECT
			EUI
		FROM edw.DimTerrarium
		WHERE ValidTo = @FutureDate)

/**		De terrarier folk sletter!		**/
UPDATE edw.DimTerrarium
SET ValidTo = @NewLoadDate - 1
WHERE EUI IN (SELECT
		EUI
	FROM edw.DimTerrarium
	WHERE EUI IN (
		SELECT EUI
		FROM [edw].DimTerrarium

		EXCEPT

		SELECT EUI
		FROM [stage].DimTerrarium)
		)
AND ValidTo = @FutureDate
INSERT INTO etl.LogUpdate(
	TableName
	,LastLoadDate
)
VALUES(
'DimTerrarium'
,@NewLoadDate
)


/**			ANIMAL		**/

SET @LastLoadDate = (SELECT
		MAX([LastLoadDate])
	FROM [etl].[LogUpdate]
	WHERE [TableName] = 'DimAnimal')

/** Nye Dyr **/
INSERT INTO [edw].[DimAnimal] ([AnimalID]
, [EUI]
, [Name]
, [Age]
, [Species]
, [Sex]
, [IsShedding]
, [IsHibernating]
, [HasOffspring]
, [ValidFrom]
, [ValidTo])
	SELECT
		[AnimalID]
	   ,[EUI]
	   ,[Name]
	   ,[Age]
	   ,[Species]
	   ,[Sex]
	   ,[IsShedding]
	   ,[IsHibernating]
	   ,[HasOffspring]
	   ,@NewLoadDate
	   ,@FutureDate
	FROM [stage].[DimAnimal]
	WHERE [AnimalID] IN (SELECT
			[AnimalID]
		FROM [stage].[DimAnimal]

		EXCEPT

		SELECT
			[AnimalID]
		FROM [edw].[DimAnimal])

/**			Dyr med ændringer!		**/
SELECT
	[AnimalID]
   ,[EUI]
   ,[Name]
   ,[Age]
   ,[Species]
   ,[Sex]
   ,[IsShedding]
   ,[IsHibernating]
   ,[HasOffspring] INTO #temp
FROM [stage].[DimAnimal]

EXCEPT

SELECT --Undtagen det som allerede er i EDW
	[AnimalID]
   ,[EUI]
   ,[Name]
   ,[Age]
   ,[Species]
   ,[Sex]
   ,[IsShedding]
   ,[IsHibernating]
   ,[HasOffspring]
FROM [edw].[DimAnimal]
WHERE ValidTo = @FutureDate

EXCEPT --Undtagen de nye som lige er blevet sat ind

SELECT
	[AnimalID]
   ,[EUI]
   ,[Name]
   ,[Age]
   ,[Species]
   ,[Sex]
   ,[IsShedding]
   ,[IsHibernating]
   ,[HasOffspring]
FROM [stage].[DimAnimal]
WHERE AnimalID IN (SELECT
		AnimalID
	FROM stage.DimAnimal

	EXCEPT

	SELECT
		AnimalID
	FROM edw.DimAnimal
	WHERE ValidTo = @FutureDate)


INSERT INTO edw.DimAnimal ([AnimalID]
, [EUI]
, [Name]
, [Age]
, [Species]
, [Sex]
, [IsShedding]
, [IsHibernating]
, [HasOffspring]
, [ValidFrom]
, [ValidTo])
	SELECT
		[AnimalID]
	   ,[EUI]
	   ,[Name]
	   ,[Age]
	   ,[Species]
	   ,[Sex]
	   ,[IsShedding]
	   ,[IsHibernating]
	   ,[HasOffspring]
	   ,@NewLoadDate
	   ,@FutureDate
	FROM #temp

UPDATE edw.DimAnimal
SET ValidTo = @NewLoadDate - 1
WHERE AnimalID IN (SELECT
		AnimalID
	FROM #temp)
AND edw.DimAnimal.ValidFrom < @NewLoadDate

DROP TABLE IF EXISTS #temp

/**		Dem der er blevet slettet		**/
UPDATE edw.DimAnimal
SET ValidTo = @NewLoadDate - 1
WHERE AnimalID IN (SELECT
		AnimalID
	FROM edw.DimAnimal
	WHERE AnimalID IN (
		SELECT AnimalID
		FROM [edw].DimAnimal

		EXCEPT

		SELECT AnimalID
		FROM [stage].DimAnimal)
		)
AND ValidTo = @FutureDate

INSERT INTO etl.LogUpdate(
	TableName
	,LastLoadDate
)
VALUES(
'DimAnimal'
,@NewLoadDate
)