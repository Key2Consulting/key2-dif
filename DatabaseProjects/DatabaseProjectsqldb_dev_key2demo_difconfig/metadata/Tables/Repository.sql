CREATE TABLE [metadata].[Repository] (
    [RepositoryKey]         SMALLINT      IDENTITY (1, 1) NOT NULL,
    [SystemKey]             SMALLINT      NOT NULL,
    [RepositoryTypeKey]     SMALLINT      NOT NULL,
    [RepositoryName]        VARCHAR (50)  NOT NULL,
    [RepositoryDescription] VARCHAR (255) NULL,
    [RepositoryPathPattern] VARCHAR (255) NULL,
    [RepositoryIsEnabled]   BIT           NOT NULL,
    [CreatedBy]             VARCHAR (50)  CONSTRAINT [df_Repository_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]       DATETIME2 (0) CONSTRAINT [df_Repository_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]            VARCHAR (50)  NULL,
    [ModifiedDateTime]      DATETIME2 (0) NULL,
    CONSTRAINT [pk_Repository] PRIMARY KEY CLUSTERED ([RepositoryKey] ASC),
    CONSTRAINT [fk_Repository_RepositoryTypeKey] FOREIGN KEY ([RepositoryTypeKey]) REFERENCES [reference].[RepositoryType] ([RepositoryTypeKey]),
    CONSTRAINT [fk_Repository_SystemKey] FOREIGN KEY ([SystemKey]) REFERENCES [metadata].[System] ([SystemKey]),
    CONSTRAINT [uc_Repository_SystemKey_RepositoryName] UNIQUE NONCLUSTERED ([SystemKey] ASC, [RepositoryName] ASC)
);


GO


CREATE TRIGGER [metadata].[RepositoryUpdate]
	ON [metadata].[Repository]
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
		[metadata].[Repository] a
		INNER JOIN inserted b on
			a.[RepositoryKey] = b.[RepositoryKey];
END

GO

