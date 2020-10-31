/*************************************************************************************************
 SEQUENCE CREATE 
 1.START WITH	: ������
 2.INCREMENT BY : ������
 3.MINVALUE		: �ּҰ�
 4.MAXVALUE		: �ִ밪
 5.CYCLE		: ��ȯ -> ��ȯ�� �ּ� �� ���� ��ȯ
 6.CACHE		: ĳ��(1������ NO CACHE)
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
