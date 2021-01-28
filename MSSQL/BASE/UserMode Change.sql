/*************************************************************************************************
 UserMode Ȯ��
 1.�����ͺ��̽� ��Ŭ�� -> �Ӽ� -> �ɼǿ��� �׼��� �������� Ȯ�� ����
 * MULTI User�� ��� QueryStore, Collation ����� ���� �߻�
 * ������ �ϳ��� �ϳ��� ����, SINGLEUSER��� �� ��� ���ο� ���� ���� �Ұ�
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

-- SINGLE USER MODE ����
-- WITH ROLLBACK IMMEDIATE : ���� Ʈ����� �߻��� ��� �ѹ�, ALTER DABASE�� ��� ��� Ʈ������� COMMIT �Ǵ� ROLLBACK�� �Ϸ�Ǿ�� ����
ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;  --���� Ȱ��ȭ �Ǿ� �ִ� Ʈ������� ��� �ѹ� �� �̱��������� ����
ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK AFTER 60; --���� Ȱ��ȭ �Ǿ� �ִ� Ʈ������� 60�� �Ŀ� ��� ó���ϰ� �̱��������� ����

-- MULTIUSER MODE ����
ALTER DATABASE TestDB SET MULTI_USER