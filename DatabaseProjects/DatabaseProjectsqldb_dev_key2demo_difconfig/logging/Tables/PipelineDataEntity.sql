CREATE TABLE [logging].[PipelineDataEntity] (
    [PipelineDataEntityKey] INT           IDENTITY (1, 1) NOT NULL,
    [PipelineRunKey]        INT           NULL,
    [DataEntityName]        VARCHAR (255) NULL,
    [InsertCount]           BIGINT        NULL,
    [UpdateCount]           BIGINT        NULL,
    [DeleteCount]           BIGINT        NULL,
    [Comment]               VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([PipelineDataEntityKey] ASC)
);


GO

