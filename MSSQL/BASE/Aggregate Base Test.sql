USE ExampleDB
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET STATISTICS PROFILE ON 
SET NOCOUNT ON 
SET STATISTICS IO ON 

/*
  PK_SalesOrderHeader_SalesOrderID(SalesOrderID) ���
  �����ȹ -> Clustered Index Scan ���, CLUSTERED INDEX�������� ������ ����
*/
SELECT SUM(SubTotal),SalesOrderID 
  FROM Sales.SalesOrderHeader  
GROUP BY SalesOrderID

/*
  IX_SalesOrderHeader_CustomerID(CustomerID) ���
  �����ȹ -> NONClustered Index Scan ���, NONClustered Index Scan ������ UNIUQE ���� �������� Hash Match(Aggregate) ��� -> ������ �� ����
*/
SELECT SUM(SubTotal),CustomerID 
  FROM Sales.SalesOrderHeader  
GROUP BY CustomerID

/*
  AK_SalesOrderHeader_SalesOrderNumber(SalesOrderNumber) ���
  �����ȹ -> NONClustered Index Scan ���, NONClustered Index Scan ������ UNIUQE �� Stream Aggregate ��� -> ������ ����

*/
SELECT SUM(SubTotal),SalesOrderNumber 
  FROM Sales.SalesOrderHeader  
GROUP BY SalesOrderNumber
