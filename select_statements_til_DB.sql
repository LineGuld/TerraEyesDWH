SELECT *
FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.measurement')

SELECT *
FROM [POSTGRESTE].[terraeyes].[terraeyes].[user];

select *
from OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes."user"')

SELECT *
FROM [POSTGRESTE].[terraeyes].[terraeyes].[terrarium];


SELECT *
FROM OPENQUERY(POSTGRESTE, 'SELECT * FROM terraeyes.animal')



--CONVERT(VARCHAR(10), CAST('22/06/2022 13:15' AS TIME ), 0)

--22/06/2022 13:15