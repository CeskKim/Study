# 시퀀스형
# 컨테이너 : 서로 상이 자료형 -> List, Tuple, collections.deque
# 플랫 : 한 개의 자료형 -> str, bytes, bytearray, array.array, memoryview
# 가변 : List,bytearray,array.array,memoryview,collections.deque
# 불변 : Tuple, str, bytes,
chars = '+)_(!@#$%^&'
code_list1 = [ord(s) for s in chars]
print(code_list1)
print(dir(chars))
# Comprehending Lists + Map, Filter
# Ord : 문자 -> 유니코드, Chr : 유니코드 -> 문자
code_list2 = [ord(s) for s in chars if ord(s) > 40 ]
code_list3 = list(filter(lambda x : x > 40, map(ord, chars)))
print(code_list3)
coed_list4 = [chr(s) for s in code_list1]
print(coed_list4)

# Generator : 다음 리턴되는 항목 만 생성(메모리 유지 X) -> (값) : ()으로 양 끝 선언
import array
tuple_g = (ord(s) for s in chars)
array_g = array.array('I', (ord(s) for s in chars))
print(type(tuple_g))
print(next(tuple_g))
print(array_g)
print(array_g.tolist())

print()
print()
print()

# Generator Example
#
# print(('%s' % c + str(n) for c in ['A','B','C','D'] for n in range(1,21)))
# for s in ('%s' % c + str(n) for c in ['A','B','C','D'] for n in range(1,21)):
#     print(s)
#

# 리스트 주의
marks1 = [['~'] * 3 for _ in range(4)]
marks2 = [['~'] * 3] * 4 #얕은 복사

print(marks1)
print(marks2)

print()
print()

# 수정
marks1[0][1] = 'X'
marks2[0][1] = 'X'

print(marks1)
print(marks2)

print([id(i) for i in marks1])
print([id(i) for i in marks2])


marks3 = marks1
print([id(i) for i in marks3])

marks4 = marks1.copy()
print(id(marks1), id(marks4))
print([id(i) for i in marks4])


marks4[0][2] = 'Z'
print(marks1)
print(marks4)