USE TestDB
GO
/*************************************************************************************************
 테이블 생성 및 인덱스 생성 
 1.TBLHeap : NONCLUSTERED
 2.TBLCIX  : CLUSTERED
 3.TBLTime : 시간측정
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLHeap') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLHeap
	(
		ObjectID			INT PRIMARY KEY NONCLUSTERED,
		Name				NVARCHAR(2000)				,
		SchemaID			INT							,
		ModuleDefinition	NVARCHAR(MAX)

	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IDX_TBLHeap')
BEGIN
	CREATE INDEX IDX_TBLHeap ON TBLHeap(Name) INCLUDE(SchemaID)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLCIX') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLCIX
	(
		ObjectID			INT PRIMARY KEY CLUSTERED	,
		Name				NVARCHAR(2000)				,
		SchemaID			INT							,
		ModuleDefinition	NVARCHAR(MAX)

	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IDX_TBLCIX')
BEGIN
	CREATE INDEX IDX_TBLCIX ON TBLCIX(Name) INCLUDE(SchemaID)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLTime') AND Xtype = 'U')
BEGIN
	
	/* 
	[DATETIME2 ]
	MSSQL 2008부터 지원, YYYY-MM-DD hh:mm:ss[.소수자릿수 초]
	자릿수 < 3 : 6Byte, 자릿수 > 3 : 7Byte, 기타 : 8Byte
	DATETIME의 경우 1953년 이전 데이터의 문제 발생, 초 이하 정확도가 떨어지기 때문에 비권장
	[SYSUTCDATETIME]
	DATETIME2 값을 반환, 소수자릿수 초 (1~7자릿수), GETDATE(), GETUTCDATE()보다 많은 소수자릿수 초 보유

	*/


	CREATE TABLE TBLTime
	(
		Test		NVARCHAR(50) NOT NULL,
		StartTime	DATETIME2	 NOT NULL DEFAULT SYSUTCDATETIME(),
		EndTime		DATETIME2

	)
END
/*************************************************************************************************
 INSERT 테스트
**************************************************************************************************/
--TBELHeap
INSERT INTO TBLTime(TEST)VALUES('TBLHeap')
GO
TRUNCATE TABLE TBLHeap

INSERT TBLHeap(ObjectID, Name, SchemaID, ModuleDefinition) 
SELECT TOP 2000 [object_id], name, [schema_id], OBJECT_DEFINITION([object_id])
  FROM sys.all_objects 
ORDER BY [object_id]

GO 100
UPDATE TBLTime 
  SET EndTime = SYSUTCDATETIME() 
 WHERE EndTime IS NULL;
GO

--TBLCIX
INSERT INTO TBLTime(TEST)VALUES('TBLCIX')
GO
TRUNCATE TABLE TBLCIX

INSERT TBLCIX(ObjectID, Name, SchemaID, ModuleDefinition) 
SELECT TOP 2000 [object_id], name, [schema_id], OBJECT_DEFINITION([object_id])
  FROM sys.all_objects 
ORDER BY [object_id]

GO 100
UPDATE TBLTime 
  SET EndTime = SYSUTCDATETIME() 
 WHERE EndTime IS NULL;
GO


/*************************************************************************************************
 SELECT 테스트
 1.RID LookUp의 경우 Key Lookup보다 조회시 속도가 더 빠름 
   => NONCLUSTERED INDEX : root -> branch -> leaf -> data page
   => NONCLUSTERED INDEX + CLUSTERED INDEX : root -> branch -> leaf -> CLUSTERED INDEX PAGE -> data page
      => NONCLUSTERED INDEX에 CLUSTERED INDEX의 키 값이 같이 저장, leaf레벨에서 바로 data page로 가는 것이 아닌
	     CLUSTERED INDEX PAGE을 거치고 가기 때문에 NONCLUSTERED INDEX 지정 되었을때 보단 속도가 느림
**************************************************************************************************/
SET STATISTICS IO ON
 SELECT*
   FROM TBLHeap WITH (INDEX(IDX_TBLHeap)) 
  WHERE Name LIKE N'S%'
 
SELECT *
  FROM TBLCIX WITH (INDEX(IDX_TBLCIX)) 
WHERE Name LIKE N'S%'

