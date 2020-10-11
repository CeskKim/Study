## 목적
- 환경 및 상황에 의해 데이터베이스 자체를 변경 해야 하는 경우 또는 각각의 데이터베이스를 이중으로 구성해야 하는 경우에 대비 테스트 
___

## 테스트 환경
- MSSQL(2019) -> MariaDB(10.5.0)로 마이그레이션
- ISPIRER상용툴이 아닌 MySQL WorkBench을 활용
- SP(Stored Procedure), Fuction, View제외 Table 및 Data만 마이그레이션
___

## 설치 과정
- 설치주소(Mysql workbench)
- https://dev.mysql.com/downloads/workbench/
- 설치문제(C++ 설치요청)인 경우 아래 링크를 다운 받아 설치 진행
- https://igotit.tistory.com/entry/Visual-C-2010-2015-2017-2019-%EC%9E%AC%EB%B0%B0%ED%8F%AC-%EA%B0%80%EB%8A%A5-%ED%8C%A8%ED%82%A4%EC%A7%80-32bit-64bit
- MySQL WorkBench 설치

![MySQLWorkbenchDownload1](./img/MySQLWorkbenchDownload1.JPG)
![MySQLWorkbenchDownload2](./img/MySQLWorkbenchDownload2.JPG)
___

## ODBC 연결
- MSSQL ODBC연결

![MSSQLODBCAdd](./img/MSSQLODBCAdd.JPG)
![MSSQLODBCClientSetting](./img/MSSQLODBCClientSetting.JPG)
![MSSQLODBCConnect1](./img/MSSQLODBCConnect1.JPG)
![MSSQLODBCConnect2](./img/MSSQLODBCConnect2.JPG)
![MSSQLODBCConnect3](./img/MSSQLODBCConnect3.JPG)
___

## 마이그레이션 과정
- Mysql workbench이용 마이그레이션

![MSSQLToMySQLConnect1](./img/MSSQLToMySQLConnect1.JPG)
![MSSQLToMySQLConnect2](./img/MSSQLToMySQLConnect2.JPG)
![MSSQLToMYSQLConnect3](./img/MSSQLToMYSQLConnect3.JPG)
![MSSQLToMYSQLConnect4](./img/MSSQLToMYSQLConnect4.JPG)
![MSSQLToMYSQLConnect5](./img/MSSQLToMYSQLConnect5.JPG)
![MSSQLToMYSQLConnect6](./img/MSSQLToMYSQLConnect6.JPG)
![MSSQLToMYSQLConnect7](./img/MSSQLToMYSQLConnect7.JPG)
![MSSQLToMYSQLConnect8](./img/MSSQLToMYSQLConnect8.JPG)
![MSSQLToMYSQLConnect9](./img/MSSQLToMYSQLConnect9.JPG)
![MSSQLToMYSQLConnect10](./img/MSSQLToMYSQLConnect10.JPG)
![MSSQLToMYSQLConnect11](./img/MSSQLToMYSQLConnect11.JPG)
![MSSQLToMYSQLConnect12](./img/MSSQLToMYSQLConnect12.JPG)
![MSSQLToMYSQLConnect13](./img/MSSQLToMYSQLConnect13.JPG)
___

## 결론

- 데이터 확인(MaraiDB, MSSQL)

![MSSQLToMySQLResult1](./img/MSSQLToMySQLResult1.JPG)
![MSSQLToMySQLResult2](./img/MSSQLToMySQLResult2.JPG)

- MariaDB와 MSSQL 마이그레이션 데이터, 테이블 내역 확인 



