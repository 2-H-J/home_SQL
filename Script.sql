-- 사용자 생성
CREATE USER C##SCOTT IDENTIFIED BY TIGER;
--권한 부여
GRANT RESOURCE, CONNECT TO C##SCOTT;
-- 저장소 사용량 부여
ALTER USER C##SCOTT DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
