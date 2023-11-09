CREATE TABLE [reference].[PipelineResultName] (
    [PipelineResultNameKey]        SMALLINT      IDENTITY (1, 1) NOT NULL,
    [PipelineResultName]           VARCHAR (50)  NOT NULL,
    [PipelineResultNameIsStandard] BIT           NOT NULL,
    [CreatedBy]                    VARCHAR (50)  CONSTRAINT [df_PipelineResultName_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]              DATETIME2 (0) CONSTRAINT [df_PipelineResultName_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]                   VARCHAR (50)  NULL,
    [ModifiedDateTime]             DATETIME2 (0) NULL,
    CONSTRAINT [pk_PipelineResultNameKey] PRIMARY KEY CLUSTERED ([PipelineResultNameKey] ASC),
    CONSTRAINT [uc_PipelineResultName_PipelineResultName] UNIQUE NONCLUSTERED ([PipelineResultName] ASC)
);


GO


CREATE TRIGGER [reference].[PipelineResultNameUpdate]
	ON [reference].[PipelineResultName]
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
		[reference].[PipelineResultName] a
		INNER JOIN inserted b on
			a.[PipelineResultNameKey] = b.[PipelineResultNameKey];
END

GO

