class Solution:
    def searchInsert(self, nums: List[int], target: int) -> int:  
                              
        LD = {v : k for k,v in enumerate(nums)}
        MaxKey = max(LD.keys())
       
        if target in LD:
            return LD[target]
        else:
            if MaxKey < target:
                return LD[MaxKey] + 1
            else:
                nums.append(target)       
                nums = sorted(nums)
                
                LD = {v : k for k,v in enumerate(nums)}
                
                return LD[target]
             
            
