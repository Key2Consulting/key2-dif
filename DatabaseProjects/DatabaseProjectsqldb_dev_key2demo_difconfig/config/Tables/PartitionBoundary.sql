CREATE TABLE [config].[PartitionBoundary] (
    [PartitionBoundaryKey]        SMALLINT      IDENTITY (1, 1) NOT NULL,
    [PartitionTypeKey]            SMALLINT      NOT NULL,
    [PartitionBoundaryMinValue]   VARCHAR (50)  NOT NULL,
    [PartitionBoundaryIncludeMin] BIT           NOT NULL,
    [PartitionBoundaryMaxValue]   VARCHAR (50)  NOT NULL,
    [PartitionBoundaryIncludeMax] BIT           NOT NULL,
    [CreatedBy]                   VARCHAR (50)  CONSTRAINT [df_PartitionBoundary_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]             DATETIME2 (0) CONSTRAINT [df_PartitionBoundary_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]                  VARCHAR (50)  NULL,
    [ModifiedDateTime]            DATETIME2 (0) NULL,
    CONSTRAINT [pk_PartitionBoundary] PRIMARY KEY CLUSTERED ([PartitionBoundaryKey] ASC),
    CONSTRAINT [fk_PartitionBoundary_PartitionTypeKey] FOREIGN KEY ([PartitionTypeKey]) REFERENCES [reference].[PartitionType] ([PartitionTypeKey])
);


GO


CREATE TRIGGER [config].[PartitionBoundaryUpdate]
	ON [config].[PartitionBoundary]
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
		[config].[PartitionBoundary] a
		INNER JOIN inserted b on
			a.[PartitionBoundaryKey] = b.[PartitionBoundaryKey];
END

GO

