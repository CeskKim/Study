/*************************************************************************************************
 Collation ����
 1.On-Premise �Ǵ� Iaas ȯ�濡���� ALTER ������ ���� Collation ���� ����
 2.Azure�� ���� Pass ��쿡�� ALTER�� �ƴ� DataBase ��ü�� �����ϰ� �ٽ� ����
   *Azure DataBase ������ Collation�κ� �����ؼ� ����
**************************************************************************************************/
ALTER DATABASE TestDB COLLATE korean_wansung_ci_as --�����ͺ��̽� ����
GO
ALTER TABLE dbo.TBLBase ALTER COLUMN UserName NVARCHAR(50) COLLATE korean_wansung_ci_as --���̺� ����

