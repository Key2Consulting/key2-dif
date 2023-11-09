CREATE TABLE [reference].[PipelineStatus] (
    [PipelineStatusKey] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [PipelineStatus]    VARCHAR (50)  NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [df_PipelineStatus_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]   DATETIME2 (0) CONSTRAINT [df_PipelineStatus_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]        VARCHAR (50)  NULL,
    [ModifiedDateTime]  DATETIME2 (0) NULL,
    CONSTRAINT [pk_PipelineStatus] PRIMARY KEY CLUSTERED ([PipelineStatusKey] ASC),
    CONSTRAINT [uc_PipelineStatus_PipelineStatus] UNIQUE NONCLUSTERED ([PipelineStatus] ASC)
);


GO


CREATE TRIGGER [reference].[PipelineStatusUpdate]
	ON [reference].[PipelineStatus]
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
		[reference].[PipelineStatus] a
		INNER JOIN inserted b on
			a.[PipelineStatusKey] = b.[PipelineStatusKey];
END

GO

