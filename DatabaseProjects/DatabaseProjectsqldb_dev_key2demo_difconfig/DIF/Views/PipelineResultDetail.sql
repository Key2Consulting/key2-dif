

CREATE   VIEW [DIF].[PipelineResultDetail]
AS

WITH
	[PipelineActivityResultDetail] as
	(
	SELECT
		b.[PipelineResultKey]
		,a.[PipelineActivityKey]
		,a.[PipelineRunKey]
		,a.[DITaskKey]
		,a.[PipelineActivityRunStatus]
		,a.[PipelineActivityRunID]
		,a.[PipelineActivityName]
		,a.[PipelineActivityType]
		,a.[PipelineActivityStartDateTime]
		,a.[PipelineActivityEndDateTime]
		,c.[PipelineResultName]
		,b.[PipelineResultValue]
	FROM
		[DIF].[PipelineActivityDetail] AS a
		INNER JOIN [logging].[PipelineResult] AS b ON
			a.[PipelineActivityKey] = b.[PipelineActivityKey]
		INNER JOIN [reference].[PipelineResultName] AS c ON
			b.[PipelineResultNameKey] = c.[PipelineResultNameKey]
	)
SELECT
	b.[PipelineResultKey] AS [PipelineRunResultKey]
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
	,c.[PipelineResultName] AS [PipelineRunResultName]
	,b.[PipelineResultValue] AS [PipelineRunResultValue]
	,d.[PipelineResultKey] AS [PipelineActivityResultKey]
	,d.[PipelineActivityRunStatus]
	,d.[PipelineActivityRunID]
	,d.[PipelineActivityStartDateTime]
	,d.[PipelineActivityEndDateTime]
	,d.[PipelineResultName] AS [PipelineActivityResultName]
	,d.[PipelineResultValue] AS [PipelineActivityResultValue]
FROM
	[DIF].[PipelineRunDetail] AS a
	INNER JOIN [logging].[PipelineResult] AS b ON
		a.[PipelineRunKey] = b.[PipelineRunKey]
	INNER JOIN [reference].[PipelineResultName] AS c ON
		b.[PipelineResultNameKey] = c.[PipelineResultNameKey]
	LEFT OUTER JOIN [PipelineActivityResultDetail] AS d ON
		a.[PipelineRunKey] = d.[PipelineRunKey];

GO

