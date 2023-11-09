CREATE TABLE [config].[Project] (
    [ProjectKey]       SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ProjectTypeKey]   SMALLINT      NOT NULL,
    [ProjectName]      VARCHAR (50)  NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_Project_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_Project_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_Project] PRIMARY KEY CLUSTERED ([ProjectKey] ASC),
    CONSTRAINT [fk_Project_ProjectTypeKey] FOREIGN KEY ([ProjectTypeKey]) REFERENCES [reference].[ProjectType] ([ProjectTypeKey]),
    CONSTRAINT [uc_Projecte_ProjectName] UNIQUE NONCLUSTERED ([ProjectName] ASC)
);


GO


CREATE TRIGGER [config].[ProjectUpdate]
	ON [config].[Project]
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
		[config].[Project] a
		INNER JOIN inserted b on
			a.[ProjectKey] = b.[ProjectKey];
END

GO

