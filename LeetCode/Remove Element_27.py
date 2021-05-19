class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        
        mnum = [num for num in nums if num != val]
        
        for i in range(len(mnum)):
            nums[i] = mnum[i]
        
        nums = nums[:len(mnum)]
            
        return len(nums)
        
        
