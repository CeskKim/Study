/*************************************************************************************************
 SQL Sever�� OS�� �޸� ��ȯ(X)
 1.MAX,MIN MEMORY ������ ���ؼ�(��ȯ) �޸� 90%�ʰ����� �ʵ��� ����
**************************************************************************************************/

EXEC SP_CONFIGURE 'SHOW ADVANCED OPTIONS', 1   -- ��� ���� �ɼ� ǥ��
RECONFIGURE WITH OVERRIDE -- DB������� ���ϰ� ������ ���ĸ� ������ ��� �ɼ� �� ���, RECONFIGURE�� �������� ������Ʈ fill factor�ɼ� ���� �籸�� �Ϸ��� �����ͺ��̽� ���� �� ����
GO
EXEC SP_CONFIGURE
GO
EXEC SP_CONFIGURE 'MAX SERVER MEMORY (MB)', 21500
RECONFIGURE WITH OVERRIDE
GO
EXEC SP_CONFIGURE 'MIN SERVER MEMORY (MB)', 21500 
RECONFIGURE WITH OVERRIDE
GO
EXEC SP_CONFIGURE 'SHOW ADVANCED OPTIONS', 0 -- ��� ���� �ɼ� ����
RECONFIGURE WITH OVERRIDE
GO
EXEC SP_CONFIGURE
GO

--�޸� Ȯ��
SELECT value,  minimum, maximum  
FROM sys.configurations   
WHERE name in ('min server memory (MB)','max server memory (MB)')