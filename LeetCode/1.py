class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:                
        numsset = {v:k for k,v in enumerate(nums)}                    
        for i, num in enumerate(nums):    
            needs = target - num                 
            if needs in numsset and numsset[needs] != i:                
                j = numsset[needs]
                return [i,j]
