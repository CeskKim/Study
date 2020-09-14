USE ExampleDB
GO
SET NOCOUNT ON 
/*************************************************************************************************
 COLUMNSTORE INDEX 적용을 통해 Adaptive Join 유도
**************************************************************************************************/

CREATE NONCLUSTERED COLUMNSTORE INDEX IDX_ADTEST ON Sales.SalesOrderHeader(SalesOrderID)

DECLARE @TerritoryID INT = 1;
SELECT SUM(SOH.SubTotal)
  FROM Sales.SalesOrderHeader AS SOH
  JOIN Sales.SalesOrderDetail AS SOD on SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.TerritoryID = @TerritoryID

/*************************************************************************************************
 임계값을 통해 Adaptive Join (NL, HASH) 선택
 1.기본 HASH로 시작 -> 임계값 이하 -> NL로 변경
 2.임계값의 경우 예측값에 의존
**************************************************************************************************/
ALTER DATABASE SCOPED CONFIGURATION CLEAR procedure_cache; --플랜 캐쉬 삭제

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
