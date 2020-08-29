## 목적
- DB C드라이브 용량 증가 문제중 ErrorLog의 용량이 비약적으로 커지는 경우 조치 사항

## 조치

- sp_cycle_errorlog, DBCC errorlog 이용 결과는 동일
- sp_cycle_errorlog : 현재 오류 로그 파일 종료, 서버 재시작과 같이 오류 로그 확정 번호 순환 생성
- 즉 새로운 로그 파일이 생성되어 기존 로그파일은 삭제 또는 다른 폴더로 이동 가능
