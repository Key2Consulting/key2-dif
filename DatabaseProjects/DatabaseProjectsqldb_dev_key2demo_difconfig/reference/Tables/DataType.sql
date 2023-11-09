CREATE TABLE [reference].[DataType] (
    [DataTypeKey]      SMALLINT      IDENTITY (1, 1) NOT NULL,
    [DataType]         VARCHAR (50)  NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_DataType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_DataType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_DataType] PRIMARY KEY CLUSTERED ([DataTypeKey] ASC),
    CONSTRAINT [uc_DataType_DataType] UNIQUE NONCLUSTERED ([DataType] ASC)
);


GO


CREATE TRIGGER [reference].[DataTypeUpdate]
	ON [reference].[DataType]
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
		[reference].[DataType] a
		INNER JOIN inserted b on
			a.[DataTypeKey] = b.[DataTypeKey];
END

GO

