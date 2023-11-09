CREATE TABLE [error].[ErrorLog] (
    [ErrorLogKey]     INT            IDENTITY (1, 1) NOT NULL,
    [ErrorMessage]    VARCHAR (4000) NULL,
    [CreatedDateTime] DATETIME       NULL
);


GO

