--사원 정보
--	사번, 이름, 직급명, 부서명, 연봉, 입사일
CREATE TABLE EMPLOYEE(
	EMP_NO CHAR(9) PRIMARY KEY,
	EMP_NAME VARCHAR2(30),
	EMP_POSITION VARCHAR2(30) DEFAULT '사원' NOT NULL,
	EMP_DEPARTMENT VARCHAR2(30),
	EMP_SALARY NUMBER(12) DEFAULT 0,
	EMP_COURSE_DATE DATE DEFAULT SYSDATE
);
-- 사원정보 샘플데이터 50건 저장
-- CSV로 만들어서 저장

--DML(Data Manipulation Language) : 데이터 조작어
--	 데이터를 조회, 삭제, 수정, 추가
--	 SELECT, DELETE, UPDATE, INSERT
CREATE TABLE PERSON(
	PNAME CHAR(30),
	PAGE NUMBER(3)
);
--INSERT : 추가
--	INSERT INTO 테이블명(컬럼1, 컬럼2, 컬럼3 ...)	
--	VALUES(데이터1, 데이터2, 데이터3....)
--	INSERT INTO 테이블명	
--	VALUES(데이터1, 데이터2, 데이터3....)
--	테이블 생성시 만든 모든 컬럼에 데이터를 저장
--	데이터 순서는 CREATE 작성시 만든 컬럼의 순서대로 작성 

--PERSON 테이블에 데이터 추가
INSERT INTO PERSON VALUES('홍길동', 20);
INSERT INTO PERSON(PNAME, PAGE) VALUES('이형준', NULL);

--PERSON 데이터 5건 추가
INSERT ALL 
	INTO PERSON VALUES('김씨', 20)
	INTO PERSON VALUES('홍씨', 32)
	INTO PERSON VALUES('박씨', 44)
	INTO PERSON VALUES('정씨', 55)
	INTO PERSON VALUES('곽씨', 33)
SELECT * FROM DUAL;

--학생데이터 한건 추가하는 INSERT문 작성
INSERT INTO STUDENT(STD_NO,STD_NEW_NAME,MAJOR_NAME,STD_SCORE)
VALUES('20251111','김철수','게임학과',3.6);
--사원정보 1건 등록하는 INSERT문 작성 - 입사일 제외하고 추가
INSERT INTO 
EMPLOYEE(EMP_NO,EMP_NAME,EMP_POSITION,EMP_DEPARTMENT,EMP_SALARY)
VALUES('A20246666','김철수','사원','총무부',32000000);
--사원정보 1건 등록하는 INSERT문 작성 - 모든 항목 추가
INSERT INTO 
EMPLOYEE(EMP_NO,EMP_NAME,EMP_POSITION,
EMP_DEPARTMENT,EMP_SALARY,EMP_COURSE_DATE)
VALUES('A20236666','박영훈','주임','개발부',48000000,'2024-01-05');

