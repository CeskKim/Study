USE ExampleDB
GO
/*************************************************************************************************
 프로시저 생성
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

	  FROM Person.Address		AS A
	  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
     WHERE A.City = @City
GO
/*************************************************************************************************
 프로시저 실행
 1.실행계획 SELECT문 우 클릭 -> 매개변수목록 : @City(옵티마이저가 Paris를 자동으로 @City)로 매개변수
  => Parameter Sniffing
**************************************************************************************************/
SET STATISTICS IO ON
EXEC _SPAddressLineQuery 'Paris'

/*************************************************************************************************
 플랜 캐쉬 확인
 1.sys.dm_exec_cached_plans을 통해 확인 (프로시저 실행시 플랜 캐쉬를 읽어 재활용)
 2.서로 상이한 매개변수 값을 통해 프로시저 실행 -> 동일한 실행 계획 표시 -> SET STATISTICS IO ON 사용 결과 : 논리적읽기 차이 
   =>기존에 플랜 캐쉬에 저장된 실행 계획 사용 확인 
**************************************************************************************************/
EXEC _SPAddressLineQuery 'Gilbert'
EXEC _SPAddressLineQuery 'Paris'

SELECT CP.objtype 
	  ,CP.cacheobjtype
	  ,CP.size_in_bytes
	  ,CP.refcounts, cp.usecounts
	  ,ST.text
  FROM sys.dm_exec_cached_plans					   AS CP
  CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS ST
 WHERE CP.objtype = 'Proc'


 /*************************************************************************************************
  SELECT문 사용(프로시저 X)
  1.SET STATISTICS IO ON 사용 결과 : 논리적읽기 차이 
    => SQL Server 컴파일 시점 값 전달 X 즉 SQL Server의 경우 CBO방식으로 통계값 사용
**************************************************************************************************/
 DECLARE @City NVARCHAR(30)
 SELECT A.AddressID
	   ,A.AddressLine1
	   ,A.AddressLine2
	   ,A.City
	   ,B.Name AS StateProvinceName
  FROM Person.Address		AS A
  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
 WHERE A.City = 'Paris'


