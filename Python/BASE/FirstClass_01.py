# 일급함수
# 파이썬 함수 특징
# 1.런타임 초기화, 2.변수할당, 3.함수 인수 전달 가능, 4.함수 결과 반환 가능

# 함수 객체
def factorial(n):
    """Factorial function ->  n : int"""
    if n==1 :
        return 1
    return n * factorial(n-1)

class A:
    pass

print(factorial(5))
print(factorial.__doc__)
print(type(factorial),type(A))
print(set(sorted(dir(factorial))) - set(sorted(dir(A)))) #함수에만 적용되어 있는 내역 출력
print(factorial.__name__)
print(factorial.__code__)

print()
print()


# 변수 할당
var_func = factorial

print(var_func)
print(var_func(10))
print(list(map(var_func, range(1,11))))

# 함수 인수 전달 및 함수로 결과 반환 -> 고위 함수(Higher-order function)
# map, filter, reduce

print([var_func(i) for i in range(1,6) if i % 2])
print(list(map(var_func, filter(lambda x : x % 2 , range(1,6)))))

print()
print()


# reduce
from functools import reduce
from operator import add

print(reduce(add, range(1,11)))
print(sum(range(1,11)))

# 익명함수(Lambda)
# 가급적 주석 작성 및 가급적 함수 및 일반 함수 작성 권장
print(reduce(lambda x, t : x + t, range(1,11)))

print()
print()


# Callable : 호출연산자 -> 메소드 형태로 호출 가능여부 확인
print(callable(str), callable(list), callable(var_func), callable(factorial))

# Partial 사용법 : 인수 고정 -> 콜백 사용
from operator import mul
from functools import partial

print(mul(10,10))

# 인수 고정
five = partial(mul, 5)

print(five(10))

# 인수 고정 추가
six = partial(five, 6)
print(six())

print([five(i) for i in range(1,11)])
print(list(map(five, range(1,11))))