class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:                
        nums_map = {num : i for i, num in enumerate(nums)}
        
        for j, numi in enumerate(nums):
            if target - numi in nums_map and j != nums_map[target - numi]:
                return nums.index(numi), nums_map[target-numi]
        
