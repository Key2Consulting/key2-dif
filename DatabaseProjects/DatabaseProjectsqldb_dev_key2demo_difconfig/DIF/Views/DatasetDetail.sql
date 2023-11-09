

CREATE   VIEW [DIF].[DatasetDetail]
AS

SELECT
	b.[DatasetKey]
	,a.[EnvironmentType]
	,a.[SystemType]
	,a.[SystemName]
	,a.[SystemFQDN]
	,a.[SystemUserName]
	,a.[SystemSecretName]
	,a.[SystemIsEnabled]
	,a.[RepositoryType]
	,a.[RepositoryName]
	,a.[RepositoryIsEnabled]
	,d.[StorageType]
	,c.[DatasetClass]
	,e.[PartitionType]
	,b.[DatasetNameSpace]
	,b.[DatasetName]
	,b.[DatasetDescription]
	,b.[DatasetPath]
	,b.[DatasetInternalVersionID]
	,b.[DatasetExternalVersionID]
	,b.[DatasetIsLatestVersion]
	,b.[DatasetIsCreated]
	,b.[DatasetIsEnabled]
	,b.[LogicalDatabaseName]
FROM
	[DIF].[RepositoryDetail] AS a
	INNER JOIN [metadata].[Dataset] AS b ON
		a.[RepositoryKey] = b.[RepositoryKey]
	INNER JOIN [reference].[DatasetClass] AS c ON
		b.[DatasetClassKey] = c.[DatasetClassKey]
	INNER JOIN [reference].[StorageType] AS d ON
		b.[StorageTypeKey] = d.[StorageTypeKey]
	INNER JOIN [reference].[PartitionType] AS e ON
		b.[PartitionTypeKey] = e.[PartitionTypeKey]

GO

