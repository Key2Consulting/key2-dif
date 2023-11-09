CREATE TABLE [metadata].[System] (
    [SystemKey]          SMALLINT      IDENTITY (1, 1) NOT NULL,
    [SystemTypeKey]      SMALLINT      NOT NULL,
    [EnvironmentTypeKey] SMALLINT      NOT NULL,
    [SystemName]         VARCHAR (50)  NOT NULL,
    [SystemDescription]  VARCHAR (255) NULL,
    [SystemProgram]      VARCHAR (50)  NULL,
    [SystemFQDN]         VARCHAR (255) NOT NULL,
    [SystemUserName]     VARCHAR (250) NULL,
    [SystemSecretName]   VARCHAR (50)  NULL,
    [SystemIsEnabled]    BIT           NOT NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [df_System_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]    DATETIME2 (0) CONSTRAINT [df_System_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]         VARCHAR (50)  NULL,
    [ModifiedDateTime]   DATETIME2 (0) NULL,
    CONSTRAINT [pk_System] PRIMARY KEY CLUSTERED ([SystemKey] ASC),
    CONSTRAINT [fk_System_EnvironmentTypeKey] FOREIGN KEY ([EnvironmentTypeKey]) REFERENCES [reference].[EnvironmentType] ([EnvironmentTypeKey]),
    CONSTRAINT [fk_System_SystemTypeKey] FOREIGN KEY ([SystemTypeKey]) REFERENCES [reference].[SystemType] ([SystemTypeKey]),
    CONSTRAINT [uc_System_SystemFQDN] UNIQUE NONCLUSTERED ([SystemFQDN] ASC),
    CONSTRAINT [uc_System_SystemName] UNIQUE NONCLUSTERED ([SystemName] ASC)
);


GO


CREATE TRIGGER [metadata].[SystemUpdate]
	ON [metadata].[System]
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
		[metadata].[System] a
		INNER JOIN inserted b on
			a.[SystemKey] = b.[SystemKey];
END

GO

