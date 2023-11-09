CREATE TABLE [metadata].[DelimitedFile] (
    [DelimitedFileKey]                 SMALLINT      IDENTITY (1, 1) NOT NULL,
    [DatasetKey]                       SMALLINT      NOT NULL,
    [DelimitedFileCompressionType]     VARCHAR (50)  NULL,
    [DelimitedFileCompressionLevel]    VARCHAR (50)  NULL,
    [DelimitedFileColumnDelimiter]     VARCHAR (50)  NULL,
    [DelimitedFileRowDelimiter]        VARCHAR (50)  NULL,
    [DelimitedFileEncoding]            VARCHAR (50)  NULL,
    [DelimitedFileEscapeCharacter]     VARCHAR (50)  NULL,
    [DelimitedFileQuoteCharacter]      VARCHAR (50)  NULL,
    [DelimitedFileFirstRowAsHeader]    BIT           NULL,
    [DelimitedFileNULLValue]           VARCHAR (50)  NULL,
    [DelimitedFileNamePattern]         VARCHAR (255) NULL,
    [CreatedBy]                        VARCHAR (50)  CONSTRAINT [df_DelimitedFile_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]                  DATETIME2 (0) CONSTRAINT [df_DelimitedFile_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]                       VARCHAR (50)  NULL,
    [ModifiedDateTime]                 DATETIME2 (0) NULL,
    [DelimitedFileIsHeaderRowOverride] BIT           NULL,
    CONSTRAINT [pk_DelimitedFile] PRIMARY KEY CLUSTERED ([DelimitedFileKey] ASC),
    CONSTRAINT [fk_DelimitedFile_DatasetKey] FOREIGN KEY ([DatasetKey]) REFERENCES [metadata].[Dataset] ([DatasetKey]),
    CONSTRAINT [uc_DelimitedFile_DatasetKey] UNIQUE NONCLUSTERED ([DatasetKey] ASC)
);


GO






CREATE TRIGGER [metadata].[DelimitedFileUpdate]
	ON [metadata].[DelimitedFile]
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
		[metadata].[DelimitedFile] a
		INNER JOIN inserted b on
			a.[DatasetKey] = b.[DatasetKey];
END

GO

