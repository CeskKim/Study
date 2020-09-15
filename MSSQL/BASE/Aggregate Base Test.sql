USE ExampleDB
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET STATISTICS PROFILE ON 
SET NOCOUNT ON 
SET STATISTICS IO ON 

/*
  PK_SalesOrderHeader_SalesOrderID(SalesOrderID) 사용
  실행계획 -> Clustered Index Scan 사용, CLUSTERED INDEX기준으로 데이터 정렬
*/
SELECT SUM(SubTotal),SalesOrderID 
  FROM Sales.SalesOrderHeader  
GROUP BY SalesOrderID

/*
  IX_SalesOrderHeader_CustomerID(CustomerID) 사용
  실행계획 -> NONClustered Index Scan 사용, NONClustered Index Scan 이지만 UNIUQE 하지 않음으로 Hash Match(Aggregate) 사용 -> 데이터 미 정렬
*/
SELECT SUM(SubTotal),CustomerID 
  FROM Sales.SalesOrderHeader  
GROUP BY CustomerID

/*
  AK_SalesOrderHeader_SalesOrderNumber(SalesOrderNumber) 사용
  실행계획 -> NONClustered Index Scan 사용, NONClustered Index Scan 이지만 UNIUQE 로 Stream Aggregate 사용 -> 데이터 정렬

*/
SELECT SUM(SubTotal),SalesOrderNumber 
  FROM Sales.SalesOrderHeader  
GROUP BY SalesOrderNumber
