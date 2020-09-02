USE TestDB
GO
/*************************************************************************************************
 테이블 생성 및 인덱스 생성 
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLDelete') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLDelete
	(
		EmpSeq	INT				,
		EmpID	NVARCHAR(20)	,
		EmpName	NVARCHAR(30)	,

		CONSTRAINT PK_TBLDelete PRIMARY KEY(EmpSeq)
	)
END

INSERT INTO TBLDelete(EmpSeq, EmpID, EmpName)
SELECT 1, N'20200902-001', N'홍길동' WHERE NOT EXISTS(SELECT 1 FROM TBLDelete WHERE EmpSeq = 1)
INSERT INTO TBLDelete(EmpSeq, EmpID, EmpName)
SELECT 2, N'20200902-002', N'김철수' WHERE NOT EXISTS(SELECT 1 FROM TBLDelete WHERE EmpSeq = 2)
INSERT INTO TBLDelete(EmpSeq, EmpID, EmpName)
SELECT 3, N'20200902-003', N'강장군' WHERE NOT EXISTS(SELECT 1 FROM TBLDelete WHERE EmpSeq = 3)

/*************************************************************************************************
 DELETE 체크
 1.ROLLBACK 가능, 조건자 지정 가능
**************************************************************************************************/
BEGIN TRAN
DELETE FROM TBLDelete WHERE EmpSeq = 3
SELECT * FROM TBLDelete 
GO
ROLLBACK TRAN
SELECT * FROM TBLDelete

/*************************************************************************************************
 페이지 확인
 *IAM(Index Allocation Map) :  테이블 인덱스 당 생성, 인덱스 미존재시 Heap을 관리하기 위해 하나의 IAM생성
 1.DBCC IND(DB명, 테이블, 옵션)
   => 옵션 - 2 : 모든 IAM Page 정보, -1 : 모든 페이지의 정보, 1: Clustered INDEX 정보, 2 ~ 254 : NONClustered INDEX 정보
   => PageType = 10 : IAM Page
 2.DBCC PAGE(DB명, 파일번호, 페이지번호, 옵션)
   => DBCC TRACEON(3604) 플래그 추적을 ON으로 선 실행
   => 옵션 0 : 헤더만, 1 : 행단위, 2 : 페이지 단위, 3 : 행 그리고 칼럼 데이터
**************************************************************************************************/
--DELETE 전
SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 141880, 3)  WITH TABLERESULTS   
	
--DELETE 후
--Data가 Heap에 존재하는 경우 페이지 할당해제를 하지 않음
DELETE FROM TBLDelete

SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 141880, 3) WITH TABLERESULTS 

/*************************************************************************************************
 페이지 할당 해제(DELETE)
 1.WITH(TABLOCK) 
 2.TRUNCATE 사용
**************************************************************************************************/
--DELETE 전
SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 149976, 3)  WITH TABLERESULTS 

--DELETE 후
DELETE FROM TBLDelete WITH(TABLOCK) 

SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 149976, 3) WITH TABLERESULTS 

--TRUNCATE
TRUNCATE TABLE TBLDelete
SET STATISTICS IO ON
SELECT * FROM TBLDelete
SET STATISTICS IO OFF

DBCC TRACEON(3604)
DBCC IND(TestDB, TBLDelete, -1)
DBCC PAGE(TestDB, 1, 149976, 3) WITH TABLERESULTS 


/*************************************************************************************************
 트랜잭션 로그 DELETE 로그 확인
**************************************************************************************************/
SELECT [Current LSN]	
	  ,[Operation]		
	  ,[Transaction ID] 
	  ,[Begin Time]
	  ,LEFT ([Description], 40) AS [Description]
  FROM fn_dblog(NULL, NULL)
 WHERE AllocUnitName LIKE '%TBLDelete%'


 /*************************************************************************************************
 TRUNCATE 체크
 1.ROLLBACK 가능, 조건자 지정 불가능
 2.IDENTITY SEED 재설정, 페이지 할당 해제를 통해 해당 페이지가 다른 영역에서 사용 가능
 3.FOREIGN KEY  내역은 삭제 불가능
**************************************************************************************************/
BEGIN TRAN
TRUNCATE TABLE TBLDelete
SELECT * FROM TBLDelete 
GO
ROLLBACK TRAN
SELECT * FROM TBLDelete

--FOREIGN KEY 설정
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLDeleteForegin') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLDeleteForegin
	(
		OrderSeq			INT				,
		OrderDate			NCHAR(8)		,
		OrderName			NVARCHAR(30)	,
		EmpSeq				INT
		
		CONSTRAINT PK_TBLDeleteForegin PRIMARY KEY (OrderSeq)
		CONSTRAINT FK_TBLDeleteForegin FOREIGN KEY (EmpSeq) REFERENCES TBLDelete(EmpSeq)
	)
END

--원본 테이블의 데이터가 존재해야만 참조하는 데이터 INSERT 가능
INSERT INTO TBLDeleteForegin(OrderSeq,OrderDate,OrderName,EmpSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLDeleteForegin WHERE OrderSeq = 1)
INSERT INTO TBLDeleteForegin(OrderSeq,OrderDate, OrderName,EmpSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLDeleteForegin WHERE OrderSeq = 2)

--FOREIGN KEY 내역이 되어 있는 원본 테이블 TRUNCATE 시 오류 발생
--테이블 'TBLDelete'은(는) FOREIGN KEY 제약 조건에 의해 참조되므로 자를 수 없습니다. 메시지 발생
TRUNCATE TABLE TBLDelete



/*************************************************************************************************
 트랜잭션 로그 TRUNCATE 로그 확인
**************************************************************************************************/
SELECT [Current LSN]	
	  ,[Operation]		
	  ,[Transaction ID] 
	  ,[Begin Time]
	  ,LEFT ([Description], 40) AS [Description]
  FROM fn_dblog(NULL, NULL)
 WHERE AllocUnitName LIKE '%TBLDelete%'

 
/*************************************************************************************************
 참조사이트 
 https://www.mssqltips.com/sqlservertip/4248/differences-between-delete-and-truncate-in-sql-server/
 https://www.mssqltips.com/sqlservertip/1080/deleting-data-in-sql-server-with-truncate-vs-delete-commands/
**************************************************************************************************/
