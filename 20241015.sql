--함수

--DUAL : 임시 테이블, 값을 확인하는 용도(함수, 결과값, 계산 결과값)
--SYSDATE : 현재 날짜 시간값
SELECT 'HELLO', 10 + 2 FROM DUAL;
SELECT '날짜시간', SYSDATE FROM DUAL

--문자열 데이터
--INITCAP : 문자열 각 단어들의 첫글자를 대문자로 변환하고, 나머지는 전부 소문자
SELECT INITCAP('hello world') FROM DUAL;
SELECT INITCAP('HELLO WORLD') FROM DUAL;

--알파벳 기준
--LOWER : 문자열 단어들을 전부 소문자로
--UPPER : 문자열 단어들을 전부 대문자로
SELECT LOWER('Hello World'), UPPER('Hello World') FROM DUAL;

--LENGTH : 문자열 글자 수
--LENGTHB : 문자열 바이트 수
SELECT LENGTH('Hello'), LENGTH('안녕하세요') FROM DUAL;
SELECT LENGTHB('Hello'), LENGTHB('안녕하세요') FROM DUAL;

--PERSON 테이블에 이름의 글자 개수와 글자 개수의 바이트수 출력
SELECT PNAME, LENGTH(PNAME), LENGTHB(PNAME) FROM PERSON;

--PERSON 테이블에서 NULL값을 가진 레코드를 조회
SELECT * FROM PERSON;
SELECT * FROM PERSON WHERE PAGE IS NULL;
SELECT * FROM PERSON WHERE PAGE IS NOT NULL;

--중요☆
--INSTR : 문자열에서 특정 문자열의 시작 위치를 반환.(검색) / 찾을 수 없다면 0 
SELECT INSTR('ABCDEFG', 'CD') FROM DUAL;
SELECT INSTR('ABCDEFG', 'CDF') FROM DUAL;
SELECT INSTR('HELLO WORLD', ' ') FROM DUAL; -- INSTR은 문자열의 공백체크 할 때 많이 사용함
--테이블 컬럼에 공백을 넣지 않는 조건
CREATE TABLE PERSON(
	PNAME VARCHAR2(30),
	PAGE NUMBER(3),
	CONSTRAINT CHK_NAME CHECK(INSTR(PNAME, ' ') = 0),
	CONSTRAINT CHK_AGE CHECK(PAGE > 0)
);

DROP TABLE PERSON;

INSERT INTO PERSON VALUES('김철수',10);
INSERT INTO PERSON VALUES('김 철수',10);
INSERT INTO PERSON VALUES('김철 수',10);
INSERT INTO PERSON VALUES('김철수',0);

SELECT * FROM USER_CONSTRAINTS; -- 제약조건 확인

--REPLACE : 문자열 바꾸기
SELECT REPLACE ('AAAAAABBBBBCCCC','B','F') FROM DUAL;

--학생테이블에 학과명을 공학을 학으로 변경을 하는 UPDATE문을 작성
--학과명에 공학이 있는 경우에만 동작하게끔 처리
UPDATE STUDENT 
SET MAJOR_NAME =  REPLACE(MAJOR_NAME, '공학', '학') 
WHERE INSTR (MAJOR_NAME, '공학') <> 0;

SELECT * FROM STUDENT;

--LPAD, RPAD : 원하는 문자열 개수만큼 남은 부분에 지정한 문자열로 채워주는 함수
SELECT LPAD('991122-1',14,'*') FROM DUAL;
SELECT RPAD('991122-1',14,'*') FROM DUAL;

SELECT LPAD('ABC',10,'1234') FROM DUAL; --지정한 문자열도 총 개수에 포함된다
SELECT RPAD('ABC',10,'1234') FROM DUAL;

