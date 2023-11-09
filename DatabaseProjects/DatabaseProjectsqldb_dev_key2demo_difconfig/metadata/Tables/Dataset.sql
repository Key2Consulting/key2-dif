CREATE TABLE [metadata].[Dataset] (
    [DatasetKey]               SMALLINT      IDENTITY (1, 1) NOT NULL,
    [DatasetClassKey]          SMALLINT      NOT NULL,
    [StorageTypeKey]           SMALLINT      NOT NULL,
    [PartitionTypeKey]         SMALLINT      NOT NULL,
    [RepositoryKey]            SMALLINT      NOT NULL,
    [DatasetNameSpace]         VARCHAR (255) NULL,
    [DatasetName]              VARCHAR (255) NOT NULL,
    [DatasetDescription]       VARCHAR (255) NULL,
    [DatasetPath]              VARCHAR (255) NOT NULL,
    [DatasetInternalVersionID] SMALLINT      NOT NULL,
    [DatasetExternalVersionID] VARCHAR (50)  NULL,
    [DatasetIsLatestVersion]   BIT           NOT NULL,
    [DatasetIsCreated]         BIT           NOT NULL,
    [DatasetIsEnabled]         BIT           NOT NULL,
    [CreatedBy]                VARCHAR (50)  CONSTRAINT [df_Dataset_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]          DATETIME2 (0) CONSTRAINT [df_Dataset_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]               VARCHAR (50)  NULL,
    [ModifiedDateTime]         DATETIME2 (0) NULL,
    [LogicalDatabaseName]      VARCHAR (250) NULL,
    CONSTRAINT [pk_Dataset] PRIMARY KEY CLUSTERED ([DatasetKey] ASC),
    CONSTRAINT [fk_Dataset_DatasetClassKey] FOREIGN KEY ([DatasetClassKey]) REFERENCES [reference].[DatasetClass] ([DatasetClassKey]),
    CONSTRAINT [fk_Dataset_PartitionTypeKey] FOREIGN KEY ([PartitionTypeKey]) REFERENCES [reference].[PartitionType] ([PartitionTypeKey]),
    CONSTRAINT [fk_Dataset_RepositoryKey] FOREIGN KEY ([RepositoryKey]) REFERENCES [metadata].[Repository] ([RepositoryKey]),
    CONSTRAINT [fk_Dataset_StorageTypeKey] FOREIGN KEY ([StorageTypeKey]) REFERENCES [reference].[StorageType] ([StorageTypeKey]),
    CONSTRAINT [uc_Dataset_RepositoryKey_DatasetNameSpace_DatasetName_DatasetInternalVersionID] UNIQUE NONCLUSTERED ([RepositoryKey] ASC, [DatasetNameSpace] ASC, [DatasetName] ASC, [DatasetInternalVersionID] ASC)
);


GO


CREATE TRIGGER [metadata].[DatasetUpdate]
	ON [metadata].[Dataset]
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
		[metadata].[Dataset] a
		INNER JOIN inserted b on
			a.[DatasetKey] = b.[DatasetKey];
END

GO

