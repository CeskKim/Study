class car():
    """
    Car class
    Author : kim
    Date : 2020.04.07
    Description : Class, Static, Instance Method
    """
    # 클래스 변수(모든 인스턴스 공유)
    price_per_rais = 1.0

    # _변수 : 인스턴스 변수, 변수 : 클래스 변수
    def __init__(self, company, details):
        self._company = company
        self._details = details

    def __str__(self):
        return 'str : {} - {}'.format(self._company, self._details)

    # Instance Method
    # self : 객체의 고유 속성 값 사용 목적
    def detail_info(self):
        print('Currend ID : {}'.format(id(self)))
        print('Car Detail Info : {} {}'.format(self._company,self._details.get('price')))
    # Instance Method
    def get_price(self):
        return 'Before Car Price -> Company : {}, price : {}'.format(self._company, self._details.get('price'))
    # Instance Method
    def get_price_cucl(self):
        return 'After Car Price -> Company : {}, price : {}'.format(self._company, self._details.get('price') * car.price_per_rais)

    # Class Method
    @classmethod
    def raise_price(cls, per):
        if per <= 1:
            print('Please Enter 1 Or More')
            return
        cls.price_per_rais = per
        print('Succeed price increased.')

    # staticmethod
    @staticmethod
    def is_bmw(inst):
        if inst._company == 'bmw':
            return 'OK This car is {}'.format(inst._company)
        return 'Sorry. This is not car bmw'


car1 = car('Ferrari', {'color' : 'White', 'hoserpower' : 400, 'price' : 5000})
car2 = car('bmw', {'color' : 'White', 'hoserpower' : 500, 'price' : 6000})

# 아래와 같이 Instance Method 값 호출 X, 해당 값을 변경하면 기존에 저장되어 있던 데이터 변경 처리
# car1._details['price'] = 700
car1.detail_info()

# 가격정보(인상 전)
print(car1.get_price())
print(car2.get_price())

# 가격정보(클래스 메서드 미사용)
car.price_per_rais = 1.4

print(car1.get_price_cucl())
print(car2.get_price_cucl())

# 가격정보(클래스 메서드 사용)
car.raise_price(2)

print(car1.get_price_cucl())
print(car2.get_price_cucl())

# 인스터스 호출(스테이틱 메서드)
print(car1.is_bmw(car1))
print(car2.is_bmw(car2))
# 클래스 호출(스테이틱 메서드)
print(car.is_bmw(car1))