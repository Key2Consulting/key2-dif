

CREATE     PROCEDURE [DIF].[UpdateProject]
	(
	 @ProjectKey SMALLINT
	,@ProjectType VARCHAR(50)
	,@ProjectName VARCHAR(50)
	)
AS

/*

SP Name:  [DIF].[UpdateProject]
Purpose:  Used to update a DIF Project record
Parameters:
	@ProjectKey
	@ProjectType - identifies the project type name
	@ProjectName - identifies the new project name

Test harnass:

SELECT * FROM [reference].[ProjectType]

EXEC [DIF].[UpdateProject]
	 @ProjectKey = 6
	,@ProjectType = 'Test Platform'
	,@ProjectName = 'Test SQL DIF'

*/

BEGIN

DECLARE
	@ProjectTypeKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the parameters are populated
*************************************************************************************************/
IF (@ProjectKey IS NULL OR @ProjectType IS NULL OR @ProjectName IS NULL)
	THROW 50101, 'All three @ProjectKey, @ProjectType and @ProjectName parameters must be specified.', 1;


/*************************************************************************************************
Check to verify that the ProjectKey already exists in the [config].Project table
*************************************************************************************************/
SELECT
	@ProjectKey = ProjectKey
FROM
	[config].Project
WHERE
	ProjectName = @ProjectName;

IF NOT EXISTS(select ProjectKey from [config].Project where ProjectKey = @ProjectKey)
	THROW 50102, 'The provided @ProjectKey does not exists in the [config].Project table.  Please check the [config].Project to find the correct value.', 1;


/*************************************************************************************************
Check for the @ProjectTypeKey value
*************************************************************************************************/
SELECT
	@ProjectTypeKey = a.ProjectTypeKey
FROM
	[reference].[ProjectType] AS a
WHERE
	a.ProjectType = @ProjectType;

IF @ProjectTypeKey IS NULL
	THROW 50105, 'An unknown ProjectType class was identified by the @ProjectName parameter.', 1;


/*************************************************************************************************
Update [config].Project record
*************************************************************************************************/
	BEGIN TRAN;

		UPDATE [config].Project
		SET ProjectTypeKey = @ProjectTypeKey
			,ProjectName = @ProjectName
			,ModifiedBy = suser_sname()
			,ModifiedDateTime = getutcdate()
		WHERE ProjectKey = @ProjectKey;

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

