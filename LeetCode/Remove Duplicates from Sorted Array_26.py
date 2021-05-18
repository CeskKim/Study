class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        
        Rst = list(set(nums))
        Rst.sort()
        
        for i, v in enumerate(Rst):
            nums[i] = v
            
        return len(Rst)    
        
