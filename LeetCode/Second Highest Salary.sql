+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |

# 해당 테이블 내역 중 상위 2번째 출력
# TestCase1 : 2번째 내역이 없고 상위 1번째 만 있는 경우에는 null 값 반환

SELECT MAX(Salary) AS SecondHighestSalary
FROM Employee
WHERE Salary < (SELECT MAX(Salary)
                FROM Employee)
