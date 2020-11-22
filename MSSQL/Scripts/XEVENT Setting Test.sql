 USE TestDB
 GO
 /*************************************************************************************************
 XEVENT Test Table
**************************************************************************************************/
CREATE TABLE dbo.TBLXevent
(
	X1 INT IDENTITY
,	X2 NVARCHAR(100) CONSTRAINT DF_TBLXevent DEFAULT('A')
,	CONSTRAINT PK_TBLXevent PRIMARY KEY(X1 ASC)
);

INSERT INTO dbo.TBLXevent DEFAULT VALUES;

/*************************************************************************************************
 기존 XEVENT 설정된 내역 존재 -> 삭제
**************************************************************************************************/
IF EXISTS(SELECT 1 FROM sys.server_event_sessions WHERE [NAME] = N'Monitorlog')
BEGIN
	DROP EVENT SESSION [Monitorlog] ON SERVER
END


/*************************************************************************************************
 신규 XEVENT설정
**************************************************************************************************/
CREATE EVENT SESSION [MonitorLog] ON SERVER
ADD EVENT [sqlserver].[file_write_completed],
ADD EVENT [sqlserver].[transaction_log]
ADD TARGET [package0].[ring_buffer]
WITH (MAX_MEMORY = 50MB, max_dispatch_latency = 1 seconds)

GO

ALTER EVENT SESSION [Monitorlog] ON SERVER
STATE = START;

/*************************************************************************************************
 참조사이트
 https://sungwookkang.com/1078
**************************************************************************************************/

