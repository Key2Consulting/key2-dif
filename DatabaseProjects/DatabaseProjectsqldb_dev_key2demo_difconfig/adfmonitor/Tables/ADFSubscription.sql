CREATE TABLE [adfmonitor].[ADFSubscription] (
    [ADFSubscriptionKey]  SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ADFSubscriptionID]   VARCHAR (255) NOT NULL,
    [ADFSubscriptionName] VARCHAR (255) NOT NULL,
    CONSTRAINT [pk_ADFSubscription] PRIMARY KEY CLUSTERED ([ADFSubscriptionKey] ASC),
    CONSTRAINT [uc_ADFSubscription_ADFSubscriptionID] UNIQUE NONCLUSTERED ([ADFSubscriptionID] ASC)
);


GO

