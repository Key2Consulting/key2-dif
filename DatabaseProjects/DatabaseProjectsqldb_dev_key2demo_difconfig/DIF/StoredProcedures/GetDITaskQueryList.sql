


CREATE   PROCEDURE [DIF].[GetDITaskQueryList]
	(
	@DITaskKey INT
	,@MaxWaterMark varchar(255)
	,@MinPartitionValue varchar(255)
	,@MaxPartitionValue varchar(255)
	)
AS

/*

SP Name:  [DIF].[GetDITaskQueryList]
Purpose:  Used to get the load queries and file name info for a given task.  It builds the source query that will be passed to the copy operation.
Parameters:
     @DITaskKey - the key for a given data integration task
	 @MaxWaterMark - This is the new max high watermark value that has just been calculated from the source.  It acts as the upper boundary for the filter criteria.
	 @MinPartitionValue - For DITasks that have a partition, this value is calculated with the SourceAuditQuery to filter out any partition boundary records that are earlier than this value.
	,@MaxPartitionValue - For DITasks that have a partition, this value is calculated with the SourceAuditQuery to filter out any partition boundary records that are greater than this value.

Test harnass:

select * from [metadata].Dataset
select * from DIF.DITaskDetail

EXEC [DIF].[GetDITaskQueryList]
	@DITaskKey = 47
	,@MaxWaterMark = ''--'2019-09-15T14:54:12.537'
	,@MinPartitionValue  = '-1'
	,@MaxPartitionValue = '15'

*/

BEGIN

DECLARE
	@TestDIGroupTaskKey INT;

BEGIN TRY

SELECT
	@TestDIGroupTaskKey = a.[DITaskKey]
FROM
	[config].DITask AS a
WHERE
	a.DITaskKey = @DITaskKey;

IF @TestDIGroupTaskKey IS NULL
	THROW 50101, 'An unknown data integration task was identified by the @DITaskKey parameter.', 1;

declare @sql nvarchar(max) = ''
		,@PartitionType varchar(50)
		,@PartitionTypeKey smallint
		,@LoadType varchar(50)
		,@PartitionAttribute varchar(255)
		,@PartitionAttributeDataType varchar(50)

drop table if exists #PB

create table #PB (
	DITaskKey int
	,PartitionTypeKey smallint
	,PartitionType varchar(50)
	,PartitionBoundaryKey smallint
	,PartitionBoundaryMinValue varchar(50)
	,PartitionBoundaryIncludeMin bit
	,PartitionBoundaryMaxValue varchar(50)
	,PartitionBoundaryIncludeMax bit
)


--This query checks to see if the DITask is a Full load and has an active partition column setup
select @PartitionType = td.SourcePartitionType
		,@PartitionTypeKey = sds.PartitionTypeKey
		,@LoadType = td.LoadType
		,@PartitionAttribute = pa.AttributeName
		,@PartitionAttributeDataType = dt.DataType
from DIF.DITaskDetail td
	inner join [metadata].Dataset sds
		on td.SourceDatasetKey = sds.DatasetKey
	inner join [metadata].Attribute pa
		on td.SourceDatasetKey = pa.DatasetKey
	inner join [reference].DataType dt
		on pa.DataTypeKey = dt.DataTypeKey
where DITaskKey = @DITaskKey
and td.SourcePartitionType <> 'None'
and td.LoadType like 'Full%'
and pa.AttributePartitionKeyOrder > 0
and pa.AttributeIsEnabled = 1

