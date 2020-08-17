USE TestDB
GO

/*************************************************************************************************
 ���̺� ����
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
 ������ ����
**************************************************************************************************/
DECLARE @BNum	INT,
		@ENum	INT

SELECT @BNum = 1,
	   @ENum = 100
WHILE(@BNum <= @ENum)
BEGIN
	INSERT INTO TBLParallel(OrderName, OrderDate)
	SELECT  N'�ֹ���' + CAST(@BNum AS NVARCHAR), CASE WHEN @BNum % 2 = 0 THEN CONVERT(NCHAR(8),DATEADD(DD, 1, GETDATE()),112)
												 ELSE CONVERT(NCHAR(8),GETDATE(),112) END
	SELECT @BNum = @BNum + 1
END


/*************************************************************************************************
 ���Ļ��� Ȯ��
**************************************************************************************************/
DBCC TRACEON (3604); 
DBCC SHOWWEIGHTS; 


/*************************************************************************************************
 ���ĵ��� ���� ����
**************************************************************************************************/
 SELECT COUNT(*)
   FROM TBLParallel

/*************************************************************************************************
 �Ӱ谪 ����
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
 CPU ����ġ ����
 1.CPU�� ����ġ ������ ���� ���� ���� Ʈ�� ��� 5�� �ʰ� -> �Ӱ谪(5)�� �ʰ��Ͽ� ����ó�� ����
 2.����ó���� ��� �Ӱ谪�� �������� ó���Ͽ� �Ӱ谪�� ������ �������� ����ó�� ���� ����
**************************************************************************************************/
DBCC FREEPROCCACHE
DBCC SETCPUWEIGHT(10000); 
GO
 SELECT COUNT(*)
   FROM TBLParallel OPTION(RECOMPILE, querytraceon 8649)

--CPU ����ġ, IO����ġ ����
DBCC SETCPUWEIGHT(1); 
DBCC SETIOWEIGHT(1);
