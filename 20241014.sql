
-- 24.10.14실습
-- 제조사 테이블 생성
--CREATE TABLE Manufacturers (
--    manufacturer_id NUMBER PRIMARY KEY,  -- 제조사번호
--    manufacturer_name VARCHAR2(100)      -- 제조사명
--);

-- 제품 테이블 생성
--CREATE TABLE Products (
--    product_id NUMBER PRIMARY KEY,       -- 제품번호
--    product_name VARCHAR2(100),          -- 제품명
--    manufacturer_id NUMBER,              -- 제조사번호 (외래키)
--    price NUMBER,                        -- 금액
--    CONSTRAINT fk_manufacturer
--        FOREIGN KEY (manufacturer_id) 
--        REFERENCES Manufacturers(manufacturer_id)
--);
-- 제조사 테이블 생성
CREATE TABLE MANUFACTURERS (
    MANUFACTURER_ID CHAR(10) PRIMARY KEY,   -- 제조사번호
    MANUFACTURER_NAME VARCHAR2(60)  -- 제조사명
);

SELECT * FROM MANUFACTURERS;
DROP TABLE MANUFACTURERS;

-- 제품 테이블 생성
CREATE TABLE PRODUCTS (
    PRODUCT_ID CHAR(10) PRIMARY KEY,        -- 제품번호
    PRODUCT_NAME VARCHAR2(120),  -- 제품명
    MANUFACTURER_ID CHAR(10),   -- 제조사번호
    PRICE NUMBER,             -- 금액
    FOREIGN KEY (MANUFACTURER_ID) REFERENCES MANUFACTURERS(MANUFACTURER_ID)
);
SELECT * FROM PRODUCTS;
DROP TABLE PRODUCTS;

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
SELECT ROW_NUMBER() OVER(ORDER BY PAGE) AS RW, P.* FROM PERSON P;
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
