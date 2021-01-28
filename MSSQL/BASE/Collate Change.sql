/*************************************************************************************************
 Collation 변경
 1.On-Premise 또는 Iaas 환경에서는 ALTER 구문을 통해 Collation 변경 가능
 2.Azure와 같은 Pass 경우에는 ALTER가 아닌 DataBase 자체를 삭제하고 다시 생성
   *Azure DataBase 생성시 Collation부분 유의해서 생성
**************************************************************************************************/
ALTER DATABASE TestDB COLLATE korean_wansung_ci_as --데이터베이스 변경
GO
ALTER TABLE dbo.TBLBase ALTER COLUMN UserName NVARCHAR(50) COLLATE korean_wansung_ci_as --테이블 변경

