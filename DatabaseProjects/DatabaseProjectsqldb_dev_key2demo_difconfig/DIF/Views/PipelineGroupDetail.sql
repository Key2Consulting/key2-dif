

CREATE   VIEW [DIF].[PipelineGroupDetail]
AS

SELECT
	b.[PipelineGroupKey]
	,a.[ProjectType]
	,a.[ProjectName]
	,b.[PipelineGroupName]
	,b.[PipelineGroupIsEnabled]
	,c.[PipelineFolder] AS [ParentPipelineFolder]
	,c.[PipelineFullName] AS [ParentPipelineFullName]
	,d.[PipelineFolder] AS [ChildPipelineFolder]
	,d.[PipelineFullName] AS [ChildPipelineFullName]
FROM
	[DIF].[ProjectDetail] AS a
	INNER JOIN [config].[PipelineGroup] AS b ON
		a.[ProjectKey] = b.[ProjectKey]
	INNER JOIN [config].[Pipeline] AS c ON
		b.[ParentPipelineKey] = c.[PipelineKey]
	INNER JOIN [config].[Pipeline] AS d ON
		b.[ChildPipelineKey] = d.[PipelineKey];

GO

