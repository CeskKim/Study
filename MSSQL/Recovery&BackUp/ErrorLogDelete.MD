## 목적
- DB C드라이브 용량 증가 문제중 ErrorLog의 용량이 비약적으로 커지는 경우 조치 사항
___

## 해결방법
- sp_cycle_errorlog, DBCC errorlog 이용 결과는 동일
- sp_cycle_errorlog : 현재 오류 로그 파일 종료, 서버 재시작과 같이 오류 로그 확정 번호 순환 생성  
___

## 실행내역


