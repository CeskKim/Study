class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        
        result = []
        p = 1
        
        # 왼쪽 곱셈 결과
        for i in range(0, len(nums)):
            result.append(p)            
            p = p * nums[i]
         
        # 왼쪽 곰셈 결과 * 오른쪽 곱셈 결과
        p = 1  
        for i in range(len(nums) - 1, 0 - 1, -1):
            
            result[i] = result[i] * p
            p = p * nums[i]
            
        return result
