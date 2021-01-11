/*********************************************************************************
BEGIN TRY
    일반실행
END TRY
BEGIN CATHCN
	에러발생
END CATCH
**********************************************************************************/
BEGIN TRY
	SELECT 1 /1
	SELECT 1/ 0 
END TRY
BEGIN CATCH
	SELECT
		N'에러 발생'
	,	ERROR_NUMBER() 
END CATCH
GO
/*********************************************************************************
PROCEDURE RETURN 확인
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
		SELECT N'에러 발생'
		
		RETURN 000
	END CATCH

RETURN 1;
GO
DECLARE @RETURN INT
EXEC @RETURN = _SPCityList 0
SELECT @RETURN