USE TestDB
GO
/*************************************************************************************************
 ���̺� ���� �� �ε��� ���� 
 1.TBLHeap : NONCLUSTERED
 2.TBLCIX  : CLUSTERED
 3.TBLTime : �ð�����
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLHeap') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLHeap
	(
		ObjectID			INT PRIMARY KEY NONCLUSTERED,
		Name				NVARCHAR(2000)				,
		SchemaID			INT							,
		ModuleDefinition	NVARCHAR(MAX)

	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IDX_TBLHeap')
BEGIN
	CREATE INDEX IDX_TBLHeap ON TBLHeap(Name) INCLUDE(SchemaID)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLCIX') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLCIX
	(
		ObjectID			INT PRIMARY KEY CLUSTERED	,
		Name				NVARCHAR(2000)				,
		SchemaID			INT							,
		ModuleDefinition	NVARCHAR(MAX)

	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IDX_TBLCIX')
BEGIN
	CREATE INDEX IDX_TBLCIX ON TBLCIX(Name) INCLUDE(SchemaID)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLTime') AND Xtype = 'U')
BEGIN
	
	/* 
	[DATETIME2 ]
	MSSQL 2008���� ����, YYYY-MM-DD hh:mm:ss[.�Ҽ��ڸ��� ��]
	�ڸ��� < 3 : 6Byte, �ڸ��� > 3 : 7Byte, ��Ÿ : 8Byte
	DATETIME�� ��� 1953�� ���� �������� ���� �߻�, �� ���� ��Ȯ���� �������� ������ �����
	[SYSUTCDATETIME]
	DATETIME2 ���� ��ȯ, �Ҽ��ڸ��� �� (1~7�ڸ���), GETDATE(), GETUTCDATE()���� ���� �Ҽ��ڸ��� �� ����

	*/


	CREATE TABLE TBLTime
	(
		Test		NVARCHAR(50) NOT NULL,
		StartTime	DATETIME2	 NOT NULL DEFAULT SYSUTCDATETIME(),
		EndTime		DATETIME2

	)
END
/*************************************************************************************************
 INSERT �׽�Ʈ
**************************************************************************************************/
--TBELHeap
INSERT INTO TBLTime(TEST)VALUES('TBLHeap')
GO
TRUNCATE TABLE TBLHeap

INSERT TBLHeap(ObjectID, Name, SchemaID, ModuleDefinition) 
SELECT TOP 2000 [object_id], name, [schema_id], OBJECT_DEFINITION([object_id])
  FROM sys.all_objects 
ORDER BY [object_id]

GO 100
UPDATE TBLTime 
  SET EndTime = SYSUTCDATETIME() 
 WHERE EndTime IS NULL;
GO

--TBLCIX
INSERT INTO TBLTime(TEST)VALUES('TBLCIX')
GO
TRUNCATE TABLE TBLCIX

INSERT TBLCIX(ObjectID, Name, SchemaID, ModuleDefinition) 
SELECT TOP 2000 [object_id], name, [schema_id], OBJECT_DEFINITION([object_id])
  FROM sys.all_objects 
ORDER BY [object_id]

GO 100
UPDATE TBLTime 
  SET EndTime = SYSUTCDATETIME() 
 WHERE EndTime IS NULL;
GO


/*************************************************************************************************
 SELECT �׽�Ʈ
 1.RID LookUp�� ��� Key Lookup���� ��ȸ�� �ӵ��� �� ���� 
   => NONCLUSTERED INDEX : root -> branch -> leaf -> data page
   => NONCLUSTERED INDEX + CLUSTERED INDEX : root -> branch -> leaf -> CLUSTERED INDEX PAGE -> data page
      => NONCLUSTERED INDEX�� CLUSTERED INDEX�� Ű ���� ���� ����, leaf�������� �ٷ� data page�� ���� ���� �ƴ�
	     CLUSTERED INDEX PAGE�� ��ġ�� ���� ������ NONCLUSTERED INDEX ���� �Ǿ����� ���� �ӵ��� ����
**************************************************************************************************/
SET STATISTICS IO ON
 SELECT*
   FROM TBLHeap WITH (INDEX(IDX_TBLHeap)) 
  WHERE Name LIKE N'S%'
 
SELECT *
  FROM TBLCIX WITH (INDEX(IDX_TBLCIX)) 
WHERE Name LIKE N'S%'

