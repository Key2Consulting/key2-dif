
CREATE   PROCEDURE [DIF].[UpdateDITaskLoadType]
	(
	@DITaskKey INT
	,@LoadType VARCHAR(50)
	)
AS

/*

SP Name:  [DIF].[UpdateDITaskLoadType]
Purpose:  Used to update the load type for a DITask
Parameters:
	@DITaskKey - the key for the DITask record to be updated
	@LoadType - the value of the load type to be set

Test harnass:

SELECT * FROM [reference].[LoadType];
SELECT * FROM [config].[DITask];

EXEC [DIF].[UpdateDITaskLoadType] 
	@DITaskKey = 11,
	@LoadType = 'Incremental'

*/

BEGIN

DECLARE
	@DITaskKeyCheck INT
	,@LoadTypeKey SMALLINT;

BEGIN TRY

SELECT
	@DITaskKeyCheck = a.[DITaskKey]
FROM
	[config].[DITask] AS a
WHERE
	a.[DITaskKey] = @DITaskKey;

IF @DITaskKeyCheck IS NULL
	THROW 50101, 'An unknown data integration task was identified by the @DITaskKey parameter.', 1;

SELECT
	@LoadTypeKey = a.[LoadTypeKey]
FROM
	[reference].LoadType AS a
WHERE
	a.[LoadType] = @LoadType;

IF @LoadTypeKey IS NULL
	THROW 50101, 'An unknown load type was identified by the @LoadType parameter.', 1;

UPDATE
	a
SET
	[LoadTypeKey] = @LoadTypeKey
FROM
	[config].[DITask] AS a
WHERE
	a.[DITaskKey] = @DITaskKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

