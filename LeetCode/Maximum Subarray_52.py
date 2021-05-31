class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        MaxSub = nums[0]
        CurSum = 0
        
        for n in nums:
            if CurSum < 0 :
                CurSum = 0
            CurSum += n
            MaxSub = max(MaxSub, CurSum)
            
        return MaxSub
            
## 참고사이트
# https://www.youtube.com/watch?v=5WZl3MMT0Eg
# https://blog.fakecoding.com/archives/algorithm-slidingwindow/
