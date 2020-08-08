"""
    1.기본 클래스 구조 사용
    2.매직메서드 __str__ 사용
"""
class car():

    def __init__(self, company, details):
        self._company = company
        self._details = details
    def __str__(self):
        return 'str : {} - {}'.format(self._company, self._details)

car1 = car('Ferrari', {'color' : 'White', 'hoserpower' : 400, 'price' : 5000})
car2 = car('Ferrari', {'color' : 'White', 'hoserpower' : 400, 'price' : 5000})

print(car1)
print(car2)