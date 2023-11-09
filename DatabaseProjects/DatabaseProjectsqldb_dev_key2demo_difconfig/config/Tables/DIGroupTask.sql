CREATE TABLE [config].[DIGroupTask] (
    [DIGroupTaskKey]           INT           IDENTITY (1, 1) NOT NULL,
    [DIGroupKey]               SMALLINT      NOT NULL,
    [DITaskKey]                INT           NOT NULL,
    [DIGroupTaskPriorityOrder] SMALLINT      NULL,
    [CreatedBy]                VARCHAR (50)  CONSTRAINT [df_DIGroupTask_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]          DATETIME2 (0) CONSTRAINT [df_DIGroupTask_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]               VARCHAR (50)  NULL,
    [ModifiedDateTime]         DATETIME2 (0) NULL,
    [PipelineKey]              SMALLINT      NOT NULL,
    [RelatedDIGroupTaskKey]    INT           NULL,
    CONSTRAINT [pk_DIGroupTask] PRIMARY KEY CLUSTERED ([DIGroupTaskKey] ASC),
    CONSTRAINT [fk_DIGroupTask_DIGroupKey] FOREIGN KEY ([DIGroupKey]) REFERENCES [config].[DIGroup] ([DIGroupKey]),
    CONSTRAINT [fk_DIGroupTask_DITaskKey] FOREIGN KEY ([DITaskKey]) REFERENCES [config].[DITask] ([DITaskKey]),
    CONSTRAINT [fk_DIGroupTask_PipelineKey] FOREIGN KEY ([PipelineKey]) REFERENCES [config].[Pipeline] ([PipelineKey]),
    CONSTRAINT [fk_DIGroupTask_RelatedDIGroupTaskKey] FOREIGN KEY ([RelatedDIGroupTaskKey]) REFERENCES [config].[DIGroupTask] ([DIGroupTaskKey])
);


GO


CREATE TRIGGER [config].[DIGroupTaskUpdate]
	ON [config].[DIGroupTask]
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
		[config].[DIGroupTask] a
		INNER JOIN inserted b on
			a.[DIGroupTaskKey] = b.[DIGroupTaskKey];
END

GO

