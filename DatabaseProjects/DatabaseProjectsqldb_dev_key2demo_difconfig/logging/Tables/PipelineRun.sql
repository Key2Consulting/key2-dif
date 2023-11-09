CREATE TABLE [logging].[PipelineRun] (
    [PipelineRunKey]           INT           IDENTITY (1, 1) NOT NULL,
    [PipelineKey]              SMALLINT      NOT NULL,
    [PipelineRunStatusKey]     SMALLINT      NOT NULL,
    [PipelineRunID]            VARCHAR (255) NULL,
    [PipelineRunStartDateTime] DATETIME2 (0) NULL,
    [PipelineRunEndDateTime]   DATETIME2 (0) NULL,
    CONSTRAINT [pk_PipelineRun] PRIMARY KEY CLUSTERED ([PipelineRunKey] ASC),
    CONSTRAINT [fk_PipelineRun_PipelineRunStatusKey] FOREIGN KEY ([PipelineRunStatusKey]) REFERENCES [reference].[PipelineStatus] ([PipelineStatusKey]),
    CONSTRAINT [uc_PipelineRun_PipelineRunID] UNIQUE NONCLUSTERED ([PipelineRunID] ASC)
);


GO

