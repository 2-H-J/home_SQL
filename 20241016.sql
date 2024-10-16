
--그룹함수(★매우 중요★)---------
-- 테이블에 있는 데이터를 특정 컬럼을 기준으로 통계값을 구하는 함수
-- 윈도우 함수의 파티션(PARTITION) 처럼 특정 컬럼에 동일한 데이터들을 묶어서 통계값을 구함
-- 예> 학생 테이블에서 학과별 평점의 평균, 학과별 인원수
-- SUM(합), AVG(평균), COUNT(개수), MAX(최대값), MIN(최소값), 잘 사용 안하는 두개 : STDDEV, VARIANCE

-- 학과별 평점의 총합을 조회
SELECT 
	M.MAJOR_NAME,
	SUM(STD_SCORE) AS "학과별 총합"
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME ;

SELECT 
	M.MAJOR_NAME,
	TRUNC(AVG(STD_SCORE), 2) AS "평균",
	SUM(S.STD_SCORE)
FROM STUDENT S 
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME ;

-- 학과별 평점의 평균을 조회
SELECT 
	M.MAJOR_NAME AS "학과",
	TRUNC(AVG(STD_SCORE), 2) AS "학과별 평균" 
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME ;

--학과별 평점의 최대값 최소값 조회
SELECT 
	M.MAJOR_NAME AS "학과",
	MAX(STD_SCORE) AS "최대값",
	MIN(STD_SCORE) AS "최소값",
	COUNT(STD_SCORE)
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME ;

--순서 : FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
--학과별 인원수를 조회, 평점이 3.0 이상인 학생들만 조회
SELECT 
	M.MAJOR_NAME AS "학과",
	COUNT(*) AS "학과 3.0이상 인원수" 
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
WHERE STD_SCORE >= 3.0
GROUP BY M.MAJOR_NAME ;

--학과별 인원수 조회시 학과 평균 점수가 3.5 이하인 학과만 조회
--HAVING문
SELECT 
	M.MAJOR_NAME AS "학과",
	COUNT(*) AS "평균 3.5이하"
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME 
HAVING AVG(STD_SCORE) <= 3.5; 
--HAVING : 그룹함수(GROUP BY)에서 조건식을 사용하기 위해 사용

--현재 학생 테이블에 있는 데이터를 기준으로 학과별, 인원수를 조회
--단 조회하는 인원수가 3명 이상인 학과만 조회
SELECT 
	M.MAJOR_NAME AS "3명이상 학과",
	COUNT(*) AS "인원수"
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME 
HAVING COUNT(*) >= 3;

DROP TABLE STUDENT;


/*
학번 2020~2024 0000 8자리
성별 추가됨
각 학년별로 100건씩
 */
CREATE TABLE STUDENT(
	STD_NO CHAR(8) PRIMARY KEY,
	STD_NAME VARCHAR2(30) NOT NULL,
	STD_MAJOR VARCHAR2(30),
	STD_SCORE NUMBER(3,2) DEFAULT 0 NOT NULL,
	STD_GENDER CHAR(1)
);

SELECT * FROM STUDENT;
--입학한 년도별, 학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "YEAR",
	M.MAJOR_NAME ,
	STD_GENDER ,
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG,
	SUM(STD_SCORE) AS STD_SUM
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY SUBSTR(STD_NO, 1, 4), M.MAJOR_NAME , STD_GENDER;

--입학한 년도별, 학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "YEAR",
	M.MAJOR_NAME,
	COUNT(*), 
	TRUNC(AVG(STD_SCORE), 2),
	SUM(STD_SCORE)
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY SUBSTR(STD_NO, 1, 4), M.MAJOR_NAME ;

--입학한 년도별, 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "YEAR",
	COUNT(*),
	TRUNC(AVG(STD_SCORE), 2),
	SUM(STD_SCORE) 
FROM STUDENT
GROUP BY SUBSTR(STD_NO, 1, 4) ;

--학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	M.MAJOR_NAME ,
	COUNT(*),
	TRUNC(AVG(STD_SCORE), 2),
	SUM(S.STD_SCORE) 
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME ;

--학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	M.MAJOR_NAME AS "학과",
	STD_GENDER AS "성별",
	COUNT(*) AS "각 인원수",
	TRUNC(AVG(STD_SCORE), 2) AS AVG_SCORE,
	SUM(STD_SCORE) AS SUM_SCORE
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY M.MAJOR_NAME , STD_GENDER
ORDER BY "학과" ASC;