--If the DITask has an active partition column, this query is built dynamically to handle the different column data types
if @PartitionType is not null
begin

	set @sql = 'insert into #PB(DITaskKey,PartitionTypeKey,PartitionType,PartitionBoundaryKey,PartitionBoundaryMinValue,PartitionBoundaryIncludeMin,PartitionBoundaryMaxValue,PartitionBoundaryIncludeMax)
				select ' + cast(@DITaskKey as varchar(50)) + ' as DITaskKey
						,PB1.PartitionTypeKey
						,''' + @PartitionType + ''' as PartitionType
						,PB1.PartitionBoundaryKey
						,PB1.PartitionBoundaryMinValue
						,PB1.PartitionBoundaryIncludeMin
						,PB1.PartitionBoundaryMaxValue
						,PB1.PartitionBoundaryINcludeMax
				from [config].[PartitionBoundary] PB1
				where  PB1.PartitionTypeKey = '+cast(@PartitionTypeKey as varchar(50))+'
				and (
							(
								cast('''+IsNull(@MaxPartitionValue,'')+''' as '+@PartitionAttributeDataType+') >= cast(NullIf(PB1.PartitionBoundaryMinValue,''NULL'') as '+@PartitionAttributeDataType+')
								and cast('''+IsNull(@MinPartitionValue,'')+''' as '+@PartitionAttributeDataType+') < cast(NullIf(PB1.PartitionBoundaryMaxValue,''NULL'') as '+@PartitionAttributeDataType+')
							)
							or PartitionBoundaryMinValue in (''NULL'',''1900-01-01'')
						)
			'

			print @sql
			exec sp_executesql @sql
end



