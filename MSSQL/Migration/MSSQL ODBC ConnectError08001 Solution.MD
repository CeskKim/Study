## 목적
- MSSQL ODBC ConnectError08001 해결방안

![ODBCConnectError08001](./img/ODBCConnectError08001.JPG)
___

## 해결방안
- SQL Server 구성 관리자 : TCP/IP 상태 [사용] 으로 변경
- 인/아웃바운드에서 SQL Server 기본 포트 1433 허용 설정
___

## 실행내역
- SQL Server 구성 관리자

![ODBCConnectError08001Solution0.JPG](./img/ODBCConnectError08001Solution0.JPG)

- 인/아웃바운드  동일 설정

![ODBCConnectError08001Solution1.JPG](./img/ODBCConnectError08001Solution1.JPG)

![ODBCConnectError08001Solution2.JPG](./img/ODBCConnectError08001Solution2.JPG)

![ODBCConnectError08001Solution3.JPG](./img/ODBCConnectError08001Solution3.JPG)

![ODBCConnectError08001Solution4.JPG](./img/ODBCConnectError08001Solution4.JPG)

![ODBCConnectError08001Solution5.JPG](./img/ODBCConnectError08001Solution5.JPG)
