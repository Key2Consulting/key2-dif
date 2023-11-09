

CREATE   VIEW [DIF].[SystemDetail]
AS

SELECT
	a.[SystemKey]
	,c.[EnvironmentType]
	,b.[SystemType]
	,a.[SystemName]
	,a.[SystemDescription]
	,a.[SystemProgram]
	,a.[SystemFQDN]
	,a.[SystemUserName]
	,a.[SystemSecretName]
	,a.[SystemIsEnabled]
FROM
	[metadata].[System] AS a
	INNER JOIN [reference].[SystemType] AS b ON
		a.[SystemTypeKey] = b.[SystemTypeKey]
	INNER JOIN [reference].[EnvironmentType] AS c ON
		a.[EnvironmentTypeKey] = c.[EnvironmentTypeKey];

GO

