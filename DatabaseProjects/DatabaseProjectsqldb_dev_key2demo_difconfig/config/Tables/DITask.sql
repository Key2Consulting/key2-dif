CREATE TABLE [config].[DITask] (
    [DITaskKey]                  INT            IDENTITY (1, 1) NOT NULL,
    [SourceDatasetKey]           SMALLINT       NOT NULL,
    [DestinationDatasetKey]      SMALLINT       NOT NULL,
    [LoadTypeKey]                SMALLINT       NOT NULL,
    [DITaskSourceFilterLogic]    VARCHAR (255)  NULL,
    [DITaskWaterMarkLogic]       VARCHAR (255)  NULL,
    [DITaskMaxWaterMark]         VARCHAR (255)  NULL,
    [DITaskLastExtractDateTime]  DATETIME2 (0)  NULL,
    [DITaskIsEnabled]            BIT            NOT NULL,
    [CreatedBy]                  VARCHAR (50)   CONSTRAINT [df_DITask_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]            DATETIME2 (0)  CONSTRAINT [df_DITask_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]                 VARCHAR (50)   NULL,
    [ModifiedDateTime]           DATETIME2 (0)  NULL,
    [SourceFilterLogicIsEnabled] BIT            CONSTRAINT [df_DITask_SourceFilterLogicIsEnabled] DEFAULT ((0)) NOT NULL,
    [SourceOverrideQuery]        VARCHAR (MAX)  NULL,
    [SourceAuditQuery]           VARCHAR (2000) NULL,
    [NotebookPath]               VARCHAR (255)  NULL,
    CONSTRAINT [pk_DITask] PRIMARY KEY CLUSTERED ([DITaskKey] ASC),
    CONSTRAINT [fk_DITask_DestinationDatasetKey] FOREIGN KEY ([DestinationDatasetKey]) REFERENCES [metadata].[Dataset] ([DatasetKey]),
    CONSTRAINT [fk_DITask_LoadTypeKey] FOREIGN KEY ([LoadTypeKey]) REFERENCES [reference].[LoadType] ([LoadTypeKey]),
    CONSTRAINT [fk_DITask_SourceDatasetKey] FOREIGN KEY ([SourceDatasetKey]) REFERENCES [metadata].[Dataset] ([DatasetKey])
);


GO


CREATE TRIGGER [config].[DITaskUpdate]
	ON [config].[DITask]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE
		a
	SET
		[ModifiedBy] = SYSTEM_USER,
		[ModifiedDateTime] = GETUTCDATE()
	FROM
		[config].[DITask] a
		INNER JOIN inserted b on
			a.[DITaskKey] = b.[DITaskKey];
END

GO

