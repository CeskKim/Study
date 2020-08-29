USE ExampleDB 
GO
SET STATISTICS IO ON 
SET NOCOUNT ON

 
 /*************************************************************************************************
 1.TABLE Hint : WITH(NOLOCK)
   => 해당 테이블에 WITH(NOLOCK), READ UNCOMMITTED TRANSACTION LEVEL과 동일 효과
***************************************************************** *********************************/
--Person.Address WITH(NOLOCK) 
BEGIN TRAN
UPDATE A
   SET City = N'Paris'
  FROM Person.Address		AS A
  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
 WHERE A.AddressID = 30 


 SELECT A.*
   FROM Person.Address		 AS A WITH(NOLOCK)
   JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
  WHERE A.AddressID = 30


BEGIN TRAN
UPDATE B
   SET Name = N'Paris'
  FROM Person.Address		AS A
  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
 WHERE A.AddressID = 30 

 /*Person.StateProvince Exclusive lock 상태 -> 아래 구문 실행 시 LOCK 상태
   SP_LOCK, DBCC Inputbuffer(SPID) -> TAB,PAG,KEY : X, IX 상태 확인 가능
 SELECT B.Name,A.*
   FROM Person.Address		 AS A WITH(NOLOCK)
   JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
  WHERE A.AddressID = 30
  */

/*************************************************************************************************
 2.TABLE Hint : WITH(UPDLOCK)
   => 해당 테이블에 WITH(UPDLOCK), SELECT -> UPDATE 다른세션에 영향을 받지 않고 순차적 진행 시 주로 사용
   => WITH(UPDLOCK) -> UPDATE -> WITH(UPLOCK)해제 SELECT
***************************************************************** *********************************/
BEGIN TRAN
SELECT @@SPID AS FirstTrasactionID 
DECLARE @StateProvinceID INT

SELECT @StateProvinceID = B.StateProvinceID
   FROM Person.Address		 AS A 
   JOIN Person.StateProvince AS B WITH(UPDLOCK) ON A.StateProvinceID = B.StateProvinceID
  WHERE A.AddressID = 30

 WAITFOR DELAY '00:00:10'

 
  SELECT B.Name,@StateProvinceID,A.*
   FROM Person.Address		 AS A 
   JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
  WHERE A.AddressID = 30


UPDATE B
   SET Name = N'ToKyo'
  FROM Person.Address		AS A
  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
 WHERE A.AddressID = 30 
   AND B.StateProvinceID  = @StateProvinceID


 COMMIT TRAN

 IF @@ERROR = 0 
 BEGIN
	BEGIN TRAN

	 SELECT B.Name,A.*
	  FROM Person.Address		AS A 
	  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
	 WHERE A.AddressID = 30

	 COMMIT TRAN
END
