USE TestDB
GO

/*************************************************************************************************
 ���̺� ���� �� �ε��� ���� Example1
**************************************************************************************************/

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLUnnest') AND Xtype = 'U')
BEGIN

	CREATE TABLE TBLUnnest
	(
		RegSeq	INT	 IDENTITY(1,1)	,
		RegDate	NCHAR(8)			,
		CONSTRAINT  PK_TBLUnnest PRIMARY KEY(RegSeq)		
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE NAME = 'IDX_TBLUnnest')
BEGIN
	CREATE NONCLUSTERED INDEX IDX_TBLUnnest ON TBLUnnest(RegDate)
END
/*************************************************************************************************
 ������ ���� Example1
**************************************************************************************************/
DECLARE @FirstDate	NCHAR(8),
		@CurrDate	NCHAR(8)
SELECT @FirstDate = CONVERT(NCHAR(8),DATEADD(YY, DATEDIFF(YY, 0, GETDATE()),0),112),
	    @CurrDate = CONVERT(NCHAR(8),GETDATE(),112)

INSERT INTO TBLUnnest(RegDate)
SELECT CONVERT(NCHAR(8), DATEADD(D,number,@FirstDate),112)
  FROM master..spt_values
 WHERE type = 'P'
   AND number <= DATEDIFF(D, @FirstDate, @CurrDate)
   AND NOT EXISTS(SELECT 1
				    FROM TBLUnnest
				   WHERE CONVERT(NCHAR(8), DATEADD(D,number,@FirstDate),112) = RegDate)

/*************************************************************************************************
 ��� : Unnest���� Example1
**************************************************************************************************/
SELECT RegSeq, RegDate
  FROM ( SELECT *
           FROM ( SELECT *
					FROM ( SELECT *
					       FROM TBLUnnest
					       WHERE RegDate >= '20200101' ) AS D1
					WHERE RegDate >= '20200201' ) AS D2
		  WHERE RegDate >= '20200301' ) AS D3
 WHERE RegDate >= '20200401'

 /*************************************************************************************************
 ��� :TOP�� ���� Filter ����(Unnest ����) Example2
**************************************************************************************************/

SELECT RegSeq, RegDate
  FROM ( SELECT TOP (9223372036854775807) *
           FROM ( SELECT TOP (9223372036854775807) *
					FROM ( SELECT TOP (9223372036854775807) *
					       FROM TBLUnnest
					       WHERE RegDate >= '20200101' ) AS D1
					WHERE RegDate >= '20200201' ) AS D2
		  WHERE RegDate >= '20200301' ) AS D3
 WHERE RegDate >= '20200401'


 -----------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------
 /*************************************************************************************************
 ���̺� ���� �� �ε��� ���� Example12
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLUnnestDetail') AND Xtype = 'U')
BEGIN

	CREATE TABLE TBLUnnestDetail
	(
		RegSeq		INT	 IDENTITY(1,1)	,
		ProudctID	NVARCHAR(100)		,
		Discount	INT
		CONSTRAINT  PK_TBLUnnestDetail PRIMARY KEY(RegSeq)		
	)
END

/*************************************************************************************************
 ������ ���� Example2
**************************************************************************************************/
DECLARE @FNum		INT			,
		@ENum		INT			
SELECT @FNum = 1	,
	   @ENum = 100

WHILE @FNum <= @ENum
BEGIN
	INSERT INTO TBLUnnestDetail(ProudctID,Discount)
	SELECT '2020' + CONVERT(NVARCHAR(10),@FNum), @FNum * 10

	SELECT @FNum = @FNum + 1
END

/*************************************************************************************************
 ��� : Unnest���� Example2
**************************************************************************************************/
SELECT RegSeq,ProudctID,Discount
  FROM (
		 SELECT *
		   FROM TBLUnnestDetail
		  WHERE Discount > (SELECT MIN(Discount) FROM TBLUnnestDetail)) AS A
WHERE 1.0 / A.Discount > 10

 /*************************************************************************************************
 ��� :TOP�� ���� Filter ����(Unnest ����) Example2
**************************************************************************************************/
SELECT RegSeq,ProudctID,Discount
  FROM (
		 SELECT TOP (9223372036854775807) *
		   FROM TBLUnnestDetail
		  WHERE Discount > (SELECT MIN(Discount) FROM TBLUnnestDetail)) AS A
WHERE 1.0 / A.Discount > 10


/*************************************************************************************************
 ��������Ʈ :https://sqlperformance.com/2020/07/t-sql-queries/table-expressions-part-4
**************************************************************************************************/
