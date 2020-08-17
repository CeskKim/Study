USE TestDB
GO
/*************************************************************************************************
 RCSI(READ COMMITTED SNAPSHOT ISOLATION) 사용
 1.ALTER DATABASE TestDB SET READ_COMMITTED_SNAPSHOT ON; :진행 시 많은 시간 경과
 2.WITH ROLLBACK IMMEDIATE 추가 : 트랜잭션 발생시 모두 롤백 -> ALTER DATABASE 사용시 모든 트랜잭션 COMMITT 또는 ROLLBACK 이 되야 실행 
  그러므로 많은 트랜잭션 발생 함으로 해당 구문 사용
**************************************************************************************************/
ALTER DATABASE TestDB SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;

GO

--SNAPSHOT 확인
SELECT DB_NAME(database_id)			,
	   is_read_committed_snapshot_on	,
	   snapshot_isolation_state_desc
  FROM sys.databases
 WHERE database_id = DB_ID()

 SELECT is_read_committed_snapshot_on FROM sys.databases 
  WHERE name= 'TestDB'


 /*************************************************************************************************
 SERIALIZABLE 사용임에도 불구하고 READ_COMMITTED_SNAPSHOT 사용이 가능한 상태로 읽기 가능
**************************************************************************************************/
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--Connection1
SELECT *
  FROM TBLUnnest



SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
--Connection2
SELECT *
  FROM TBLUnnest


 /*************************************************************************************************
  UPDATE 충돌 문제 PART1
  1.미리 업데이트가 진행되고 있는 행의 커밋되기 전 다른 세션에서 진행 시 아래와 같은 오류 발생
   -> 메시지 3951, 수준 16, 상태 1, 줄 69
      문이 스냅샷 격리하에 실행되었지만 트랜잭션이 스냅샷 격리에서 시작되지 않았으므로 데이터베이스 'TestDB'에서 해당 트랜잭션이 실패했습니다. 
      트랜잭션이 원래 스냅샷 격리 수준에서 시작되지 않은 한 트랜잭션이 시작된 후에 트랜잭션의 격리 수준을 스냅샷으로 변경할 수 없습니다.
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLConflict') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLConflict
	(
		ID1    INT UNIQUE NOT NULL	,
		Value1 INT	  NOT NULL	,
		ID2    INT UNIQUE NOT NULL	,
		Value2 INT	  NOT NULL
	)
END
-- Insert one row
INSERT TBLConflict
    (ID1, ID2, Value1, Value2)
VALUES
    (1, 1, 1, 1)

-- Connection1
BEGIN TRAN
UPDATE TBLConflict
   SET Value1 = 1
 WHERE ID1 = 1

 SET TRANSACTION ISOLATION LEVEL SNAPSHOT
 -- Connection2
BEGIN TRAN
UPDATE TBLConflict
   SET Value1 = 1
 WHERE ID1 = 1
 -- Connection1
 COMMIT TRAN


  /*************************************************************************************************
  UPDATE 충돌 문제 PART2
  1.외부키 관련 문제점
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLDummy') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLDummy
	(
		X INT NOT NULL
	)
END


IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLParent') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLParent
	(
		 ParentID    INT PRIMARY KEY,
		 ParentValue INT NOT NULL
	)
END


IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLChild') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLChild
	(
		ChildID		INT PRIMARY KEY,
        	ChildValue	INT NOT NULL   ,
        	ParentID	INT NULL FOREIGN KEY REFERENCES TBLParent
	)
END


INSERT TBLParent 
    (ParentID, ParentValue) 
VALUES (1, 1);
 
INSERT TBLChild 
    (ChildID, ChildValue, ParentID) 
VALUES (1, 1, 1);


SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
-- Connection1
SELECT COUNT_BIG(*) FROM TBLDummy
 
-- Connection 2 (any isolation level)
UPDATE TBLParent SET ParentValue = 1 WHERE ParentID = 1
 
-- Connection 1
UPDATE TBLChild SET ParentID = NULL WHERE ChildID = 1
UPDATE TBLChild SET ParentID = 1 WHERE ChildID = 1


 /*************************************************************************************************
 TRUNCATE 삭제 문제점
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLAccess') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLAccess
	(
		X INT NOT NULL
	)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLTruncate') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLTruncate
	(
		X INT NOT NULL
	)
END

-- Connection 1
SET TRANSACTION ISOLATION LEVEL SNAPSHOT	
BEGIN TRAN
SELECT COUNT_BIG(*) FROM TBLAccess
 
-- Connection 2
TRUNCATE TABLE TBLTruncate
 
-- Connection 1
SELECT COUNT_BIG(*) FROM TBLTruncate

/*************************************************************************************************
 참조사이트 
 https://sqlperformance.com/2020/07/t-sql-queries/table-expressions-part-4
 https://www.sqlshack.com/snapshot-isolation-in-sql-server/
**************************************************************************************************/
