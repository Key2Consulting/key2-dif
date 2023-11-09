CREATE TABLE [reference].[StorageType] (
    [StorageTypeKey]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [StorageType]      VARCHAR (50)  NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_StorageType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_StorageType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_StorageType] PRIMARY KEY CLUSTERED ([StorageTypeKey] ASC),
    CONSTRAINT [uc_StorageType_StorageType] UNIQUE NONCLUSTERED ([StorageType] ASC)
);


GO


CREATE TRIGGER [reference].[StorageTypeUpdate]
	ON [reference].[StorageType]
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
		[reference].[StorageType] a
		INNER JOIN inserted b on
			a.[StorageTypeKey] = b.[StorageTypeKey];
END

GO