SELECT 
		
		TD.SourceDatasetName as DatasetName
		,isNull(A2.AttributeName,'') AS WaterMark_Column
		,isNull(@PartitionAttribute,'') AS Partition_Column
		,@PartitionAttributeDataType AS Partition_Type
		,CASE WHEN TD.SourceOverrideQuery IS NOT NULL /*and TD.LoadType = 'Incremental'*/ THEN TD.SourceOverrideQuery --Check to see if there is an override query, if not then use the standard DatasetPath value to build the source query
			 ELSE 'SELECT * 
					FROM '+TD.SourceDatasetPath+ ' AS T1 
					WHERE 1=1 '
		 END
			/****Add logic to handle partition scenario*****/
			+CASE WHEN @PartitionAttribute is not null and TD.LoadType like 'Full%' THEN--Begin check to see if a dataset has a partition
			' and T1.'+isNull(@PartitionAttribute,'')+' '+CASE WHEN PB.PartitionBoundaryMinValue = 'NULL' THEN ' is null '--Begin check for NULL boundary
																					ELSE
																						CASE WHEN PB.PartitionBoundaryMinValue = PB.PartitionBoundaryMaxValue THEN '='--Begin check for comparison
																								WHEN PB.[PartitionBoundaryIncludeMin] = 1 THEN '>='
																								WHEN PB.[PartitionBoundaryIncludeMin] = 0 THEN '>' 
																							END+'  '--End check for comparison
																						+CASE WHEN @PartitionType = 'Year' THEN ' CONVERT('+@PartitionAttributeDataType+', ''' + convert(varchar(50),DATEFROMPARTS(PB.[PartitionBoundaryMinValue], 01, 01)) + ''')'--Begin check for min value
																							ELSE ' CONVERT('+@PartitionAttributeDataType+', ''' +PB.PartitionBoundaryMinValue + ''') '
																						END--End check for min value
																					END+ --End check for NULL
				CASE WHEN PB.PartitionBoundaryMaxValue <> 'NULL' THEN 
						CASE WHEN PB.PartitionBoundaryMinValue <> PB.PartitionBoundaryMaxValue THEN 
							' AND T1.'+isNull(@PartitionAttribute,'')+' '+CASE WHEN PB.PartitionBoundaryMinValue = PB.PartitionBoundaryMaxValue THEN '='--Begin check for comparison
																										WHEN PB.[PartitionBoundaryIncludeMax] = 1 THEN '<='
																										WHEN PB.[PartitionBoundaryIncludeMax] = 0 THEN '<' 
																									END+' '--End check for comparison
																					+CASE WHEN @PartitionType = 'Year' THEN ' CONVERT('+@PartitionAttributeDataType+', ''' + CONVERT(varchar(50), DATEFROMPARTS(PB.[PartitionBoundaryMaxValue], 01, 01)) + ''')'--Begin check for max value
																								ELSE ' CONVERT('+@PartitionAttributeDataType+', ''' + PB.PartitionBoundaryMaxValue + ''')'
																							END --End check for max value
								ELSE ''
							END
							else ''
						END
					ELSE ''
				end--End check to see if a dataset has a partition
			/***Add logic to handle high watermark scenario***/
				+CASE WHEN A2.AttributeName is not null and TD.LoadType = 'Incremental' THEN DIF.ReplaceWaterMarkLogic(@DITaskKey,@MaxWaterMark)
					ELSE ''
				END--End WaterMarkLogic
			/***Add logic to include source filter ***/
				+CASE WHEN TD.DITaskSourceFilterLogic is not null and TD.SourceFilterLogicIsEnabled = 1 THEN ' ' + TD.DITaskSourceFilterLogic
					ELSE ''
				END
				as LoadSQL
		,REPLACE(REPLACE(CASE WHEN TD.LoadType like 'Full%' THEN 
						CASE WHEN PB.PartitionBoundaryMinValue = 'NULL' THEN 'NULL_'
							WHEN @PartitionType = 'Year' THEN PB.PartitionBoundaryMinValue+'_'+PB.PartitionBoundaryMaxValue+'_'
							WHEN @PartitionType = 'Quarter' THEN convert(varchar(50),cast(PB.PartitionBoundaryMinValue as datetime2(0)),112)+'_'+convert(varchar(50),cast(PB.PartitionBoundaryMaxValue as datetime2(0)),112)+'_'
							WHEN @PartitionType <> 'None' THEN PB.PartitionBoundaryMinValue+'_'
						ELSE convert(varchar(255),cast(getdate() as datetime2(0)),112)+'_'+replace(convert(varchar(255),cast(getdate() as datetime2(0)),108),':','.')+'_'
						END
				WHEN TD.LoadType = 'Incremental' THEN
						case when DT2.DataType in ('tinyint','smallint','int','bigint') then @MaxWaterMark+'_'
							when DT2.DataType in ('smalldatetime','datetime','datetime2','date') then convert(varchar(255),cast(@MaxWaterMark as datetime2(0)),112)+'_'+replace(convert(varchar(255),cast(@MaxWaterMark as datetime2(0)),108),':','.')+'_'
						else ''
						end
				ELSE ''
			END 
			+TD.SourceDatasetPath+'.parquet', '[', ''), ']', '')
			AS IngestionFileName
		--LoadFolder currently follows this pattern:
		--<DestinationDatasetPath>\<SourceDatasetPat>\<LoadType>\<year>\<month>\<day>
		--Example: dbserver\db.dbo.testtable\incremental\2021\11\05
		,REPLACE(REPLACE(TD.DestinationDatasetPath+'\'+TD.SourceDataSetPath+'\'+
												CASE TD.LoadType WHEN 'Incremental' THEN 'incremental'
													ELSE 'full'
												END
												+'\'+CAST(DATEPART(YYYY,GETUTCDATE()) AS VARCHAR(4))
												+'\'+RIGHT('00'+CAST(DATEPART(MM,GETUTCDATE()) AS VARCHAR(2)),2)
												+'\'+RIGHT('00'+CAST(DATEPART(DD,GETUTCDATE()) AS VARCHAR(2)),2), '[', ''), ']', '')
		AS LoadFolder
from DIF.DITaskDetail TD
	left outer join #PB pb
		on TD.DITaskKey = pb.DITaskKey
	LEFT OUTER JOIN [metadata].Attribute A2--Watermark 
		ON TD.SourceDatasetKey = A2.DatasetKey 
		and A2.AttributeIsEnabled = 1
		and A2.AttributeIsWaterMark = 1
	LEFT JOIN [reference].DataType DT2 
		ON A2.DataTypeKey=DT2.DataTypeKey 
WHERE TD.DITaskKey = @DITaskKey
and TD.DITaskIsEnabled = 1

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

