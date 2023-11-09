CREATE TABLE [reference].[ProjectType] (
    [ProjectTypeKey]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ProjectType]      VARCHAR (50)  NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_ProjectType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_ProjectType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_ProjectType] PRIMARY KEY CLUSTERED ([ProjectTypeKey] ASC),
    CONSTRAINT [uc_ProjectType_ProjectType] UNIQUE NONCLUSTERED ([ProjectType] ASC)
);


GO


CREATE TRIGGER [reference].[ProjectTypeUpdate]
	ON [reference].[ProjectType]
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
		[reference].[ProjectType] a
		INNER JOIN inserted b on
			a.[ProjectTypeKey] = b.[ProjectTypeKey];
END

GO

