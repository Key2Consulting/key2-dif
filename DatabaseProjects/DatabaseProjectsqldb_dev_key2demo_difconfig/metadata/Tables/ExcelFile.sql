CREATE TABLE [metadata].[ExcelFile] (
    [ExcelFileKey]                      SMALLINT      IDENTITY (1, 1) NOT NULL,
    [DatasetKey]                        SMALLINT      NOT NULL,
    [ExcelFileSheetName]                VARCHAR (255) NULL,
    [ExcelFileSheetFirstRowAsHeader]    BIT           NULL,
    [ExcelFileSheetIsHeaderRowOverride] BIT           NULL,
    [ExcelFileSheetRange]               VARCHAR (50)  NULL,
    [ExcelFileNamePattern]              VARCHAR (255) NULL,
    [ExcelFileCompressionType]          VARCHAR (50)  NULL,
    [ExcelFileNULLValue]                VARCHAR (50)  NULL,
    [CreatedBy]                         VARCHAR (50)  CONSTRAINT [df_ExcelFile_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]                   DATETIME2 (0) CONSTRAINT [df_ExcelFile_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]                        VARCHAR (50)  NULL,
    [ModifiedDateTime]                  DATETIME2 (0) NULL,
    CONSTRAINT [pk_ExcelFile] PRIMARY KEY CLUSTERED ([ExcelFileKey] ASC),
    CONSTRAINT [fk_ExcelFile_DatasetKey] FOREIGN KEY ([DatasetKey]) REFERENCES [metadata].[Dataset] ([DatasetKey]),
    CONSTRAINT [uc_ExcelFile_DatasetKey_SheetName] UNIQUE NONCLUSTERED ([DatasetKey] ASC, [ExcelFileSheetName] ASC)
);


GO

