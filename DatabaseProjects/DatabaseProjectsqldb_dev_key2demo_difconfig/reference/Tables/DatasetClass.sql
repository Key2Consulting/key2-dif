CREATE TABLE [reference].[DatasetClass] (
    [DatasetClassKey]  SMALLINT      IDENTITY (1, 1) NOT NULL,
    [DatasetClass]     VARCHAR (50)  NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_DatasetClass_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_DatasetClass_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_DatasetClass] PRIMARY KEY CLUSTERED ([DatasetClassKey] ASC),
    CONSTRAINT [uc_DatasetClass_DatasetClass] UNIQUE NONCLUSTERED ([DatasetClass] ASC)
);


GO


CREATE TRIGGER [reference].[DatasetClassUpdate]
	ON [reference].[DatasetClass]
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
		[reference].[DatasetClass] a
		INNER JOIN inserted b on
			a.[DatasetClassKey] = b.[DatasetClassKey];
END

GO

