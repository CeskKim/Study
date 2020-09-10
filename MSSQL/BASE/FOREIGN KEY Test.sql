USE TestDB
GO
/*************************************************************************************************
 테이블 생성
 1.기준 테이블 : TBLUser
 2.참조 테이블 : TBLItem
   2.1 CASCADE     : 기준테이블 변경,삭제 -> 참조테이블 변경, 삭제
   2.2 SET NULL    : 기준테이블 삭제 -> 참조테이블 해당 필드 NULL 값
   2.3 SET DEFAULT : 기준테이블 삭제 -> 참조테이블 해당 필드 DEFAULT 값
   2.4 NO ACTION   : 참조무결성 위반하는 액션은 되지 않음
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLBase') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLBase
	(
		UserSeq		INT				,
		UserID		NVARCHAR(20)	,
		UserName	NVARCHAR(30)	,

		CONSTRAINT PK_TBLBase PRIMARY KEY(UserSeq)
	)
END
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) --참조테이블에서 기준테이블에 참조 칼럼이 PK/UNIQUE로 설정되어야함
	)
END

INSERT INTO TBLBase(UserSeq, UserID, UserName)
SELECT 1, N'Chobo', N'홍길동' WHERE NOT EXISTS(SELECT 1 FROM TBLBase WHERE UserSeq = 1)
INSERT INTO TBLBase(UserSeq, UserID, UserName)
SELECT 2, N'Hauso', N'김철수' WHERE NOT EXISTS(SELECT 1 FROM TBLBase WHERE UserSeq = 2)
INSERT INTO TBLBase(UserSeq, UserID, UserName)
SELECT 3, N'Got', N'강장군' WHERE NOT EXISTS(SELECT 1 FROM TBLBase WHERE UserSeq = 3)

--원본 테이블의 데이터가 존재해야만 참조하는 데이터 INSERT 가능
INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

/*
  CASCADE : 기준테이블 변경,삭제 -> 참조테이블 변경, 삭제
  UPDATE CASECADE : 기준테이블 변경 -> 참조테이블 같이 변경,  DELETE CASECADE : 기준테이블 삭제 -> 참조테이블 같이 삭제
*/
DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON UPDATE CASCADE
	
	)
END
INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

UPDATE TBLBase
   SET UserSeq = 5
 WHERE UserSeq = 1

SELECT *
  FROM TBLItem 
 WHERE UserSeq = 5

 DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON DELETE CASCADE
	
	)
END
--기준테이블 데이터 원복
UPDATE TBLBase
   SET UserSeq = 1
 WHERE UserSeq = 5

INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

DELETE FROM TBLBase WHERE UserSeq = 1
SELECT * FROM TBLItem



/*
  SET NULL    : 기준테이블 변경,삭제 -> 참조테이블 해당 필드 NULL 값
  UPDATE SET NULL : 기준테이블 변경 -> 참조테이블 같이 필드 NULL,  DELETE SET NULL : 기준테이블 삭제 -> 참조테이블 필드 NULL
  해당 참조 필드는 NULL값으로 설정되어야 함
*/

 DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT	NULL
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON UPDATE SET NULL
	
	)
END
INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

UPDATE TBLBase
   SET UserSeq = 5
 WHERE UserSeq = 1
SELECT * FROM TBLItem


 DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT	NULL
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON DELETE SET NULL
	
	)
END
INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

--기준데이터 원복
UPDATE TBLBase
   SET UserSeq = 1
 WHERE UserSeq = 5

 DELETE FROM TBLBase WHERE UserSeq = 1
 SELECT * FROM TBLItem



 /*
  SET DEFAULT : 기준테이블 변경,삭제 -> 참조테이블 해당 필드 DEFAULT 값
  UPDATE SET NULL : 기준테이블 변경 -> 참조테이블 같이 필드 DEFAULT,  DELETE SET NULL : 기준테이블 삭제 -> 참조테이블 필드 DEFAULT
  UPDATE -> 기준테이블에서 업데이트 하는 값이 참조테이블에 참조 필드 기본값으로 설정된 경우만 진행
  DELETE -> 기준테이블에서 삭제 시 참조테이블의 참조 필드 기본 값이 기준테이블 범위 안에 존재하는 경우에만 진행
*/

 DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT	DEFAULT(5)
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON UPDATE SET DEFAULT
	
	)
END

INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

UPDATE TBLBase
   SET UserSeq = 1
 WHERE UserSeq = 5

 SELECT * FROM TBLItem



DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT	DEFAULT(2)
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON DELETE SET DEFAULT
	
	)
END

INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

DELETE FROM TBLBase WHERE UserSeq = 1
SELECT * FROM TBLItem



 /*
  NO ACTION : 참조무결성 위배되는 행위 금지
 
*/
DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT	DEFAULT(5)
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON UPDATE NO ACTION
	
	)
END

INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)
UPDATE TBLBase
   SET UserSeq = 5
 WHERE UserSeq = 1

DROP TABLE TBLItem
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLItem
	(
		ItemSeq			INT				,
		ItemDate		NCHAR(8)		,
		ItemName		NVARCHAR(30)	,
		UserSeq			INT	DEFAULT(5)
		
		CONSTRAINT PK_TBLItem PRIMARY KEY (ItemSeq)
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) ON DELETE NO ACTION
	
	)
END
INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'가전제품',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'휴대폰', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)
DELETE FROM TBLBase WHERE UserSeq = 1