--데이터 조회 : SELECT
--SELECT 조회할 컬럼1, 조회할 컬럼2, .....
--FROM 조회할 테이블1, 조회할 테이블2, .... 
--WHERE 조건절
--GROUP BY 그룹으로 묶을 컬럼1, 그룹으로 묶을 컬럼2, ... [HAVING 조건절] 
--ORDER BY 정렬할 기준 컬럼1 [ASC | DESC], 정렬할 기준 컬럼2 [ASC | DESC] ...
--전체 PERSON 데이터 조회
SELECT * FROM PERSON;
--조회할 컬럼을 다쓰는 SQL
SELECT PNAME, PAGE FROM PERSON;
--AS는 해당 컬럼의 별칭을 지정함, 함수나, 수식을 감추기 위해서
SELECT PNAME AS 이름, PAGE AS 나이 FROM PERSON;
SELECT PNAME, LENGTH(PNAME) AS PNAME_LENGTH FROM PERSON;
--학생 테이블에서 학과명만 조회
--DISTINCT : 중복된 내용 제거해서 조회
SELECT DISTINCT MAJOR_NAME FROM STUDENT;
--조건절
-- 관계연산자 : > < >= <= = <>
-- 논리연산자 : NOT AND OR
--PERSON 테이블에서 나이가 30이상인 사람만 조회
SELECT * FROM PERSON WHERE PAGE >= 30;
--PERSON 테이블에서 나이가 30이 아닌 사람만 조회
SELECT * FROM PERSON WHERE PAGE != 30;
SELECT * FROM PERSON WHERE PAGE <> 30;
--PERSON 테이블에서 나이가 30대인 사람만 조회
SELECT * FROM PERSON WHERE PAGE >= 30 AND PAGE <= 39;
SELECT * FROM PERSON WHERE PAGE BETWEEN 30 AND 39;
-- NOT 사용방법
SELECT * FROM PERSON WHERE NOT PAGE < 30;
--컬럼 IN(....) 해당 컬럼의 값이 IN 안에 존재하면 true, 아니면 false 
--비교하는 연산자는 = 으로 비교한다.
SELECT * FROM PERSON WHERE PAGE IN(30,32,33);
SELECT * FROM PERSON WHERE PAGE NOT IN(30,32,33);
--문자열 비교
-- = 고정길이 비교시 남는 공백도 포함해서 비교
-- LIKE 로 비교하면 완전일치, 문자열 패턴과 일치하는 문자열 검색
SELECT * FROM PERSON WHERE PNAME LIKE '홍길동';
SELECT * FROM PERSON WHERE PNAME = '홍길동';
-- % 와일드 카드 문자, 글자개수가 0개 이상 올수 있다.
-- 박으로 시작하는 문자열
SELECT * FROM PERSON WHERE PNAME LIKE '박%';
-- 씨로 끝나는 문자열
SELECT * FROM PERSON WHERE PNAME LIKE '%씨';
-- 김을 포함하는 문자열
SELECT * FROM PERSON WHERE PNAME LIKE '%김%';
-- _ 와일드카드 문자 1글자
SELECT * FROM PERSON WHERE PNAME LIKE '박_';
SELECT * FROM PERSON WHERE PNAME LIKE '박__';
-- || 양쪽의 데이터를 하나의 문자열로 합쳐주는 연산자
SELECT PNAME || '-' || PAGE FROM PERSON;
SELECT * FROM USER_TABLES; -- 사용자가 만들 테이블 조회
SELECT 'DROP TABLE ' || TABLE_NAME || ';' FROM USER_TABLES;
--학점이 2.5이상 3.5이하인 학생 목록을 조회
SELECT * FROM STUDENT WHERE STD_SCORE BETWEEN 2.5 AND 3.5;
--학점이 2.5이상 3.5이하인 학생 이면서 '경영학'과인 학생 목록을 조회
SELECT * FROM STUDENT WHERE STD_SCORE BETWEEN 2.5 AND 3.5
AND MAJOR_NAME LIKE '경영학';
--학점이 2.5 미만인 학생 이면서 학번이 2023인 학생들만 조회
SELECT * FROM STUDENT WHERE STD_SCORE < 2.5 
AND STD_NO LIKE '2023%';
--입사일이 2023/01/01 ~ 2023/01/03인 직원을 조회
SELECT * FROM EMPLOYEE
WHERE EMP_COURSE_DATE >= '2023/01/01' 
AND EMP_COURSE_DATE  <= '2023/01/03';

SELECT * FROM EMPLOYEE
WHERE EMP_COURSE_DATE BETWEEN '2023/01/01' AND '2023/01/03';

--데이터 수정 : UPDATE
--UPDATE 테이블명 SET 수정할컬럼명=수정할값,.... WHERE 조건절
-- + - * / 
-- PERSON 테이블의 데이터 중 20세 미만인 데이터는 나이를 99로 수정
UPDATE PERSON SET PAGE=99 WHERE PAGE < 20;
SELECT * FROM PERSON;
-- PERSON 테이블의 데이터 중 30세 미만인 데이터에 나이를 현재 값에 5씩 빼서 저장
UPDATE PERSON SET PAGE = PAGE - 5 WHERE PAGE < 30;
--학생 데이터 중 점수 1.5 미만이면 이름 제적으로 수정하겠다.
UPDATE STUDENT SET STD_NEW_NAME = '제적'
WHERE STD_SCORE < 1.5;

--데이터 삭제 : DELETE
-- DELETE FROM 테이블명 WHERE 조건절
--PERSON 테이블의 데이터 중 나이가 99세는 전부 삭제
DELETE FROM PERSON WHERE PAGE = 99;

SELECT * FROM PERSON;

