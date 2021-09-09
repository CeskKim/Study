import collections
from functools import reduce

def solution(clothes):
    answer = 1
    clothes = dict(clothes)
    
    ClothesVal = list(clothes.values())
    
    Counter = collections.Counter(ClothesVal)
    
    answer = reduce(lambda x,y : x*(y+1), Counter.values(),1) -1
    
    
    return answer
