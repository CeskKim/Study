USE TestDB
GO
/*************************************************************************************************
 테이블 생성
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLIndexDestiny') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLIndexDestiny
	(
		COL1		INT NOT NULL,
		COL2		INT	    ,
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

ALTER TABLE TBLIndexDestiny ADD CONSTRAINT PK_TBLIndexDestiny PRIMARY KEY CLUSTERED(COL1 ASC) WITH(FILLFACTOR = 90) -- FILLFACTOR : IndexData 채우기 비율

/*************************************************************************************************
 통계정보 확인_01
 기본구조 : DBCC SHOW_STATISTICS(테이블명, 인덱스명)
 1.ALL density : Distinct / unique values -> 1 / 100 -> 0.1
 2.Steps : HISTOGRAM의 단계를 표시하며, 최대단계 200
**************************************************************************************************/
USE TestDB
GO
SELECT * 
  FROM TBLIndexDestiny
 WHERE COL3 = 1
DBCC SHOW_STATISTICS ('TBLIndexDestiny', 'PK_TBLIndexDestiny')

/*************************************************************************************************
 통계정보 확인_02
 ＊adventureworks 사용
 1.상수 대신 바인드 변수 기술시 옵티마이저는 히스토그램 대신 밀도 를 사용해 비용 계산
**************************************************************************************************/
USE ExampleDB
GO
DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID') WITH HISTOGRAM 
SET STATISTICS IO ON 

--실행계획 -> 예상실행횟수 와 실제행수  불일치 ->  DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID') WITH(HISTOGRAM)로 확인 
--RANGE_HI_KEY : 897의 근처값 898의 AVG_RANGE_ROWS 75.6666을 예상행수로 제공
SELECT SalesOrderID, SalesOrderDetailID
  FROM [Sales].[SalesOrderDetail]
 WHERE productid = 897

--1.상수 사용
--실행계획 -> 예상실행횟수 와 실제행수 일치 ->  DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID') WITH(HISTOGRAM)로 확인 
--RANGE_HI_KEY : 870이 존재하여 EQ_ROWS 4688 제공
SELECT SalesOrderID, SalesOrderDetailID
  FROM [Sales].[SalesOrderDetail]
 WHERE productid = 870

 DBCC SHOW_STATISTICS('sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID')
--2.바인드 변수 사용
 DECLARE @productid INT
 SELECT @productid =870

 SELECT SalesOrderID, SalesOrderDetailID
  FROM [Sales].[SalesOrderDetail]
 WHERE productid = @productid

--3.프로시저 Parameter 사용
--상수사용과 마찬가지로 Histogram 사용(Bind Peeking, Parameter Snifiing이용 가능으로 인해)
--Bind Peeking : SQL 최초 실행시 바인드 변수 포함, 바인드 변수에 값을 참조 실행계획 실행
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

--4.프로시저 Parameter 미 사용
--내부에서 바인드 변수 사용 밀도 사용(Bind Peeking, Parameter Snifiing이용 불가능으로 인해)
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
 참조사이트 
 https://www.mssqltips.com/sqlservertip/4092/how-to-interpret-sql-server-dbcc-showstatistics-output/
 https://www.sentryone.com/blog/loriedwards/statistics-2
 https://docs.microsoft.com/ko-kr/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-ver15
**************************************************************************************************/
