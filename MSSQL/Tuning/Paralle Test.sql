USE TestDB
GO

/*************************************************************************************************
 테이블 생성
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLParallel') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLParallel
	(
		ID			INT IDENTITY (1,1) PRIMARY KEY,
		OrderName	NVARCHAR(100)				  ,
		OrderDate	NCHAR(8)
	)
END

/*************************************************************************************************
 데이터 삽입
**************************************************************************************************/
DECLARE @BNum	INT,
		@ENum	INT

SELECT @BNum = 1,
	   @ENum = 100
WHILE(@BNum <= @ENum)
BEGIN
	INSERT INTO TBLParallel(OrderName, OrderDate)
	SELECT  N'주문명' + CAST(@BNum AS NVARCHAR), CASE WHEN @BNum % 2 = 0 THEN CONVERT(NCHAR(8),DATEADD(DD, 1, GETDATE()),112)
												 ELSE CONVERT(NCHAR(8),GETDATE(),112) END
	SELECT @BNum = @BNum + 1
END


/*************************************************************************************************
 병렬상태 확인
**************************************************************************************************/
DBCC TRACEON (3604); 
DBCC SHOWWEIGHTS; 


/*************************************************************************************************
 병렬되지 않은 쿼리
**************************************************************************************************/
 SELECT COUNT(*)
   FROM TBLParallel

/*************************************************************************************************
 임계값 설정
**************************************************************************************************/
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO
EXEC sp_configure 'cost threshold for parallelism', 5;
RECONFIGURE;
GO
EXEC sp_configure 'show advanced options', 0;
RECONFIGURE;


/*************************************************************************************************
 CPU 가중치 증가
 1.CPU의 가중치 증가를 통해 예상 하위 트리 비용 5를 초과 -> 임계값(5)를 초과하여 병렬처리 진행
 2.병렬처리의 경우 임계값을 기준으로 처리하여 임계값을 강제로 증가시켜 병렬처리 유도 가능
**************************************************************************************************/
DBCC FREEPROCCACHE
DBCC SETCPUWEIGHT(10000); 
GO
 SELECT COUNT(*)
   FROM TBLParallel OPTION(RECOMPILE, querytraceon 8649)

--CPU 가중치, IO가중치 원복
DBCC SETCPUWEIGHT(1); 
DBCC SETIOWEIGHT(1);
