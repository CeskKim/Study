/*************************************************************************************************
 �������� �� ������ Ȯ��
 Status
 1.dormant : SqlServer���� ���� �� ���� ����
 2.running : ���ǿ��� �ϰ� ó���� �ϳ� �̻� ���� ����
 3.background : ���ǿ��� ��׶��� �½�ũ ���� ����
 4.rollback  : ���ǿ��� Ʈ����� �ѹ� ���� ����
 5.pending : �۾��� �����带 ����� �� ������ ���� ��� ����
 6.runnable : ������ ������ ����
 7.sleeping : ������ �۾��� ��ٸ��� �ִ� ����
 8.spinloop : ������ ���ɶ��� �ɷ� �ִ� ����
 9.suspended : ������ �̺�Ʈ�� �߻��� ������ ����ϰ� �ִ� ����
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

--���� ����
KILL [SPID]