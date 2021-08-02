class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        
        # DP 방식
        # Memoization
        # 음수 * 음수 : 양수 -> 최소값 유지
        # 양수 * 음수 : 음수
        # 양수 * 양수 : 양수 -> 최대값 유지
        # 꼭 곱하지 않고 현재수로 유지(Memoization 느낌)
        
        # 필요한 변수 :Max_V, Min_V, Rst_V
        
        Max_V, Min_V, Rst_V = nums[0], nums[0], nums[0]
        
        for i in range(1, len(nums)):
            x = max(nums[i], Max_V * nums[i], Min_V * nums[i])
            y = min(nums[i], Max_V * nums[i], Min_V * nums[i])
            
            Max_V, Min_V = x, y
      
            Rst_V = max(Max_V, Rst_V)
            
        return Rst_V
                 
       
