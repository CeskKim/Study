class Car():
    def __init__(self, speed=0):
        self.speed = speed
        self.odometer = 0
        self.time = 0

    def SayState(self):
        print("현재 차량 솓도는 {} kph입니다.".format(self.speed))

    def Acclerate(self):
        self.speed += 5

    def Break(self):
        self.speed -= 5

    def Step(self):
        self.odometer += self.speed
        self.time += 1

    def AverageSpeed(self):
        if self.time != 0 :
            return self.odometer / self.time
        else:
            pass

if __name__ == '__main__':

    MyCar = Car()
    print("차량에 연결되었습니다.")

    while True:
        Action = input("[A] 가속 [B] 감속 [O] 주행거리 [S] 평균속도")

        if Action not in "ABOS" or len(Action) != 1:
            print("해당 명령은 실행 할 수 없습니다.")
            continue
        if Action == "A":
            MyCar.Acclerate()
        elif Action == "B":
            MyCar.Break()
        elif Action == "O":
            print("현재까지 주행거리는 {} km입니다.".format(MyCar.odometer))
        elif Action == "S":
            print("평균속도는 {} kph입니다.".format(MyCar.AverageSpeed()))

        MyCar.step()
        MyCar.SayState()

