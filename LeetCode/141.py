# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    """
        요구사항
        1.싸이클 반복 가능 -> True, 미 반복 -> False
        
        설명
        1.walker : 한칸씩 이동 하는 변수
        2.runner : 두칸씩 이동 하는 변수 
        3.walker와 runner는 언젠가는 만남
    """    
    def hasCycle(self, head: ListNode) -> bool:      
        walker = head
        runner = head        
        while runner is not None :
            runner = runner.next            
            if runner is not None:
                runner = runner.next
                walker = walker.next 
                
                if runner == walker:
                    break
            else:
                break
                                    
        if runner is None:
            return False
        else:
            return True                       
