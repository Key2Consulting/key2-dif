CREATE TABLE [reference].[RepositoryType] (
    [RepositoryTypeKey] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [RepositoryType]    VARCHAR (50)  NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [df_RepositoryType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]   DATETIME2 (0) CONSTRAINT [df_RepositoryType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]        VARCHAR (50)  NULL,
    [ModifiedDateTime]  DATETIME2 (0) NULL,
    CONSTRAINT [pk_RepositoryType] PRIMARY KEY CLUSTERED ([RepositoryTypeKey] ASC),
    CONSTRAINT [uc_RepositoryType_RepositoryType] UNIQUE NONCLUSTERED ([RepositoryType] ASC)
);


GO


CREATE TRIGGER [reference].[RepositoryTypeUpdate]
	ON [reference].[RepositoryType]
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
		[reference].[RepositoryType] a
		INNER JOIN inserted b on
			a.[RepositoryTypeKey] = b.[RepositoryTypeKey];
END

GO

