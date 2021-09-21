class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        
        #사용 기법 : 투포인터, 슬라이싱 알고리즘
        
        MaxLen = Start = 0
        
        Exists = dict()
        
        for i, c in enumerate(s):
            if c in Exists and Start <= Exists[c]:
                Start = Exists[c] + 1
            else:
                MaxLen = max(MaxLen,  i - Start + 1)
                
            Exists[c] = i
            
        return MaxLen
