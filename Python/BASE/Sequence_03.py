
# 해쉬테이블 : Key에 Value를 저장하는 구조
# 키 값의 연산 결과에 따라 직접 접근이 가능한 구조
# Key 값 해싱 함수 -> 해쉬 주소 -> Key에 대한 Value 참조

# Hash 확인
t1 = (10,20,(30,40,50))
t2 = (10,20,[30,40,50])

print(hash(t1))
# print(hash(t2)) #예외 List : 가변 -> hash 사용 X

# Dict Setdefault 예제

source = (('k1', 'val1'),
          ('k1', 'val2'),
          ('k2', 'val3'),
          ('k2', 'val4'),
          ('k2', 'val5'))

new_dict1 = {}
new_dict2 = {}

# No Use SetDefault

for k, v in source:
    if k in new_dict1:
        new_dict1[k].append(v)
    else:
        new_dict1[k] = [v]
print(new_dict1)

print('source',source[0])


# Use SetDefault
for k, v in source:
    new_dict2.setdefault(k, []).append(v)

print(new_dict2)

# 주의
# 키 동일 시 최종값으로 호출 되기 때문에 아래 구문은 사용 금지
# new_dict3 = {k : v for k, v in source}
