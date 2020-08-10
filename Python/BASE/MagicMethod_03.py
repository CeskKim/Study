# 파이썬 핵심 : 시퀀스(Sequence), 반복(Iterator), 함수(Function), 클래스(Class)
# 클래스 내부에 정의 할 수 있는 특별한(Built-in)메서드

# 객체 -> 파이썬의 데이터 추상화, 모든 객체 -> id, type -> value

# 기본 튜플
pt1 = (1.0, 5.0)
pt2 = (2.5 ,1.5)

from math import sqrt

l_leng1 = sqrt((pt1[0] - pt2[0]) **2 + (pt1[1] - pt2[1]) **2)
print(l_leng1)

# 네임드 튜플

from collections import namedtuple
Point = namedtuple('Point', 'x y')
pt3 = Point(1.0, 5.0)
pt4 = Point(2.5, 1.5)

l_leng2 = sqrt((pt3.x - pt4.x) **2 + (pt3.y - pt4.y) **2)

print(l_leng2)

# 네임드 튜플 선언 방식

Point1 = namedtuple('Point', ['x', 'y'])
Point2 = namedtuple('Point', 'x,y')
Point3 = namedtuple('Point', 'x y')
Point4 = namedtuple('Point', 'x y x class', rename=True) #Defaul rename = False, class : 예약어

# Dict to Unpacking
temp_dict = {'x' : 75, 'y' : 55}

# 객체생성
p1 = Point1(x=10, y=35)
p2 = Point2(20, 40)
p3 = Point3(45, y=35)
p4 = Point4(10, 20, 30 ,40)
p5 = Point3(**temp_dict) #Tupe Unpacking : *, Dict Unpacking : **

print()

print(p1)
print(p2)
print(p3)
print(p4)
print(type(p5))

x,y = p3
print(x,y)


# 네임드 튜플 메소드
# _make() : 새로운 객체 생성
temp = [52, 78]
p4 = Point1._make(temp)
print(p4)
# _fields : 필드 네임 확인
print(p1._fields, p2._fields, p3._fields)

# _asdict() : OrderDict 반환
print(p1._asdict())

# 실사용 실습
# 반20명 , 4개의 반(A,B,C,D)

Classes = namedtuple('Classes', ['rank', 'number'])

numbers = [str(i) for i in range(1,21)]
ranks = 'A,B,C,D'.split(',')

print(numbers)
print(ranks)

students = [Classes(rank, number) for rank in ranks for number in numbers]

print(students)

# 추천
students2 = [Classes(rank, number)
             for rank in 'A,B,C,D'.split(',')
                for number in [str(n)
                    for n in range(1,21)]]


for s in students2:
    print(s)