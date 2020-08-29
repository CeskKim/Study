USE ExampleDB 
GO
SET STATISTICS IO ON 
SET NOCOUNT ON

 
 /*************************************************************************************************
 1.TABLE Hint : WITH(NOLOCK)
   => �ش� ���̺� WITH(NOLOCK), READ UNCOMMITTED TRANSACTION LEVEL�� ���� ȿ��
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

 /*Person.StateProvince Exclusive lock ���� -> �Ʒ� ���� ���� �� LOCK ����
   SP_LOCK, DBCC Inputbuffer(SPID) -> TAB,PAG,KEY : X, IX ���� Ȯ�� ����
 SELECT B.Name,A.*
   FROM Person.Address		 AS A WITH(NOLOCK)
   JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
  WHERE A.AddressID = 30
  */

/*************************************************************************************************
 2.TABLE Hint : WITH(UPDLOCK)
   => �ش� ���̺� WITH(UPDLOCK), SELECT -> UPDATE �ٸ����ǿ� ������ ���� �ʰ� ������ ���� �� �ַ� ���
   => WITH(UPDLOCK) -> UPDATE -> WITH(UPLOCK)���� SELECT
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
