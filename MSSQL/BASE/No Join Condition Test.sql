USE TestDB
GO
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*************************************************************************************************
 ���̺����
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLProduct') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLProduct
	(
		ProductSeq		INT				,
		ProductNo		NVARCHAR(30)	,

		CONSTRAINT PK_TBLProduct PRIMARY KEY(ProductSeq)
	)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLProductItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLProductItem
	(
		ProductSeq		INT				,
		ProductSerl		INT				,
		DetailName		NVARCHAR(50)	,
		Qty				DECIMAL(19,5)	,
		Price			DECIMAL(19,5)

		CONSTRAINT PK_TBLProductItem PRIMARY KEY(ProductSeq,ProductSerl)
	)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLProductPlan') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLProductPlan
	(
		ProductSeq		INT				,
		ProductSerl		INT				,
		StartPlace		NVARCHAR(50)	,
		EndPlace		NVARCHAR(50)	,
		Remark			NVARCHAR(100)

		CONSTRAINT PK_TBLProductPlan PRIMARY KEY(ProductSeq,ProductSerl)
	)
END

DECLARE @BNum	INT,
		@ENum	INT
SELECT @BNUM = 1,
	   @ENum = 3

WHILE @BNum <= @ENum
BEGIN
	INSERT INTO TBLProduct(ProductSeq,ProductNo)
	SELECT @BNum, CONVERT(NCHAR(8), GETDATE(),112) + '000' + CONVERT(NVARCHAR(20), @BNum)
	 WHERE NOT EXISTS(SELECT 1 FROM TBLProduct WHERE ProductSeq = @BNum)
	SELECT @BNum = @BNum + 1
END

INSERT INTO TBLProductItem(ProductSeq,ProductSerl,DetailName,Qty,Price)
SELECT 1,1, N'������', 3, 10000 WHERE NOT EXISTS(SELECT 1 FROM TBLProductItem WHERE ProductSeq = 1 AND  ProductSerl = 1) UNION ALL
SELECT 1,2, N'���̸�', 2, 20000 WHERE NOT EXISTS(SELECT 1 FROM TBLProductItem WHERE ProductSeq = 1 AND  ProductSerl = 2) UNION ALL
SELECT 1,3, N'�����е�', 1, 30000 WHERE NOT EXISTS(SELECT 1 FROM TBLProductItem WHERE ProductSeq = 1 AND  ProductSerl = 3)
   
INSERT INTO TBLProductPlan(ProductSeq,ProductSerl,StartPlace,EndPlace,Remark)
SELECT 1,1, N'����', N'�뱸', N'��ǰ â��' WHERE NOT EXISTS(SELECT 1 FROM TBLProductPlan WHERE ProductSeq = 1 AND  ProductSerl = 1) UNION ALL
SELECT 1,2, N'����', N'�λ�', N'���� â��' WHERE NOT EXISTS(SELECT 1 FROM TBLProductPlan WHERE ProductSeq = 1 AND  ProductSerl = 2)
   

/*************************************************************************************************
 ���� ���� Ȯ��(�����ȹ)
 1.TBLProductPlan ���ν� TBLProduct,TBLProductItem ������ ��� -> �����ȹ�� ��� : ������ ���� Ȯ��
   => TBLProductPlan�� ���� ���� �������� ���� ������ �߻�
**************************************************************************************************/
--������ ����
SELECT *
  FROM TBLProduct			AS A
  JOIN TBLProductItem		AS B ON A.ProductSeq = B.ProductSeq
  JOIN TBLProductPlan		AS C ON A.ProductSeq = B.ProductSeq
--����
SELECT *
  FROM TBLProduct			AS A
  JOIN TBLProductItem		AS B ON A.ProductSeq = B.ProductSeq
  JOIN TBLProductPlan		AS C ON A.ProductSeq = C.ProductSeq