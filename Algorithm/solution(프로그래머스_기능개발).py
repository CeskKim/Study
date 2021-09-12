def solution(progresses, speeds):
    answer = []
    
    for p, s in zip(progresses, speeds):
        if len(answer) == 0 or answer[-1][0] < - ((p - 100) // s):
            answer.append([-((p - 100) // s), 1])
        else:
            answer[-1][1] += 1
 
    return [reanswer[1] for reanswer in answer]
