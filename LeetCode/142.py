# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def detectCycle(self, head: ListNode) -> ListNode:        
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
            return None
        
        check = head
        
        while(check != walker):
            check = check.next
            walker = walker.next
        return check      
