-- 사원정보
-- 사번, 이름, 직급명, 부서명, 연봉, 입사일

-- SQL은 스네이크 표기법 _
CREATE TABLE EMPLOYEE(
	EMP_NO CHAR(9) PRIMARY KEY,
	EMP_NAME VARCHAR2(10 CHAR) NOT NULL, -- 10 CHAR : VARCHAR2에 바이트수 대신 최대 10글자를 넣게 할 수 있다.
	JOB_TITLE VARCHAR2(30) DEFAULT '사원' NOT NULL,
	DEPT_NAME VARCHAR2(30),
	SALARY NUMBER(12) DEFAULT 0,
	HIRE_DATE DATE DEFAULT SYSDATE
);
DELETE TABLE EMPLOYEE; -- 모든 데이터 삭제
DROP TABLE PERSON; -- EMPLOYEE 테이블 삭제
-- 사원정보 샘플데이터 50건 CSV로 저장
SELECT * FROM EMPLOYEE;
/*
 # DML(Data Manipulation Language) : 데이터 조작어
	- 데이터를 조회,   삭제,   수정,   추가
	-         SELECT, DELETE, UPDATE, INSERT
*/

CREATE TABLE PERSON(
	PNAME VARCHAR2(30),
	PAGE NUMBER(3)
);
-- INSERT : 추가 ------------------------------------------------------------------------

-- 1.
-- INSERT INTO 테이블명(컬럼1, 컬럼2, 컬럼3, ...) VALUES(데이터1, 데이터2, 데이터3, ...);
INSERT INTO PERSON(PNAME, PAGE) VALUES('홍길동', 30);
-- 2.
-- 테이블 생성시 만든 모든 컬럼에 데이터를 저장, 데이터 순서는 CREATE 작성시 만든 컬럼 순서대로
-- INSERT INTO 테이블명 VALUES(데이터1, 2, 3, ...);
INSERT INTO PERSON VALUES('김철수', 20);

-- PERSON 데이터 5건 추가
INSERT INTO PERSON (PNAME, PAGE) VALUES ('이영희', 29);
INSERT INTO PERSON (PNAME, PAGE) VALUES ('박민수', 42);
INSERT INTO PERSON (PNAME, PAGE) VALUES ('최영수', 55);
INSERT INTO PERSON (PNAME, PAGE) VALUES ('정수빈', 23);
INSERT INTO PERSON VALUES('손흥민', 99);

INSERT ALL -- ORACLE 에서만 가능 INSERT 문
	INTO PERSON VALUES('김씨', 53)
	INTO PERSON VALUES('박씨', 23)
	INTO PERSON VALUES('정씨', 34)
	INTO PERSON VALUES('이씨', 32)
	INTO PERSON VALUES('민씨', 66)
SELECT * FROM DUAL;

-- 학생데이터 한건 추가하는 INSERT문 작성
-- 학번, 이름, 학과, 평점
INSERT INTO STUDENT VALUES('20241011', '김학생', '컴퓨터 공학', 4.1);
SELECT  * FROM STUDENT;

-- 사원정보 1건 등록하는 INSERT 작성 - 입사일 제외하고 추가
-- 사번, 이름, 직급명, 부서명, 연봉, 입사일
INSERT INTO EMPLOYEE (EMP_NO, EMP_NAME ,EMP_POSITION ,EMP_DEPARTMENT ,EMP_SALARY) 
VALUES('A20240311', '이사원', '사원', '개발팀', 35000000);

-- 사원정보 1건 등록하는 INSERT 작성 - 모든 항목 추가
INSERT INTO EMPLOYEE VALUES('A20240121', '김팀장', '팀장', '인사과', 65000000, SYSDATE);
/*

# 데이터 조회 : SELECT ---------------------------------------------------------
 	- SELECT 조회할 컬럼1, 조회할컬럼2, ....
 	- FROM 조회할 테이블1, 테이블2, ....
 	- WHERE 조건절
 	- GROUP BY 그룹으로 묶을 컬럼1, 컬럼2, .... [HAVING 조건절]
 	- ORDER BY 정렬할 기준 컬럼[ASC | DESC], 정렬할 기준 컬럼2 [ASC | DESC], ...
*/

-- 전체 PERSON 데이터 조회
SELECT  * FROM PERSON;

-- 조회할 컬럼 다 쓰고 조회
SELECT PNAME, PAGE FROM PERSON;
SELECT PNAME FROM PERSON;

-- AS(별칭) :해당 컬럼의 별칭을 지정함, 함수나 수식을 감추기 위해서
SELECT PNAME AS 이름, PAGE AS 나이 FROM PERSON;

-- 학생 테이블에서 학과명만 조회
SELECT MAJOR_NAME FROM STUDENT;
SELECT DISTINCT MAJOR_NAME FROM STUDENT; -- DISTINCT : 중복제거

-- 조건절
-- 관계연산자 : > , < , >= , <= , = , <> 
-- 논리연산자 : NOT , AND , OR

-- PERSON 테이블에서 나이가 30 이상인 사람만 조회
SELECT * FROM PERSON WHERE PAGE >= 30;

SELECT * FROM PERSON WHERE PAGE <> 30;

SELECT * FROM PERSON WHERE PAGE != 30;

