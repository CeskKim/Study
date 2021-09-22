class Solution:
    def romanToInt(self, s: str) -> int:
              
        RomanDict = {
            'I': 1,
            'V': 5,
            'X': 10,
            'L': 50,
            'C': 100,
            'D': 500,
            'M': 1000
        }
        
        A = 0 
        P = 'I'
        
        for C in s[::-1]:
            if RomanDict[C] < RomanDict[P]:
                A = A - RomanDict[C]
            else:
                A = A + RomanDict[C]           
            P = C
            
        return A
