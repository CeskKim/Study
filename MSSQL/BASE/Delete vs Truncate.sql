USE TestDB
GO
/*************************************************************************************************
 ���̺� ���� �� �ε��� ���� 
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLDelete') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLDelete
	(
		EmpSeq	INT				,
		EmpID	NVARCHAR(20)	,
		EmpName	NVARCHAR(30)	,

		CONSTRAINT PK_TBLDelete PRIMARY KEY(EmpSeq)
	)
END

INSERT INTO TBLDelete(EmpSeq, EmpID, EmpName)
SELECT 1, N'20200902-001', N'ȫ�浿' WHERE NOT EXISTS(SELECT 1 FROM TBLDelete WHERE EmpSeq = 1)
INSERT INTO TBLDelete(EmpSeq, EmpID, EmpName)
SELECT 2, N'20200902-002', N'��ö��' WHERE NOT EXISTS(SELECT 1 FROM TBLDelete WHERE EmpSeq = 2)
INSERT INTO TBLDelete(EmpSeq, EmpID, EmpName)
SELECT 3, N'20200902-003', N'���屺' WHERE NOT EXISTS(SELECT 1 FROM TBLDelete WHERE EmpSeq = 3)

/*************************************************************************************************
 DELETE üũ
 1.ROLLBACK ����, ������ ���� ����
**************************************************************************************************/
BEGIN TRAN
DELETE FROM TBLDelete WHERE EmpSeq = 3
SELECT * FROM TBLDelete 
GO
ROLLBACK TRAN
SELECT * FROM TBLDelete

/*************************************************************************************************
 ������ Ȯ��
 *IAM(Index Allocation Map) :  ���̺� �ε��� �� ����, �ε��� ������� Heap�� �����ϱ� ���� �ϳ��� IAM����
 1.DBCC IND(DB��, ���̺�, �ɼ�)
   => �ɼ� - 2 : ��� IAM Page ����, -1 : ��� �������� ����, 1: Clustered INDEX ����, 2 ~ 254 : NONClustered INDEX ����
   => PageType = 10 : IAM Page
 2.DBCC PAGE(DB��, ���Ϲ�ȣ, ��������ȣ, �ɼ�)
   => DBCC TRACEON(3604) �÷��� ������ ON���� �� ����
   => �ɼ� 0 : �����, 1 : �����, 2 : ������ ����, 3 : �� �׸��� Į�� ������
**************************************************************************************************/
--DELETE ��
SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 141880, 3)  WITH TABLERESULTS   
	
--DELETE ��
--Data�� Heap�� �����ϴ� ��� ������ �Ҵ������� ���� ����
DELETE FROM TBLDelete

SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 141880, 3) WITH TABLERESULTS 

/*************************************************************************************************
 ������ �Ҵ� ����(DELETE)
 1.WITH(TABLOCK) 
 2.TRUNCATE ���
**************************************************************************************************/
--DELETE ��
SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 149976, 3)  WITH TABLERESULTS 

--DELETE ��
DELETE FROM TBLDelete WITH(TABLOCK) 

SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 149976, 3) WITH TABLERESULTS 

--TRUNCATE
TRUNCATE TABLE TBLDelete
SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 149976, 3) WITH TABLERESULTS 


/*************************************************************************************************
 Ʈ����� �α� DELETE �α� Ȯ��
**************************************************************************************************/
SELECT [Current LSN]	
	  ,[Operation]		
	  ,[Transaction ID] 
	  ,[Begin Time]
	  ,LEFT ([Description], 40) AS [Description]
  FROM fn_dblog(NULL, NULL)
 WHERE AllocUnitName LIKE '%TBLDelete%'


 /*************************************************************************************************
 TRUNCATE üũ
 1.ROLLBACK ����, ������ ���� �Ұ���
 2.IDENTITY SEED �缳��, ������ �Ҵ� ������ ���� �ش� �������� �ٸ� �������� ��� ����
 3.FOREIGN KEY  ������ ���� �Ұ���
**************************************************************************************************/
BEGIN TRAN
TRUNCATE TABLE TBLDelete
SELECT * FROM TBLDelete 
GO
ROLLBACK TRAN
SELECT * FROM TBLDelete

--FOREIGN KEY ����
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLDeleteForegin') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLDeleteForegin
	(
		OrderSeq			INT				,
		OrderDate			NCHAR(8)		,
		OrderName			NVARCHAR(30)	,
		EmpSeq				INT
		
		CONSTRAINT PK_TBLDeleteForegin PRIMARY KEY (OrderSeq)
		CONSTRAINT FK_TBLDeleteForegin FOREIGN KEY (EmpSeq) REFERENCES TBLDelete(EmpSeq)
	)
END

--���� ���̺��� �����Ͱ� �����ؾ߸� �����ϴ� ������ INSERT ����
INSERT INTO TBLDeleteForegin(OrderSeq,OrderDate,OrderName,EmpSeq)
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLDeleteForegin WHERE OrderSeq = 1)
INSERT INTO TBLDeleteForegin(OrderSeq,OrderDate, OrderName,EmpSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLDeleteForegin WHERE OrderSeq = 2)

--FOREIGN KEY ������ �Ǿ� �ִ� ���� ���̺� TRUNCATE �� ���� �߻�
--���̺� 'TBLDelete'��(��) FOREIGN KEY ���� ���ǿ� ���� �����ǹǷ� �ڸ� �� �����ϴ�. �޽��� �߻�
TRUNCATE TABLE TBLDelete



/*************************************************************************************************
 Ʈ����� �α� TRUNCATE �α� Ȯ��
**************************************************************************************************/
SELECT [Current LSN]	
	  ,[Operation]		
	  ,[Transaction ID] 
	  ,[Begin Time]
	  ,LEFT ([Description], 40) AS [Description]
  FROM fn_dblog(NULL, NULL)
 WHERE AllocUnitName LIKE '%TBLDelete%'

 
/*************************************************************************************************
 ��������Ʈ 
 https://www.mssqltips.com/sqlservertip/4248/differences-between-delete-and-truncate-in-sql-server/
 https://www.mssqltips.com/sqlservertip/1080/deleting-data-in-sql-server-with-truncate-vs-delete-commands/
**************************************************************************************************/