--TRIM : 문자열 양쪽의 공백 또는 지정한 문자를 제거.
--LTRIM() : 문자열 왼쪽의 공백 또는 지정한 문자를 제거.
--RTRIM() : 문자열 오른쪽의 공백 또는 지정한 문자를 제거.
--TRIM([[LEADING | TRAILING | BOTH] [제거할 문자] FROM 문자열])  SELECT TRIM(BOTH '-' FROM '---Hello World---') FROM dual;
SELECT TRIM('      A    B  C             '),'      A    B  C             ' FROM DUAL;
SELECT TRIM('A' FROM 'AAAABBBBBCCCCCCDDDDDDDAAAAAA') FROM DUAL;
SELECT TRIM(BOTH 'A' FROM 'AAAABBBBBCCCCCCDDDDDDDAAAAAA') FROM DUAL;
SELECT TRIM(LEADING 'A' FROM 'AAAABBBBBCCCCCCDDDDDDDAAAAAA') FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAAABBBBBCCCCCCDDDDDDDAAAAAA') FROM DUAL;

SELECT LTRIM('AAAABBBBBCCCCCCDDDDDDDAAAAAA','A') FROM DUAL;
SELECT RTRIM('AAAABBBBBCCCCCCDDDDDDDAAAAAA','A') FROM DUAL;

SELECT LTRIM('AABAACBBBBBCCCCCDDDDDDAAAAA','ABC') FROM DUAL;
SELECT RTRIM('AAABACBBBBBCCCCCDDDDDDAACABAA','ABC') FROM DUAL;

--CONCAT : 두 문자열또는 숫자를 하나로 합치기 두개만 가능 CONCAT('문자열','문자열')
--|| : 문자열 또는 숫자를 붙일 수 있다 몇개든 가능
SELECT CONCAT('HELLO', 'WORLD')) AS CON, 'HELLO' || 'WORLD' || 321 FROM DUAL;
SELECT CONCAT('HELLO', CONCAT('WORLD','추가로 붙여보기')) AS CON, 'HELLO' || 'WORLD' || 321 FROM DUAL;

--SUBSTR() : 문자열 부분 추출(문자 기준으로 추출)
SELECT SUBSTR('1234567890', 5, 4) FROM DUAL; -- 문자열, 지정 수부터 ,개수만큼 추출 - SUBSTR('문자열', 지정수, 추출할 개수)
SELECT SUBSTR('안녕하세요', 2, 3) FROM DUAL; 
--바이트 단위로 문자열 추출
SELECT SUBSTRB('안녕하세요', 2, 3) FROM DUAL; 
SELECT SUBSTRB('ABCDEFG', 2, 3) FROM DUAL;

--LENGTH : 문자열 길이 반환
SELECT LENGTH(TRIM('      A    B  C             ')),
LENGTH ('      A    B  C             ') FROM DUAL;

-------------------------------------------------------------------------------------------------------

--ROUND : 숫자를 지정한 자릿수에서 반올림.
--   -2 -1     0  1  2
-- 1  2  3  .  4  5  6
SELECT ROUND(123.456, -2) FROM DUAL; 
SELECT ROUND(123.456, -1) FROM DUAL; 
SELECT ROUND(163.456, 0) FROM DUAL; 
SELECT ROUND(163.456, 1) FROM DUAL; 
SELECT ROUND(163.456, 2) FROM DUAL;

--올림 : CEIL / 내림 : FLOOR
SELECT CEIL(123.456), FLOOR(123.456) FROM DUAL;

--TRUNC : 숫자를 지정한 자릿수에서 버림.
SELECT TRUNC(123.456, -2) FROM DUAL; 
SELECT TRUNC(123.456, -1) FROM DUAL; 
SELECT TRUNC(163.456, 0) FROM DUAL; 
SELECT TRUNC(163.456, 1) FROM DUAL; 
SELECT TRUNC(163.456, 2) FROM DUAL;

--MOD : 나눗셈의 나머지를 반환
SELECT MOD(6, 4) FROM DUAL;

--POWER(N, M) :N의 M승(주어진 숫자의 거듭제곱을 반환) 
SELECT POWER(2, 10) FROM DUAL;

