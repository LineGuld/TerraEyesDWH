USE [TerraEyesDWH]
GO

/** Tjek stage tabellerne for nulls, når de er blevet populated med data fra DB **/
/**		ANIMAL		**/
UPDATE stage.DimAnimal
SET [Name] = 'UNKNOWN'
WHERE [Name] IS NULL

UPDATE stage.DimAnimal
SET Age = - 1 --Sat til -1 fordi 0 jo bare kunne være en baby og et højt tal kunne være en skildpadde
WHERE Age IS NULL

UPDATE stage.DimAnimal
SET Species = 'UNKNOWN'
WHERE Species IS NULL

UPDATE stage.DimAnimal
SET Sex = 'N'
WHERE Sex IS NULL

--De nedenstående bliver sat til 0 hvis de er null, under antagelse af at brugeren ikke er interesseret i dem, hvis de ikke er indtastet
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
SET MinHum = 10 -- https://www.sensorpush.com/articles/temperature-and-humidity-monitoring-for-pet-reptiles-and-amphibians det kommer virkelig meget an på dyret
WHERE MinHum IS NULL

UPDATE stage.DimTerrarium
SET MaxHum = 80 -- Igen meget bredt
WHERE MaxHum IS NULL

UPDATE stage.DimTerrarium
SET MaxCarbon = 5000 -- så følger vi OSHA guidelines for vores dyr https://www.fsis.usda.gov/sites/default/files/media_file/2020-08/Carbon-Dioxide.pdf
WHERE MaxCarbon IS NULL

/***		FACT		***/
/* UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET AnimalID = 0 -- Betyder stadig intet dyr
WHERE [AnimalID] IS NULL */


UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [Time] = Cast([Time] as time(0))
WHERE [Time] is not null

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
SET [Lumen] = -1
WHERE [Lumen] IS NULL

-- Servo Moved
UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET ServoMoved = 0
WHERE ServoMoved IS NULL
	-- Servo label, vil altid være sat fordi den er beregnet i DWH
	-- Temp flag, vil altid være sat fordi den er beregnet i DWH
	-- Hum flag, vil altid være sat fordi den er beregnet i DWH
	-- Carbon flag, vil altid være sat fordi den er beregnet i DWH
