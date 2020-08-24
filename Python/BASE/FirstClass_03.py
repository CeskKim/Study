# 일급함수
# 클로저 기초
# 외부에서 호출 된 함수의 변수값, 상태(레퍼런스) 복사 후 저장 -> 후에 접근(액세스)가능

# Closure 사용
# def closure_ex1():
#     # Free variable
#     # 클로저 영역
#     series = []
#     def averager(v):
#         series.append(v)
#         print('inner >>> {} / {}'.format(series, len(series)))
#         return sum(series) / len(series)
#     return averager #함수 자체 return
#
# avg_closure1 = closure_ex1()
#
# print(avg_closure1)
# print(avg_closure1(10))
# print(avg_closure1(20))
# print(avg_closure1(30))
#
# # print(dir(avg_closure1))
# # print(dir(avg_closure1.__closure__[0]))
# # print(avg_closure1.__closure__[0].cell_contents)
#
# print(dir(avg_closure1))
# print()
# print(dir(avg_closure1.__code__))
# print(avg_closure1.__code__.co_freevars)
#
# # 잘못된 클로저 사용
# def closure_ex2():
#     # Free Variable
#     cnt = 0
#     total = 0
#     def averager(v):
#         cnt += 1
#         total += v
#
#         return total / cnt
#     return averager
#
# avg_closure2 = closure_ex2()

# print(avg_closure2(10))


def closure_ex3():
    # Free Variable
    cnt = 0
    total = 0
    def averager(v):
        nonlocal cnt, total
        cnt += 1
        total += v

        return total / cnt
    return averager

avg_closure3 = closure_ex3()

print(avg_closure3(10))
print(avg_closure3(15))