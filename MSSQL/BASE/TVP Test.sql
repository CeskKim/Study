USE TestDB 
GO
/*************************************************************************************************
 TVP ����
**************************************************************************************************/
CREATE TYPE dbo.LessonType AS TABLE
(	
	LessonID INT
,	LessonName NVARCHAR(100)
)

CREATE TABLE dbo.TBLLesson
(
	ID INT NOT NULL PRIMARY KEY
,	LName NVARCHAR(50)
)

/*************************************************************************************************
 TVP Procedure ����
**************************************************************************************************/
CREATE PROCEDURE dbo.Usp_InsertLesson
	@ParLessonType LessonType READONLY
AS
	INSERT INTO dbo.TBLLesson
	SELECT * FROM @ParLessonType

DECLARE 
	@VarLessonType  AS LessonType --TVP

INSERT INTO @VarLessonType
VALUES(1, N'Math')
INSERT INTO @VarLessonType
VALUES(2, N'Science')
INSERT INTO @VarLessonType
VALUES(3, N'Geometry')

EXEC dbo.Usp_InsertLesson @VarLessonType

/*************************************************************************************************
 MEMORY_OPTIMIZED ���
**************************************************************************************************/
--FileGroup����
ALTER DATABASE TestDB ADD FILEGROUP IMOLTP CONTAINS MEMORY_OPTIMIZED_DATA;
--FileGroup��ġ ����
ALTER DATABASE TestDB ADD FILE (NAME='IMOLTP',FILENAME='C:\MOPT') TO FILEGROUP IMOLTP;


CREATE TYPE dbo.LessonTypeOptimized AS TABLE
(
	LessonID INT NOT NULL PRIMARY KEY NONCLUSTERED  HASH WITH(BUCKET_COUNT = 1000) --CLUSTERED INDEX�� MEMORY_ORPTIMZED ����(X)
,	LessonName NVARCHAR(50)	
) WITH (MEMORY_OPTIMIZED = ON)


CREATE PROCEDURE dbo.Usp_InsertLessonMemOpt
	@ParLessonType LessonTypeOptimized READONLY
AS
	INSERT INTO dbo.TBLLesson
	SELECT * FROM @ParLessonType


DECLARE 
	@VarLessonType_OptiMized  AS LessonType --TVP

INSERT INTO @VarLessonType_OptiMized
VALUES(4, N'Math')
INSERT INTO @VarLessonType_OptiMized
VALUES(5, N'Science')
INSERT INTO @VarLessonType_OptiMized
VALUES(6, N'Geometry')

/*************************************************************************************************
 PerfMon ����͸�
 *SQLServer:Database- > Write  Transcations/sec. tempdb -> ADD
 1.TVP VS TVP_Memory_Optimized ��
**************************************************************************************************/
--TVP
TRUNCATE TABLE dbo.TBLLesson
GO    
DECLARE @Counter AS INT=1
WHILE @Counter <= 100000
BEGIN 
DECLARE @VarLessonType AS LessonType
    
SET @Counter = @Counter+1 
    
INSERT INTO @VarLessonType
VALUES ( @Counter, 'Math'
           )
SET @Counter = @Counter+1
INSERT INTO @VarLessonType
VALUES ( @Counter, 'Science'
       )
SET @Counter = @Counter+1
INSERT INTO @VarLessonType
VALUES ( @Counter, 'Geometry'
       )
EXEC dbo.Usp_InsertLesson @VarLessonType
DELETE @VarLessonType
END


--TVP_Memory_Optimized
TRUNCATE TABLE dbo.TBLLesson
GO
DECLARE @Counter AS INT=1
WHILE @Counter <= 100000
BEGIN 
DECLARE @VarLessonType_MemOptimized AS LessonTypeOptimized
    
SET @Counter = @Counter+1 
    
INSERT INTO @VarLessonType_MemOptimized
VALUES ( @Counter, 'Math'
       )
SET @Counter = @Counter+1
 
INSERT INTO @VarLessonType_MemOptimized
VALUES ( @Counter, 'Science'
       )
SET @Counter = @Counter+1
 
INSERT INTO @VarLessonType_MemOptimized
VALUES ( @Counter, 'Geometry'
       )
EXECUTE Usp_InsertLessonMemOpt @VarLessonType_MemOptimized
DELETE @VarLessonType_MemOptimized
END