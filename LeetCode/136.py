from collections import Counter
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        rstcnt = Counter(nums)
        for k,v in rstcnt.items():
            if v == 1:
                return k
