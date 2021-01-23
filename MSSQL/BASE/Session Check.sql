/*************************************************************************************************
 세션정보 및 아이피 확인
 Status
 1.dormant : SqlServer에서 세션 재 설정 상태
 2.running : 세션에서 일괄 처리를 하나 이상 실행 상태
 3.background : 세션에서 백그라운드 태스크 실행 상태
 4.rollback  : 세션에서 트랜잭션 롤백 지행 상태
 5.pending : 작업자 스레드를 사용할 수 있을때 까지 대기 상태
 6.runnable : 세션이 실행중 상태
 7.sleeping : 세션이 작업을 기다리고 있는 상태
 8.spinloop : 세션이 스핀락에 걸려 있는 상태
 9.suspended : 세션이 이벤트가 발생할 때까지 대기하고 있는 상태
**************************************************************************************************/
SELECT
	A.spid
,	A.login_time
,	A.last_batch
,	A.status
,	A.program_name
,	A.cmd
,	A.nt_domain
,	A.nt_username
,	B.client_net_address
FROM sys.sysprocesses AS A
INNER JOIN sys.dm_exec_connections AS B
ON
	A.spid = B.session_id

--세션 종료
KILL [SPID]