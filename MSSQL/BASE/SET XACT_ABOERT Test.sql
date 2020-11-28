 USE TestDB
 GO
 /*************************************************************************************************
 SET XACT_ABOERT 
 1.�⺻�� OFF : ���� �κи� �ѹ�
 2.ON : ���߿� ������ �߻��� ��� ��ü �ѹ�
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
	SET XACT_ABOERT OFF ���·ν� TBLTempStageV2�� ��� Value�� UNIQUE�� ���� ���� �߻�
	������ TBLTempStageV1�� ���� ������ ���� �� ���� �κи� �ѹ�
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
	SET XACT_ABOERT ON ���·ν� ��ü �ѹ�
*/
EXEC dbo._SUpSertStageDataV1 @Value = 1
SELECT * FROM dbo.TBLTempStageV1
SELECT * FROM dbo.TBLTempStageV2



/*
	BEGIN TRAY ~ END CATCH ROLLBACK TRAN ���� ���� �߻��� ��ü�� ��
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

