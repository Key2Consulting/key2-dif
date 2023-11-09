CREATE TABLE [reference].[LoadType] (
    [LoadTypeKey]           SMALLINT      IDENTITY (1, 1) NOT NULL,
    [SubsequentLoadTypeKey] SMALLINT      NULL,
    [LoadType]              VARCHAR (50)  NOT NULL,
    [CreatedBy]             VARCHAR (50)  CONSTRAINT [df_LoadType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]       DATETIME2 (0) CONSTRAINT [df_LoadType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]            VARCHAR (50)  NULL,
    [ModifiedDateTime]      DATETIME2 (0) NULL,
    CONSTRAINT [pk_LoadType] PRIMARY KEY CLUSTERED ([LoadTypeKey] ASC),
    CONSTRAINT [fk_LoadType_SubsequentLoadTypeKey] FOREIGN KEY ([SubsequentLoadTypeKey]) REFERENCES [reference].[LoadType] ([LoadTypeKey]),
    CONSTRAINT [uc_LoadType_LoadType] UNIQUE NONCLUSTERED ([LoadType] ASC)
);


GO


CREATE TRIGGER [reference].[LoadTypeUpdate]
	ON [reference].[LoadType]
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
		[reference].[LoadType] a
		INNER JOIN inserted b on
			a.[LoadTypeKey] = b.[LoadTypeKey];
END

GO

