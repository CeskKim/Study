USE ExampleDB
GO
SET NOCOUNT ON 
/*************************************************************************************************
 COLUMNSTORE INDEX ������ ���� Adaptive Join ����
**************************************************************************************************/

CREATE NONCLUSTERED COLUMNSTORE INDEX IDX_ADTEST ON Sales.SalesOrderHeader(SalesOrderID)

DECLARE @TerritoryID INT = 1;
SELECT SUM(SOH.SubTotal)
  FROM Sales.SalesOrderHeader AS SOH
  JOIN Sales.SalesOrderDetail AS SOD on SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.TerritoryID = @TerritoryID

/*************************************************************************************************
 �Ӱ谪�� ���� Adaptive Join (NL, HASH) ����
 1.�⺻ HASH�� ���� -> �Ӱ谪 ���� -> NL�� ����
 2.�Ӱ谪�� ��� �������� ����
**************************************************************************************************/
ALTER DATABASE SCOPED CONFIGURATION CLEAR procedure_cache; --�÷� ĳ�� ����

DECLARE @TerritoryIDAfter INT = 1;
SELECT SUM(SOH.SubTotal)
  FROM Sales.SalesOrderHeader AS SOH
  JOIN Sales.SalesOrderDetail AS SOD on SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.TerritoryID = @TerritoryIDAfter
OPTION(OPTIMIZE  FOR (@TerritoryIDAfter = 0));
--Adaptive Thresholdrows : 72.8498, NL JOIN

SELECT SUM(SOH.SubTotal)
  FROM Sales.SalesOrderHeader AS SOH
  JOIN Sales.SalesOrderDetail AS SOD on SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.TerritoryID = @TerritoryIDAfter
OPTION(OPTIMIZE FOR (@TerritoryIDAfter = 1));
--Adaptive Thresholdrows : 244.025. HASH JOIN 

SELECT SUM(SOH.SubTotal)
  FROM Sales.SalesOrderHeader AS SOH
  JOIN Sales.SalesOrderDetail AS SOD on SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.TerritoryID = @TerritoryIDAfter
OPTION(OPTIMIZE FOR (@TerritoryIDAfter = 10));
--Adaptive Thresholdrows : 188.54, HASH JOIN
