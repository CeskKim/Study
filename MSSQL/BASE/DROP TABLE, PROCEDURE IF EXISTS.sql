USE TestDB
GO
/*************************************************************************************************
 SQL SERVER 2016부터 추가
 1.IF EXISTS 대시 DROP IF EXISTS 사용가능
**************************************************************************************************/
DROP TABLE IF EXISTS dbo.TestTable
GO
CREATE TABLE dbo.TestTable
(
	TestSeq SMALLINT NOT NULL
,	TestName NVARCHAR(50)
)
DROP PROCEDURE IF EXISTS dbo.SPTest
GO
CREATE PROCEDURE dbo.SPTest
AS
	SELECT 1 RETURN;


