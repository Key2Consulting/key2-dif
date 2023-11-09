

CREATE   PROCEDURE [DIF].[UpdateMaxHighWaterMark]
	(
	@DITaskKey INT
	,@MaxHighWaterMark VARCHAR(255)
	)
AS

/*

SP Name:  [DIF].[UpdateMaxHighWaterMark]
Purpose:  Used to update the max high water mark for a DITask
Parameters:
	@DITaskKey - the key for the DITask record to be updated
	@MaxHighWaterMark - the new max value for the high water mark

Test harnass:

SELECT * FROM [config].[DITask];

EXEC [DIF].[UpdateMaxHighWaterMark] 
	@DITaskKey = 11,
	@MaxHighWaterMark = 4;

*/

BEGIN

DECLARE
   @DITaskKeyCheck SMALLINT;

BEGIN TRY

SELECT
	@DITaskKeyCheck = a.[DITaskKey]
FROM
	[config].[DITask] AS a
WHERE
	a.[DITaskKey] = @DITaskKey;

IF @DITaskKeyCheck IS NULL
	THROW 50101, 'An unknown DITask was identified by the @DITaskKey parameter.', 1;

UPDATE
	a
SET
	[DITaskMaxWaterMark] = @MaxHighWaterMark
	,[DITaskLastExtractDateTime] = GETUTCDATE()
FROM
	[config].[DITask] AS a
WHERE
	[DITaskKey] = @DITaskKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

