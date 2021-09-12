from collections import deque
def solution(priorities, location):
    answer = 0
    
    dq = deque([(v, i) for i, v in enumerate(priorities)])
    
    while len(dq):
        item = dq.popleft()        
        if dq and max(dq)[0] > item[0]:
            dq.append(item)
        else:
            answer += 1
            
            if item[1] == location:
                break
                    
    return answer
