/*********************************************************************************
BEGIN TRY
    �Ϲݽ���
END TRY
BEGIN CATHCN
	�����߻�
END CATCH
**********************************************************************************/
BEGIN TRY
	SELECT 1 /1
	SELECT 1/ 0 
END TRY
BEGIN CATCH
	SELECT
		N'���� �߻�'
	,	ERROR_NUMBER() 
END CATCH
GO
/*********************************************************************************
PROCEDURE RETURN Ȯ��
**********************************************************************************/
CREATE OR ALTER PROC dbo._SPCityList
@CityCode INT
AS
	BEGIN TRY

		SELECT
			*
		FROM dbo.City
		WHERE
			CityCode = @CityCode
	END TRY
	BEGIN CATCH
		SELECT N'���� �߻�'
		
		RETURN 000
	END CATCH

RETURN 1;
GO
DECLARE @RETURN INT
EXEC @RETURN = _SPCityList 0
SELECT @RETURN