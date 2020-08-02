# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def isSymmetric(self, root: TreeNode) -> bool:           
        if root is None:
            return True               
        return self.isSymmetricCheck(root.left, root.right)
    
    def isSymmetricCheck(self, leftnode, rightnode):       
        if  leftnode is None and rightnode is None:
            return True         
        if leftnode is None or rightnode is None:
            return False                 
        if leftnode.val != rightnode.val:
            return False
        
        return self.isSymmetricCheck(leftnode.left, rightnode.right) and self.isSymmetricCheck(leftnode.right, rightnode.left)                                             
        
