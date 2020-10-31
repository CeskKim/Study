/*************************************************************************************************
 SEQUENCE CREATE 
 1.START WITH	: 시작점
 2.INCREMENT BY : 증가값
 3.MINVALUE		: 최소값
 4.MAXVALUE		: 최대값
 5.CYCLE		: 순환 -> 순환시 최소 값 부터 순환
 6.CACHE		: 캐시(1로지정 NO CACHE)
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sys.sequences WHERE name = N'TestSEQUENCE')
BEGIN
	CREATE SEQUENCE TestSEQUENCE AS INT

	START WITH 1
	INCREMENT BY 1
	MINVALUE 10
	MAXVALUE 100
	CYCLE
	CACHE 1
END
SELECT NEXT VALUE FOR TestSEQUENCE

/*************************************************************************************************
 SEQUENCE ALTER 
**************************************************************************************************/
ALTER SEQUENCE TestSEQUENCE AS INT

	START WITH 1
	INCREMENT BY 1
	MINVALUE 5
	MAXVALUE 100
	CYCLE 
	CACHE 1
/*************************************************************************************************
 SEQUENCE DROP 
**************************************************************************************************/
DROP SEQUENCE TestSEQUENCE
