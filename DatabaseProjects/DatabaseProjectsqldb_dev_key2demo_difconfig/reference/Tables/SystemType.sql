CREATE TABLE [reference].[SystemType] (
    [SystemTypeKey]    SMALLINT      IDENTITY (1, 1) NOT NULL,
    [SystemType]       VARCHAR (50)  NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_SystemType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_SystemType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_SystemType] PRIMARY KEY CLUSTERED ([SystemTypeKey] ASC),
    CONSTRAINT [uc_SystemType_SystemType] UNIQUE NONCLUSTERED ([SystemType] ASC)
);


GO


CREATE TRIGGER [reference].[SystemTypeUpdate]
	ON [reference].[SystemType]
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
		[reference].[SystemType] a
		INNER JOIN inserted b on
			a.[SystemTypeKey] = b.[SystemTypeKey];
END

GO

