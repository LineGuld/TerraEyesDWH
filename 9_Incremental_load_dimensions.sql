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
INSERT INTO [edw].DimUser (UserID
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
UPDATE edw.DimUser
SET IsValid = 0 --Hvis brugeren er i EDW men ikke i stage, er den blevet slettet og valid s�ttes til 0
WHERE UserID IN(
	SELECT UserID
	from edw.DimUser

	EXCEPT

	SELECT  UserID
	From stage.DimUser
)


-- Der skulle ikke s� gerne ske �ndringer i users, eftersom det kun der deres ID fra firebase og en indikator p� om det er en g�ldende user