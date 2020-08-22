USE ExampleDB 
GO
DBCC freeproccache --ĳ�� �ʱ�ȭ
SET STATISTICS IO ON 
 
 /*************************************************************************************************
 1.Parameter Sniffing �ذ��� : OPTIMIZE FOR
   => �Ű������� ������ ������ �����ȹ�� ���
   => ������ �Ű������� ���� �����ȹ ����̹Ƿ� ��Ȯ�� ������ ��쿡�� ���
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
	 OPTION (OPTIMIZE FOR (@City = 'Milwaukie'))
GO
EXEC _SPAddressLineQuery 'Paris'
 /*************************************************************************************************
 2.Parameter Sniffing �ذ��� : WITH(RECOMPILE)
   => �÷� ĳ���� Ȱ������ �ʰ� ���ν����� ����ɶ� ���ο� �����ȹ����(Parsing -> �����м� -> ��������ȭ)
   �������ȹ���� ���� (Parsing -> DML -> NO ->Algebrizing
                                       -> YES -> Algebrizing-> Optimizing ->Execution)
						Optimizing -> Is a valid plan cached -> YES -> Execution
                                                                    -> NO -> Apply simplification -> Is this a trival plan -> YES -> Execution
																																  -> NO -> Is the plan cheap enough -> YES -> Execution
																																								-> NO -> Start cost  - based optimization -> Execution
    => ���� ���� �����ȹ�� ���Ӱ� ���� -> ���ν��������� ����� ���� �Ҹ� -> ����ϰ� ���Ǵ� ���ν��������� �� ��õ
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
	 OPTION (RECOMPILE)

GO
EXEC _SPAddressLineQuery 'Paris'

 /*************************************************************************************************
 3.Parameter Sniffing �ذ��� : Dynamic SQL ���
   => �Ű������� ������� ���� ��� ���Ӱ� �����ȹ�� �������� ����
   => �������� ���� ����, �Ű������� ������ ����� ��� RECOPILE�� ���� �����ȹ�� ���Ӱ� ���� -> ���ν��������� ����� ���� �Ҹ� -> ����ϰ� ���Ǵ� ���ν��������� �� ��õ
   => ���ȣ, ��ȣ, Ư�����ڰ� ����ǰų� �������� �ʵ��� �ؾ���
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
						   FROM Person.Address		 AS A
						   JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
						  WHERE A.City = ''' + CAST(@City AS NVARCHAR(200)) + ''''
			
	 PRINT @SQLCommand
	 EXEC sp_executesql @SQLCommand
GO
EXEC _SPAddressLineQuery 'Paris'

 /*************************************************************************************************
 4.Parameter Sniffing �ذ��� : Temporary ���ν��� ���
   => ���� ����� ���ν����� �̷��� -> �����ȹ�� ����� ���ʿ��� ��� ����
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

	  FROM Person.Address		AS A
	  JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID
     WHERE A.City = @City
	 
GO
EXEC #_SPAddressLineQuery 'Paris'
EXEC #_SPAddressLineQuery 'Gilbert'
GO
DROP PROC #_SPAddressLineQuery

/*************************************************************************************************
 ��������Ʈ 
 https://www.sqlshack.com/query-optimization-techniques-in-sql-server-parameter-sniffing/
**************************************************************************************************/