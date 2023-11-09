
CREATE   VIEW [DIF].[PipelineActivityDetail]
AS

SELECT
	b.[PipelineActivityKey]
	,a.[PipelineRunKey]
	,a.[ProjectType]
	,a.[ProjectName]
	,a.[PipelineShortName]
	,a.[PipelineFolder]
	,a.[PipelineFullName]
	,a.[PipelineRunStatus]
	,a.[PipelineRunID]
	,a.[PipelineRunStartDateTime]
	,a.[PipelineRunEndDateTime]
	,b.[DITaskKey]
	,c.[PipelineStatus] as [PipelineActivityRunStatus]
	,b.[PipelineActivityRunID]
	,b.[PipelineActivityName]
	,b.[PipelineActivityType]
	,b.[PipelineActivityStartDateTime]
	,b.[PipelineActivityEndDateTime]
FROM
	[DIF].[PipelineRunDetail] AS a
	INNER JOIN [logging].[PipelineActivity] AS b ON
		a.[PipelineRunKey] = b.[PipelineRunKey]
	INNER JOIN [reference].[PipelineStatus] AS c ON
		b.[PipelineActivityStatusKey] = c.[PipelineStatusKey];

GO

