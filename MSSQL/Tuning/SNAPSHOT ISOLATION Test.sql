USE TestDB
GO
/*************************************************************************************************
 RCSI(READ COMMITTED SNAPSHOT ISOLATION) ���
 1.ALTER DATABASE TestDB SET READ_COMMITTED_SNAPSHOT ON; :���� �� ���� �ð� ���
 2.WITH ROLLBACK IMMEDIATE �߰� : Ʈ����� �߻��� ��� �ѹ� -> ALTER DATABASE ���� ��� Ʈ����� COMMITT �Ǵ� ROLLBACK �� �Ǿ� ���� 
  �׷��Ƿ� ���� Ʈ����� �߻� ������ �ش� ���� ���
**************************************************************************************************/
ALTER DATABASE TestDB SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;

GO

--SNAPSHOT Ȯ��
SELECT DB_NAME(database_id)				,
	   is_read_committed_snapshot_on	,
	   snapshot_isolation_state_desc
  FROM sys.databases
 WHERE database_id = DB_ID()

 SELECT is_read_committed_snapshot_on FROM sys.databases 
  WHERE name= 'TestDB'


 /*************************************************************************************************
 SERIALIZABLE ����ӿ��� �ұ��ϰ� READ_COMMITTED_SNAPSHOT ����� ������ ���·� �б� ����
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
  UPDATE �浹 ���� PART1
  1.�̸� ������Ʈ�� ����ǰ� �ִ� ���� Ŀ�ԵǱ� �� �ٸ� ���ǿ��� ���� �� �Ʒ��� ���� ���� �߻�
   -> �޽��� 3951, ���� 16, ���� 1, �� 69
      ���� ������ �ݸ��Ͽ� ����Ǿ����� Ʈ������� ������ �ݸ����� ���۵��� �ʾ����Ƿ� �����ͺ��̽� 'TestDB'���� �ش� Ʈ������� �����߽��ϴ�. 
      Ʈ������� ���� ������ �ݸ� ���ؿ��� ���۵��� ���� �� Ʈ������� ���۵� �Ŀ� Ʈ������� �ݸ� ������ ���������� ������ �� �����ϴ�.
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLConflict') AND xtype = 'U')
BEGIN
	CREATE TABLE TBLConflict
	(
		ID1    INT UNIQUE NOT NULL	,
		Value1 INT		  NOT NULL	,
		ID2	   INT UNIQUE NOT NULL	,
		Value2 INT		  NOT NULL
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
  UPDATE �浹 ���� PART2
  1.�ܺ�Ű ���� ������
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
 TRUNCATE ���� ������
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
 ��������Ʈ 
 https://sqlperformance.com/2020/07/t-sql-queries/table-expressions-part-4
 https://www.sqlshack.com/snapshot-isolation-in-sql-server/
**************************************************************************************************/
