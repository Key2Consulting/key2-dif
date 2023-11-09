CREATE TABLE [adfmonitor].[ADFResourceGroup] (
    [ADFResourceGroupKey]  SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ADFSubscriptionKey]   SMALLINT      NOT NULL,
    [ADFResourceGroupName] VARCHAR (255) NOT NULL,
    CONSTRAINT [pk_ADFResourceGroup] PRIMARY KEY CLUSTERED ([ADFResourceGroupKey] ASC),
    CONSTRAINT [fk_ADFResourceGroup_ADFSubscriptionKey] FOREIGN KEY ([ADFSubscriptionKey]) REFERENCES [adfmonitor].[ADFSubscription] ([ADFSubscriptionKey]),
    CONSTRAINT [uc_ADFResourceGroup_ADFSubscriptionKey_ADFResourceGroupName] UNIQUE NONCLUSTERED ([ADFSubscriptionKey] ASC, [ADFResourceGroupName] ASC)
);


GO

