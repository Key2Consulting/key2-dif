CREATE TABLE [config].[Pipeline] (
    [PipelineKey]         SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ProjectKey]          SMALLINT      NOT NULL,
    [PipelineShortName]   VARCHAR (50)  NOT NULL,
    [PipelineFullName]    VARCHAR (255) NOT NULL,
    [PipelineFolder]      VARCHAR (255) NULL,
    [PipelineDescription] VARCHAR (255) NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [df_Pipeline_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]     DATETIME2 (0) CONSTRAINT [df_Pipeline_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]          VARCHAR (50)  NULL,
    [ModifiedDateTime]    DATETIME2 (0) NULL,
    CONSTRAINT [pk_Pipeline] PRIMARY KEY CLUSTERED ([PipelineKey] ASC),
    CONSTRAINT [fk_Pipeline_ProjectKey] FOREIGN KEY ([ProjectKey]) REFERENCES [config].[Project] ([ProjectKey]),
    CONSTRAINT [uc_Pipeline_PipelineFullName] UNIQUE NONCLUSTERED ([PipelineFullName] ASC)
);


GO


CREATE TRIGGER [config].[PipelineUpdate]
	ON [config].[Pipeline]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE
		a
	SET
		[ModifiedBy] = SYSTEM_USER,
		[ModifiedDateTime] = GETUTCDATE()
	FROM
		[config].[Pipeline] a
		INNER JOIN inserted b on
			a.[PipelineKey] = b.[PipelineKey];
END

GO

