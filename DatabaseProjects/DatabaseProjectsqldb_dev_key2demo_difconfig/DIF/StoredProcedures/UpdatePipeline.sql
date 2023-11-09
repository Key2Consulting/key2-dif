

CREATE   PROCEDURE [DIF].[UpdatePipeline]
	(
	 @PipelineKey SMALLINT
	,@ProjectName VARCHAR(50)
	,@PipelineShortName VARCHAR(50)
	,@PipelineFullName VARCHAR(255)
	,@PipelineFolder VARCHAR(255) = null
	,@PipelineDescription VARCHAR(255) = null
	)
AS

/*

SP Name:  [DIF].[UpdatePipeline]
Purpose:  Used to update a DIF Project record
Parameters:
	@PipelineKey - identifies the updated Pipeline
	@ProjectName - identifies the new Pipeline name
	@PipelineShortName - new PipelineShortName value
	@PipelineFullName - new PipelineFullName as it is deployed in ADF
	@PipelineFolder - new PipelineFolder value from ADF
	@PipelineDescription - new PipelineDescription value

Test harnass:

SELECT * FROM [reference].[ProjectType]

EXEC [DIF].[UpdatePipeline]
	 @PipelineKey = 12
	,@ProjectName = 'Test SQL DIF'
	,@PipelineShortName = 'TEST PIPELINE'
	,@PipelineFullName = 'PL_TEST_Pipeline'
	,@PipelineFolder = 'PL Test'
	,@PipelineDescription = 'This is a test of the UpdatePipeline stored proc'

*/

BEGIN

DECLARE
	@ProjectKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the parameters are populated
*************************************************************************************************/
IF (@PipelineKey IS NULL OR @ProjectName IS NULL OR @PipelineShortName IS NULL OR @PipelineFullName IS NULL)
	THROW 50101, 'The @PipelineKey, @ProjectName, @PipelineShortName and @PipelineFullName parameters must be specified.', 1;


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
Update [config].Pipeline record
*************************************************************************************************/
	BEGIN TRAN;

		UPDATE [config].Pipeline
		SET ProjectKey = @ProjectKey
			,PipelineShortName = @PipelineShortName
			,PipelineFullName = @PipelineFullName
			,PipelineFolder = isNull(@PipelineFolder, PipelineFolder)
			,PipelineDescription = isNull(@PipelineDescription,PipelineDescription)
			,ModifiedBy = suser_sname()
			,ModifiedDateTime = getutcdate()
		WHERE PipelineKey = @PipelineKey;

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

