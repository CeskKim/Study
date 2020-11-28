 USE TestDB
 GO
 /*************************************************************************************************
 SET XACT_ABOERT 
 1.기본값 OFF : 오류 부분만 롤백
 2.ON : 도중에 오류가 발생한 경우 전체 롤백
**************************************************************************************************/
CREATE TABLE dbo.TBLTempStageV1
(
	ID TINYINT NOT NULL IDENTITY(1,1) 
,	SpId SMALLINT
,	Value INT
)

CREATE TABLE dbo.TBLTempStageV2
(
	ID TINYINT NOT NULL IDENTITY(1,1) 
,	SpId SMALLINT
,	Value INT NOT NULL UNIQUE	
)


CREATE OR ALTER PROCEDURE dbo._SUpSertStageDataV1
@Value	INT
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT OFF

	BEGIN TRAN
	INSERT INTO TBLTempStageV1 (SpId,Value)
	VALUES(@@SPID, @Value)

	INSERT INTO TBLTempStageV2(SpId,Value)
	VALUES(@@SPID, @Value)
	COMMIT TRAN
END

/*
	SET XACT_ABOERT OFF 상태로써 TBLTempStageV2의 경우 Value가 UNIQUE로 인해 오류 발생
	하지만 TBLTempStageV1의 경우는 데이터 삽입 즉 오류 부분만 롤백
*/
EXEC dbo._SUpSertStageDataV1 @Value = 1
SELECT * FROM dbo.TBLTempStageV1
SELECT * FROM dbo.TBLTempStageV2


CREATE OR ALTER PROCEDURE dbo._SUpSertStageDataV1
@Value	INT
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRAN
	INSERT INTO TBLTempStageV1 (SpId,Value)
	VALUES(@@SPID, @Value)

	INSERT INTO TBLTempStageV2(SpId,Value)
	VALUES(@@SPID, @Value)
	COMMIT TRAN
END

/*
	SET XACT_ABOERT ON 상태로써 전체 롤백
*/
EXEC dbo._SUpSertStageDataV1 @Value = 1
SELECT * FROM dbo.TBLTempStageV1
SELECT * FROM dbo.TBLTempStageV2



/*
	BEGIN TRAY ~ END CATCH ROLLBACK TRAN 으로 오류 발생시 전체롤 백
*/

CREATE OR ALTER PROCEDURE dbo._SUpSertStageDataV1
@Value	INT
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		BEGIN TRAN

		INSERT INTO TBLTempStageV1 (SpId,Value)
		VALUES(@@SPID, @Value)

		INSERT INTO TBLTempStageV2(SpId,Value)
		VALUES(@@SPID, @Value)

		COMMIT
	END TRY
	BEGIN CATCH
		
		SELECT ERROR_MESSAGE() AS ErrorMesssage;

		IF @@TRANCOUNT > 0 
		BEGIN
			ROLLBACK TRAN
		END
	END CATCH
END


EXEC dbo._SUpSertStageDataV1 @Value = 1
SELECT * FROM dbo.TBLTempStageV1
SELECT * FROM dbo.TBLTempStageV2