--TO_NUMBER('문자열') : 문자열을 숫자로 바꿔주는 함수 (알파벳,한글 안됨)
SELECT 123 + '123', 123 / '3' FROM DUAL;
SELECT TO_NUMBER('123') / '3' FROM DUAL;
-----------------------------------------------------------------------------------------------------
--날짜시간
SELECT SYSDATE FROM DUAL;
--오라클에서 지정된 현재 날짜 시간의 출력 포맷을 변경 - 현재 연결된 세션에서만 가능
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'YY/MM/DD';

--TO_CHAR(데이터, '형식') : 
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD (DAY) HH:MI:SS'),
TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MON MONTH DY DAY') FROM DUAL; --MON,MONTH : 월 약자,월 풀네임 / DY, DAY : 요일 약자, 요일 풀네임
SELECT TO_CHAR(SYSDATE, 'MON MONTH DY DAY','NLS_DATE_LANGUAGE=ENGLISH') FROM DUAL;
-- NLS_DATE_LANGUAGE=ENGLISH : 지역언어 영어로 변경

SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH:MI:SS AM') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2024-10-15 15:00:11',
						'YYYY-MM-DD HH24:MI:SS'),
						'Q YYYY-MM-DD HH:MI:SS AM') 
FROM DUAL; 			  -- Q : 분기 / AMorPM : 오전오후 / YYYY-MM-DD : 년월일 / HH24,HH : 24시간기준,12시간기준 / MI,SS : 분초
-----------------------------------------------------------------------------------------------------------------------------
--숫자 포멧
-- 9 : 숫자 한자리, 자리가 없으면 공백
-- O : 숫자 한자리, 자리가 없으면 0으로 채움
SELECT TO_CHAR(1234567.89,'99999999.000') FROM DUAL;

-- L : 통화 기호(지역 설정 기준 - KR:￦)
SELECT TO_CHAR(1234567.89,'L99999999.000') FROM DUAL;

-- $ : 통화 기호 (달러)
SELECT TO_CHAR(1234567.89,'$99999999.000') FROM DUAL;

-- , : 단위 구분 (천단위 등등) 기호,  . : 소수점 기호 - ,랑 .을 같이 사용 하여야 함
SELECT TO_CHAR(1234567.89,'L99,999,999.000') FROM DUAL;
SELECT TO_CHAR(1234567.89,'L99,999,999.000') FROM DUAL;

-- G : 단위 구분(천단위 등등) ,기호, D : 소수점 .기호 - G랑 D랑 같이 사용 하여야 함
SELECT TO_CHAR(1234567.89, 'L99G999G999D000') FROM DUAL;

-- FM : 공백제거
SELECT TO_CHAR(1234567.89,'99999999.000'),TO_CHAR(1234567.89,'FM99999999.000') FROM DUAL;
SELECT TO_CHAR(1234567.89,'FML99999999.000') FROM DUAL;

-- PR : -일때 <> 묶어서 표현,  S : + - 부호 표시
SELECT 
		TO_CHAR(-1234567,'S9,999,999'),
		TO_CHAR(1234567,'S9,999,999'),
		TO_CHAR(-1234567,'9,999,999PR'),
		TO_CHAR(1234567,'9,999,999PR')
FROM DUAL;

-- 문자열을 날짜로 변경
SELECT TO_DATE('2020-11-11','YYYY-MM-DD') FROM DUAL;

--오늘 날짜부터 지정된 날짜까지 남은 개월 수
SELECT ABS(MONTHS_BETWEEN(SYSDATE,'2024-12-31')) FROM DUAL;
--ABS : 절대값

-- ADD_MONTHS : 지정된 날로부터, 입력 개월 후 날짜
SELECT ADD_MONTHS(SYSDATE, 2) FROM DUAL; 

-- NEXT_DAY : 지정된 날로 부터,입력한 돌아오는 요일이 되는 날짜
SELECT NEXT_DAY(SYSDATE, '수') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '월') FROM DUAL;

