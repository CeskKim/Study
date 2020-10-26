USE ExampleDB
GO
/*************************************************************************************************
 1.프로시저내 테이블 조회
**************************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OBJECT_NAME(object_id), OBJECT_DEFINITION(object_id) 
  FROM sys.procedures 
 WHERE OBJECT_DEFINITION(object_id) LIKE 'SalesPerson%'

