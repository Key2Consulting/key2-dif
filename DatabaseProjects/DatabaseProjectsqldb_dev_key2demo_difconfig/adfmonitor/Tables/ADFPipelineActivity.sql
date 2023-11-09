CREATE TABLE [adfmonitor].[ADFPipelineActivity] (
    [ADFPipelineActivityKey]     INT           IDENTITY (1, 1) NOT NULL,
    [ADFPipelineRunKey]          INT           NOT NULL,
    [PipelineActivityKey]        INT           NULL,
    [ADFActivityRunID]           VARCHAR (255) NOT NULL,
    [ADFActivityName]            VARCHAR (255) NOT NULL,
    [ADFActivityType]            VARCHAR (255) NOT NULL,
    [ADFActivityRunStart]        DATETIME2 (0) NOT NULL,
    [ADFActivityRunEnd]          DATETIME2 (0) NULL,
    [ADFActivityRunDurationInMS] INT           NULL,
    [ADFActivityRunStatus]       VARCHAR (255) NULL,
    CONSTRAINT [pk_ADFPipelineActivity] PRIMARY KEY CLUSTERED ([ADFPipelineActivityKey] ASC),
    CONSTRAINT [fk_ADFPipelineActivity_ADFPipelineRunKey] FOREIGN KEY ([ADFPipelineRunKey]) REFERENCES [adfmonitor].[ADFPipelineRun] ([ADFPipelineRunKey]),
    CONSTRAINT [fk_ADFPipelineActivity_PipelineActivityKey] FOREIGN KEY ([PipelineActivityKey]) REFERENCES [logging].[PipelineActivity] ([PipelineActivityKey]),
    CONSTRAINT [uc_ADFPipelineActivity_ADFActivityRunID] UNIQUE NONCLUSTERED ([ADFActivityRunID] ASC)
);


GO

