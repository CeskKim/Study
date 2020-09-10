USE TestDB
GO
/*************************************************************************************************
 ���̺� ����
 1.���� ���̺� : TBLUser
 2.���� ���̺� : TBLItem
   2.1 CASCADE     : �������̺� ����,���� -> �������̺� ����, ����
   2.2 SET NULL    : �������̺� ���� -> �������̺� �ش� �ʵ� NULL ��
   2.3 SET DEFAULT : �������̺� ���� -> �������̺� �ش� �ʵ� DEFAULT ��
   2.4 NO ACTION   : �������Ἲ �����ϴ� �׼��� ���� ����
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
		CONSTRAINT FK_TBLItem FOREIGN KEY (UserSeq) REFERENCES TBLBase(UserSeq) --�������̺��� �������̺� ���� Į���� PK/UNIQUE�� �����Ǿ����
	)
END

INSERT INTO TBLBase(UserSeq, UserID, UserName)
SELECT 1, N'Chobo', N'ȫ�浿' WHERE NOT EXISTS(SELECT 1 FROM TBLBase WHERE UserSeq = 1)
INSERT INTO TBLBase(UserSeq, UserID, UserName)
SELECT 2, N'Hauso', N'��ö��' WHERE NOT EXISTS(SELECT 1 FROM TBLBase WHERE UserSeq = 2)
INSERT INTO TBLBase(UserSeq, UserID, UserName)
SELECT 3, N'Got', N'���屺' WHERE NOT EXISTS(SELECT 1 FROM TBLBase WHERE UserSeq = 3)

--���� ���̺��� �����Ͱ� �����ؾ߸� �����ϴ� ������ INSERT ����
INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

/*
  CASCADE : �������̺� ����,���� -> �������̺� ����, ����
  UPDATE CASECADE : �������̺� ���� -> �������̺� ���� ����,  DELETE CASECADE : �������̺� ���� -> �������̺� ���� ����
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
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

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
--�������̺� ������ ����
UPDATE TBLBase
   SET UserSeq = 1
 WHERE UserSeq = 5

INSERT INTO TBLItem(ItemSeq,ItemDate,ItemName,UserSeq)
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

DELETE FROM TBLBase WHERE UserSeq = 1
SELECT * FROM TBLItem



/*
  SET NULL    : �������̺� ����,���� -> �������̺� �ش� �ʵ� NULL ��
  UPDATE SET NULL : �������̺� ���� -> �������̺� ���� �ʵ� NULL,  DELETE SET NULL : �������̺� ���� -> �������̺� �ʵ� NULL
  �ش� ���� �ʵ�� NULL������ �����Ǿ�� ��
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
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

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
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

--���ص����� ����
UPDATE TBLBase
   SET UserSeq = 1
 WHERE UserSeq = 5

 DELETE FROM TBLBase WHERE UserSeq = 1
 SELECT * FROM TBLItem



 /*
  SET DEFAULT : �������̺� ����,���� -> �������̺� �ش� �ʵ� DEFAULT ��
  UPDATE SET NULL : �������̺� ���� -> �������̺� ���� �ʵ� DEFAULT,  DELETE SET NULL : �������̺� ���� -> �������̺� �ʵ� DEFAULT
  UPDATE -> �������̺��� ������Ʈ �ϴ� ���� �������̺� ���� �ʵ� �⺻������ ������ ��츸 ����
  DELETE -> �������̺��� ���� �� �������̺��� ���� �ʵ� �⺻ ���� �������̺� ���� �ȿ� �����ϴ� ��쿡�� ����
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
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

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
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)

DELETE FROM TBLBase WHERE UserSeq = 1
SELECT * FROM TBLItem



 /*
  NO ACTION : �������Ἲ ����Ǵ� ���� ����
 
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
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)
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
SELECT 1,N'20200902', N'������ǰ',1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 1)
INSERT INTO TBLItem(ItemSeq,ItemDate, ItemName,UserSeq)
SELECT 2,N'20200902', N'�޴���', 1 WHERE NOT EXISTS(SELECT 1 FROM TBLItem WHERE UserSeq = 2)
DELETE FROM TBLBase WHERE UserSeq = 1