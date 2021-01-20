/*************************************************************************************************
  테이블 용량 확인 
**************************************************************************************************/
EXEC sp_spaceused 'TestDB.dbo.TBLParent';

GO

SELECT CONVERT(VARCHAR(30), MIN(o.name)) AS t_name
, LTRIM(STR(SUM(reserved) * 8192.0 / 1024.0, 15, 0)) AS t_size
, UNIT = 'KB'
FROM  sysindexes AS i 
INNER JOIN sysobjects AS o ON o.id = i.id
WHERE 
	i.indid IN (0, 1, 255) 
AND 
	o.xtype = 'U'
GROUP BY 
	i.id
ORDER BY 
	t_name ASC
