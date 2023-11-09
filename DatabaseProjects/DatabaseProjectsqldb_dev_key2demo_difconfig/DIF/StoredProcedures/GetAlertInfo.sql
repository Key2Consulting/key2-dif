

CREATE     PROCEDURE [DIF].[GetAlertInfo]
	(
	@ProjectName VARCHAR(50)
	)
AS

/*

SP Name:  [DIF].[GetAlertInfo]
Purpose:  Used to get the load queries and file name info for a given task.  It builds the source query that will be passed to the copy operation.
Parameters:
     @ProjectName - Name of the project associated with the given Alert

Test harnass:

select * from [config].Alert
select * from [config].Project

EXEC [DIF].[GetAlertInfo]
	@ProjectName = 'Test SQL Server Ingestion Framework'

*/

BEGIN

DECLARE
		@ProjectKey INT

BEGIN TRY

--Check to see that the ProjectName parameter matches a config record
SELECT
	@ProjectKey = a.ProjectKey
FROM
	[config].Project AS a
WHERE
	a.ProjectName = @ProjectName;

IF @ProjectKey IS NULL
	THROW 50101, 'An unknown Project value was identified by the @ProjectName parameter.', 1;



SELECT a.AlertRecipient
FROM [config].Alert a
WHERE a.ProjectKey = @ProjectKey

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

