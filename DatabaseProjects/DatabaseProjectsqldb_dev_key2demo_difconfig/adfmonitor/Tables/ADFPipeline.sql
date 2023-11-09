CREATE TABLE [adfmonitor].[ADFPipeline] (
    [ADFPipelineKey]    INT           IDENTITY (1, 1) NOT NULL,
    [ADFDataFactoryKey] SMALLINT      NOT NULL,
    [PipelineKey]       SMALLINT      NULL,
    [ADFPipelineName]   VARCHAR (255) NOT NULL,
    [ADFPipelineFolder] VARCHAR (255) NULL,
    CONSTRAINT [pk_ADFPipeline] PRIMARY KEY CLUSTERED ([ADFPipelineKey] ASC),
    CONSTRAINT [fk_ADFPipeline_ADFDataFactoryKey] FOREIGN KEY ([ADFDataFactoryKey]) REFERENCES [adfmonitor].[ADFDataFactory] ([ADFDataFactoryKey]),
    CONSTRAINT [fk_ADFPipeline_PipelineKey] FOREIGN KEY ([PipelineKey]) REFERENCES [config].[Pipeline] ([PipelineKey]),
    CONSTRAINT [uc_ADFPipeline_ADFDataFactoryKey_ADFPipelineName] UNIQUE NONCLUSTERED ([ADFDataFactoryKey] ASC, [ADFPipelineName] ASC)
);


GO

