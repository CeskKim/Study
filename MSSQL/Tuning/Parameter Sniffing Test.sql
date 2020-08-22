USE ExampleDB
GO
/*************************************************************************************************
 ���ν��� ����
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
 ���ν��� ����
 1.�����ȹ SELECT�� �� Ŭ�� -> �Ű�������� : @City(��Ƽ�������� Paris�� �ڵ����� @City)�� �Ű�����
  => Parameter Sniffing
**************************************************************************************************/
SET STATISTICS IO ON
EXEC _SPAddressLineQuery 'Paris'

/*************************************************************************************************
 �÷� ĳ�� Ȯ��
 1.sys.dm_exec_cached_plans�� ���� Ȯ�� (���ν��� ����� �÷� ĳ���� �о� ��Ȱ��)
 2.���� ������ �Ű����� ���� ���� ���ν��� ���� -> ������ ���� ��ȹ ǥ�� -> SET STATISTICS IO ON ��� ��� : �����б� ���� 
   =>������ �÷� ĳ���� ����� ���� ��ȹ ��� Ȯ�� 
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
  SELECT�� ���(���ν��� X)
  1.SET STATISTICS IO ON ��� ��� : �����б� ���� 
    => SQL Server ������ ���� �� ���� X �� SQL Server�� ��� CBO������� ��谪 ���
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