--성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	STD_GENDER AS "성별",
	COUNT(*) AS "남여 비율",
	TRUNC(AVG(STD_SCORE), 2) AS "남여 평점 평균",
	SUM(STD_SCORE) AS "남여 평점 총합" 
FROM STUDENT
GROUP BY STD_GENDER ;

--전체 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	COUNT(*) AS "전체 인원수",
	TRUNC(AVG(STD_SCORE), 2) AS "전체 평점 평균",
	SUM(STD_SCORE) AS "전체 평점 총합"
FROM STUDENT;
------------------------------------------------------------------------------

--CUBE 함수 : 제공된 모든 컬럼의 모든 조합에 대한 집계 결과를 생성하는 함수
-- 예) CUBE(컬럼 A, 컬럼 B, ...)
-- 1. 전체 집계
-- 2. B에 대한 집계
-- 3. A에 대한 집계
-- 4. A,B에 대한 집계

--입학한 년도별, 학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "연도",
	M.MAJOR_NAME AS "학과",
	STD_GENDER AS "성별",
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG,
	SUM(STD_SCORE) AS STD_SUM
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY CUBE (SUBSTR(STD_NO, 1, 4), M.MAJOR_NAME , STD_GENDER);

--ROLLUP 함수 : 계층적인 데이터 집계를 생성, 상위 수준의 요약 정보를 점점 상세한 수준으로 내려가면서 데이터를 집계
-- 예) ROLLUP(컬럼A, 컬럼B, ...)
-- 1. A,B에 대한 집계
-- 2. A에 대한 집계 결과
-- 3. 전체 집계
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "연도",
	M.MAJOR_NAME AS "학과",
	STD_GENDER AS "성별",
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG,
	SUM(STD_SCORE) AS STD_SUM
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY ROLLUP (SUBSTR(STD_NO, 1, 4), M.MAJOR_NAME , STD_GENDER);


--입학년도, 학과별, 성씨를 기준으로 학생 인원수, 평점 평균을 출력
-- 단 입학년도는 학번 1~4자리, 평점의 평균 소수 둘째 자리에서 절삭

--CUBE
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "연도",
	S.MAJOR_NO AS "학과 번호",
	SUBSTR(STD_NAME, 1, 1) AS "성씨",
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY CUBE(SUBSTR(STD_NO, 1, 4), S.MAJOR_NO , SUBSTR(STD_NAME, 1, 1));

--ROLLUP
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "연도",
	S.MAJOR_NO AS "학과",
	SUBSTR(STD_NAME, 1, 1) AS "성씨",
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
GROUP BY ROLLUP(SUBSTR(STD_NO, 1, 4), S.MAJOR_NO , SUBSTR(STD_NAME, 1, 1));

---------------------------------------------------------------------------------------

-- GROUPING SETS : 그룹된 각각 컬럼의 값들로만 보여준다/ ROLLUP,CUBE도 들어가서 각 컬럼에 적용 할 수 있다.
-- 특정 항목에 대한 소계를 계산한느 함수
-- GROUPING SETS(A, B, ...)
-- 1. A그룹 집계
-- 2. B그룹 집계

-- GROUPING SETS(A, B, ..., ())
-- 1. A그룹 집계
-- 2. B그룹 집계
-- 3. ...
-- 4. 전체 집계

/*
GROUPING SETS(A, B, ..., CUBE(C, D)

*/

/*
GROUPING SETS(A, B, ..., ROLLUP(C, D)
	1. A그룹 집계
	2. B그룹 집계
	3. ...
	4. C그룹, D그룹 집계
	5. C그룹
	6. D그룹
	7. 전체 집계
*/

SELECT 
	SUBSTR(STD_NO, 1, 4) AS "연도",
	M.MAJOR_NAME AS "학과",
	SUBSTR(STD_NAME, 1, 1) AS "성씨",
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY GROUPING SETS (SUBSTR(STD_NO, 1, 4), M.MAJOR_NAME , SUBSTR(STD_NAME, 1, 1));


SELECT 
	SUBSTR(STD_NO, 1, 4) AS "연도",
	SUBSTR(S.STD_NAME,1,1) AS "성씨",
	STD_GENDER AS "성별",
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG
FROM STUDENT S
JOIN MAJOR M ON S.MAJOR_NO = M.MAJOR_NO
GROUP BY GROUPING SETS (SUBSTR(STD_NO, 1, 4), CUBE (SUBSTR(S.STD_NAME,1,1) , STD_GENDER));