-- 주어진 날로 부터 마지막 날
SELECT LAST_DAY(SYSDATE) FROM DUAL; 

--내일 날짜 출력
SELECT SYSDATE + 1 FROM DUAL;

--D-DAY 올해 수능 날까지 D-DAY 출력
SELECT CEIL(TO_DATE('2024-11-14','YYYY-MM-DD') - SYSDATE) FROM DUAL;
--SELECT DATEDIFF('2024-11-14', CURDATE()) AS d_day;

--------------------------------------------------------------------------------------------

-- PERSON 샘플 50건 CSV로 추가함
SELECT * FROM PERSON;

--윈도우 함수 (Window Functions) : 윈도우 함수는 그룹화하지 않고도 결과 집합에 대해 순차적으로 계산할 수 있는 함수
--OVER, PARTITION BY, ORDER BY

--순위 RANK() : 순위를 체크 동일한 값이 있으면 다음 순위는 건너뛴다
SELECT RANK() OVER(ORDER BY PAGE) AS RANK, P.* FROM PERSON P; -- ORDER BY PAGE : 기본 정렬은 ASC 올림차순으로 적용 되어 있다.
SELECT RANK() OVER(ORDER BY PAGE DESC) AS RANK, P.* FROM PERSON P;

-- DENSE_RANK() : 동일한 값이 같은 랭크 후 이어서 랭크순위를 반환
SELECT DENSE_RANK() OVER(ORDER BY PAGE) AS RANK, P.* FROM PERSON P; 
SELECT DENSE_RANK() OVER(ORDER BY PAGE DESC) AS RANK, P.* FROM PERSON P;

-- ROW_NUMBER() : 줄번호
SELECT 
	ROW_NUMBER() OVER(ORDER BY PAGE) AS RW,
	P.* 
FROM PERSON P;
SELECT ROW_NUMBER() OVER(ORDER BY PAGE DESC) AS RW, P.* FROM PERSON P;

SELECT
	ROW_NUMBER() OVER(ORDER BY PAGE) AS RW,
	RANK() OVER(ORDER BY PAGE) AS RANK,
P.* FROM PERSON P;

--------------------------------------------------------------------------------------------

-- LEAD(): 현재 행 이후의 값을 반환.
-- 현재 행을 기준으로 다음 위치에 해당하는 값을 읽어오는 함수
SELECT P.*, 
	LEAD(PNAME) OVER(ORDER BY PAGE) AS NEXT_PNAME -- LEAD(현재 행 이후 값)
FROM PERSON P;

SELECT P.*, 
	LEAD(PNAME, 2, '데이터 없음') OVER(ORDER BY PAGE) AS NEXT_PNAME -- LEAD(현재 행, 현재 행 지정한 이후 값, 값이 없을때 나옴)
FROM PERSON P;

-- 현재 행을 기준으로 이전 위치에 해당하는 값을 읽어오는 함수
SELECT P.*, 
	LAG(PNAME) OVER(ORDER BY PAGE) AS PREV_PNAME -- LAG(현재 행 이전 값)
FROM PERSON P;

SELECT P.*, 
	LAG(PNAME, 2, '데이터 없음') OVER(ORDER BY PAGE) AS PREV_PNAME -- LAG(현재 행, 현재 행 지정한 이전 값, 값이 없을때 나옴)
FROM PERSON P;

-- 학생테이블의 평점을 기준으로 성적 순위를 출력, 성적순은 내림차순으로 처리, 순위는 건너뛰지 않는다
SELECT  
	DENSE_RANK() OVER(ORDER BY S.STD_SCORE DESC) AS RANK, S.*
FROM STUDENT S;

--PARTITION BY 파티션으로 나눌 변수명 : 파티션별 나눠서 순위를 줄 수 있다.
SELECT  
	DENSE_RANK() OVER(PARTITION BY S.MAJOR_NAME ORDER BY S.STD_SCORE DESC) AS RANK, S.*
