

CREATE   VIEW [DIF].[ProjectDetail]
AS

SELECT
	a.[ProjectKey]
	,b.[ProjectType]
	,a.[ProjectName]
FROM
	[config].[Project] AS a
	INNER JOIN [reference].[ProjectType] AS b ON
		a.[ProjectTypeKey] = b.[ProjectTypeKey];

GO

