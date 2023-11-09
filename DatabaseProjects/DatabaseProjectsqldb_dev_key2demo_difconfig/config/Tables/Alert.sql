CREATE TABLE [config].[Alert] (
    [AlertKey]         SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ProjectKey]       SMALLINT      NOT NULL,
    [AlertRecipient]   VARCHAR (50)  NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_Alert_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_Alert_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_Alert] PRIMARY KEY CLUSTERED ([AlertKey] ASC),
    CONSTRAINT [fk_Alert_ProjectKey] FOREIGN KEY ([ProjectKey]) REFERENCES [config].[Project] ([ProjectKey])
);


GO



CREATE TRIGGER [config].[AlertUpdate]
	ON [config].[Alert]
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
		[config].[Alert] a
		INNER JOIN inserted b on
			a.[AlertKey] = b.[AlertKey];
END

GO

