/*************************************************************************************************
 In-Memory OLTP DB로 변경
 1.DISK 테이블과 다르게 Latch가 발생하지 않음 페이지 구조가 아닌 각 행을 포인터로 처리하는 방식
**************************************************************************************************/
ALTER DATABASE inMemoryDB ADD FILEGROUP [inMemoryDB_Fg] CONTAINS MEMORY_OPTIMIZED_DATA
ALTER DATABASE inMemoryDB ADD FILE(NAME = inMemoryDB_dir, FILENAME = 'C:\InMemoryDB\inMemoryDB_dir') TO FILEGROUP inMemoryDB_Fg
/*************************************************************************************************
 In-Memory OLTP에서는 데이터가 메모리 상주
 서버 재부팅시 데이터 유지를 위해 Filestream에 저장된 데이터, 트랜잭션 로그를 사용 재부팅시 저장된 데이터를
 메모리로 다시 로드
**************************************************************************************************/
/*************************************************************************************************
 참조자료
 https://m.blog.naver.com/PostView.nhn?blogId=gun0626&logNo=220089783486&proxyReferer=https:%2F%2Fwww.google.com%2F
 https://channel9.msdn.com/Events/Channel9-Korea/SQL-/SQL-Server-2016-In-Memory-OLTP
**************************************************************************************************/