--GROUPING SETS 전체데이터 추가 : () 또는 NULL 
SELECT 
	SUBSTR(STD_NO, 1, 4) AS "연도",
	COUNT(*) AS STD_COUNT,
	TRUNC(AVG(STD_SCORE), 2) AS STD_AVG
FROM STUDENT
GROUP BY GROUPING SETS (SUBSTR(STD_NO, 1, 4), ());
-----------------------------------------------------------------------------------------------------------

--사원테이블에서 부서별, 직급별, 인원수, 연봉 평균(소수점 절삭)
SELECT 
	EMP_DEPARTMENT AS "부서",
	EMP_POSITION AS "직급",
	COUNT(*) AS "인원수",
	TRUNC(AVG(EMP_SALARY)) AS "연봉 평균"
FROM EMPLOYEE
GROUP BY EMP_DEPARTMENT , EMP_POSITION;

--사원테이블에서 부서별, 인원수, 연봉 평균(소수점 절삭)
SELECT 
	EMP_DEPARTMENT AS "부서",
	COUNT(*) AS "인원수",
	TRUNC(AVG(EMP_SALARY)) AS "연봉 평균" 
FROM EMPLOYEE
GROUP BY EMP_DEPARTMENT

--ROLLUP
SELECT 
	EMP_DEPARTMENT AS "부서",
	EMP_POSITION AS "직급",
	COUNT(*) AS "인원수",
	TRUNC(AVG(EMP_SALARY)) AS "연봉 평균"
FROM EMPLOYEE
GROUP BY ROLLUP (EMP_DEPARTMENT , EMP_POSITION);
--
SELECT 
	EMP_DEPARTMENT AS "부서",
	COUNT(*) AS "인원수",
	TRUNC(AVG(EMP_SALARY)) AS "연봉 평균" 
FROM EMPLOYEE
GROUP BY ROLLUP (EMP_DEPARTMENT);

--CUBE
SELECT 
	EMP_DEPARTMENT AS "부서",
	EMP_POSITION AS "직급",
	COUNT(*) AS "인원수",
	TRUNC(AVG(EMP_SALARY)) AS "연봉 평균"
FROM EMPLOYEE
GROUP BY CUBE (EMP_DEPARTMENT , EMP_POSITION);
--
SELECT 
	EMP_DEPARTMENT AS "부서",
	COUNT(*) AS "인원수",
	TRUNC(AVG(EMP_SALARY)) AS "연봉 평균" 
FROM EMPLOYEE
GROUP BY CUBE (EMP_DEPARTMENT);

--GROUPING SETS
SELECT 
	EMP_DEPARTMENT AS "부서",
	EMP_POSITION AS "직급",
	COUNT(*) AS "인원수",
	TRUNC(AVG(EMP_SALARY)) AS "연봉 평균"
FROM EMPLOYEE
GROUP BY GROUPING SETS (EMP_DEPARTMENT , EMP_POSITION, ());


----------------------------------------------------------------------------------
--CAR 테이블
--제조사별, 연도별, 차량 개수, 차량 평균 금액
SELECT 
	CAR_MAKER AS "제조사",
	CAR_MAKE_YEAR AS "차량 연도",
	COUNT(*) AS "개수",
	TRUNC(AVG(CAR_PRICE)) AS "평균 금액" 
FROM CAR
GROUP BY CAR_MAKER , CAR_MAKE_YEAR
ORDER BY "평균 금액" DESC;

--ROLLUP
SELECT 
	CAR_MAKER AS "제조사",
	CAR_MAKE_YEAR AS "차량 연도",
	COUNT(*) AS "개수",
	TRUNC(AVG(CAR_PRICE)) AS "평균 금액" 
FROM CAR
GROUP BY ROLLUP (CAR_MAKER , CAR_MAKE_YEAR); 

--CUBE
SELECT 
	CAR_MAKER AS "제조사",
	CAR_MAKE_YEAR AS "차량 연도",
	COUNT(*) AS "개수",
	TRUNC(AVG(CAR_PRICE)) AS "평균 금액" 
FROM CAR
GROUP BY CUBE (CAR_MAKER , CAR_MAKE_YEAR);

