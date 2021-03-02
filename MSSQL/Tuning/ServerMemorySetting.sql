/*************************************************************************************************
 SQL Sever는 OS에 메모리 반환(X)
 1.MAX,MIN MEMORY 설정을 통해서(반환) 메모리 90%초과하지 않도록 조절
**************************************************************************************************/

EXEC SP_CONFIGURE 'SHOW ADVANCED OPTIONS', 1   -- 고급 구성 옵션 표시
RECONFIGURE WITH OVERRIDE -- DB재시작을 안하고 데이터 형식만 맞으면 모든 옵션 값 허용, RECONFIGURE은 동적으로 업데이트 fill factor옵션 값을 재구성 하려면 데이터베이스 엔지 재 시작
GO
EXEC SP_CONFIGURE
GO
EXEC SP_CONFIGURE 'MAX SERVER MEMORY (MB)', 21500
RECONFIGURE WITH OVERRIDE
GO
EXEC SP_CONFIGURE 'MIN SERVER MEMORY (MB)', 21500 
RECONFIGURE WITH OVERRIDE
GO
EXEC SP_CONFIGURE 'SHOW ADVANCED OPTIONS', 0 -- 고급 구성 옵션 닫음
RECONFIGURE WITH OVERRIDE
GO
EXEC SP_CONFIGURE
GO

--메모리 확인
SELECT value,  minimum, maximum  
FROM sys.configurations   
WHERE name in ('min server memory (MB)','max server memory (MB)')