

CREATE   PROCEDURE [DIF].[UpdateDIGroup]
	(
	 @DIGroupKey SMALLINT
	,@DIGroupName VARCHAR(50)
	,@ProjectName VARCHAR(50)
	,@DIGroupIsEnabled BIT
	)
AS

/*

SP Name:  [DIF].[UpdateDIGroup]
Purpose:  Used to update a DIF DIGroup record
Parameters:
	@DIGroupKey - key value for the given DIGroup
	@DIGroupName - name for the updated DIGroup
	@ProjectName - key value for the Pipeline associated with this new DIGroup
	@DIGroupIsEnabled - bit value to determine if it is enabled or not

Test harnass:

SELECT * FROM [config].[Pipeline]
SELECT * FROM [config].[DIGroup]

EXEC [DIF].[UpdateDIGroup]
	 @DIGroupKey = 12
	,@DIGroupName = 'Config DIGroup Test'
	,@ProjectName = 'Test SQL Server Ingestion Framework'
	,@DIGroupIsEnabled = 0

*/

BEGIN

DECLARE
	@ProjectKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the parameters are populated
*************************************************************************************************/
IF (@DIGroupKey IS NULL OR @DIGroupName IS NULL OR @ProjectName IS NULL OR @DIGroupIsEnabled IS NULL)
	THROW 50101, 'The @DIGroupKey, @DIGroupName, @DIGroupIsEnabled and @ProjectName parameters must be specified.', 1;


/*************************************************************************************************
Check for the @ProjectName value
*************************************************************************************************/
SELECT
	@ProjectKey = ProjectKey
FROM
	[config].Project
WHERE
	ProjectName = @ProjectName

IF @ProjectKey IS NULL
	THROW 50105, 'An unknown Project was identified by the @ProjectName parameter.', 1;

/*************************************************************************************************
Check for the @DIGroupKey value
*************************************************************************************************/
IF not exists (select DIGroupKey from [config].DIGroup where DIGroupKey = @DIGroupKey)
	THROW 50105, 'An unknown DIGroup was identified by the @DIGroupKey parameter.', 1;

/*************************************************************************************************
Check to verify that the DIGroupName provided doesn't already exist for the given Pipeline
*************************************************************************************************/

IF exists(select DIGroupKey from [config].DIGroup where DIGroupName = @DIGroupName AND ProjectKey = @ProjectKey and DIGroupKey <> @DIGroupKey)
	THROW 50102, 'The provided DIGroup values already exists in the [config].DIGroup table for the given Pipeline.', 1;

/*************************************************************************************************
Update [config].DIGroup record
*************************************************************************************************/
	BEGIN TRAN;

		UPDATE [config].DIGroup
		SET ProjectKey = @ProjectKey
			,DIGroupName = @DIGroupName
			,DIGroupIsEnabled = @DIGroupIsEnabled
			,ModifiedBy = suser_sname()
			,ModifiedDateTime = getutcdate()
		WHERE DIGroupKey = @DIGroupKey;

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

