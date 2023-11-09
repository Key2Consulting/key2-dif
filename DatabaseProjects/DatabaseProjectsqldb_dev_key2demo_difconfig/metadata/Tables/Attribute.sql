CREATE TABLE [metadata].[Attribute] (
    [AttributeKey]                  INT           IDENTITY (1, 1) NOT NULL,
    [DataTypeKey]                   SMALLINT      NOT NULL,
    [DatasetKey]                    SMALLINT      NOT NULL,
    [AttributeName]                 VARCHAR (255) NOT NULL,
    [AttributeSequenceNumber]       SMALLINT      NOT NULL,
    [AttributeMaxLength]            SMALLINT      NULL,
    [AttributePrecision]            SMALLINT      NULL,
    [AttributeScale]                SMALLINT      NULL,
    [AttributeIsNullable]           BIT           NOT NULL,
    [AttributeIsPrimaryKey]         BIT           NOT NULL,
    [AttributeIsUnique]             BIT           NOT NULL,
    [AttributeIsForeignKey]         BIT           NOT NULL,
    [AttributeIsWaterMark]          BIT           NOT NULL,
    [AttributePartitionKeyOrder]    TINYINT       NULL,
    [AttributeDistributionKeyOrder] TINYINT       NULL,
    [AttributeIsEnabled]            BIT           NOT NULL,
    [CreatedBy]                     VARCHAR (50)  CONSTRAINT [df_Attribute_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]               DATETIME2 (0) CONSTRAINT [df_Attribute_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]                    VARCHAR (50)  NULL,
    [ModifiedDateTime]              DATETIME2 (0) NULL,
    CONSTRAINT [pk_Attribute] PRIMARY KEY CLUSTERED ([AttributeKey] ASC),
    CONSTRAINT [fk_Attribute_DatasetKey] FOREIGN KEY ([DatasetKey]) REFERENCES [metadata].[Dataset] ([DatasetKey]),
    CONSTRAINT [fk_Attribute_DataTypeKey] FOREIGN KEY ([DataTypeKey]) REFERENCES [reference].[DataType] ([DataTypeKey]),
    CONSTRAINT [uc_Attribute_DatasetKey_AttributeName] UNIQUE NONCLUSTERED ([DatasetKey] ASC, [AttributeName] ASC)
);


GO


CREATE TRIGGER [metadata].[AttributeUpdate]
	ON [metadata].[Attribute]
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
		[metadata].[Attribute] a
		INNER JOIN inserted b on
			a.[AttributeKey] = b.[AttributeKey];
END

GO

