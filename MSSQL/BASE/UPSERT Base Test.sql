USE TestDB
GO
--/*************************************************************************************************
-- 테이블 생성
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
	SELECT @SNum, N'데이터_' + CONVERT(NVARCHAR, @SNum) 
	 WHERE NOT EXISTS(SELECT 1 
						FROM TBLPattern
					   WHERE @SNum = Seq)
	SELECT @SNum = @SNum + 1
END

/*************************************************************************************************
  UPSERT anti-pattern Procedure 생성
  1.멀티쓰레드 사용 -> 기본키 오류 발생 여지
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
		   SET Val = N'Anti데이터데이터_' + CONVERT(NVARCHAR, @Seq)
		 WHERE Seq = @Seq
		 
	END
	ELSE
	BEGIN
		INSERT INTO TBLPattern
		SELECT @Seq, N'데이터_' + CONVERT(NVARCHAR, @Seq) 
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
 UPDATE 구문 (UPDLOCK, SERIALIZABLE)추가 
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPUPSERTPattern') AND xtype = 'P')
DROP PROC _SPUPSERTPattern
GO
CREATE PROC _SPUPSERTPattern
@Seq	INT

AS	BEGIN TRAN
	SET NOCOUNT ON 
	UPDATE TBLPattern WITH(UPDLOCK, SERIALIZABLE)
	   SET Val = N'Anti데이터데이터_' + CONVERT(NVARCHAR, @Seq)
	 WHERE Seq = @Seq
	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO TBLPattern
		SELECT @Seq, N'데이터_' + CONVERT(NVARCHAR, @Seq) 
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
 INSERT 구문 EXISTS (UPDLOCK, SERIALIZABLE)추가 
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
		  SET Val = N'Anti데이터데이터_' + CONVERT(NVARCHAR, @Seq)
		WHERE Seq = @Seq
	END

	ELSE
	BEGIN
		INSERT INTO TBLPattern
		SELECT @Seq, N'데이터_' + CONVERT(NVARCHAR, @Seq) 
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
