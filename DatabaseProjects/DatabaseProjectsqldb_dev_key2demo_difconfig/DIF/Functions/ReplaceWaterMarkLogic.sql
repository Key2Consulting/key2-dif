
--liquibase formatted sql

--changeset tomhuneke:function-DIF.ReplaceWaterMarkLogic runOnChange:true endDelimiter:GO
CREATE   FUNCTION [DIF].[ReplaceWaterMarkLogic]
(
	 @DITaskKey		INT			
	,@MaxWaterMark  VARCHAR(255) 

)
RETURNS VARCHAR(1000)
AS
/*
Function Name:  DIF.ReplaceWaterMarkLogic
Purpose:  Used to build the WarterMarkLogic string for all Incremental or Full then Incremental load types
Parameters:
     @DITaskKey - the key for a given data integration group
	 @MaxWaterMark  - This value is returned from a query against the source prior to the copy operation

Test harnass:

SELECT DIF.ReplaceWaterMarkLogic(18,'2021-09-16T15:36:20.23')

*/
BEGIN


DECLARE @DITaskWaterMark VARCHAR(1000)

SELECT @DITaskWaterMark = 
							replace(--This replaces the %MaxWaterMark% placeholder value with the one just queried from the source
									replace(--This replaces the %MinWaterMark% placeholder value with the previous load's max value
											DT.DITaskWaterMarkLogic
											,'%MinWaterMark%'
											,case when DT2.DataType in ('tinyint','smallint','int','bigint') then isNull(NullIf(DT.DITaskMaxWaterMark,''),'0')
													when DT2.DataType in ('smalldatetime','datetime','datetime2','date') then ''''+isNull(NullIf(DT.DITaskMaxWaterMark,''),'1/1/1900')+''''
												else ''
											 end
											)
									,'%MaxWaterMark%'
									,''''+@MaxWaterMark+''''
								)
FROM [config].DITask DT
	INNER JOIN [metadata].Dataset AS DS 
		ON DT.SourceDatasetKey = DS.DatasetKey
	LEFT OUTER JOIN [metadata].Attribute A2
		ON DS.DatasetKey = A2.DatasetKey 
		AND A2.AttributeIsEnabled = 1
		AND A2.AttributeIsWaterMark = 1
	LEFT JOIN [reference].DataType DT2 
		ON A2.DataTypeKey=DT2.DataTypeKey 
WHERE DT.DITaskKey = @DITaskKey
AND DT.DITaskIsEnabled = 1


RETURN @DITaskWaterMark

END

GO

