# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeTwoLists(self, l1: ListNode, l2: ListNode) -> ListNode:               
        llist = []        
        while l1 is not None:
            llist.append(int(l1.val))
            l1 = l1.next
            
        while l2 is not None:
            llist.append(int(l2.val))
            l2 = l2.next
            
        llist = (sorted(llist))
        
        rstlist = None
        
        for i in range(len(llist)):
            if i == 0:
                rstlist = ListNode(llist[i])
            else:
                new_node = ListNode(llist[i])
                curr_node = rstlist
                while curr_node.next is not None:
                    curr_node = curr_node.next                    
                curr_node.next = new_node
        return rstlist                             
