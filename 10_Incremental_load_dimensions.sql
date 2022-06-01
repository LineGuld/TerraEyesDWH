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

/** Update logtable**/
INSERT INTO etl.LogUpdate(
	TableName
	,LastLoadDate
)
VALUES(
'DimUser'
,@NewLoadDate
)

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
		FROM edw.DimTerrarium)

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

/** Terrarier der er opdateret **/
UPDATE edw.DimTerrarium
SET ValidTo = @NewLoadDate - 1
WHERE EUI IN (SELECT
		EUI
	FROM edw.DimTerrarium dt
	WHERE EUI NOT IN(
		SELECT EUI
		FROM stage.DimTerrarium st
		WHERE st.MinTemp = dt.MinTemp
		and st.MaxTemp = dt.MaxTemp
		and st.MinHum = dt.MinHum
		and st.MaxHum = dt.MaxHum
		and st.MaxCarbon = dt.MaxCarbon
		and st.EUI = dt.EUI))

Insert into edw.DimTerrarium
		(EUI,
		MinTemp,
		MaxTemp,
		MinHum,
		MaxHum,
		MaxCarbon,
		ValidFrom,
		ValidTo)
	Select
		EUI,
		MinTemp,
		MaxTemp,
		MinHum,
		MaxHum,
		MaxCarbon,
		@NewLoadDate,
		@FutureDate
	From stage.DimTerrarium
	Where EUI in (SELECT
		EUI
	FROM edw.DimTerrarium dt
	WHERE EUI NOT IN(
		SELECT EUI
		FROM stage.DimTerrarium st
		WHERE st.MinTemp = dt.MinTemp
		and st.MaxTemp = dt.MaxTemp
		and st.MinHum = dt.MinHum
		and st.MaxHum = dt.MaxHum
		and st.MaxCarbon = dt.MaxCarbon
		and st.EUI = dt.EUI))

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
, [Sex])
	SELECT
		[AnimalID]
	   ,[EUI]
	   ,[Name]
	   ,[Age]
	   ,[Species]
	   ,[Sex]
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
    INTO #temp
FROM [stage].[DimAnimal]

EXCEPT

SELECT --Undtagen det som allerede er i EDW
	[AnimalID]
   ,[EUI]
   ,[Name]
   ,[Age]
   ,[Species]
   ,[Sex]

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

, [ValidFrom]
, [ValidTo])
	SELECT
		[AnimalID]
	   ,[EUI]
	   ,[Name]
	   ,[Age]
	   ,[Species]
	   ,[Sex]

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

/**  Bridge nye dyr **/
With CTE AS (
	Select CONCAT (EUI, AnimalID) AS eaid
	From stage.TerrariumToAnimalBridge)
Insert into edw.TerrariumToAnimalBridge (
	EUI,
	EUI_AnimalID,
	AnimalID,
	ValidFrom,
	ValidTo)
Select EUI,
	eaid,
	AnimalID,
	@NewLoadDate,
	@FutureDate
From stage.TerrariumToAnimalBridge, CTE
Where eaid not in (
	Select EUI_AnimalID
	From edw.TerrariumToAnimalBridge);


/** Bridge ændringer **/
Update edw.TerrariumToAnimalBridge
Set ValidTo = @NewLoadDate - 1
Where EUI in (
	Select EUI
	From edw.TerrariumToAnimalBridge eb
	Where EUI not in (
		Select EUI
		From stage.TerrariumToAnimalBridge sb
		Where eb.EUI = sb.EUI
			and eb.AnimalID = sb.AnimalID))

Insert into edw.TerrariumToAnimalBridge
		(EUI,
		EUI_AnimalID,
		AnimalID,
		ValidFrom,
		ValidTo)
Select EUI,
	CONCAT (EUI, AnimalID),
	AnimalID,
	@NewLoadDate,
	@FutureDate
From stage.TerrariumToAnimalBridge
Where AnimalID in (
	Select AnimalID
	From edw.TerrariumToAnimalBridge eb
	Where AnimalID not in (
		Select AnimalID
		From stage.TerrariumToAnimalBridge sb
		Where eb.EUI = sb.EUI
			and eb.AnimalID = sb.AnimalID))

/** Bridge slettet **/
Update edw.TerrariumToAnimalBridge
Set ValidTo = @NewLoadDate - 1
Where AnimalID in (
	Select AnimalID
	From edw.TerrariumToAnimalBridge eb
	Where AnimalID not in (
		Select AnimalID
		From stage.TerrariumToAnimalBridge sb
		Where sb.AnimalID = eb.AnimalID
			and sb.EUI = eb.EUI))