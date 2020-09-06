USE TestDB
GO
/*************************************************************************************************
 ���̺� ����
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLIndexDestiny') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLIndexDestiny
	(
		COL1		INT NOT NULL,
		COL2		INT			,
		COL3		INT
	)
END

DECLARE @Num	INT
SELECT @Num = 1

WHILE @Num <= 100
BEGIN
	INSERT INTO TBLIndexDestiny(COL1,COL2,COL3)
	SELECT @Num, @Num + 1 ,1 WHERE NOT EXISTS(SELECT 1 FROM TBLIndexDestiny WHERE COL1 = @Num)

	SELECT @Num = @Num + 1
END

ALTER TABLE TBLIndexDestiny ADD CONSTRAINT PK_TBLIndexDestiny PRIMARY KEY CLUSTERED(COL1 ASC) WITH(FILLFACTOR = 90) -- FILLFACTOR : IndexData ä��� ����

/*************************************************************************************************
 ������� Ȯ��_01
 �⺻���� : DBCC SHOW_STATISTICS(���̺��, �ε�����)
 1.ALL density : Distinct / unique values -> 1 / 100 -> 0.1
 2.Steps : HISTOGRAM�� �ܰ踦 ǥ���ϸ�, �ִ�ܰ� 200
**************************************************************************************************/
USE TestDB
GO
SELECT * 
  FROM TBLIndexDestiny
 WHERE COL3 = 1
DBCC SHOW_STATISTICS ('TBLIndexDestiny', 'PK_TBLIndexDestiny')

/*************************************************************************************************
 ������� Ȯ��_02
 ��adventureworks ���
 1.��� ��� ���ε� ���� ����� ��Ƽ�������� ������׷� ��� �е� �� ����� ��� ���
**************************************************************************************************/
USE ExampleDB
GO
DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID') WITH HISTOGRAM 
SET STATISTICS IO ON 

--�����ȹ -> �������Ƚ�� �� �������  ����ġ ->  DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID') WITH(HISTOGRAM)�� Ȯ�� 
--RANGE_HI_KEY : 897�� ��ó�� 898�� AVG_RANGE_ROWS 75.6666�� ��������� ����
SELECT SalesOrderID, SalesOrderDetailID
  FROM [Sales].[SalesOrderDetail]
 WHERE productid = 897

--1.��� ���
--�����ȹ -> �������Ƚ�� �� ������� ��ġ ->  DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID') WITH(HISTOGRAM)�� Ȯ�� 
--RANGE_HI_KEY : 870�� �����Ͽ� EQ_ROWS 4688 ����
SELECT SalesOrderID, SalesOrderDetailID
  FROM [Sales].[SalesOrderDetail]
 WHERE productid = 870

 DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID')
--2.���ε� ���� ���
 DECLARE @productid INT
 SELECT @productid =870

 SELECT SalesOrderID, SalesOrderDetailID
  FROM [Sales].[SalesOrderDetail]
 WHERE productid = @productid

--3.���ν��� Parameter ���
--������� ���������� Histogram ���(Bind Peeking, Parameter Snifiing�̿� �������� ����)
--Bind Peeking : SQL ���� ����� ���ε� ���� ����, ���ε� ������ ���� ���� �����ȹ ����
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPHistTestQuery') AND xtype = 'P')
	DROP PROC _SPHistTestQuery
GO
CREATE PROC _SPHistTestQuery
@productid	INT

AS 
	 SELECT SalesOrderID, SalesOrderDetailID
	  FROM [Sales].[SalesOrderDetail]
	 WHERE productid = @productid 

RETURN
GO
EXEC _SPHistTestQuery 870

--4.���ν��� Parameter �� ���
--���ο��� ���ε� ���� ��� �е� ���(Bind Peeking, Parameter Snifiing�̿� �Ұ������� ����)
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPHistTestQuery') AND xtype = 'P')
	DROP PROC _SPHistTestQuery
GO
CREATE PROC _SPHistTestQuery

AS 
	 DECLARE @productid INT

	 SELECT @productid = 870

	 SELECT SalesOrderID, SalesOrderDetailID
	  FROM [Sales].[SalesOrderDetail]
	 WHERE productid = @productid 

RETURN
GO
EXEC _SPHistTestQuery

/*************************************************************************************************
 ��������Ʈ 
 https://www.mssqltips.com/sqlservertip/4092/how-to-interpret-sql-server-dbcc-showstatistics-output/
 https://www.sentryone.com/blog/loriedwards/statistics-2
 https://docs.microsoft.com/ko-kr/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-ver15
**************************************************************************************************/