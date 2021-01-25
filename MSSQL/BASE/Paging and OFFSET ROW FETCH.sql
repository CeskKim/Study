USE TestDB
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
/*************************************************************************************************
 1.기본 페이지 기법
**************************************************************************************************/
DECLARE 
	@PAGENO TINYINT = 2
,	@PAGESIZE TINYINT = 5

SELECT
	A.ROWNUM
,	A.ProudctID
,	A.Discount
FROM
(
	SELECT
		ROW_NUMBER() OVER(ORDER BY ProudctID) AS ROWNUM
	,	ProudctID
	,	Discount
	FROM dbo.TBLUnnestDetail
)AS A 
WHERE
	A.ROWNUM BETWEEN((@PAGENO-1) * @PAGESIZE) + 1 AND (@PAGENO * @PAGESIZE)

/*************************************************************************************************
 2.OFFSET ROWS FETCH
 *SQL SERVER 2012부터 지원
**************************************************************************************************/
DECLARE 
	@PAGENO2 TINYINT = 2
,	@PAGESIZE2 TINYINT = 5

SELECT
	ProudctID
,	Discount
FROM dbo.TBLUnnestDetail
ORDER BY
	ProudctID
OFFSET (@PAGENO2-1) * @PAGESIZE2 ROW
FETCH NEXT @PAGESIZE2 ROW ONLY

