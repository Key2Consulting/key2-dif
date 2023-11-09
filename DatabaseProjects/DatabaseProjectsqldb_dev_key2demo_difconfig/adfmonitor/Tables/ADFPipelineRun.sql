CREATE TABLE [adfmonitor].[ADFPipelineRun] (
    [ADFPipelineRunKey] INT           IDENTITY (1, 1) NOT NULL,
    [ADFPipelineKey]    INT           NOT NULL,
    [PipelineRunKey]    INT           NULL,
    [ADFRunID]          VARCHAR (255) NOT NULL,
    [ADFRunStart]       DATETIME2 (0) NOT NULL,
    [ADFRunEnd]         DATETIME2 (0) NULL,
    [ADFDurationInMS]   INT           NULL,
    [ADFStatus]         VARCHAR (255) NOT NULL,
    [ADFMessage]        VARCHAR (255) NULL,
    CONSTRAINT [pk_ADFPipelineRun] PRIMARY KEY CLUSTERED ([ADFPipelineRunKey] ASC),
    CONSTRAINT [fk_ADFPipelineRun_ADFPipelineKey] FOREIGN KEY ([ADFPipelineKey]) REFERENCES [adfmonitor].[ADFPipeline] ([ADFPipelineKey]),
    CONSTRAINT [fk_ADFPipelineRun_PipelineRunKey] FOREIGN KEY ([PipelineRunKey]) REFERENCES [logging].[PipelineRun] ([PipelineRunKey]),
    CONSTRAINT [uc_ADFPipelineRun_ADFRunID] UNIQUE NONCLUSTERED ([ADFRunID] ASC)
);


GO

