


CREATE     PROCEDURE [DIF].[AddProject]
	(
	@ProjectType VARCHAR(50)
	,@ProjectName VARCHAR(50)
	,@ProjectKey SMALLINT OUTPUT
	)
AS

/*

SP Name:  [DIF].[AddProject]
Purpose:  Used to add a new DIF Project
Parameters:
	@ProjectType - identifies the project type name
	@ProjectName - identifies the new project name

Test harnass:

SELECT * FROM [reference].[ProjectType]
SELECT * FROM [config].[Project]

DECLARE @PK SMALLINT

EXEC [DIF].[AddProject]
	@ProjectType = 'Test Platform'
	,@ProjectName = 'Test'
	,@ProjectKey = @PK OUTPUT

SELECT @PK

*/

BEGIN

DECLARE
	@ProjectCheckKey SMALLINT
	,@ProjectTypeKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the parameters are populated
*************************************************************************************************/
IF (@ProjectType IS NULL OR @ProjectName IS NULL)
	THROW 50101, 'Both the @ProjectType and @ProjectName parameters must be specified.', 1;


/*************************************************************************************************
Check to verify that the ProjectName provided doesn't already exist and should be an update
*************************************************************************************************/
SELECT
	@ProjectCheckKey = ProjectKey
FROM
	[config].Project
WHERE
	ProjectName = @ProjectName;

IF @ProjectCheckKey IS NOT NULL
	THROW 50102, 'The provided @ProjectName value already exists in the [config].Project table.  Please use the DIF.UpdateProject store procedure to update any values in that table.', 1;


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
Add new [config].Project record
*************************************************************************************************/
	BEGIN TRAN;

		INSERT INTO [config].[Project]
			(
			[ProjectTypeKey]
			, [ProjectName]
			, [CreatedBy]
			, [CreatedDateTime]
			, [ModifiedBy]
			, [ModifiedDateTime]
			)
		VALUES
			(
			@ProjectTypeKey
			,@ProjectName
			,suser_sname()
			,getutcdate()
			,suser_sname()
			,getutcdate()
			);

		SET @ProjectKey = SCOPE_IDENTITY();

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

