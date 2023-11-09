

CREATE   VIEW [DIF].[DataSetAttributeDetail]
AS

SELECT
	a.[SystemName]
	,a.[SystemFQDN]
	,a.[SystemIsEnabled]
	,b.[RepositoryName]
	,b.[RepositoryIsEnabled]
	,c.[DatasetNameSpace]
	,c.[DatasetName]
	,c.[DatasetPath]
	,c.[DatasetIsEnabled]
	,d.[AttributeName]
	,e.[DataType]
	,d.[AttributeMaxLength]
	,d.[AttributePrecision]
	,d.[AttributeScale]
	,d.[AttributeIsNullable]
	,d.[AttributeIsPrimaryKey]
FROM
	[metadata].[System] AS a
	INNER JOIN [metadata].[Repository] AS b ON
		a.[SystemKey] = b.[SystemKey]
	INNER JOIN [metadata].[Dataset] AS c ON
		b.[RepositoryKey] = c.[RepositoryKey]
	LEFT OUTER JOIN [metadata].[Attribute] AS d ON
		c.[DatasetKey] = d.[DatasetKey]
	LEFT OUTER JOIN [reference].[DataType] AS e ON
		d.[DataTypeKey] = e.[DataTypeKey];

GO

