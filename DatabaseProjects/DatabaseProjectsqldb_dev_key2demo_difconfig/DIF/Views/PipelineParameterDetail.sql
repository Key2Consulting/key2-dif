
CREATE   VIEW [DIF].[PipelineParameterDetail]
AS

SELECT
	b.[PipelineParameterKey]
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
	,b.[PipelineParameterPhase]
	,b.[PipelineParameterName]
	,b.[PipelineParameterValue]
FROM
	[DIF].[PipelineRunDetail] AS a
	INNER JOIN [logging].[PipelineParameter] AS b ON
		a.[PipelineRunKey] = b.[PipelineRunKey];

GO

