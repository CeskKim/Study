USE TestDB
GO
/*************************************************************************************************
 테이블 생성
**************************************************************************************************/
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE ID = OBJECT_ID('TBLImage') AND Xtype = 'U')
BEGIN
	CREATE TABLE TBLImage
	(
		DataSeq		INT		,
		Photo		NVARCHAR(50)	,
		Image		VARBINARY(MAX)
	)
END

INSERT INTO TBLImage
SELECT 1, N'유투브', BulkColumn 
  FROM OPENROWSET(BULK N'C:\Users\pkuuu\Desktop\Youtube.JPG', SINGLE_BLOB) AS Image

/*
	1.에러 발생 : 복제할LOB 데이터의 길이가 구성된 최대 길이 65536길이를 초과합니다.
	2.조치 : SSMS이용 -> 서버 우클릭 -> 속성 -> 고급 -> 최대 텍스트 복제길이 -1로 변경 기본 : 65536
	3.sp_configure 사용
*/

--sp_configure
USE TestDB
GO
EXEC sp_configure 'show advanced options', 1; 
RECONFIGURE ; 
GO
EXEC sp_configure 'max text repl size', -1; 
GO
RECONFIGURE; 
GO




 /*
	1.에러 발생 : 파일 "‪C:\Users\pkuuu\Desktop\TestLob.JPG"을(를) 열 수 없으므로 대량 로드할 수 없습니다. 운영 체제 오류 코드 123(파일 이름, 디렉터리 이름 또는 볼륨 레이블 구문이 잘못되었습니다.)입니다.
	2.조치 : 파일 형식 문제로 위치 복사시 문제발생 -> 직접 타이핑으로 해결
 */
--파일 위치 복사본
INSERT INTO TBLImage
SELECT 1, BulkColumn 
  FROM OPENROWSET(Bulk '‪C:\Users\pkuuu\Desktop\TestLob.JPG', SINGLE_BLOB) AS Image
