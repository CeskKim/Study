/*************************************************************************************************
 �ּ� �α� �׽�Ʈ
 1.TABLOCK ���
**************************************************************************************************/
CREATE TABLE dbo.TBLBulk
(
	Seq INT
,	BulkNo INT
)
DECLARE 
	@SNUM INT = 1
WHILE @SNUM <= 100000

BEGIN
	INSERT INTO dbo.TBLBulk
	SELECT @SNUM, 10 + @SNUM

	SET @SNUM += 1;
END


WHILE @SNUM <= 100000
BEGIN
	INSERT INTO dbo.TBLBulk WITH(TABLOCK)
	SELECT @SNUM, 10 + @SNUM

	SET @SNUM += 1;
END
