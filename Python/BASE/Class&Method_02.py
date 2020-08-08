class car():
    """
    주석 기본 구조
    Car class
    Author : kim
    Date : 2020.04.06
    """
    # 클래스 변수(모든 인스턴스 공유)
    car_count = 0

    # 변수 : 인스턴스 변수, 변수 : 클래스 변수
    def __init__(self, company, details):
        self._company = company
        self._details = details
        self.car_count = 10
        car.car_count += 1
    def __str__(self):
        return 'str : {} - {}'.format(self._company, self._details)

    def __del__(self):
        car.car_count -= 1


    def detail_info(self):
        
        print('Currend ID : {}'.format(id(self)))
        print('Car Detail Info : {} {}'.format(self._company,self._details.get('price')))

car1 = car('Ferrari', {'color' : 'White', 'hoserpower' : 400, 'price' : 5000})
car2 = car('bmw', {'color' : 'White', 'hoserpower' : 500, 'price' : 6000})

print(car.__doc__) #클래스가 참조하는 메서드 내역
print()
print()

car1.detail_info()
car.detail_info(car1)

print(car1.__class__)

# 공유 확인
print(car1.car_count)
print(car1.__dict__)
print(dir(car1))

del car2
print(car1.car_count)

# 인스턴스 네임스페이스에 미 존재 : 상위에서 검샘
# 동일한 이름으로 변수 생성 가능 : 인스턴스 검색 -> 미 존재 -> 상위(클래스변수, 부모클래스 변수)검색
print(car1.car_count)
print(car.car_count)

