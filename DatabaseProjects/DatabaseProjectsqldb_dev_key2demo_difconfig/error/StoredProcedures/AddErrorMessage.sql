
-- =============================================
-- Author:     Key2
-- Create Date: 2022.03.22
-- Description: Basic error logging for debug purposes

/*
EXEC error.AddErrorMessage 'test'
SELECT * FROM [error].[ErrorLog]
*/

-- =============================================
CREATE PROCEDURE [error].[AddErrorMessage]
(
	@ErrorMessage VARCHAR(4000)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    INSERT INTO [error].[ErrorLog]
    (
		[ErrorMessage]
		,[CreatedDateTime]
	)
	VALUES
		(@ErrorMessage
		,GETUTCDATE())
END

GO

