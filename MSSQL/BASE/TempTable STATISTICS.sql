USE TestDB
GO
/*************************************************************************************************
 �������̺� ����
**************************************************************************************************/
DROP TABLE #TempTable
CREATE TABLE #TempTable
(
	Col1 INT			NOT  NULL,
	Col2 INT			NULL	 ,
	Col3 INT			NULL	 ,
	Col4 VARCHAR(50)	NULL
)

DECLARE @Num INT
SELECT @Num = 1

WHILE @Num <= 500
BEGIN
   INSERT INTO #TempTable (col1, col2, col3, col4) VALUES (@Num,@Num,@Num,'TEST')
   SELECT @Num = @Num + 1

END
CREATE CLUSTERED INDEX IDX_#TempTable ON #TempTable(Col1)

--/*************************************************************************************************
-- ���Ȯ��
-- 1.�������̺� ������ Ȯ���� ���� ���̺� �������� ��뷮 ó�� ��ȸ�� ����
--**************************************************************************************************/
DBCC SHOW_STATISTICS('tempdb.dbo.#TempTable', 'IDX_#TempTable')
SELECT *
  FROM #TempTable

