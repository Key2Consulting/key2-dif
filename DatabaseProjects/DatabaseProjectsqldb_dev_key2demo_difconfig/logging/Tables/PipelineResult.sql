CREATE TABLE [logging].[PipelineResult] (
    [PipelineResultKey]     INT            IDENTITY (1, 1) NOT NULL,
    [PipelineRunKey]        INT            NOT NULL,
    [PipelineActivityKey]   INT            NULL,
    [PipelineResultNameKey] SMALLINT       NOT NULL,
    [PipelineResultValue]   VARCHAR (2000) NOT NULL,
    CONSTRAINT [pk_PipelineResult] PRIMARY KEY CLUSTERED ([PipelineResultKey] ASC),
    CONSTRAINT [fk_PipelineResult_PipelineActivityKey] FOREIGN KEY ([PipelineActivityKey]) REFERENCES [logging].[PipelineActivity] ([PipelineActivityKey]),
    CONSTRAINT [fk_PipelineResult_PipelineRunKey] FOREIGN KEY ([PipelineRunKey]) REFERENCES [logging].[PipelineRun] ([PipelineRunKey])
);


GO

CREATE NONCLUSTERED INDEX [PipelineResult_PipelineActivityKey]
    ON [logging].[PipelineResult]([PipelineRunKey] ASC, [PipelineActivityKey] ASC)
    INCLUDE([PipelineResultNameKey], [PipelineResultValue]);


GO

CREATE NONCLUSTERED INDEX [PipelineResult_PipelineResultNameKey]
    ON [logging].[PipelineResult]([PipelineResultNameKey] ASC)
    INCLUDE([PipelineRunKey], [PipelineActivityKey], [PipelineResultValue]);


GO

