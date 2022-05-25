USE TerraEyesDWH
GO


DECLARE @LastLoadDate INT
DECLARE @NewLoadDate INT
DECLARE @FutureDate INT

SET @NewLoadDate = convert(CHAR(8), getdate(), 112)

SET @FutureDate = 99990101


/****		USER		****/
SET @LastLoadDate = (
		SELECT max([LastLoadDate])
		FROM [etl].[LogUpdate]
		WHERE [Table] = 'DimUser'
		)

/**		Nye Users	**/
INSERT INTO [edw].DimUser (
	UserID
	,
	)
SELECT [UserID]
FROM [stage].[DimUser]
WHERE UserID IN (
		SELECT UserID
		FROM [stage].[DimUser]
		
		EXCEPT
		
		SELECT UserID
		FROM [edw].[DimUser]
		)
