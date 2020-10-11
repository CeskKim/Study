## 목적
- 환경 및 상황에 의해 데이터베이스 자체를 변경 해야 하는 경우 또는 각각의 데이터베이스를 이중으로 구성해야 하는 경우에 대비 테스트 
___

## 테스트 환경
- MSSQL(2019) -> MariaDB(10.5.0)로 마이그레이션
- ISPIRER상용툴이 아닌 MySQL WorkBench을 활용
- SP(Stored Procedure), Fuction, View제외 Table 및 Data만 마이그레이션
___

## 설치과정
- 설치주소
- https://dev.mysql.com/downloads/workbench/
- 설치문제(C++ 설치요청)인 경우 아래 링크를 다운 받아 설치 진행
- https://igotit.tistory.com/entry/Visual-C-2010-2015-2017-2019-%EC%9E%AC%EB%B0%B0%ED%8F%AC-%EA%B0%80%EB%8A%A5-%ED%8C%A8%ED%82%A4%EC%A7%80-32bit-64bit
- MySQL WorkBench 설치
![MySQL Workbench Download1](./img/MySQL Workbench Download1.JPG)
