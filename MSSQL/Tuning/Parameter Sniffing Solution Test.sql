--adventureworks 예제 파일 사용
USE ExampleDB 
GO
DBCC freeproccache --캐쉬 초기화
SET STATISTICS IO ON 
 
 /*************************************************************************************************
 1.Parameter Sniffing 해결방안 : OPTIMIZE FOR
   => 매개변수에 지정된 내역의 실행계획만 사용
   => 지정된 매개변수에 대한 실행계획 사용이므로 명확한 내역인 경우에만 사용
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPAddressLineQuery') AND Xtype = 'P')
DROP PROC _SPAddressLineQuery
GO
CREATE PROC _SPAddressLineQuery
@City NVARCHAR(30)

AS
	SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT A.AddressID
	      ,A.AddressLine1
	      ,A.AddressLine2
	      ,A.City
	      ,B.Name AS StateProvinceName
	  FROM Person.Address	    AS A
	  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
         WHERE A.City = @City
	 OPTION (OPTIMIZE FOR (@City = 'Milwaukie'))
GO
EXEC _SPAddressLineQuery 'Paris'
 /*************************************************************************************************
 2.Parameter Sniffing 해결방안 : WITH(RECOMPILE)
   => 플랜 캐쉬를 활용하지 않고 프로시저가 실행될때 새로운 실행계획생성(Parsing -> 구문분석 -> 구문최적화)
   ＊실행계획생성 과정 (Parsing -> DML -> NO -> Algebrizing
                                      -> YES -> Algebrizing-> Optimizing ->Execution)
						Optimizing -> Is a valid plan cached -> YES -> Execution
											    -> NO -> Apply simplification -> Is this a trival plan -> YES -> Execution
																																  -> NO -> Is the plan cheap enough -> YES -> Execution
																																								-> NO -> Start cost  - based optimization -> Execution
    => 위와 같은 실행계획을 새롭게 생성 -> 프로시저에서는 비용이 많이 소모 -> 빈번하게 사용되는 프로시저에서는 비 추천
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPAddressLineQuery') AND Xtype = 'P')
DROP PROC _SPAddressLineQuery
GO
CREATE PROC _SPAddressLineQuery
@City NVARCHAR(30)

AS
	SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT A.AddressID
	      ,A.AddressLine1
	      ,A.AddressLine2
	      ,A.City
	      ,B.Name AS StateProvinceName
	  FROM Person.Address       AS A
	  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
         WHERE A.City = @City
	 OPTION (RECOMPILE)

GO
EXEC _SPAddressLineQuery 'Paris'

 /*************************************************************************************************
 3.Parameter Sniffing 해결방안 : Dynamic SQL 사용
   => 매개변수가 변경되지 않은 경우 새롭게 실행계획을 생성하지 않음
   => 가독성이 좋지 않음, 매개변수가 변경이 빈번한 경우 RECOPILE과 같이 실행계획을 새롭게 생성 -> 프로시저에서는 비용이 많이 소모 -> 빈번하게 사용되는 프로시저에서는 비 추천
   => 대괄호, 기호, 특수문자가 변경되거나 수정되지 않도록 해야함
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('_SPAddressLineQuery') AND Xtype = 'P')
DROP PROC _SPAddressLineQuery
GO
CREATE PROC _SPAddressLineQuery
@City NVARCHAR(30)

AS
	SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLCommand NVARCHAR(MAX)


	SELECT @SQLCommand = 'SELECT A.AddressID
			            ,A.AddressLine1	 
			            ,A.AddressLine2
			            ,A.City
			            ,B.Name AS StateProvinceName
			       FROM Person.Address	 AS A
			       JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
			       WHERE A.City = ''' + CAST(@City AS NVARCHAR(200)) + ''''
			
	 PRINT @SQLCommand
	 EXEC sp_executesql @SQLCommand
GO
EXEC _SPAddressLineQuery 'Paris'

 /*************************************************************************************************
 4.Parameter Sniffing 해결방안 : Temporary 프로시저 사용
   => 새로 저장된 프로시저를 미러링 -> 실행계획에 사용할 불필요한 기록 제거
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('#_SPAddressLineQuery') AND Xtype = 'P')
DROP PROC #_SPAddressLineQuery
GO
CREATE PROC #_SPAddressLineQuery
@City NVARCHAR(30)

AS
	SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT A.AddressID
	      ,A.AddressLine1
	      ,A.AddressLine2
	      ,A.City
	      ,B.Name AS StateProvinceName
	  FROM Person.Address	    AS A
	  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
     WHERE A.City = @City
	 
GO
EXEC #_SPAddressLineQuery 'Paris'
EXEC #_SPAddressLineQuery 'Gilbert'
GO
DROP PROC #_SPAddressLineQuery

/*************************************************************************************************
 참조사이트 
 https://www.sqlshack.com/query-optimization-techniques-in-sql-server-parameter-sniffing/
**************************************************************************************************/
