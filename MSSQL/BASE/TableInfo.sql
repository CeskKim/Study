--TABLE SCHEMA TABLE Type Search
SELECT *
FROM INFORMATION_SCHEMA.TABLES

SELECT *
FROM sysobjects 
WHERE xtype = 'U'

SELECT *
FROM sys.tables


--TABLE COLUMN Search
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS

SELECT *
FROM sys.columns 


--TABLE Total Row Count Search
SELECT
	SC.name + '.' + TA.name AS TableName
,	SUM(PA.rows) AS TableRowCnt
FROM sys.tables AS TA
INNER JOIN sys.partitions AS PA
ON
	TA.object_id = PA.object_id
INNER JOIN sys.schemas AS SC
ON
	TA.schema_id = SC.schema_id
WHERE 
	TA.is_merge_published = 0 
AND
	PA.index_id IN(1,0)
GROUP BY 
	SC.name
,	TA.name
ORDER BY
	SUM(PA.rows) DESC
