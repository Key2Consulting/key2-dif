CREATE TABLE [config].[IngestionConfig] (
    [IngestionConfigKey]   SMALLINT       IDENTITY (1, 1) NOT NULL,
    [ProjectKey]           SMALLINT       NOT NULL,
    [IngestionConfigType]  VARCHAR (250)  NOT NULL,
    [IngestionConfigName]  VARCHAR (250)  NOT NULL,
    [IngestionConfigValue] VARCHAR (1000) NOT NULL,
    [CreatedBy]            VARCHAR (50)   CONSTRAINT [df_IngestionConfig_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]      DATETIME2 (0)  CONSTRAINT [df_IngestionConfig_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]           VARCHAR (50)   NULL,
    [ModifiedDateTime]     DATETIME2 (0)  NULL,
    CONSTRAINT [pk_IngestionConfig] PRIMARY KEY CLUSTERED ([IngestionConfigKey] ASC),
    CONSTRAINT [fk_IngestionConfig_ProjectKey] FOREIGN KEY ([ProjectKey]) REFERENCES [config].[Project] ([ProjectKey])
);


GO



CREATE TRIGGER [config].[IngestionConfigUpdate]
	ON [config].[IngestionConfig]
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
		[config].[IngestionConfig] a
		INNER JOIN inserted b on
			a.[IngestionConfigKey] = b.[IngestionConfigKey];
END

GO

