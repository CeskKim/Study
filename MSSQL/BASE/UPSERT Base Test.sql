USE TestDB
GO
--/*************************************************************************************************
-- ���̺� ����
--**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLPattern') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLPattern
	(
		Seq	INT				,
		Val	NVARCHAR(20)	,
		
		CONSTRAINT PK_TBLPattern PRIMARY KEY(Seq)
	)
END
DECLARE @SNum	INT

SELECT @SNum = 1

WHILE @SNum <= 100
BEGIN
	INSERT INTO TBLPattern
	SELECT @SNum, N'������_' + CONVERT(NVARCHAR, @SNum) 
	 WHERE NOT EXISTS(SELECT 1 
						FROM TBLPattern
					   WHERE @SNum = Seq)
	SELECT @SNum = @SNum + 1
END

/*************************************************************************************************
  UPSERT anti-pattern Procedure ����
  1.��Ƽ������ ��� -> �⺻Ű ���� �߻� ����
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPUPSERTPattern') AND xtype = 'P')
DROP PROC _SPUPSERTPattern
GO
CREATE PROC _SPUPSERTPattern
@Seq	INT

AS	
	BEGIN TRAN
	SET NOCOUNT ON 
	IF EXISTS(SELECT 1 
				FROM TBLPattern 
			   WHERE Seq = @Seq)
	BEGIN
		UPDATE TBLPattern 
		   SET Val = N'Anti�����͵�����_' + CONVERT(NVARCHAR, @Seq)
		 WHERE Seq = @Seq
		 
	END
	ELSE
	BEGIN
		INSERT INTO TBLPattern
		SELECT @Seq, N'������_' + CONVERT(NVARCHAR, @Seq) 
	END
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		COMMIT TRAN
	END

WAITFOR DELAY '00:00:05'
EXEC _SPUPSERTPattern 105
GO 10 

/*************************************************************************************************
 UPDATE ���� (UPDLOCK, SERIALIZABLE)�߰� 
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPUPSERTPattern') AND xtype = 'P')
DROP PROC _SPUPSERTPattern
GO
CREATE PROC _SPUPSERTPattern
@Seq	INT

AS	BEGIN TRAN
	SET NOCOUNT ON 
	UPDATE TBLPattern WITH(UPDLOCK, SERIALIZABLE)
	   SET Val = N'Anti�����͵�����_' + CONVERT(NVARCHAR, @Seq)
	 WHERE Seq = @Seq
	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO TBLPattern
		SELECT @Seq, N'������_' + CONVERT(NVARCHAR, @Seq) 
	END
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		COMMIT TRAN
	END

WAITFOR DELAY '00:00:05'
EXEC _SPUPSERTPattern 106
GO 5 


/*************************************************************************************************
 INSERT ���� EXISTS (UPDLOCK, SERIALIZABLE)�߰� 
**************************************************************************************************/

IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPUPSERTPattern') AND xtype = 'P')
DROP PROC _SPUPSERTPattern
GO
CREATE PROC _SPUPSERTPattern
@Seq	INT

AS	
	BEGIN TRAN
	SET NOCOUNT ON 
	IF EXISTS(SELECT 1 FROM TBLPattern WITH(UPDLOCK, SERIALIZABLE) WHERE Seq = @Seq)
	BEGIN
		UPDATE TBLPattern
		  SET Val = N'Anti�����͵�����_' + CONVERT(NVARCHAR, @Seq)
		WHERE Seq = @Seq
	END

	ELSE
	BEGIN
		INSERT INTO TBLPattern
		SELECT @Seq, N'������_' + CONVERT(NVARCHAR, @Seq) 
	END
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		COMMIT TRAN
	END

WAITFOR DELAY '00:00:05'
EXEC _SPUPSERTPattern 107
GO 5 
