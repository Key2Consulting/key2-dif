
CREATE   VIEW [DIF].[AttributeDetail]
AS

SELECT
	b.[AttributeKey]
	,a.[EnvironmentType]
	,a.[SystemType]
	,a.[SystemName]
	,a.[SystemFQDN]
	,a.[SystemIsEnabled]
	,a.[RepositoryType]
	,a.[RepositoryName]
	,a.[RepositoryIsEnabled]
	,a.[StorageType]
	,a.[DatasetClass]
	,a.[PartitionType]
	,a.[DatasetNameSpace]
	,a.[DatasetName]
	,a.[DatasetPath]
	,a.[DatasetInternalVersionID]
	,a.[DatasetIsLatestVersion]
	,a.[DatasetIsCreated]
	,a.[DatasetIsEnabled]
	,b.[AttributeName]
	,b.[AttributeSequenceNumber]
	,c.[DataType]
	,b.[AttributeMaxLength]
	,b.[AttributePrecision]
	,b.[AttributeScale]
	,b.[AttributeIsNullable]
	,b.[AttributeIsPrimaryKey]
	,b.[AttributeIsUnique]
	,b.[AttributeIsForeignKey]
	,b.[AttributeIsWaterMark]
	,b.[AttributePartitionKeyOrder]
	,b.[AttributeDistributionKeyOrder]
	,b.[AttributeIsEnabled]
FROM
	[DIF].[DatasetDetail] AS a
	INNER JOIN [metadata].[Attribute] AS b ON
		a.[DatasetKey] = b.[DatasetKey]
	INNER JOIN [reference].[DataType] AS c ON
		b.[DataTypeKey] = c.[DataTypeKey];

GO

