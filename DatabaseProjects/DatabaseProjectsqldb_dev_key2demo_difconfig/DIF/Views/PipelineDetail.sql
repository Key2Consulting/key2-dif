
CREATE   VIEW [DIF].[PipelineDetail]
AS

SELECT
	b.[PipelineKey]
	,a.[ProjectType]
	,a.[ProjectName]
	,b.[PipelineShortName]
	,b.[PipelineFolder]
	,b.[PipelineFullName]
	,b.PipelineDescription
FROM
	[DIF].[ProjectDetail] AS a
	INNER JOIN [config].[Pipeline] AS b ON
		a.[ProjectKey] = b.[ProjectKey];

GO

