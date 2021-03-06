/*************************************************************************************************
 IDENTITY 제약 조건 중간 삽입
**************************************************************************************************/
CREATE TABLE dbo.TBLIDentity
(
	ID INT IDENTITY(1,1) NOT NULL
,	IDName NVARCHAR(30)
)
INSERT INTO dbo.TBLIDentity
SELECT N'홍구홍' UNION ALL
SELECT N'하홍홍' UNION ALL
SELECT N'김수리'

/*************************************************************************************************
 IDENTITY 조건(ID칼럼에 값 지정 삽입)
  -> ID 열의 명시적 값은 열 목록이 사용되고 IDENTITY_INSERT가 ON일 때만 지정할 수 있습니다. 오류 발생
**************************************************************************************************/
INSERT INTO dbo.TBLIDentity
SELECT 4, N'윤호호' UNION ALL
SELECT 5, N'최상사'

/*************************************************************************************************
 해결책
 SET IDENTITY_INSERT [테이블명] ON : ID열에 명시적 값 삽입 가능
 SET IDENTITY_INSERT [테이블명] OFF : ID열에 명시적 값 삽입 불가능
**************************************************************************************************/
SET IDENTITY_INSERT dbo.TBLIDentity ON
INSERT INTO dbo.TBLIDentity(ID,IDName) -- 칼럼 명시
SELECT 4, N'윤호호' UNION ALL
SELECT 5, N'최상사'

/*************************************************************************************************
**************************************************************************************************/
SET IDENTITY_INSERT dbo.TBLIDentity OFF
INSERT INTO dbo.TBLIDentity
SELECT N'김호호' UNION ALL
SELECT N'진상사'