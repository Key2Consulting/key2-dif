CREATE TABLE [adfmonitor].[ADFDataFactory] (
    [ADFDataFactoryKey]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ADFResourceGroupKey] SMALLINT      NOT NULL,
    [ADFDataFactoryName]  VARCHAR (255) NOT NULL,
    [ADFDataFactoryType]  VARCHAR (255) NULL,
    CONSTRAINT [pk_ADFDataFactory] PRIMARY KEY CLUSTERED ([ADFDataFactoryKey] ASC),
    CONSTRAINT [fk_ADFDataFactory_ADFResourceGroupKey] FOREIGN KEY ([ADFResourceGroupKey]) REFERENCES [adfmonitor].[ADFResourceGroup] ([ADFResourceGroupKey]),
    CONSTRAINT [uc_ADFDataFactory_ADFResourceGroupKey_ADFDataFactoryName] UNIQUE NONCLUSTERED ([ADFResourceGroupKey] ASC, [ADFDataFactoryName] ASC)
);


GO

