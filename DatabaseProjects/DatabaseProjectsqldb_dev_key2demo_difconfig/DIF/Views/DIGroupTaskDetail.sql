


CREATE   VIEW [DIF].[DIGroupTaskDetail]
AS

SELECT
	a.[DIGroupTaskKey]
	,b.[ProjectType]
	,b.[ProjectName]
	,d.[PipelineShortName]
	,d.[PipelineFullName]
	,a.[DIGroupKey]
	,b.[DIGroupName]
	,b.[DIGroupIsEnabled]
	,a.[DIGroupTaskPriorityOrder]
	,c.[DITaskKey]
	,c.[SourceSystemName]
	,c.[SourceSystemIsEnabled]
	,c.[SourceRepositoryName]
	,c.[SourceRepositoryIsEnabled]
	,c.[SourceDatasetNameSpace]
	,c.[SourceDatasetName]
	,c.[SourceDatasetIsEnabled]
	,c.[DestinationSystemName]
	,c.[DestinationSystemIsEnabled]
	,c.[DestinationRepositoryName]
	,c.[DestinationRepositoryIsEnabled]
	,c.[DestinationDatasetNameSpace]
	,c.[DestinationDatasetName]
	,c.[DestinationDatasetIsEnabled]
	,c.[DITaskSourceFilterLogic]
	,c.[DITaskWaterMarkLogic]
	,c.[DITaskMaxWaterMark]
	,c.[DITaskLastExtractDateTime]
	,c.[DITaskIsEnabled]
	,a.RelatedDIGroupTaskKey
	,e.DITaskKey as RelatedDITaskKey
	,e.PipelineKey as RelatedPipelineKey
	,f.PipelineFullName as RelatedPipelineFullName
FROM
	[config].[DIGroupTask] AS a
	INNER JOIN [DIF].[DIGroupDetail] AS b ON
		a.[DIGroupKey] = b.[DIGroupKey]
	INNER JOIN [DIF].[DITaskDetail] AS c ON
		a.[DITaskKey] = c.[DITaskKey]
	INNER JOIN DIF.PipelineDetail AS d ON
		a.PipelineKey = d.PipelineKey
	LEFT OUTER JOIN [config].[DIGroupTask] e ON
		a.RelatedDIGroupTaskKey = e.DIGroupTaskKey
	LEFT OUTER JOIN DIF.PipelineDetail AS f ON
		e.PipelineKey = f.PipelineKey;

GO

