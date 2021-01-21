USE TestDB
GO
/*************************************************************************************************
 Without FillFactor Table 생성
 1.FillFacter 0으로 생성,  PK또는 INDEX 미 생성시 FillFacter는 생성되지 않음
 2.FillFacter는 Default(0)
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
  테이블 용량 확인
**************************************************************************************************/
EXEC sp_spaceused 'TestDB.dbo.TBLWithoutFillFactor';

DBCC IND(TestDB, TBLWithoutFillFactor, 1) --IndexID(0 : Heap, 1 : CLUSTERED INDEX, 2 > : NONCLUSTRED INDEX, IndexLevel 0 : Leaf Page

DBCC TRACEON(3604) --Page내용 확인

DBCC PAGE('TestDB', 1, 162784, 1)   WITH TABLERESULTS --Page 확인, m_sloctcnt = 10 : 현재 로우 수

/*************************************************************************************************
  FillFactorName 데이터 추가
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
  FillFactor 결론
  1.FillFactor의 경우 마지막 데이터 분할(x) -> 페이지의 인덱스 행 사이 예약 
    EX) 100인페이지(FillFactor = 80)의 새로운 행 추가 -> 페이지 분할이 80 : 20이 아닌 50:50으로 분할
		되고 분할된 페이지에 데이터가 추가될 때 80비율로 추가
  2.FillFactor가 0 또는 100인경우 인덱스 페이지를 가득 채워 새로운 행이 생기는 경우 새 페이지 분할되므로 
   요구사항에 따라 FillFactor 조정
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


--Fill Factor 전역 설정
sp_configure 'show advanced options', 1;
GO
sp_configure 'fill factor', 0;
GO
RECONFIGURE;
GO

-- Fill Factor 조회
SELECT *
FROM sys.configurations
WHERE
	NAME = N'fill factor (%)'

