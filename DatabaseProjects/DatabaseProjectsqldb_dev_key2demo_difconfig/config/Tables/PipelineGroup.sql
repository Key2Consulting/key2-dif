CREATE TABLE [config].[PipelineGroup] (
    [PipelineGroupKey]       SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ProjectKey]             SMALLINT      NOT NULL,
    [ParentPipelineKey]      SMALLINT      NOT NULL,
    [ChildPipelineKey]       SMALLINT      NOT NULL,
    [PipelineGroupName]      VARCHAR (50)  NOT NULL,
    [PipelineGroupIsEnabled] BIT           NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [df_PipelineGroup_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDateTime]        DATETIME2 (0) CONSTRAINT [df_PipelineGroup_CreatedDateTime] DEFAULT (getutcdate()) NULL,
    [ModifiedBy]             VARCHAR (50)  NULL,
    [ModifiedDateTime]       DATETIME2 (0) NULL,
    CONSTRAINT [pk_PipelineGroup] PRIMARY KEY CLUSTERED ([PipelineGroupKey] ASC),
    CONSTRAINT [fk_PipelineGroup_ChildPipelineKey] FOREIGN KEY ([ProjectKey]) REFERENCES [config].[Pipeline] ([PipelineKey]),
    CONSTRAINT [fk_PipelineGroup_ParentPipelineKey] FOREIGN KEY ([ProjectKey]) REFERENCES [config].[Pipeline] ([PipelineKey])
);


GO


CREATE TRIGGER [config].[PipelineGroupUpdate]
	ON [config].[PipelineGroup]
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
		[config].[PipelineGroup] a
		INNER JOIN inserted b on
			a.[PipelineGroupKey] = b.[PipelineGroupKey];
END

GO

