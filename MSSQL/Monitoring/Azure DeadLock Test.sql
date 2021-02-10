/*************************************************************************************************
 ���̺� ����
**************************************************************************************************/
CREATE TABLE dbo.Player
(	
	PlayerSeq BIGINT CONSTRAINT DF_Player_PlayerSeq DEFAULT (NEXT VALUE FOR dbo.PlayerSeq) NOT NULL
,	PlayerName NVARCHAR(30) CONSTRAINT DF_Player_PlayerName DEFAULT ('')  NOT NULL
,	CreateDT DATETIME2 CONSTRAINT DF_CreateDT DEFAULT SYSDATETIME() NOT NULL
,	CONSTRAINT PK_Player PRIMARY KEY(PlayerSeq)
)

/*************************************************************************************************
 ���̺� ���� �� Ʈ�����
**************************************************************************************************/ 
INSERT INTO dbo.Player(PlayerName)
SELECT N'�̵���' UNION ALL
SELECT N'�ֿ��' UNION ALL
SELECT N'������'

/*************************************************************************************************
 ����1
**************************************************************************************************/ 
BEGIN TRAN

	UPDATE dbo.Player 
	SET PlayerName = N'�⼺��'
	WHERE PlayerSeq = 15
	   
	WAITFOR DELAY '00:00:05'

	UPDATE dbo.Player  
	SET PlayerName = N'��û��'
	WHERE PlayerSeq = 16

ROLLBACK

/*************************************************************************************************
 ����2
**************************************************************************************************/ 
BEGIN TRAN
	
	UPDATE dbo.Player  
	SET PlayerName = N'��û��'
	WHERE PlayerSeq = 16

	WAITFOR DELAY '00:00:05'

	UPDATE dbo.Player 
	SET PlayerName = N'�⼺��'
	WHERE PlayerSeq = 15
	   

ROLLBACK


/*************************************************************************************************
 Deadlock Ȯ��
**************************************************************************************************/ 

USE master
GO
WITH CTE AS (  
       SELECT CAST(event_data AS XML)  AS [target_data_XML]  
   FROM sys.fn_xe_telemetry_blob_target_read_file('dl', null, null, null)  
)  
SELECT target_data_XML.value('(/event/@timestamp)[1]', 'DateTime2') AS Timestamp,  
target_data_XML.query('/event/data[@name=''xml_report'']/value/deadlock') AS deadlock_xml,  
target_data_XML.query('/event/data[@name=''DataBaseName �Է�'']/value').value('(/value)[1]', 'nvarchar(100)') AS db_name  
FROM CTE  