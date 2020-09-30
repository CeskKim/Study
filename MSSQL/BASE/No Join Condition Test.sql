USE TestDB
GO
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*************************************************************************************************
 테이블생성
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLProduct') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLProduct
	(
		ProductSeq		INT		,
		ProductNo		NVARCHAR(30)	,

		CONSTRAINT PK_TBLProduct PRIMARY KEY(ProductSeq)
	)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLProductItem') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLProductItem
	(
		ProductSeq		INT		,
		ProductSerl		INT		,
		DetailName		NVARCHAR(50)	,
		Qty			DECIMAL(19,5)	,
		Price			DECIMAL(19,5)

		CONSTRAINT PK_TBLProductItem PRIMARY KEY(ProductSeq,ProductSerl)
	)
END

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLProductPlan') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLProductPlan
	(
		ProductSeq		INT		,
		ProductSerl		INT		,
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
SELECT 1,1, N'에어팟', 3, 10000 WHERE NOT EXISTS(SELECT 1 FROM TBLProductItem WHERE ProductSeq = 1 AND  ProductSerl = 1) UNION ALL
SELECT 1,2, N'아이맥', 2, 20000 WHERE NOT EXISTS(SELECT 1 FROM TBLProductItem WHERE ProductSeq = 1 AND  ProductSerl = 2) UNION ALL
SELECT 1,3, N'아이패드', 1, 30000 WHERE NOT EXISTS(SELECT 1 FROM TBLProductItem WHERE ProductSeq = 1 AND  ProductSerl = 3)
   
INSERT INTO TBLProductPlan(ProductSeq,ProductSerl,StartPlace,EndPlace,Remark)
SELECT 1,1, N'서울', N'대구', N'물품 창구' WHERE NOT EXISTS(SELECT 1 FROM TBLProductPlan WHERE ProductSeq = 1 AND  ProductSerl = 1) UNION ALL
SELECT 1,2, N'서울', N'부산', N'보관 창구' WHERE NOT EXISTS(SELECT 1 FROM TBLProductPlan WHERE ProductSeq = 1 AND  ProductSerl = 2)
   

/*************************************************************************************************
 조인 조건 확인(실행계획)
 1.TBLProductPlan 조인시 TBLProduct,TBLProductItem 조건절 사용 -> 실행계획시 경고 : 조건절 없음 확인
   => TBLProductPlan에 대한 조인 조건절이 없기 때문에 발생
**************************************************************************************************/
--조건절 없음
SELECT *
  FROM TBLProduct			AS A
  JOIN TBLProductItem		AS B ON A.ProductSeq = B.ProductSeq
  JOIN TBLProductPlan		AS C ON A.ProductSeq = B.ProductSeq
--정상
SELECT *
  FROM TBLProduct			AS A
  JOIN TBLProductItem		AS B ON A.ProductSeq = B.ProductSeq
  JOIN TBLProductPlan		AS C ON A.ProductSeq = C.ProductSeq
