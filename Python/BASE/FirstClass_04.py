# 일급함수
# 클로저 기초
# 데코레이터
# 장점
# -> 중복 제거, 코드 간결, 공통 함수 작성
# -> 로깅, 프레임워크, 유효성 체크 : 공통기능
# -> 조합해서 사용 용이

# 단점
# -> 특정 기능에 함수된 함수 -> 단일 함수로 작성 유리
# -> 디버깅 불편

# 데코레이터 실습

import time

def perf_clock(func):
    def perf_clokecd(*args):
        # 함수시작시간
        st = time.perf_counter()
        # 함수실행
        result = func(*args)
        # 함수종료시간
        et = time.perf_counter() - st
        # 실행 함수명
        name = func.__name__
        # 함수 매개변수
        arg_str = ','.join(repr(arg) for arg in args)
        # 결과 출력
        print('[%0.5fs] %s(%s) -> %r' % (et, name,arg_str,result))

        return result
    return perf_clokecd


def time_func(seconds):
    time.sleep(seconds)

def sum_func(*numbers):
    return sum(numbers)

# 데코레이터 미사용
none_deco1 = perf_clock(time_func)
none_deco2 = perf_clock(sum_func)
print(none_deco1, none_deco1.__code__.co_freevars)
print(none_deco2, none_deco2.__code__.co_freevars)

print('-' * 40, 'Called None Decorator -> time_func')
print()
none_deco1(1.5)
print('-' * 40, 'Called None Decorator -> sum_func')
print()
none_deco2(100,200,300,400,500)

print()
print()
# 데코레이터 사용

@perf_clock
def time_func(seconds):
    time.sleep(seconds)
@perf_clock
def sum_func(*numbers):
    return sum(numbers)

print('-' * 40, 'Called Decorator -> time_func')
time_func(1.5)

print('-' * 40, 'Called Decorator -> sum_func')
sum_func(100,200,300,400,500)