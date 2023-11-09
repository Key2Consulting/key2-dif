CREATE TABLE [logging].[PipelineActivity] (
    [PipelineActivityKey]           INT           IDENTITY (1, 1) NOT NULL,
    [PipelineRunKey]                INT           NOT NULL,
    [PipelineActivityStatusKey]     SMALLINT      NOT NULL,
    [DITaskKey]                     INT           NULL,
    [PipelineActivityRunID]         VARCHAR (255) NOT NULL,
    [PipelineActivityName]          VARCHAR (255) NOT NULL,
    [PipelineActivityType]          VARCHAR (255) NULL,
    [PipelineActivityStartDateTime] DATETIME2 (0) NOT NULL,
    [PipelineActivityEndDateTime]   DATETIME2 (0) NULL,
    CONSTRAINT [pk_PipelineActivity] PRIMARY KEY CLUSTERED ([PipelineActivityKey] ASC),
    CONSTRAINT [fk_PipelineActivity_PipelineActivityStatusKey] FOREIGN KEY ([PipelineActivityStatusKey]) REFERENCES [reference].[PipelineStatus] ([PipelineStatusKey]),
    CONSTRAINT [fk_PipelineActivity_PipelineRunKey] FOREIGN KEY ([PipelineRunKey]) REFERENCES [logging].[PipelineRun] ([PipelineRunKey]),
    CONSTRAINT [uc_PipelineActivity_PipelineActivityRunID] UNIQUE NONCLUSTERED ([PipelineActivityRunID] ASC)
);


GO

