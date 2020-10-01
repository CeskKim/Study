USE ExampleDB
GO
/*************************************************************************************************
 ������ ���� ��ȸ
**************************************************************************************************/

SELECT  [TEXT],
		SUBSTRING(st.[TEXT], (qs.statement_start_offset/2)+1, 
		((CASE qs.statement_end_offset	WHEN -1 
										THEN DATALENGTH(st.[TEXT])
		  ELSE qs.statement_end_offset	END - qs.statement_start_offset)/2) + 1) 
		AS statement_text,* 
  FROM  sys.dm_exec_requests AS qs
  CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS st
  CROSS APPLY sys.dm_exec_query_plan(plan_handle)

 /*************************************************************************************************
 ��������Ʈ
 https://ittutorial.org/sql-server-dba-scripts-all-in-one-useful-ms-sql-dba-database-administration-scripts/?fbclid=IwAR0sronvPn0lshQ9nYNqaLKP6FnOZ_9I3oq1T1kkGMQnYNQDkQ7Xzxag6JE
**************************************************************************************************/


