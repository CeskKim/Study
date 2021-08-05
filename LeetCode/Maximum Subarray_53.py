class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        
        # DP 방식으로 접근
        # d[i]번째 원소가 마지막 원소인 부분배열의 최대 값
        # d[2] : max(nums[2], mums[1] + nums[2], nums[0] + nums[1] + nums[2])
        # 참조사이트 : https://www.youtube.com/watch?v=E5r1cQ-vLgM
        
        current_subarray = max_subarray = nums[0]
        
        for num in nums[1:]:
            current_subarray = max(num, current_subarray + num)
            max_subarray = max(max_subarray, current_subarray)
        
        return max_subarray
