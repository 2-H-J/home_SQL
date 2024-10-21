

-- 2024/10/18

-- 제약조건 
SELECT * FROM USER_CONSTRAINTS;
-- 기본키 
-- ALTER TABLE 테이블명 ADD CONSTRAINTS 제약명 PRIMARY KEY(기본키로 지정할 컬럼)
DROP TABLE PERSON;

-- PERSON TABLE 생성
CREATE TABLE PERSON(
    PID CHAR(4),
    PNAME VARCHAR2(30 BYTE),
    AGE NUMBER(3, 0)
);

-- 제약조건
ALTER TABLE PERSON ADD CONSTRAINTS PERSON_PID_PK
PRIMARY KEY(PID);

-- 제약조건 확인
SELECT * FROM USER_CONSTRAINTS;

-- 데이터 추가

INSERT INTO PERSON VALUES('0001','홍길동',20);
INSERT INTO PERSON VALUES('0002','김길동',30);
INSERT INTO PERSON VALUES('0003','이길동',40);
INSERT INTO PERSON VALUES('0004','박길동',50);

--외래키 테이블 생성 후 등록 방법(테이블 생성 후 가능)
--ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명
--FOREIGN KEY(외래키 지정할 컬럼명) --노비
--REFERENCES 외래키로 연결될 테이블명(참조할 테이블의 기본키); -- 주인
--[ON DELETE CASCADE]  |   [ON DELETE RESTRICT]  |  [ON DELETE SET NULL] -> [] : 옵션
--     같이 삭제	   |		 같이 멈춤       |  연결된 PK가 사라지면 참조연결을 제거
-- 만약 위 옵션중 설정을 하지 않으면 기본값이 ON DELETE RESTRICT로 설정됨
CREATE TABLE PERSON_ORDER(
	P_ORDER_NO NUMBER(5), --PRIMARY KEY,
	P_ORDER_MEMO VARCHAR2(300),
	PID CHAR(4)--,
--	CONSTRAINTS PERSON_ORDER_PID_FK FOREIGN KEY(PID) REFERENCES PERSON(PID);
	-- 위와 같이 테이블 생성중 제약조건등록 가능
);

DROP TABLE PERSON_ORDER;

-- PERSON_ORDER에 P_ORDER_NO를 기본키로 작성 : PRIMARY KEY 또는 ALTER로 설정
ALTER TABLE PERSON_ORDER ADD CONSTRAINTS PERSON_ORDER_PO_NO_PK
PRIMARY KEY(P_ORDER_NO);

SELECT * FROM USER_CONSTRAINTS;

--PERSON_ORDER에 PID를 외래키 설정, PERSON에 있는 PID와 연결
ALTER TABLE PERSON_ORDER ADD CONSTRAINTS PERSON_ORDER_PID_FK
FOREIGN KEY(PID) REFERENCES PERSON(PID); -- 아무 설정을 하지 않아서 기본적으로 ON DELETF RESTRICT이 설정됨
/*
ADD CONSTRAINT: 새로운 제약 조건을 추가하는 명령어입니다.
FOREIGN KEY (P_ID): PERSON_ORDER 테이블의 P_ID 컬럼을 외래키로 설정합니다.
REFERENCES PERSON(PID): PERSON 테이블의 PID 컬럼과 외래키로 연결합니다. 
 */

