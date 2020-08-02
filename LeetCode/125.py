from collections import deque
class Solution:
    def isPalindrome(self, s: str) -> bool:        
        strs = deque([i.lower() for i in s if i.isalnum()])
        
        while len(strs) >1:
            #O(N) + O(1) 소요 -> O(1) + O(1)
            #List의 pop(0)으로 가장 좌측 제거 -> 제거된 부분에 이 후 데이터 삽입 -> 재 정렬 -> O(N)
            #deque의 popleft()이용 가장 좌측 제거, postion index 활용 -> O(1)
            
            if strs.popleft() != strs.pop(): #O(1) + O(1)
                return False            
            """
            if strs.pop(0) != strs.pop(): #O(N) + O(1)
                return False
            """
        return True
