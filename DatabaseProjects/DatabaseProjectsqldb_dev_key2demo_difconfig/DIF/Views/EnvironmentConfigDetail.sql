

CREATE   VIEW [DIF].[EnvironmentConfigDetail]
AS

SELECT
	b.[EnvironmentConfigKey]
	,a.[ProjectType]
	,a.[ProjectName]
	,b.[EnvironmentConfigName]
	,b.[EnvironmentConfigValue]
FROM
	[DIF].[ProjectDetail] AS a
	inner join [config].[EnvironmentConfig] AS b ON
		a.[ProjectKey] = b.[ProjectKey];

GO