--CAR 
CREATE TABLE CAR(
	CAR_ID CHAR(10), --> A000000000
	CAR_NAME VARCHAR2(30),
	CAR_MAKER VARCHAR2(30),
	CAR_MAKE_YEAR NUMBER(4),
	CAR_PRICE NUMBER(5)
);

SELECT * FROM CAR;

DROP TABLE CAR;

-- 자동차테이블에서 제조사가 BMW인 자동차를 조회
SELECT ROWNUM, C.* FROM CAR C WHERE CAR_MAKER LIKE 'BMW'; -- 테이블 옆 C는 테이블명의 별칭
-- ROWNUM : ROW(행)번호

-- 정렬 : ORDER BY 컬럼명 [ASC | DESC], 컬럼명 [ASC | DESC];
SELECT C.* FROM CAR c WHERE CAR_MAKER LIKE 'BMW' ORDER BY CAR_PRICE;
SELECT C.* FROM CAR c WHERE CAR_MAKER LIKE 'BMW' 
ORDER BY CAR_PRICE DESC; -- DESC : 내림차순(높은순)

SELECT C.* FROM CAR c WHERE CAR_MAKER LIKE 'BMW' 
ORDER BY CAR_MAKE_YEAR DESC, CAR_PRICE DESC; -- DESC : 내림차순 / 우선순위로는 연도가 높은거 부터

SELECT ROWNUM, C.* FROM CAR C WHERE CAR_MAKER LIKE 'BMW'
ORDER BY CAR_MAKE_YEAR DESC, CAR_PRICE DESC;
-- 실행 순서 : FROM -> WHERE -> SELECT -> ORDER BY


-- 자동차 데이터 TOP 10건 출력 ROWNUM 활용
SELECT C.* FROM CAR C WHERE ROWNUM <= 10 ORDER BY CAR_PRICE DESC;

-- 자동차 테이블에서 제조사가 BMW이거나 Mercedes-Benz, Audi인 자동차 조회
SELECT C.* FROM CAR C WHERE CAR_MAKER IN ('BMW','Mercedes-Benz','Audi');
SELECT C.* FROM CAR c WHERE CAR_MAKER LIKE 'BMW' OR CAR_MAKER LIKE 'Mercedes-Benz' OR CAR_MAKER LIKE 'Audi';

-- 자동차 테이블에서자동차 금액이 7000이상 9000이하 자동차를 조회
SELECT C.* FROM CAR c WHERE CAR_PRICE BETWEEN 7000 AND 9000;
SELECT C.* FROM CAR c WHERE CAR_PRICE >= 7000 AND CAR_PRICE <= 9000 ORDER BY CAR_PRICE ASC;

-- 자동차 테이블에서 제조사가 Kia이면서 자동차 금액이 70000이상 90000이하인 자동차 조회
SELECT C.* FROM CAR c WHERE CAR_PRICE BETWEEN 70000 AND 90000 AND CAR_MAKER LIKE 'Kia';

-- 자동차 테이블에서 자동차 번호가 3번째 자리가 8, 4번째자리가 9인 자동차를 조회
--SUBSTR : 함수는 문자열에서 특정 위치부터 지정된 길이만큼의 문자열을 추출하는 데 사용되는 함수
SELECT C.* FROM CAR c WHERE SUBSTR (CAR_ID, 3, 1) = '8' AND SUBSTR(CAR_ID, 4, 1) = '9'; 

SELECT  C.* FROM CAR c WHERE CAR_ID LIKE '__89______';
SELECT  C.* FROM CAR c WHERE CAR_ID LIKE '__89%'; -- %뒤에 수는 상관없음

-- 자동차 테이블에서 금액이 10000넘는 자동차의 금액을 3000씩 금액을 낮추세요
SELECT C.* FROM CAR c ;
UPDATE CAR SET CAR_PRICE = CAR_PRICE - 3000 WHERE CAR_PRICE >= 10000;

-- 자동차 테이블에서 자동차 금액을 전부 30% 할인한 금액으로 낮추세요
UPDATE CAR SET CAR_PRICE = CAR_PRICE * 0.7;

-- 자동차 테이블에서 제조사가 Jeep인 데이터를 삭제
DELETE FROM CAR WHERE CAR_MAKER = 'Jeep';
SELECT CAR_MAKER FROM CAR WHERE CAR_MAKER ='Jeep';