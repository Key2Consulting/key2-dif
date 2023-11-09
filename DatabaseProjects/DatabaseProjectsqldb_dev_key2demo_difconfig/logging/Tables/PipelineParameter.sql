CREATE TABLE [logging].[PipelineParameter] (
    [PipelineParameterKey]   INT           IDENTITY (1, 1) NOT NULL,
    [PipelineRunKey]         INT           NOT NULL,
    [PipelineParameterPhase] VARCHAR (50)  NULL,
    [PipelineParameterName]  VARCHAR (255) NOT NULL,
    [PipelineParameterValue] VARCHAR (255) NULL,
    CONSTRAINT [pk_PipelineParameter] PRIMARY KEY CLUSTERED ([PipelineParameterKey] ASC),
    CONSTRAINT [fk_PipelineParameter_PipelineRunKey] FOREIGN KEY ([PipelineRunKey]) REFERENCES [logging].[PipelineRun] ([PipelineRunKey])
);


GO

