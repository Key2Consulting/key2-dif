

CREATE   VIEW [DIF].[PipelineRunDetail]
AS

SELECT
	b.[PipelineRunKey]
	,a.[ProjectType]
	,a.[ProjectName]
	,a.[PipelineShortName]
	,a.[PipelineFolder]
	,a.[PipelineFullName]
	,c.[PipelineStatus] as [PipelineRunStatus]
	,b.[PipelineRunID]
	,b.[PipelineRunStartDateTime]
	,b.[PipelineRunEndDateTime]
FROM
	[DIF].[PipelineDetail] AS a
	INNER JOIN [logging].[PipelineRun] AS b ON
		a.[PipelineKey] = b.[PipelineKey]
	INNER JOIN [reference].[PipelineStatus] AS c ON
		b.[PipelineRunStatusKey] = c.[PipelineStatusKey];

GO

