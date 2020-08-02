USE TestDB
GO

/*************************************************************************************************
 ���̺� ���� �� �ε��� ����
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLHighFrgmentation') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLHighFrgmentation
	(
		UniqueID	 UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
		FirstName	 NVARCHAR(100)								 ,
		LastName	 NVARCHAR(100)					
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE Name = 'IDX_TBLHighFrgmentation')
BEGIN
	CREATE NONCLUSTERED INDEX IDX_TBLHighFrgmentation ON TBLHighFrgmentation(LastName)
END



IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLLowFragmentation') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLLowFragmentation
	(
		UniqueID	 UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
		FirstName	 NVARCHAR(100)								 ,
		LastName	 NVARCHAR(100)					
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE Name = 'TBLLowFragmentation')
BEGIN
	CREATE NONCLUSTERED INDEX IDX_TBLLowFragmentation ON TBLLowFragmentation(LastName)
END

GO

/*************************************************************************************************
 ������ ����
**************************************************************************************************/
INSERT INTO TBLHighFrgmentation(FirstName, LastName)
SELECT TOP 100000 A.name, B.name
  FROM master.dbo.spt_values		AS A
  CROSS JOIN master.dbo.spt_values	AS B 
 WHERE ISNULL(A.name,'') <> ''
   AND ISNULL(B.name,'') <> ''
ORDER BY NEWID();

INSERT INTO TBLLowFragmentation
SELECT A.UniqueID,A.FirstName,A.LastName
  FROM TBLHighFrgmentation AS A


/*************************************************************************************************
 ������ ��ȸ
**************************************************************************************************/
-------------------------------------------
--DMV�� ���� ����ȭ ���� ��ȸ
--DMV(Dynamic Management Views) : ���� ���� ���� ����
-------------------------------------------
SELECT OBJECT_NAME(ps.object_id) AS table_name
      ,i.name					 AS index_name
      ,ps.index_id
      ,ps.index_depth
      ,avg_fragmentation_in_percent		--���� ����ȭ ����
      ,fragment_count					--�ε��� ������
      ,page_count						
      ,avg_page_space_used_in_percent
      ,record_count
  FROM sys.dm_db_index_physical_stats(
	  DB_ID(), 
      NULL, 
      NULL, 
      NULL, 
      'DETAILED')  AS ps
  JOIN sys.indexes AS i  ON ps.object_id = i.object_id
						AND ps.index_id  = i.index_id
  WHERE index_level = 0;

-------------------------------------------
--INDEX REBUILD
--INDEX Fragement�� ��� DISK�� Page���� ���������� ��ġ���� �ʰ� ����� �ִ� ����
--�ʱ� Page�� ��쿡�� ���������� ��ġ (INSERT,UPDATE,DELETE)���� ������ �۾����� ���� Page ��ġ�� �� ���������� ��ġ�Ͽ�
--INDEX�� �籸�� ����
-------------------------------------------
ALTER INDEX ALL ON TBLLowFragmentation REBUILD


--���̺� ��(�⺻���̺� : TBLLowFragmentation, �ε��� �籸�� : TBLHighFrgmentation)
SELECT LastName, COUNT(*)
  FROM TBLLowFragmentation
  GROUP BY LastName;
  GO        
 
SELECT LastName, COUNT(*)
  FROM TBLHighFrgmentation
  GROUP BY LastName;
  GO

--�ε��� ����ȭ ���� ǥ��
DBCC SHOWCONTIG(TBLLowFragmentation, IDX_TBLLowFragmentation)


--�ε��� ���ܺ� ����ȭ ��(�ܺ�����ȭ(5 ~ 30% : REORGANIZE ��õ, 30% �̻� : REBUILD��õ)
SELECT OBJECT_NAME(ps.object_id)		AS table_name
      ,i.name							AS index_name
      ,ps.index_id
      ,ps.index_depth	
      ,avg_fragmentation_in_percent		AS OuterFragmentation
	  ,avg_page_space_used_in_percent	AS InnerFragmentation
      ,fragment_count					
      ,page_count						
      ,avg_page_space_used_in_percent
      ,record_count
  FROM sys.dm_db_index_physical_stats(
	  DB_ID(), 
      OBJECT_ID('TBLLowFragmentation'), 
      NULL, 
      NULL, 
      'DETAILED')  AS ps
  JOIN sys.indexes AS i  ON ps.object_id = i.object_id
						AND ps.index_id  = i.index_id
  WHERE index_level = 0;

--�ε��� REORGANIZE
ALTER INDEX IDX_TBLLowFragmentation ON  TBLLowFragmentation REORGANIZE WITH( LOB_COMPACTION = ON)