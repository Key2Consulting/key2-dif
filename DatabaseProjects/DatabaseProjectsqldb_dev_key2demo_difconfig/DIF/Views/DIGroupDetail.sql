


CREATE   VIEW [DIF].[DIGroupDetail]
AS

SELECT
	b.[DIGroupKey]
	,a.[ProjectType]
	,a.[ProjectName]
	,b.[DIGroupName]
	,b.[DIGroupIsEnabled]
FROM
	[DIF].[ProjectDetail] AS a
	INNER JOIN [config].[DIGroup] AS b ON
		a.ProjectKey = b.ProjectKey

GO

