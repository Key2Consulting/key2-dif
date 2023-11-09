CREATE TABLE [reference].[PartitionType] (
    [PartitionTypeKey] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [PartitionType]    VARCHAR (50)  NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [df_PartitionType_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]  DATETIME2 (0) CONSTRAINT [df_PartitionType_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [ModifiedDateTime] DATETIME2 (0) NULL,
    CONSTRAINT [pk_PartitionType] PRIMARY KEY CLUSTERED ([PartitionTypeKey] ASC),
    CONSTRAINT [uc_PartitionType_PartitionType] UNIQUE NONCLUSTERED ([PartitionType] ASC)
);


GO


CREATE TRIGGER [reference].[PartitionTypeUpdate]
	ON [reference].[PartitionType]
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
		[reference].[PartitionType] a
		INNER JOIN inserted b on
			a.[PartitionTypeKey] = b.[PartitionTypeKey];
END

GO

