USE Test
GO

/*Noclustered INDEX와 Clustered INDEX 예시*/

/*
CREATE TABLE IndexTest1
(
	ColA NVARCHAR(10),
	ColB NVARCHAR(10),
	ColC NVARCHAR(10)
)

DECLARE @Num	INT,
		@TNum	INT,
		@SQL	NVARCHAR(MAX),
		@A		NVARCHAR(10),
		@B		NVARCHAR(10),
		@C		NVARCHAR(10)

SELECT @Num  = 1	,
	   @TNum = 10	,
	   @A	 = 'A'	,
	   @B	 = 'B'  ,
	   @C	 = 'C'

WHILE @Num <= @TNum
BEGIN
	SELECT @SQL = 'INSERT INTO IndexTest1',
		   @SQL = @SQL + CHAR(10) + 'SELECT ' + space(0) + '''' + @A+CONVERT(NVARCHAR(10),@Num) + '''' + space(0) + ',',
		   @SQL = @SQL + ''''+@B+CONVERT(NVARCHAR(10),@Num) + ''''+space(0) + ',',
		   @SQL = @SQL + ''''+@C+CONVERT(NVARCHAR(10),@Num) + ''''+space(0),
		   @SQL = @SQL + CHAR(10) + 'Where' + space(2) + CONVERT(NVARCHAR(10),@Num) + '=' + CONVERT(NVARCHAR(10),@Num)

	 PRINT @SQL 
	 EXECUTE sp_executeSql @SQL --EXCUTE sp_executeSql은 재사용이 가능하여, Exec()보다 활용도가 높음
								--Exec()인 경우에는 안에 파라미터가 달라지는 경우 재사용을 하지 않음

	 SELECT @Num = @Num + 1
END

CREATE NONCLUSTERED INDEX Idx_ColA ON IndexTest1 (COLA)
CREATE CLUSTERED INDEX Idx_ColB ON IndexTest1 (COLB)
*/

--exec sp_helpindex IndexTest1
--dbcc show_statistics(IndexTest1, idx_ColA)
--dbcc show_statistics(IndexTest1, idx_ColB)

drop index Idx_ColA on IndexTest1
drop index Idx_ColB on IndexTest1

SELECT COLA FROM IndexTest1 WHERE ColA IN('A1','A2','A3')
SELECT COLA, COLB FROM IndexTest1 WHERE COLA IN('A1','A2','A3')
SET STATISTICS IO ON 

SELECT ColA,ColB FROM IndexTest1  WHERE ColA  = 'A1' AND COLB = 'B1'

--DECLARE @Num INT

--CREATE TABLE IndextTest2 
--(
--	Num INT
--)
--SELECT @Num = 1

--WHILE @Num <= 100
--BEGIN
--	INSERT INTO IndextTest2
--	SELECT @Num

--	SELECT @Num = @Num + 1
--END

--CREATE CLUSTERED INDEX Idx_Num ON IndextTest2 (Num)
SET STATISTICS IO ON 

SELECT  * FROM IndextTest2 WHERE Num > 0

SELECT  * FROM IndextTest2 