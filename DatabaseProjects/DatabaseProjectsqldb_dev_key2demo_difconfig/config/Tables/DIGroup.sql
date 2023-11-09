CREATE TABLE [config].[DIGroup] (
    [DIGroupKey]       SMALLINT      IDENTITY (1, 1) NOT NULL,
    [DIGroupName]      VARCHAR (50)  NOT NULL,
    [DIGroupIsEnabled] BIT           NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_DIGroup_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_DIGroup_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    [ProjectKey]       SMALLINT      NULL,
    CONSTRAINT [pk_DIGroup] PRIMARY KEY CLUSTERED ([DIGroupKey] ASC),
    CONSTRAINT [fk_DIGroup_ProjectKey] FOREIGN KEY ([ProjectKey]) REFERENCES [config].[Project] ([ProjectKey])
);


GO


CREATE TRIGGER [config].[DIGroupUpdate]
	ON [config].[DIGroup]
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
		[config].[DIGroup] a
		INNER JOIN inserted b on
			a.[DIGroupKey] = b.[DIGroupKey];
END

GO

