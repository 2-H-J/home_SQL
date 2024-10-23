-- 1. 테이블 생성
-- 유저 테이블 생성
CREATE TABLE BOARD_MEMBER (
	ID VARCHAR2(50) NOT NULL, -- 사용자 ID
	PASSWORD CHAR(128) NOT NULL, -- 비밀번호
	USERNAME VARCHAR2(50) NOT NULL, -- 사용자 이름
	NICKNAME VARCHAR2(50) NOT NULL -- 사용자 닉네임
);

-- 게시판 테이블 생성
CREATE TABLE BOARD (
	BNO NUMBER NOT NULL, -- 게시글 번호
	ID VARCHAR2(50) NOT NULL, -- 사용자 ID (외래키)
	TITLE VARCHAR2(150) NOT NULL, -- 게시글 제목
	CONTENT VARCHAR2(4000) NOT NULL, -- 게시글 내용
	WRITE_DATE DATE DEFAULT SYSDATE NOT NULL, -- 작성일
	WRITE_UPDATE_DATE DATE DEFAULT SYSDATE NOT NULL, -- 수정일
	BCOUNT NUMBER DEFAULT 0 NULL -- 조회수
);

-- 게시판 좋아요 테이블 생성
CREATE TABLE BOARD_CONTENT_LIKE (
	BNO NUMBER NOT NULL, -- 게시글 번호 (외래키)
	ID VARCHAR2(50) NOT NULL -- 사용자 ID (외래키)
);

-- 게시판 싫어요 테이블 생성
CREATE TABLE BOARD_CONTENT_HATE (
	BNO NUMBER NOT NULL, -- 게시글 번호 (외래키)
	ID VARCHAR2(50) NOT NULL -- 사용자 ID (외래키)
);

-- 첨부파일 테이블 생성
CREATE TABLE BOARD_FILE (
	FNO CHAR(10) NOT NULL, -- 파일 번호
	BNO NUMBER NOT NULL, -- 게시글 번호 (외래키)
	FPATH VARCHAR2(256) NULL -- 파일 경로
);

-- 댓글 테이블 생성
CREATE TABLE BOARD_COMMENT (
	CNO NUMBER NOT NULL, -- 댓글 번호
	BNO NUMBER NOT NULL, -- 게시글 번호 (외래키)
	ID VARCHAR2(50) NOT NULL, -- 사용자 ID (외래키)
	CONTENT VARCHAR2(1000) NULL, -- 댓글 내용
	CDATE DATE DEFAULT SYSDATE NULL -- 댓글 작성일
);

-- 댓글 좋아요 테이블 생성
CREATE TABLE BOARD_COMMENT_LIKE (
	ID VARCHAR2(50) NOT NULL, -- 사용자 ID (외래키)
	CNO NUMBER NOT NULL -- 댓글 번호 (외래키)
);

-- 댓글 싫어요 테이블 생성
CREATE TABLE BOARD_COMMENT_HATE (
	ID VARCHAR2(50) NOT NULL, -- 사용자 ID (외래키)
	CNO NUMBER NOT NULL -- 댓글 번호 (외래키)
);

-- 조회
SELECT * FROM BOARD_MEMBER;
SELECT * FROM BOARD;
SELECT * FROM BOARD_CONTENT_LIKE;
SELECT * FROM BOARD_CONTENT_HATE;
SELECT * FROM BOARD_COMMENT;
SELECT * FROM BOARD_COMMENT_LIKE;
SELECT * FROM BOARD_COMMENT_HATE;

------------------------------------------------------------------------------------------
-- 2. 제약조건(기본키, 외래키)
-- 기본키 설정

-- 유저 테이블에 기본키 설정
ALTER TABLE BOARD_MEMBER ADD CONSTRAINT PK_BOARD_MEMBER PRIMARY KEY (ID);

-- 게시글 테이블에 기본키 설정
ALTER TABLE BOARD ADD CONSTRAINT PK_BOARD PRIMARY KEY(BNO);

-- 게시글 좋아요 테이블에 기본키 설정 (복합키)
ALTER TABLE BOARD_CONTENT_LIKE ADD CONSTRAINT PK_BOARD_CONTENT_LIKE PRIMARY KEY(BNO, ID);

-- 게시글 싫어요 테이블에 기본키 설정 (복합키)
ALTER TABLE BOARD_CONTENT_HATE ADD CONSTRAINT PK_BOARD_CONTENT_HATE PRIMARY KEY(BNO, ID);

-- 첨부파일 테이블에 기본키 설정
ALTER TABLE BOARD_FILE 
ADD CONSTRAINT PK_BOARD_FILE PRIMARY KEY (FNO);

-- 댓글 테이블에 기본키 설정
ALTER TABLE BOARD_COMMENT 
ADD CONSTRAINT PK_BOARD_COMMENT PRIMARY KEY(CNO);

-- 댓글 좋아요 테이블에 기본키 설정 (복합키)
ALTER TABLE BOARD_COMMENT_LIKE ADD CONSTRAINT PK_BOARD_COMMENT_LIKE PRIMARY KEY (ID, CNO);

