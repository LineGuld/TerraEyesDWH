use[TerraEyesDWH]
go

/** Tjek stage tabellerne for nulls, når de er blevet populated med data fra DB **/
/**		ANIMAL		**/
UPDATE stage.DimAnimal
SET [Name] = 'UNKNOWN'
WHERE [Name] is NULL

UPDATE stage.DimAnimal
SET Age = -1 --Sat til -1 fordi 0 jo bare kunne være en baby og et højt tal kunne være en skildpadde
WHERE Age is NULL

UPDATE stage.DimAnimal
SET Species = 'UNKNOWN'
WHERE Species is NULL

UPDATE stage.DimAnimal
SET Sex = 'N'
WHERE Sex is NULL

--De nedenstående bliver sat til 0 hvis de er null, under antagelse af at brugeren ikke er interesseret i dem, hvis de ikke er indtastet
UPDATE stage.DimAnimal
SET IsShedding = 0
WHERE IsShedding is NULL

UPDATE stage.DimAnimal
SET IsHibernating = 0
WHERE IsHibernating is NULL

UPDATE stage.DimAnimal
SET HasOffspring = 0
WHERE HasOffspring is NULL

/***		TERRARIUM		***/
UPDATE stage.DimTerrarium
SET MinTemp = 5 -- https://www.sciencedaily.com/releases/2020/10/201021085119.htm reptiler i Miami kan generelt klare ned til 5 grader
WHERE MinTemp is NULL

UPDATE stage.DimTerrarium
SET MaxTemp = 40 -- https://www.jabberwockreptiles.com/news/temperature-range-for-reptiles/ der er noget variation, men 40 virker som om det er til den varme side
WHERE MinTemp is NULL

UPDATE stage.DimTerrarium
SET MinHum = 10 -- https://www.sensorpush.com/articles/temperature-and-humidity-monitoring-for-pet-reptiles-and-amphibians det kommer virkelig meget an på dyret
WHERE MinHum is NULL

UPDATE stage.DimTerrarium
SET MaxHum = 80 -- Igen meget bredt
WHERE MaxHum is NULL

UPDATE stage.DimTerrarium
SET MaxCarbon = 5000 -- så følger vi OSHA guidelines for vores dyr https://www.fsis.usda.gov/sites/default/files/media_file/2020-08/Carbon-Dioxide.pdf
WHERE MaxCarbon is null


/***		FACT		***/
UPDATE stage.FactFiveMinuteSnapshotMeasurement
SET [AnimalID] = 0
WHERE [AnimalID] is null
