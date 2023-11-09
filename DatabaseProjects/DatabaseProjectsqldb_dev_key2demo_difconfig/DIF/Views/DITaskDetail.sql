


CREATE   VIEW [DIF].[DITaskDetail]
AS

select
	a.[DITaskKey]
	,b.DatasetKey as SourceDatasetKey
	,b.[SystemType] as [SourceSystemType]
	,b.[SystemName] as [SourceSystemName]
	,b.[SystemFQDN] as [SourceSystemFQDN]
	,b.[SystemUserName] as [SourceSystemUserName]
	,b.[SystemSecretName] as [SourceSystemSecretName]
	,b.[SystemIsEnabled] as [SourceSystemIsEnabled]
	,b.[RepositoryType] as [SourceRepositoryType]
	,b.[RepositoryName] as [SourceRepositoryName]
	,b.[RepositoryIsEnabled] as [SourceRepositoryIsEnabled]
	,b.[StorageType] as [SourceStorageType]
	,b.[DatasetClass] as [SourceDatasetClass]
	,b.[PartitionType] as [SourcePartitionType]
	,b.[DatasetNameSpace] as [SourceDatasetNameSpace]
	,b.[DatasetName] as [SourceDatasetName]
	,b.[DatasetPath] as [SourceDatasetPath]
	,b.[LogicalDatabaseName] as SourceLogicalDatabaseName
	,b.[DatasetInternalVersionID] as [SourceDatasetInternalVersionID]
	,b.[DatasetIsEnabled] as [SourceDatasetIsEnabled]
	,c.[DatasetKey] as DestinationDatasetKey
	,c.[SystemType] as [DestinationSystemType]
	,c.[SystemName] as [DestinationSystemName]
	,c.[SystemFQDN] as [DestinationSystemFQDN]
	,c.[SystemUserName] as [DestinationSystemUserName]
	,c.[SystemSecretName] as [DestinationSystemSecretName]
	,c.[SystemIsEnabled] as [DestinationSystemIsEnabled]
	,c.[RepositoryType] as [DestinationRepositoryType]
	,c.[RepositoryName] as [DestinationRepositoryName]
	,c.[RepositoryIsEnabled] as [DestinationRepositoryIsEnabled]
	,c.[StorageType] as [DestinationStorageType]
	,c.[DatasetClass] as [DestinationDatasetClass]
	,c.[PartitionType] as [DestinationPartitionType]
	,c.[DatasetNameSpace] as [DestinationDatasetNameSpace]
	,c.[DatasetName] as [DestinationDatasetName]
	,c.[DatasetPath] as [DestinationDatasetPath]
	,c.[LogicalDatabaseName] as DestinationLogicalDatabaseName
	,c.[DatasetInternalVersionID] as [DestinationDatasetInternalVersionID]
	,c.[DatasetIsEnabled] as [DestinationDatasetIsEnabled]
	,d.[LoadType]
	,d.[SubsequentLoadTypeKey]
	,a.[DITaskSourceFilterLogic]
	,a.[SourceFilterLogicIsEnabled]
	,a.[SourceOverrideQuery]
	,a.[SourceAuditQuery]
	,a.[DITaskWaterMarkLogic]
	,a.[DITaskMaxWaterMark]
	,a.[DITaskLastExtractDateTime]
	,a.[DITaskIsEnabled]
	,a.[NotebookPath]
from
	[config].[DITask] as a
	inner join [DIF].[DatasetDetail] as b on
		a.[SourceDatasetKey] = b.[DatasetKey]
	inner join [DIF].[DatasetDetail] as c on
		a.[DestinationDatasetKey] = c.[DatasetKey]
	inner join [reference].[LoadType] as d on
		a.[LoadTypeKey] = d.[LoadTypeKey];

GO

