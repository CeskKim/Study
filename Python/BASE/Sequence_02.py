print(divmod(100,9))
print(divmod(*(100,9))) # * -> Tuple형식 -> Upaking
print(*(divmod(100,9)))

x,y,*rest = range(10)
print(x,y,rest)

# Mutable(가변) vs Imutalbe(불변)

l = (15, 20, 25)
m = [15, 20, 25]

print(l, id(l))
print(m, id(m))

l = l * 2
m = m * 2

print(l, id(l))
print(m, id(m))

l *= 2
m *= 2


print(l, id(l))
print(m, id(m))

m *= 5
print(m, id(m))

# sort vs sorted
# reverse, key = len, key = str.lower, key=func..
# sorted : 정렬 -> 새로운 객체, sort : 정렬후 객체 직접 변경

f_list = ['orange', 'apple', 'mango', 'papaya', 'lemon', 'strawberry', 'coconut']
print('sorted - ', sorted(f_list, reverse=True))
print('sorted - ', sorted(f_list, key=len))
print('sorted - ', sorted(f_list, key=lambda x : x[-1], reverse=True))

print('sort - ', f_list.sort(), f_list)
print('sort - ', f_list.sort(key=lambda x : x[-1]), f_list)


# List vs Array 사용법
# List : 융통성, 다양한 자료형, 범용적 사용
# Array : 숫자기반, 배열(리스트와 호환되는 기능)

