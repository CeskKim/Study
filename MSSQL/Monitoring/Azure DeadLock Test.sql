/*************************************************************************************************
 테이블 생성
**************************************************************************************************/
CREATE TABLE dbo.Player
(	
	PlayerSeq BIGINT CONSTRAINT DF_Player_PlayerSeq DEFAULT (NEXT VALUE FOR dbo.PlayerSeq) NOT NULL
,	PlayerName NVARCHAR(30) CONSTRAINT DF_Player_PlayerName DEFAULT ('')  NOT NULL
,	CreateDT DATETIME2 CONSTRAINT DF_CreateDT DEFAULT SYSDATETIME() NOT NULL
,	CONSTRAINT PK_Player PRIMARY KEY(PlayerSeq)
)

/*************************************************************************************************
 테이블 삽입 및 트랜잭션
**************************************************************************************************/ 
INSERT INTO dbo.Player(PlayerName)
SELECT N'이동국' UNION ALL
SELECT N'최용수' UNION ALL
SELECT N'김정우'

/*************************************************************************************************
 세션1
**************************************************************************************************/ 
BEGIN TRAN

	UPDATE dbo.Player 
	SET PlayerName = N'기성용'
	WHERE PlayerSeq = 15
	   
	WAITFOR DELAY '00:00:05'

	UPDATE dbo.Player  
	SET PlayerName = N'이청용'
	WHERE PlayerSeq = 16

ROLLBACK

/*************************************************************************************************
 세션2
**************************************************************************************************/ 
BEGIN TRAN
	
	UPDATE dbo.Player  
	SET PlayerName = N'이청용'
	WHERE PlayerSeq = 16

	WAITFOR DELAY '00:00:05'

	UPDATE dbo.Player 
	SET PlayerName = N'기성용'
	WHERE PlayerSeq = 15
	   

ROLLBACK


/*************************************************************************************************
 Deadlock 확인
**************************************************************************************************/ 

USE master
GO
WITH CTE AS (  
       SELECT CAST(event_data AS XML)  AS [target_data_XML]  
   FROM sys.fn_xe_telemetry_blob_target_read_file('dl', null, null, null)  
)  
SELECT target_data_XML.value('(/event/@timestamp)[1]', 'DateTime2') AS Timestamp,  
target_data_XML.query('/event/data[@name=''xml_report'']/value/deadlock') AS deadlock_xml,  
target_data_XML.query('/event/data[@name=''DataBaseName 입력'']/value').value('(/value)[1]', 'nvarchar(100)') AS db_name  
FROM CTE  