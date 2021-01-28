/*************************************************************************************************
 UserMode 확인
 1.데이터베이스 우클릭 -> 속성 -> 옵션에서 액세스 제한으로 확인 가능
 * MULTI User일 경우 QueryStore, Collation 변경시 오류 발생
 * 새쿼리 하나당 하나의 세션, SINGLEUSER모드 일 경우 새로운 새션 연결 불가
**************************************************************************************************/
SELECT
	B.[NAME]
,	A.SPID
,	A.Login_Time
,	A.Nt_UserName
,	A.loginame
FROM SYSPROCESSES  AS A WITH(NOLOCK)
INNER JOIN SYSDATABASES  AS B WITH(NOLOCK)
ON
	A.[DBID] = B.[DBID]
WHERE
	B.[NAME]  = N'TestDB'

-- SINGLE USER MODE 변경
-- WITH ROLLBACK IMMEDIATE : 현재 트랜잭션 발생시 즉시 롤백, ALTER DABASE의 경우 모든 트랜잭션이 COMMIT 또는 ROLLBACK이 완료되어야 실행
ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;  --현재 활성화 되어 있는 트랜잭션을 즉시 롤백 후 싱글유저모드로 변경
ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK AFTER 60; --현재 활성화 되어 있는 트랜잭션을 60초 후에 모두 처리하고 싱글유저모드로 변경

-- MULTIUSER MODE 변경
ALTER DATABASE TestDB SET MULTI_USER