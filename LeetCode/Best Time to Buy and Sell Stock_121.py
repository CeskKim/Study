import math
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        
        # 1.최소값 매번 갱신
        # 2.현재 값 <-> 최소 값 차이 -> 최대값 산출
        
        profit = 0
        min_price = math.inf # 무한 수 설정, Python 3.5 이상 적용
        
        for price in prices:                                                
            min_price = min(price, min_price)
            profit = max(profit, price - min_price)
            
            # 결과 시뮬레이션
            # p:7, m:7, pf:0
            # p:1, m:1, pf:0
            # p:5, m:1, pf:4
            # p:3, m:1, pf:4
            # p:6, m:1, pf:5
            # p:4, m:1, pf:5
                                                
        return profit
