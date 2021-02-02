/*************************************************************************************************
 테이블 생성
**************************************************************************************************/
CREATE TABLE dbo.TBLIndexTest
(
	Col1 INT NOT NULL PRIMARY KEY CLUSTERED
,	Col2 INT NULL
,	Col3 INT NULL
,	Col4 NVARCHAR(50) NULL
)


/*************************************************************************************************
 데이터 생성
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
 인덱스 조각화 정보 확인
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
 인덱스 Rebuild
 1.인덱스 삭제 -> 재 생성
 2.인덱스 조각화 제거, 지정된 채우기 비율 또는 기존 채우기 비율설정 기준 페이지 압축하여 디스크공간 회수,
   인덱스 행을 연속된 페이지로 재 정렬
**************************************************************************************************/
ALTER INDEX IDX_TBLIndexTest_Col3 ON dbo.TBLIndexTest REBUILD PARTITION = ALL
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);


/*************************************************************************************************
 인덱스 REORGANIZE
 1.리프 노드의 논맂적 순서에 맞도록 리프 수준 페이지를 물리적으로 재 정렬
 2.DBCC DBREINDEX : 인덱스 업데이트 뿐 아니라 수동, 자동으로 생성된 통계도 업데이트
 3.ALTER INDEX : 인덱스에 의해 생성된 통계만 업데이트
**************************************************************************************************/
ALTER INDEX IDX_TBLIndexTest_Col3 ON dbo.TBLIndexTest REORGANIZE 
WITH (LOB_COMPACTION = ON );


