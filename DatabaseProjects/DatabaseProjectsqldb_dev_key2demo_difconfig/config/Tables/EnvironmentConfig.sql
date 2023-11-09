CREATE TABLE [config].[EnvironmentConfig] (
    [EnvironmentConfigKey]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ProjectKey]             SMALLINT      NOT NULL,
    [EnvironmentConfigName]  VARCHAR (255) NOT NULL,
    [EnvironmentConfigValue] VARCHAR (255) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [df_EnvironmentConfig_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]        DATETIME2 (0) CONSTRAINT [df_EnvironmentConfig_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]             VARCHAR (50)  NULL,
    [ModifiedDateTime]       DATETIME2 (0) NULL,
    CONSTRAINT [pk_EnvironmentConfig] PRIMARY KEY CLUSTERED ([EnvironmentConfigKey] ASC),
    CONSTRAINT [fk_EnvironmentConfig_ProjectKey] FOREIGN KEY ([ProjectKey]) REFERENCES [config].[Project] ([ProjectKey])
);


GO


CREATE TRIGGER [config].[EnvironmentConfigUpdate]
	ON [config].[EnvironmentConfig]
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
		[config].[EnvironmentConfig] a
		INNER JOIN inserted b on
			a.[EnvironmentConfigKey] = b.[EnvironmentConfigKey];
END

GO

