

CREATE   VIEW [DIF].[RepositoryDetail]
AS

SELECT
	b.[RepositoryKey]
	,a.[EnvironmentType]
	,a.[SystemType]
	,a.[SystemName]
	,a.[SystemFQDN]
	,a.[SystemUserName]
	,a.[SystemSecretName]
	,a.[SystemIsEnabled]
	,c.[RepositoryType]
	,b.[RepositoryName]
	,b.[RepositoryDescription]
	,b.[RepositoryPathPattern]
	,b.[RepositoryIsEnabled]
FROM
	[DIF].[SystemDetail] AS a
	INNER JOIN [metadata].[Repository] AS b ON
		a.[SystemKey] = b.[SystemKey]
	INNER JOIN [reference].[RepositoryType] AS c ON
		b.[RepositoryTypeKey] = c.[RepositoryTypeKey];

GO

