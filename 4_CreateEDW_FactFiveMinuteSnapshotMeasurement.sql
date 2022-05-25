USE TerraEyesDWH;

/****** Object:  Table [edw].[FactFiveMinuteSnapshotMeasurement]    Script Date: 20-05-2022 12:31:10 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[edw].[FactFiveMinuteSnapshotMeasurement]')
			AND type IN (N'U')
		)
	CREATE TABLE [edw].[FactFiveMinuteSnapshotMeasurement] (
		[A_ID] INT NOT NULL
		,[T_ID] INT NOT NULL
		,[D_ID] INT NOT NULL
		,[U_ID] INT NOT NULL
		,[TE_ID] INT NOT NULL
		,[AnimalID] [int]
		,[Time] [time]
		,[Date] [date]
		,[UserID] [varchar](64)
		,[EUI] [varchar](64)
		,[Temperature] [float]
		,[Humidity] [float]
		,[Lumen] [int]
		,[CarbonDioxid] [float]
		,[Activity] [int]
		,[ServoMoved] [bit]
		,[ServoMovedLabel] [varchar](15)
		,[TemperatureOutOfRangeFlag] [bit]
		,[HumidityOutOfRangeFlag] [bit]
		,[CarbonDioxideOutOfRangeFlag] [bit]
		);
GO

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT PK_FactSale PRIMARY KEY (
	A_ID ASC
	,T_ID ASC
	,D_ID ASC
	,U_ID ASC
	,TE_ID ASC
	);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_0 FOREIGN KEY (A_ID) REFERENCES edw.DimAnimal (A_ID);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_1 FOREIGN KEY (D_ID) REFERENCES edw.DimDate (D_ID);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_2 FOREIGN KEY (T_ID) REFERENCES edw.DimTime (T_ID);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_3 FOREIGN KEY (U_ID) REFERENCES edw.DimUser (U_ID);

ALTER TABLE [edw].[FactFiveMinuteSnapshotMeasurement] ADD CONSTRAINT FK_FactSale_4 FOREIGN KEY (TE_ID) REFERENCES edw.DimTerrarium (TE_ID);