INSERT INTO PERSON_ORDER VALUES(1, '지시 내용1', '0001');
INSERT INTO PERSON_ORDER VALUES(2, '지시 내용2', '0002');
INSERT INTO PERSON_ORDER VALUES(3, '지시 내용3', '0003');
--INSERT INTO PERSON_ORDER VALUES(5, '지시 내용5', '0005'); --연결된 PERSON에 PID의 참조값이 없으면 값이 들어 갈 수가 없다.
--무결성 제약조건(C##SCOTT.PERSON_ORDER_PID_FK)이 위배되었습니다- 부모 키가 없습니다

--PERSON
DELETE FROM PERSON WHERE PID LIKE '0001'; 
-- 자식 레코드가 있으면 FK의 ON DELETF RESTRICT 기본 설정으로 진행 할 수 없다
--Error : 무결성 제약조건(C##SCOTT.PERSON_ORDER_PID_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
DELETE FROM PERSON_ORDER WHERE PID LIKE '0001'; -- 자식의 레코드를 먼저 삭제하면 가능

--PERSON_ORDER 외래키 제약 조건 삭제
ALTER TABLE PERSON_ORDER DROP CONSTRAINT PERSON_ORDER_PID_FK;

--외래키 지정시 ON DELETE CASCADE 지정
ALTER TABLE PERSON_ORDER ADD CONSTRAINTS PERSON_ORDER_PID_FK
FOREIGN KEY(PID) REFERENCES PERSON(PID) ON DELETE CASCADE;

DELETE FROM PERSON WHERE PID LIKE '0002';

--외래키 지정시 ON DELETE SET NULL 지정
ALTER TABLE PERSON_ORDER ADD CONSTRAINTS PERSON_ORDER_PID_FK
FOREIGN KEY(PID) REFERENCES PERSON(PID) ON DELETE SET NULL;

DELETE FROM PERSON WHERE PID LIKE '0003';

SELECT * FROM PERSON_ORDER;

--PERSON 테이블 삭제
DROP TABLE PERSON; -- 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
DROP TABLE PERSON CASCADE CONSTRAINTS; -- KEY로 연결된 테이블이 있더라도 해당 테이블을 삭제할 수 있다.

--STUDENT 테이블의 학과번호를 외래키로 지정, MAJOR의 테이블의 학과번호로 지정
ALTER TABLE MAJOR ADD CONSTRAINTS MAJOR_NO_PK
PRIMARY KEY(MAJOR_NO);

ALTER TABLE STUDENT ADD CONSTRAINTS STUDENT_MAJOR_NO_FK
FOREIGN KEY(MAJOR_NO) REFERENCES MAJOR(MAJOR_NO) ON DELETE CASCADE;

SELECT
	S.*,
	M.MAJOR_NO 
FROM STUDENT S 
LEFT OUTER JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
WHERE M.MAJOR_NO IS NULL;

-- 장학금 테이블 학번 외래키 지정
ALTER TABLE STUDENT_SCHOLARSHIP ADD CONSTRAINTS STUDENT_SCHOLARSHIP_S_S_NO_PK
PRIMARY KEY(SCHOLARSHIP_NO);

ALTER TABLE STUDENT_SCHOLARSHIP ADD CONSTRAINTS SCHOLARSHIP_STD_NO_FK
FOREIGN KEY(STD_NO) REFERENCES STUDENT(STD_NO) ON DELETE CASCADE;

--CHECK 제약조건
--컬럼에 들어올 값의 범위 및 제약 조건을 거는 방법
--예) 값이 1~10까지만 CHECK조건, 값이 ~~어떻게 들어와야 한다
--ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 CHECK(조건식); 
SELECT * FROM PERSON;

ALTER TABLE PERSON ADD CONSTRAINT PERSON_AGE_CHK CHECK(AGE > 0);

INSERT INTO PERSON VALUES('0002', '김만구', -10); -- 나이가 0보다 큰값만 넣는 조건 만들기
INSERT INTO PERSON VALUES('0003', '김진기', -30); 
INSERT INTO PERSON VALUES('0004', '장만보', -50); 
INSERT INTO PERSON VALUES('0001', '홍길동', 20);

ALTER TABLE PERSON DISABLE CONSTRAINT PERSON_AGE_CHK; -- 제약조건을 끈다(비활성화)
ALTER TABLE PERSON ENABLE CONSTRAINT PERSON_AGE_CHK; -- 다시 제약조건을 켤수(활성) 있지만 이미 제약에 위배되는 값이 들어가 있으면 들어갈 수 없다.
-------------------------------------------------------------------------------
-- 제약조건 삭제
ALTER TABLE PERSON DROP CONSTRAINT PERSON_NAME_CHK;
-------------------------------------------------------------------------------
-- PERSON 테이블에 이름 저장을 할 때 공백이 들어가지 않도록 제약조건을 설정
ALTER TABLE PERSON ADD CONSTRAINT PERSON_NAME_CHK CHECK(NOT PNAME LIKE '% %');
ALTER TABLE PERSON ADD CONSTRAINT PERSON_NAME_CHK CHECK(INSTR(PNAME, ' ') = 0);
INSERT INTO PERSON VALUES('0005', '김철 ', 20);
ALTER TABLE PERSON DROP CONSTRAINT PERSON_NAME_CHK;
-- 학생 테이블에 평점이 0.0 ~ 4.5 까지 저장되게끔 제약조건을 추가
ALTER TABLE STUDENT ADD CONSTRAINT STUDENT_SCORE_CHK CHECK(STD_SCORE BETWEEN 0.0 AND 4.5);

ALTER TABLE PERSON DROP CONSTRAINT STUDENT_STD_SCORE_CHE; -- 제약 삭제
INSERT INTO STUDENT VALUES('20224020', '쳌쳌쳌', 5.0, 'M', '01');



------------------------------------------------------------------------------------------------------------------------------------
--서브쿼리(Sub Query) : 하나의 SQL문에 또다른 SQL문이 있는 형태
-- 단일 행, 멀티 행, 다중 컬럼, 스칼라(컬럼에 서브쿼리가 들어가는 형태)

-- 조건식에 들어가는 서브쿼리
-- 평점이 최고점에 해당하는 학생 정보를 조회
SELECT 
	S.*
FROM STUDENT S
WHERE STD_SCORE = (SELECT MAX(STD_SCORE) FROM STUDENT) ;
-------------------------------------------------------------------------------
--평점이 최저점인 학생 데이터를 삭제
SELECT * FROM STUDENT ORDER BY STD_SCORE ;

DELETE FROM STUDENT WHERE STD_SCORE = (SELECT MIN(STD_SCORE) FROM STUDENT);
-------------------------------------------------------------------------------
--평점이 최고점인 학생과, 최저점인 학생을 조회
-- 조회할 컬럼은 학번, 이름, 학과명, 평점, 성별
SELECT 
	S.STD_NO ,
	S.STD_NAME ,
	M.MAJOR_NAME ,
	S.STD_SCORE ,
	S.STD_GENDER 
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
WHERE 
	STD_SCORE = (SELECT MAX(STD_SCORE) FROM STUDENT)
	OR 
	STD_SCORE = (SELECT MIN(STD_SCORE) FROM STUDENT);
--------------
SELECT 
	S.STD_NO ,
	S.STD_NAME ,
	M.MAJOR_NAME ,
	S.STD_SCORE ,
	S.STD_GENDER 
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
WHERE STD_SCORE 
IN ((SELECT MAX(STD_SCORE) FROM STUDENT), (SELECT MIN(STD_SCORE) FROM STUDENT));
-------------------------------------------------------------------------------
--평균 이하인 학생들의 평점을 0.5 증가

UPDATE STUDENT SET STD_SCORE = STD_SCORE + 0.5 
WHERE STD_SCORE <= (SELECT AVG(STD_SCORE) FROM STUDENT);
-------------------------------------------------------------------------------
--장학금을 받는 학생들만 조회
--학번, 이름, 학과명, 평점
SELECT
	S.STD_NO ,S.STD_NAME ,M.MAJOR_NAME ,
	S.STD_SCORE ,S.STD_GENDER
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
WHERE S.STD_NO IN(SELECT SS.STD_NO FROM STUDENT_SCHOLARSHIP SS);
-- S.STD_NO IN(SELECT SS.STD_NO FROM STUDENT_SCHOLARSHIP SS)
-- S.STD_NO 랑 SS.STD_NO랑 값이 같은게 있으면 TRUE S.STD_NO로 가져온다

--반대로 NOT IN를 통해 일치하지 않느 값으로만 가져온다(불일치)
SELECT
	S.STD_NO , S.STD_NAME , M.MAJOR_NAME ,
	S.STD_SCORE , S.STD_GENDER
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
WHERE S.STD_NO NOT IN(SELECT SS.STD_NO FROM STUDENT_SCHOLARSHIP SS);
-------------------------------------------------------------------------------
--학과별로 최고점을 가진 학생들을 조회
--1. 학과별로 최고점을 가진 점수를 조회, 학과 번호, 최고점 조회
SELECT
	MAJOR_NO , MAX(STD_SCORE) 
FROM STUDENT
GROUP BY MAJOR_NO;
--2.
SELECT * FROM STUDENT
WHERE (MAJOR_NO, STD_SCORE)
IN (SELECT MAJOR_NO , MAX(STD_SCORE) 
	FROM STUDENT GROUP BY MAJOR_NO);

--3. 조인을 이용해서 조회
SELECT S.* FROM STUDENT S --STUDENT의 모든 정보 
JOIN (SELECT MAJOR_NO, MAX(STD_SCORE) AS MAX_SCORE FROM STUDENT GROUP BY MAJOR_NO) M
ON S.MAJOR_NO = M.MAJOR_NO AND S.STD_SCORE = M.MAX_SCORE;
-------------------------------------------------------------------------------
--FROM 절에 들어가는 서브쿼리
--학생정보 조회시 행번호, 학번, 이름, 학과명, 평점을 조회
-- 평점을 기준으로 내림차순 정렬하여 조회

--SELECT 후 ORDER BY가 실행되기 때문에 뒤족박죽 상태가 된다
SELECT 
--	ROW_NUMBER() OVER(ORDER BY S.STD_SCORE DESC),
	S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY S.STD_SCORE DESC;

--이것을 해결하기 위해 서브쿼리로 작업
SELECT ROWNUM, S.* 
FROM (SELECT 
	S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY S.STD_SCORE DESC) S;

-- 제일 위에서 데이터 5건만 조회
SELECT ROWNUM, S.* 
FROM(SELECT 
	S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY S.STD_SCORE DESC) S
WHERE ROWNUM <= 5;

-- 행번호가 6번부터 10번 데이터 까지만
SELECT * FROM (
	SELECT ROWNUM AS RW, S.* FROM(
	SELECT S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE 
	FROM STUDENT S 
	JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
	ORDER BY S.STD_SCORE DESC) S)
WHERE RW BETWEEN 6 AND 10;
-- 
SELECT * FROM
	(SELECT 
	ROW_NUMBER() OVER (ORDER BY S.STD_SCORE DESC) AS RN, 
	S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE 
	FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO)
WHERE RN BETWEEN 6 AND 10;
-------------------------------------------------------------------------------
--장학금 받는 학생들 중 제일 많은 장학금을 받는 학생 TOP3 학생 목록 조회
-- 학번, 이름, 학과명, 장학금 금액 (동일한 금액도 포함)
SELECT * FROM 
(SELECT
	DENSE_RANK () OVER(ORDER BY SS.MONEY DESC) AS D_RANK,
	S.STD_NO , S.STD_NAME , M.MAJOR_NAME, SS.MONEY
FROM STUDENT S JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
JOIN STUDENT_SCHOLARSHIP SS ON S.STD_NO = SS.STD_NO)
WHERE D_RANK <= 3;

--학생 정보 조회(스칼라)
--학번 이름 학과명 평점
SELECT 
	S.STD_NO , S.STD_NAME , 
	(SELECT M.MAJOR_NAME FROM MAJOR M WHERE S.MAJOR_NO = M.MAJOR_NO) AS MAJOR_NAME, 
	S.STD_SCORE 
FROM STUDENT S;
----------------------------------------------------------------------------------

--최대 금액과 최소 금액을 가진 차량의 정보를 조회

-- 제조사별 차량 종류 개수, 평균 금액을 조회
-- 제조사명, 개수, 금액, 평균 컬럼

--월별 최대 판매 차량 대수를 조회
--1. 월별, 차량별 총 판매 대수 조회 (month, car_no, sum_ea)
--2. 1번 데이터를 기준으로 월별 최대 판매대수를 구하면
--3. 1번과 2번을 기준으로 월별 최대 판매 차량 대수를 조회, 다중 컬럼 비교식 참고

--판매가 한번도 안된 자동차를 목록 조회 not in 사용

--판매가 안된 자동차들을 기준으로 금액이 평균 이상인 자동차 조회

--판매가 안된 자동차들을 기준으로 제일 많이 안팔린 모딜을 보유 중인 제조사 조회