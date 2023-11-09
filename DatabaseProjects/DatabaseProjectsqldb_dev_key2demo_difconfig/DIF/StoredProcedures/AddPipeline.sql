


CREATE     PROCEDURE [DIF].[AddPipeline]
	(
	 @ProjectName VARCHAR(50)
	,@PipelineShortName VARCHAR(50)
	,@PipelineFullName VARCHAR(255)
	,@PipelineFolder VARCHAR(255)
	,@PipelineDescription VARCHAR(255)
	,@PipelineKey SMALLINT OUTPUT
	)
AS

/*

SP Name:  [DIF].[AddPipeline]
Purpose:  Used to add a new DIF Project
Parameters:
	@ProjectName - identifies the new project name
	@PipelineShortName - new PipelineShortName value
	@PipelineFullName - new PipelineFullName as it is deployed in ADF
	@PipelineFolder - new PipelineFolder value from ADF
	@PipelineDescription - new PipelineDescription value

Test harnass:

SELECT * FROM [config].[Project]
SELECT * FROM [config].Pipeline

DECLARE @PK SMALLINT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'Test Project'
	,@PipelineShortName = 'Test PL'
	,@PipelineFullName = 'PL_TEST'
	,@PipelineFolder = 'PL_TEST'
	,@PipelineDescription = 'This is a test of the AddPipeline stored proc'
	,@PipelineKey = @PK OUTPUT

SELECT @PK

*/

BEGIN

DECLARE
	@ProjectKey SMALLINT
	,@PipelineCheckKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the required parameters are populated
*************************************************************************************************/
IF (@ProjectName IS NULL OR @PipelineShortName IS NULL OR @PipelineFullName IS NULL)
	THROW 50101, 'All three of the @ProjectName, @PipelineShortName and @PipelineFullName parameters must be specified.', 1;


/*************************************************************************************************
Check for the @ProjectKey value
*************************************************************************************************/
SELECT
	@ProjectKey = a.ProjectKey
FROM
	[config].[Project] AS a
WHERE
	a.ProjectName = @ProjectName;

IF @ProjectKey IS NULL
	THROW 50105, 'An unknown Project was identified by the @ProjectName parameter.', 1;

/*************************************************************************************************
Check to verify that the Pipeline provided doesn't already exist and should be an update
*************************************************************************************************/
SELECT
	@PipelineCheckKey = PipelineKey
FROM
	[config].Pipeline
WHERE
	PipelineShortName = @PipelineShortName
	AND PipelineFullName = @PipelineFullName
	AND ProjectKey = @ProjectKey

IF @PipelineCheckKey IS NOT NULL
	THROW 50102, 'The provided PipelineShortName and PipelineFullName values for the given ProjectName already exists in the [config].Pipeline table.  Please use the DIF.UpdatePipeline store procedure to update any values in that table.', 1;



/*************************************************************************************************
Add new [config].Pipeline record
*************************************************************************************************/
	BEGIN TRAN;

		INSERT INTO [config].[Pipeline]
			(
			 [ProjectKey]
			 , [PipelineShortName]
			 , [PipelineFullName]
			 , [PipelineFolder]
			 , [PipelineDescription]
			 , [CreatedBy]
			 , [CreatedDateTime]
			 , [ModifiedBy]
			 , [ModifiedDateTime]
			)
		VALUES
			(
			@ProjectKey
			,@PipelineShortName
			,@PipelineFullName
			,@PipelineFolder
			,@PipelineDescription
			,suser_sname()
			,getutcdate()
			,suser_sname()
			,getutcdate()
			);

		SET @PipelineKey = SCOPE_IDENTITY();

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

