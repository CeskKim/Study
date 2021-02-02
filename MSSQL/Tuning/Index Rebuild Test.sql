/*************************************************************************************************
 ���̺� ����
**************************************************************************************************/
CREATE TABLE dbo.TBLIndexTest
(
	Col1 INT NOT NULL PRIMARY KEY CLUSTERED
,	Col2 INT NULL
,	Col3 INT NULL
,	Col4 NVARCHAR(50) NULL
)


/*************************************************************************************************
 ������ ����
**************************************************************************************************/
DECLARE
	@Val INT = 1

WHILE @Val < 1000000
BEGIN
	INSERT INTO dbo.TBLIndexTest
	(
		Col1
	,	Col2
	,	Col3
	,	Col4
	)
	VALUES
	(
		@Val
	,	ROUND(RAND()*100000,0)
	,	ROUND(RAND()*100000,0)
	,	N'TEST' + CAST(@val AS NVARCHAR)
	)

	SET @Val += 1;
END

CREATE INDEX IDX_TBLIndexTest_Col3 ON TBLIndexTest(Col3 ASC)

/*************************************************************************************************
 �ε��� ����ȭ ���� Ȯ��
**************************************************************************************************/
SELECT 
	object_name(object_id) as tablename
,	index_id,index_type_desc
,	avg_fragmentation_in_percent
,   page_count,page_count*8/1024 as [size(mb)]
FROM [sys].[dm_db_index_physical_stats](DB_ID(), NULL, NULL, NULL, DEFAULT)
WHERE 
	object_name(object_id) = 'TBLIndexTest' 
AND 
	index_id=2

SET STATISTICS IO ON

/*************************************************************************************************
 �ε��� Rebuild
 1.�ε��� ���� -> �� ����
 2.�ε��� ����ȭ ����, ������ ä��� ���� �Ǵ� ���� ä��� �������� ���� ������ �����Ͽ� ��ũ���� ȸ��,
   �ε��� ���� ���ӵ� �������� �� ����
**************************************************************************************************/
ALTER INDEX IDX_TBLIndexTest_Col3 ON dbo.TBLIndexTest REBUILD PARTITION = ALL
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);


/*************************************************************************************************
 �ε��� REORGANIZE
 1.���� ����� �퐜�� ������ �µ��� ���� ���� �������� ���������� �� ����
 2.DBCC DBREINDEX : �ε��� ������Ʈ �� �ƴ϶� ����, �ڵ����� ������ ��赵 ������Ʈ
 3.ALTER INDEX : �ε����� ���� ������ ��踸 ������Ʈ
**************************************************************************************************/
ALTER INDEX IDX_TBLIndexTest_Col3 ON dbo.TBLIndexTest REORGANIZE 
WITH (LOB_COMPACTION = ON );