-- 댓글 싫어요 테이블에 기본키 설정 (복합키)
ALTER TABLE BOARD_COMMENT_HATE ADD CONSTRAINT PK_BOARD_COMMENT_HATE PRIMARY KEY (ID, CNO);

------------------------------------------------------------------------------------------
-- 외래키 설정

-- 게시글 테이블의 유저 ID를 외래키로 설정 (BOARD_MEMBER와 연결)
ALTER TABLE BOARD ADD CONSTRAINT BOARD_FK_ID FOREIGN KEY (ID)
REFERENCES BOARD_MEMBER (ID);

-- 게시글 좋아요 테이블의 게시글 번호와 유저 ID를 외래키로 설정
ALTER TABLE BOARD_CONTENT_LIKE ADD CONSTRAINT BCL_FK_BNO FOREIGN KEY (BNO)
REFERENCES BOARD (BNO);
ALTER TABLE BOARD_CONTENT_LIKE ADD CONSTRAINT BCL_FK_ID FOREIGN KEY (ID)
REFERENCES BOARD_MEMBER (ID);

-- 게시글 싫어요 테이블의 게시글 번호와 유저 ID를 외래키로 설정
ALTER TABLE BOARD_CONTENT_HATE ADD CONSTRAINT BCH_FK_BNO FOREIGN KEY (BNO)
REFERENCES BOARD (BNO);
ALTER TABLE BOARD_CONTENT_HATE ADD CONSTRAINT BCH_FK_ID FOREIGN KEY (ID)
REFERENCES BOARD_MEMBER (ID);

-- 첨부파일 테이블의 게시글 번호를 외래키로 설정 (BOARD와 연결)
ALTER TABLE BOARD_FILE ADD CONSTRAINT BOARD_FILE_FK_BNO FOREIGN KEY (BNO)
REFERENCES BOARD (BNO);

-- 댓글 테이블의 게시글 번호를 외래키로 설정
ALTER TABLE BOARD_COMMENT ADD CONSTRAINT BOARD_COMMENT_FK_BNO FOREIGN KEY (BNO)
REFERENCES BOARD (BNO);

-- 댓글 테이블의 유저 ID를 외래키로 설정 (BOARD_MEMBER와 연결)
ALTER TABLE BOARD_COMMENT ADD CONSTRAINT BOARD_COMMENT_FK_ID FOREIGN KEY (ID)
REFERENCES BOARD_MEMBER (ID);

-- 댓글 좋아요 테이블의 유저 ID와 댓글 번호를 외래키로 설정
ALTER TABLE BOARD_COMMENT_LIKE ADD CONSTRAINT BCML_FK_ID FOREIGN KEY (ID)
REFERENCES BOARD_MEMBER (ID);
ALTER TABLE BOARD_COMMENT_LIKE ADD CONSTRAINT BCML_FK_CNO FOREIGN KEY (CNO)
REFERENCES BOARD_COMMENT (CNO);

-- 댓글 싫어요 테이블의 유저 ID와 댓글 번호를 외래키로 설정
ALTER TABLE BOARD_COMMENT_HATE ADD CONSTRAINT BCMH_FK_ID FOREIGN KEY (ID)
REFERENCES BOARD_MEMBER (ID);
ALTER TABLE BOARD_COMMENT_HATE ADD CONSTRAINT BCMH_FK_CNO FOREIGN KEY (CNO)
REFERENCES BOARD_COMMENT (CNO);

------------------------------------------------------------------------------------------
-- 3. 시퀀스 생성 (필요시 추가로 시퀀스 생성할 수 있음)
--CREATE SEQUENCE 
--NO_SEQ : 시퀸스명
--INCREMENT BY 1 : 증가하는 간격
--START WITH 5 : 시작값
--MINVALUE 1 : 최소값
--MAXVALUE 99999999 : 최대값
--CYCLE/NOCYCLE : 사이클반복 / 반복X
--CACHE 20 NOORDER 

--글번호 1 ~
CREATE SEQUENCE SEQ_BOARD_BNO;
--INCREMENT 1 기본값 1
--START WITH 1 기본값 1
--MINVALUE 1
--NOMAXVALUE
--NOCYCLE
--CACHE 10;

--댓글번호 1 ~
CREATE SEQUENCE SEQ_BOARD_COMMENT_CNO;
--INCREMENT 1
--START WITH 1
--MINVALUE 1
--NOMAXVALUE
--NOCYCLE
--CACHE 10;

--파일번호 1 ~ 999999999
CREATE SEQUENCE SEQ_BOARD_FILE_PNO;
START WITH 1
INCREMENT 1
MINVALUE 1
MAXVALUE 999999999;
--CYCLE
--CACHE 10;

------------------------------------------------------------------------------------------
-- 4. 샘플 데이터 저장 (샘플 데이터 저장용 쿼리 작성 가능)
--암호화방법 (19버전 이후 부터)
SELECT STANDARD_HASH('암호화할 데이터', 'SHA512') AS "STANDARD",
LENGTHB(STANDARD_HASH('암호화할 데이터', 'SHA512')) AS "STANDARD_LENGTHB" FROM DUAL;
SELECT STANDARD_HASH('123456', 'SHA512') AS "STANDARD",
LENGTHB(STANDARD_HASH('123456', 'SHA512')) AS "STANDARD_LENGTHB" FROM DUAL;

