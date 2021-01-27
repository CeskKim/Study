/*************************************************************************************************
테스트 테이블 생성 및 삽입
**************************************************************************************************/
IF NOT EXISTS(SELECT * FROM sys.tables WHERE object_id = object_id('dbo.UserTable'))
BEGIN
	CREATE TABLE dbo.UserTable
	(
		USeq INT IDENTITY(1,1) NOT NULL
	,	UserName NVARCHAR(30) NOT NULL
	,	CONSTRAINT PK_UserTable PRIMARY KEY(USeq ASC)
	)
END
DECLARE
	@_I TINYINT = 0
,	@_E TINYINT = 10
WHILE @_I <= @_E
BEGIN
	INSERT INTO dbo.UserTable
	(
		UserName
	)
	SELECT
		CAST(@_I AS NVARCHAR(3)) + N'Test'
	
	SET @_I += 1;
END

--UTest의 dbo.UserTable의 조회,삭제,변경 권한
GRANT SELECT,DELETE,UPDATE ON dbo.UserTable TO UTest

--UTest의 dbo.UserTable의 조회,삭제,변경 권한 제거
REVOKE SELECT,DELETE,UPDATE ON dbo.UserTable TO UTest

--UTest 전체 권한(조회,삭제,변경) 설정
GRANT SELECT,DELETE,UPDATE TO UTest

--UTest 전체 권한(조회,삭제,변경) 제거
REVOKE SELECT,DELETE,UPDATE TO UTest


--UTest 전체 권한(조회,삭제,변경) 특정 스키마 설정
GRANT SELECT,DELETE,UPDATE ON SCHEMA :: WEB TO UTest

--UTest 전체 권한(조회,삭제,변경) 특정 스키마 제거
REVOKE SELECT,DELETE,UPDATE ON SCHEMA :: WEB TO UTest


/*************************************************************************************************
권한 조회
**************************************************************************************************/
SELECT 
    A.state_desc       
  ,	A.permission_name  
  ,	B.name             
  ,	B.name             
  , C.name
  , B.name
  ,	A.*
FROM sys.database_permissions AS A
INNER JOIN sys.objects AS B 
ON 
	A.major_id = B.object_id

INNER JOIN sys.database_principals AS C 
ON 
	A.grantee_principal_id = C.principal_id
WHERE 
	A.major_id = object_id('UserTable')

