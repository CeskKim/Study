USE TestDB
GO
/*************************************************************************************************
 템프테이블 생성
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
-- 통계확인
-- 1.템프테이블 통계생성 확인을 통해 테이블 변수보다 대용량 처리 조회에 유리
--**************************************************************************************************/
DBCC SHOW_STATISTICS('tempdb.dbo.#TempTable', 'IDX_#TempTable')
SELECT *
  FROM #TempTable

