



CREATE     PROCEDURE [DIF].[AddDIGroup]
	(
	 @DIGroupName VARCHAR(50)
	,@ProjectName VARCHAR(50)
	,@DIGroupIsEnabled BIT
	,@DIGroupKey SMALLINT OUTPUT
	)
AS

/*

SP Name:  [DIF].[DIGroup]
Purpose:  Used to add a new DIF DIGroup
Parameters:
	@DIGroupName - name for the new DIGroup
	@ProjectName - name for the Project associated with this new DIGroup
	@DIGroupIsEnabled - bit value to determine if it is enabled or not

Test harnass:

SELECT * FROM [config].[Project]
SELECT * FROM [config].[DIGroup]

DECLARE @DK SMALLINT

EXEC [DIF].[AddDIGroup]
	@DIGroupName = 'Group Testzz'
	,@ProjectName = 'Test SQL Server Ingestion Framework'
	,@DIGroupIsEnabled = 1
	,@DIGroupKey = @DK OUTPUT

SELECT @DK

*/

BEGIN

DECLARE
	@DIGroupCheckKey SMALLINT
	,@ProjectKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the required parameters are populated
*************************************************************************************************/
IF (@DIGroupName IS NULL OR @ProjectName IS NULL)
	THROW 50101, 'The @DIGroupName and @ProjectName parameters must be specified.', 1;

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
Check to verify that the DIGroupName provided doesn't already exist
*************************************************************************************************/
SELECT
	@DIGroupCheckKey = DIGroupKey
FROM
	[config].DIGroup
WHERE
	DIGroupName = @DIGroupName
	AND ProjectKey = @ProjectKey

IF @DIGroupCheckKey IS NOT NULL
	THROW 50102, 'The provided DIGroup values already exists in the [config].DIGroup table for the given Pipeline.  Please use the DIF.UpdateDIGroup store procedure to update any values in that table.', 1;


/*************************************************************************************************
Add new [config].DIGroup record
*************************************************************************************************/
	BEGIN TRAN;

		INSERT INTO [config].[DIGroup]
			(
			 [ProjectKey]
			 , [DIGroupName]
			 , [DIGroupIsEnabled]
			 , [CreatedBy]
			 , [CreatedDateTime]
			 , [ModifiedBy]
			 , [ModifiedDateTime]
			)
		VALUES
			(
			@ProjectKey
			,@DIGroupName
			,@DIGroupIsEnabled
			,suser_sname()
			,getutcdate()
			,suser_sname()
			,getutcdate()
			);

		SET @DIGroupKey = SCOPE_IDENTITY();

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

