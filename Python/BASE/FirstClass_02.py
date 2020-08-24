# 일급함수
# 클로저 기초

# 파이썬 변수 범위(scope)

c = 30

def func_v3(a):
    global c
    # c = 40
    print(a)
    print(c)
    # c = 40 -> 오류 발생 print(c) 할당 이전에 전역 변수 참조로 인해
    c = 40

print('>>', c)
func_v3(10)
print('>>>', c)

# Closure(클로저) 사용 이유
# 서버 프로그래밍 -> 동시성(Concurrency) 제어 -> 메모리 공간에 여러 자원이 접근 -> 교착상태(Dead Lock)
# 메모리를 공유하지 않고 메시지 전달로 처리
# 클로저는 공유하되 변경되지 않은 불변(Immutable, Read only)을 적극 사용 -> 함수형 프로그래밍 관 연관
# 클로저는 불변자료 구조 및 atom,STM -> 멀티스레드 프로그래밍에 강점, 코루틴 사용 예정

# 결과 누적 함수 이용
print(sum(range(1,51)))
print(sum(range(51,101)))

# 클래스 이용
class Average():
    def __init__(self):
        self._series = []

    def __call__(self, v):
        self._series.append(v)

        return sum(self._series) / len(self._series)

# 인스턴스 생성
average_cls = Average()


# 누적
print(average_cls(10))
print(dir(average_cls(30)))


def print_msg(msg):
    def inner():
        print(msg)
    return inner