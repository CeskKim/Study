# 파이썬 핵심 : 시퀀스(Sequence), 반복(Iterator), 함수(Function), 클래스(Class)
# 클래스 내부에 정의 할 수 있는 특별한(Built-in)메서드
# 클래스 예제2
#  (5,2) + (4,3) = (9,5), (10,3) * 5 = (50,15)

class Vector():

    def __init__(self,*args):
        """
        초기
        1.백터길이 체크 : 값이 존재하지 않은 경우 초기화
        """
        if len(args) == 0 :
            self._x, self._y = 0,0
        else:
            self._x, self._y = args

    def __repr__(self):
        """
        백터정보
        """
        return 'Vector(%r, %r)' % (self._x, self._y)

    def __add__(self, other):
        """
        덧셈
        1.백터 좌표의 덧셈 생성
        """
        return Vector(self._x + other._x, self._y + other._y)

    def __mul__(self, ohter):
        return Vector(self._x * ohter._x, self._y * ohter._y)

    def __bool__(self):
        return bool(max(self._x, self._y))

# 백터 인스턴스 생성
v1 = Vector(5,7)
v2 = Vector(12,13)
v3 = Vector()


print(Vector.__init__.__doc__)
print(Vector.__add__.__doc__)

print(bool(v1), bool(v2))































