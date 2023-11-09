

CREATE   PROCEDURE [DIF].[ValidateDIGroupConfigurations]
	(
	@DIGroupName VARCHAR(50)
	)
AS

/*

SP Name:  [DIF].[ValidateDIGroupConfigurations]
Purpose:  Used to get load details for a given set of tasks associated with a data integration group and its execution order
Parameters:
     @DIGroupName - the key for a given data integration group
	 

Test harnass:

EXEC [DIF].[ValidateDIGroupConfigurations]
	@DIGroupName = 'All DW Views'

*/

BEGIN

DECLARE
	@DIGroupKey INT;

BEGIN TRY

SELECT
	@DIGroupKey = a.DIGroupKey
FROM
	[config].[DIGroup] AS a
WHERE
	a.DIGroupName = @DIGroupName;

IF @DIGroupKey IS NULL
	THROW 50101, 'An unknown data integration task was identified by the @DIGroupName parameter.', 1;

--- Validation Checks
--	○ [config].DIGroupTask DIGroupTaskPriorityOrder must not be NULL
--	○ PartitionBoundary must contain NULL condition
--	○ Incremental Load Types
--		§ Must include "MinWaterMark" and "MaxWaterMark" DITaskWaterMarkLogic value
--		§ Must have Watermark Attribute record set
--	○ Full Load Types
--		Must have Partition Attribute record set

DECLARE @ConfigErrors varchar(max)

set @ConfigErrors = ''

	/**
	Check to see if there are any [config].DIGroupTask records for this DIGroupName.
	**/
	IF not exists (
				SELECT *
				FROM [config].DIGroupTask
				WHERE DIGroupKey = @DIGroupKey
				)
	BEGIN
		set @ConfigErrors = @ConfigErrors + '****This DIGroup does not have any DITasks assigned to it.'+char(13)
	END

	/**
	Check to see if there are any [config].DIGroupTask records with a NULL DIGroupTaskPriorityOrder value.	
	**/
	IF exists (
				SELECT *
				FROM [config].DIGroupTask
				WHERE DIGroupKey = @DIGroupKey
				AND DIGroupTaskPriorityOrder is null
				)
	BEGIN
		set @ConfigErrors = @ConfigErrors + '****This DIGroup has a task assigned to it without a DIGroupTaskPriorityOrder set.'+char(13)
	END

	/**
	For an incremental load type, check to see that there is an appropriate [metadata].Attribute record is set.	
	**/
	IF exists (
				SELECT t.DITaskKey
						,sum(case when a.AttributeKey is not null then 1 else 0 end)
				FROM [config].DIGroupTask gt
					INNER JOIN [config].DITask t	
						ON gt.DITaskKey = t.DITaskKey
					INNER JOIN [reference].LoadType lt
						on t.LoadTypeKey = lt.LoadTypeKey
					LEFT OUTER  JOIN [metadata].Dataset sds
						ON t.SourceDatasetKey = sds.DatasetKey
					LEFT OUTER JOIN [metadata].Attribute a
						ON sds.DatasetKey = a.DatasetKey
						AND a.AttributeIsWaterMark = 1
				WHERE gt.DIGroupKey = @DIGroupKey
				AND lt.LoadType in ('Full then Incremental','Incremental')
				GROUP BY t.DITaskKey
				HAVING sum(case when a.AttributeKey is not null then 1 else 0 end) = 0
				)
	BEGIN
		set @ConfigErrors = @ConfigErrors + '****This DIGroup has an incremental load task assigned to it without a corresponding [metadata].Attribute AttributeIsWaterMark set.'+char(13)
	END

	

	/**
	For an incremental load type, check to see that the "%MinWaterMark%" and "%MaxWaterMark%" placeholder values are included.	
	**/
	IF exists (
				SELECT t.DITaskKey
				FROM [config].DIGroupTask gt
					INNER JOIN [config].DITask t	
						ON gt.DITaskKey = t.DITaskKey
					INNER JOIN [reference].LoadType lt
						on t.LoadTypeKey = lt.LoadTypeKey
				WHERE gt.DIGroupKey = @DIGroupKey
				AND lt.LoadType in ('Full then Incremental','Incremental')
				AND (
						t.DITaskWaterMarkLogic is null
						OR t.DITaskWaterMarkLogic not like '%[%]MinWaterMark[%]%'
						OR t.DITaskWaterMarkLogic not like '%[%]MaxWaterMark[%]%'
					)
				)
	BEGIN
		set @ConfigErrors = @ConfigErrors + '****This DIGroup has an incremental load task that does not include the MinWaterMark and MaxWaterMark placeholder values.'+char(13)
	END

	/**
	For a full load type, check to see that there is an appropriate partition [metadata].Attribute record is set.	
	**/
	IF exists (
				SELECT t.DITaskKey
						,sum(case when a.AttributeKey is not null then 1 else 0 end)
				FROM [config].DIGroupTask gt
					INNER JOIN [config].DITask t	
						ON gt.DITaskKey = t.DITaskKey
					INNER JOIN [reference].LoadType lt
						on t.LoadTypeKey = lt.LoadTypeKey
					INNER JOIN [metadata].Dataset sds
						ON t.SourceDatasetKey = sds.DatasetKey
					INNER JOIN [reference].PartitionType pt
						ON sds.PartitionTypeKey = pt.PartitionTypeKey
					LEFT OUTER JOIN [metadata].Attribute a
						ON sds.DatasetKey = a.DatasetKey
						AND a.AttributePartitionKeyOrder > 0
				WHERE gt.DIGroupKey = @DIGroupKey
				AND lt.LoadType in ('Full Only')
				AND pt.PartitionType <> 'None'
				GROUP BY t.DITaskKey
				HAVING sum(case when a.AttributeKey is not null then 1 else 0 end) = 0
				)
	BEGIN
		set @ConfigErrors = @ConfigErrors + '****This DIGroup has a full load (partition) task assigned to it without a corresponding [metadata].Attribute AttributePartitionKeyOrder set.'+char(13)
	END



	IF @ConfigErrors = ''
	BEGIN
		print 'There are no validation issues with this DIGroup.'
	END
	ELSE
	BEGIN
		THROW 50101, @ConfigErrors, 1;
	END

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