SELECT STANDARD_HASH('123456', 'SHA256') AS "STANDARD",
LENGTHB(STANDARD_HASH('123456', 'SHA256')) AS "STANDARD_LENGTHB" FROM DUAL;

SELECT STANDARD_HASH('123456', 'SHA1') AS "STANDARD",
LENGTHB(STANDARD_HASH('123456', 'SHA1')) AS "STANDARD_LENGTHB" FROM DUAL;



------------------------------------------------------------------------------------------
--데이터 삭제
-- 유저 테이블 데이터 삭제
DELETE FROM BOARD_MEMBER;

-- 게시판 테이블 데이터 삭제
DELETE FROM BOARD;

-- 게시판 좋아요 테이블 데이터 삭제
DELETE FROM BOARD_CONTENT_LIKE;

-- 게시판 싫어요 테이블 데이터 삭제
DELETE FROM BOARD_CONTENT_HATE;

-- 첨부파일 테이블 데이터 삭제
DELETE FROM BOARD_FILE;

-- 댓글 테이블 데이터 삭제
DELETE FROM BOARD_COMMENT;

-- 댓글 좋아요 테이블 데이터 삭제
DELETE FROM BOARD_COMMENT_LIKE;

-- 댓글 싫어요 테이블 데이터 삭제
DELETE FROM BOARD_COMMENT_HATE;

------------------------------------------------------------------------------------------
-- 테이블 삭제
-- 기존 테이블을 삭제하는 구문
DROP TABLE BOARD_COMMENT_HATE;
DROP TABLE BOARD_COMMENT_LIKE;
DROP TABLE BOARD_COMMENT;
DROP TABLE BOARD_FILE;
DROP TABLE BOARD_CONTENT_HATE;
DROP TABLE BOARD_CONTENT_LIKE;
DROP TABLE BOARD;
DROP TABLE BOARD_MEMBER;

------------------------------------------------------------------------------------------
-- 기본키 삭제
-- 기본키 제약조건을 삭제하는 구문
ALTER TABLE BOARD_MEMBER DROP CONSTRAINT PK_BOARD_MEMBER;
ALTER TABLE BOARD DROP CONSTRAINT PK_BOARD;
ALTER TABLE BOARD_CONTENT_LIKE DROP CONSTRAINT PK_BOARD_CONTENT_LIKE;
ALTER TABLE BOARD_CONTENT_HATE DROP CONSTRAINT PK_BOARD_CONTENT_HATE;
ALTER TABLE BOARD_FILE DROP CONSTRAINT PK_BOARD_FILE;
ALTER TABLE BOARD_COMMENT DROP CONSTRAINT PK_BOARD_COMMENT;
ALTER TABLE BOARD_COMMENT_LIKE DROP CONSTRAINT PK_BOARD_COMMENT_LIKE;
ALTER TABLE BOARD_COMMENT_HATE DROP CONSTRAINT PK_BOARD_COMMENT_HATE;

------------------------------------------------------------------------------------------
-- 외래키 삭제
-- 외래키 제약조건을 삭제하는 구문
ALTER TABLE BOARD DROP CONSTRAINT BOARD_FK_ID;
ALTER TABLE BOARD_CONTENT_LIKE DROP CONSTRAINT BCL_FK_BNO;
ALTER TABLE BOARD_CONTENT_LIKE DROP CONSTRAINT BCL_FK_ID;
ALTER TABLE BOARD_CONTENT_HATE DROP CONSTRAINT BCH_FK_BNO;
ALTER TABLE BOARD_CONTENT_HATE DROP CONSTRAINT BCH_FK_ID;
ALTER TABLE BOARD_FILE DROP CONSTRAINT BOARD_FILE_FK_BNO;
ALTER TABLE BOARD_COMMENT DROP CONSTRAINT BOARD_COMMENT_FK_BNO;
ALTER TABLE BOARD_COMMENT DROP CONSTRAINT BOARD_COMMENT_FK_ID;
ALTER TABLE BOARD_COMMENT_LIKE DROP CONSTRAINT BCML_FK_ID;
ALTER TABLE BOARD_COMMENT_LIKE DROP CONSTRAINT BCML_FK_CNO;
ALTER TABLE BOARD_COMMENT_HATE DROP CONSTRAINT BCMH_FK_ID;
ALTER TABLE BOARD_COMMENT_HATE DROP CONSTRAINT BCMH_FK_CNO;

------------------------------------------------------------------------------------------
--시퀸스 삭제
-- 글번호 시퀀스 삭제
DROP SEQUENCE SEQ_BOARD_BNO;
-- 댓글번호 시퀀스 삭제
DROP SEQUENCE SEQ_BOARD_COMMENT_CNO;
-- 파일번호 시퀀스 삭제
DROP SEQUENCE SEQ_BOARD_FILE_PNO;