FROM STUDENT S;

------------------------------------------------------------------------------------------------------------

--NULL 값 처리하는 함수 ( 중요 )
--NVL(첫번째값, 리턴값) : 1번째 값이 NULL일때 2번째 값을 리턴, NULL이 아니면 그냥 1번째 값을 리턴
SELECT NVL(NULL, 'NULL일때 값'), NVL('100','NULL값') FROM DUAL;

--NVL2(값, 널이 아니면 리턴 하는 값, 널이면 리턴 하는 값) : 1번째 값이 널이면 3번째 값을 리턴하고 널이 아니면 2번째 값을 리턴 한다.
SELECT 
	NVL2(NULL,'널이 아닐때 값','널일때 값'),
	NVL2('100','널이 아닐때 값', '널일때 값')
FROM DUAL;

--DECODE : 1번째 값이 ~일때, ~를 리턴 하는 함수 가장 마지막 값은 default값(1번째 값이 없으면 나올 값) (Java의 swich문과 비슷)
--값을 숫자로만 지원함, default값은 끝에 넣어야 한다.
SELECT DECODE(1,1,'A',2,'B','C') FROM DUAL;
SELECT DECODE(2,1,'A',2,'B','C') FROM DUAL;
SELECT DECODE(5,1,'A',5,'B','C') FROM DUAL;
SELECT DECODE(4,1,'A',2,'B',3,'C',4,'D','F') FROM DUAL;

------------------------------------------------------------------------------------------------------------
-- 학생 테이블에서 학생정보 조회시
-- 학번의 경우 앞에서 4자리만 표현하고 나머지 4자리는 마스킹 처리 해서 조회
SELECT SUBSTR(STD_NO,1,4) || '****',
	STD_NAME , MAJOR_NAME ,STD_SCORE 
FROM STUDENT;

SELECT RPAD(SUBSTR(STD_NO,1,4),8,'*'),
	STD_NAME , MAJOR_NAME ,STD_SCORE 
FROM STUDENT;

SELECT CONCAT(SUBSTR(STD_NO,1,4), '****'),
	STD_NAME , MAJOR_NAME ,STD_SCORE 
FROM STUDENT;) 

-- 사원 테이블에서데이터 조회시 연봉 순위를 조회, 입사일은 입사년도만 출력
-- 연봉은 출력시 천단위 기호가 붙게끔 처리
SELECT
	DENSE_RANK() OVER(ORDER BY EMP_SALARY DESC) AS SALARY_RANK,
	EMP_NO, EMP_NAME, 
	TO_CHAR(EMP_COURSE_DATE, 'YYYY') AS COURSE_DATE,
	TO_CHAR(EMP_SALARY, 'FM999,999,999,999') AS SALARY
FROM EMPLOYEE;

-- 학생 테이블에서 성씨별로 점수 순위를 내림 차순 기준으로 조회하시오
-- 출력 형태는 아래와 같이 조회하세요 순위는 건너뛰지 않습니다.
-- 순위 학번 성씨 학과명 평점
SELECT 
	DENSE_RANK() OVER(PARTITION BY SUBSTR(S.STD_NAME, 1, 1) 
	ORDER BY S.STD_SCORE DESC) AS SCORE_RANK , S.*
FROM STUDENT s
--WHERE S.STD_SCORE >= 3
;

-- 입학한 년도 별로 순위 구하기
SELECT 
	DENSE_RANK() OVER(PARTITION BY SUBSTR(S.STD_NO, 1, 4) 
	ORDER BY S.STD_SCORE DESC) AS SCORE_RANK , S.*
FROM STUDENT s;

-- 학번 앞 4자리와 학과명 으로 분류, 평점으로 랭킹순위
SELECT 
	DENSE_RANK() OVER(PARTITION BY SUBSTR(S.STD_NO, 1, 4) ,MAJOR_NAME 
	ORDER BY S.STD_SCORE DESC) AS SCORE_RANK , S.*
FROM STUDENT s;