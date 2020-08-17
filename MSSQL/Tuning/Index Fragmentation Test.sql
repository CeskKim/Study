USE TestDB
GO

/*************************************************************************************************
 테이블 생성 및 인덱스 생성
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLHighFrgmentation') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLHighFrgmentation
	(
		UniqueID	 UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
		FirstName	 NVARCHAR(100)				     ,
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
		FirstName	 NVARCHAR(100)				     ,
		LastName	 NVARCHAR(100)					
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE Name = 'TBLLowFragmentation')
BEGIN
	CREATE NONCLUSTERED INDEX IDX_TBLLowFragmentation ON TBLLowFragmentation(LastName)
END

GO

/*************************************************************************************************
 데이터 삽입
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
 데이터 조회
**************************************************************************************************/
-------------------------------------------
--DMV를 통한 조각화 비율 조회
--DMV(Dynamic Management Views) : 성능 관련 정보 수집
-------------------------------------------
SELECT OBJECT_NAME(ps.object_id) AS table_name
      ,i.name					 AS index_name
      ,ps.index_id
      ,ps.index_depth
      ,avg_fragmentation_in_percent		--논리적 조각화 비율
      ,fragment_count				--인덱스 조각수
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
--INDEX Fragement의 경우 DISK에 Page들이 연속적으로 위치하지 않고 흩어져 있는 현상
--초기 Page의 경우에는 연속적으로 위치 (INSERT,UPDATE,DELETE)등의 데이터 작업으로 인해 Page 위치가 비 연속적으로 위치하여
--INDEX를 재구성 목적
-------------------------------------------
ALTER INDEX ALL ON TBLLowFragmentation REBUILD


--테이블 비교(기본테이블 : TBLLowFragmentation, 인덱스 재구성 : TBLHighFrgmentation)
SELECT LastName, COUNT(*)
  FROM TBLLowFragmentation
  GROUP BY LastName;
  GO        
 
SELECT LastName, COUNT(*)
  FROM TBLHighFrgmentation
  GROUP BY LastName;
  GO

--인덱스 조각화 정보 표시
DBCC SHOWCONTIG(TBLLowFragmentation, IDX_TBLLowFragmentation)


--인덱스 내외부 조각화 비교(외부조각화(5 ~ 30% : REORGANIZE 추천, 30% 이상 : REBUILD추천)
SELECT OBJECT_NAME(ps.object_id)		AS table_name
      ,i.name					AS index_name
      ,ps.index_id
      ,ps.index_depth	
      ,avg_fragmentation_in_percent     AS OuterFragmentation
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

--인덱스 REORGANIZE
ALTER INDEX IDX_TBLLowFragmentation ON  TBLLowFragmentation REORGANIZE WITH( LOB_COMPACTION = ON)
