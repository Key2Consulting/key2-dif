CREATE TABLE [reference].[EnvironmentType] (
    [EnvironmentTypeKey] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [EnvironmentType]    VARCHAR (50)  NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [df_EnvironmentType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]    DATETIME2 (0) CONSTRAINT [df_EnvironmentType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]         VARCHAR (50)  NULL,
    [ModifiedDateTime]   DATETIME2 (0) NULL,
    CONSTRAINT [pk_EnvironmentType] PRIMARY KEY CLUSTERED ([EnvironmentTypeKey] ASC),
    CONSTRAINT [uc_EnvironmentType_EnvironmentType] UNIQUE NONCLUSTERED ([EnvironmentType] ASC)
);


GO


CREATE TRIGGER [reference].[EnvironmentTypeUpdate]
	ON [reference].[EnvironmentType]
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
		[reference].[EnvironmentType] a
		INNER JOIN inserted b on
			a.[EnvironmentTypeKey] = b.[EnvironmentTypeKey];
END

GO

