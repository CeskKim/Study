USE TestDB
GO
/*************************************************************************************************
 Without FillFactor Table ����
 1.FillFacter 0���� ����,  PK�Ǵ� INDEX �� ������ FillFacter�� �������� ����
 2.FillFacter�� Default(0)
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE NAME = N'TBLWithoutFillFactor')
BEGIN
	
	CREATE TABLE dbo.TBLWithoutFillFactor
	(
		FillSeq INT NOT NULL
	,	FillFactorName CHAR(900) NOT NULL
	)
END

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(N'TBLWithoutFillFactor') AND NAME = N'IX_TBLWithoutFillFactor')
BEGIN
	CREATE CLUSTERED INDEX IX_TBLWithoutFillFactor ON dbo.TBLWithoutFillFactor(FillSeq)
END


DECLARE 
	@_S INT = 1
,	@_E INT = 9

WHILE @_S <= @_E
BEGIN
	
	INSERT INTO dbo.TBLWithoutFillFactor
	(
		FillSeq
	,	FillFactorName
	)
	SELECT 
		@_S
	,	CONVERT(NCHAR(10),@_S) + N'WithouFillFactorName'
	WHERE
		NOT EXISTS(
					SELECT 1 
					FROM dbo.TBLWithoutFillFactor
					WHERE
						@_S = FillSeq)
	SET @_S += 1;
	
END

/*************************************************************************************************
  ���̺� �뷮 Ȯ��
**************************************************************************************************/
EXEC sp_spaceused 'TestDB.dbo.TBLWithoutFillFactor';

DBCC IND(TestDB, TBLWithoutFillFactor, 1) --IndexID(0 : Heap, 1 : CLUSTERED INDEX, 2 > : NONCLUSTRED INDEX, IndexLevel 0 : Leaf Page

DBCC TRACEON(3604) --Page���� Ȯ��

DBCC PAGE('TestDB', 1, 162784, 1)   WITH TABLERESULTS --Page Ȯ��, m_sloctcnt = 10 : ���� �ο� ��

/*************************************************************************************************
  FillFactorName ������ �߰�
**************************************************************************************************/
INSERT INTO dbo.TBLWithoutFillFactor
(
	FillSeq
,	FillFactorName
)
SELECT 10,N'10WithouFillFactorName'

SELECT 
	A.database_id
,	A.object_id
,	A.extent_page_id
,	A.allocated_page_page_id
,	A.next_page_file_id
,	A.previous_page_page_id
,	A.page_type
FROM sys.dm_db_database_page_allocations(DB_ID('TestDB'), OBJECT_ID('TBLWithoutFillFactor'),NULL, NULL, 'DETAILED') AS A
INNER JOIN sys.indexes AS I 
ON 
	I.object_id = A.object_id 
AND 
	I.index_id = A.index_id
WHERE A.page_type = 1 --page_type_desc = 'DATA_PAGE'


/*************************************************************************************************
  FillFactor ���
  1.FillFactor�� ��� ������ ������ ����(x) -> �������� �ε��� �� ���� ���� 
    EX) 100��������(FillFactor = 80)�� ���ο� �� �߰� -> ������ ������ 80 : 20�� �ƴ� 50:50���� ����
		�ǰ� ���ҵ� �������� �����Ͱ� �߰��� �� 80������ �߰�
  2.FillFactor�� 0 �Ǵ� 100�ΰ�� �ε��� �������� ���� ä�� ���ο� ���� ����� ��� �� ������ ���ҵǹǷ� 
   �䱸���׿� ���� FillFactor ����
**************************************************************************************************/
DROP INDEX IX_TBLWithoutFillFactor ON dbo.TBLWithoutFillFactor
GO
CREATE CLUSTERED INDEX IX_TBLWithoutFillFactor ON dbo.TBLWithoutFillFactor(FillSeq) WITH FILLFACTOR = 80

INSERT INTO dbo.TBLWithoutFillFactor
(
	FillSeq
,	FillFactorName
)
SELECT 11,N'11WithouFillFactorName'


--Fill Factor ���� ����
sp_configure 'show advanced options', 1;
GO
sp_configure 'fill factor', 0;
GO
RECONFIGURE;
GO

-- Fill Factor ��ȸ
SELECT *
FROM sys.configurations
WHERE
	NAME = N'fill factor (%)'

