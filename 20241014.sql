
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

SELECT
	INSTR(P.PRODUCT_NAME,'갤럭시') AS "INSTR갤럭시", 
	M.*, P.*
FROM MANUFACTURERS M, PRODUCTS P;

/*
1. 문제 1: 제조사별 제품 목록을 가격순으로 조회
각 제조사별로 제품명과 가격을 가격순으로 정렬하여 조회하세요.
가격이 50만 원 이상인 제품만 조회합니다. 
출력할 컬럼: 제조사명, 제품명, 가격
*/
SELECT 
    RANK() OVER(PARTITION BY M.MANUFACTURER_NAME 
    ORDER BY P.PRICE DESC) AS "분류",
    M.MANUFACTURER_NAME AS "제조사",
    P.PRODUCT_NAME AS "제품",
    P.PRICE AS "가격"
FROM MANUFACTURERS M
JOIN PRODUCTS P ON M.MANUFACTURER_ID = P.MANUFACTURER_ID
WHERE P.PRICE >= 500000
ORDER BY M.MANUFACTURER_NAME, P.PRICE DESC;

-- GPT
SELECT 
    M.MANUFACTURER_NAME AS "제조사", 
    P.PRODUCT_NAME AS "제품", 
    P.PRICE AS "가격"
FROM MANUFACTURERS M
JOIN PRODUCTS P ON M.MANUFACTURER_ID = P.MANUFACTURER_ID
WHERE P.PRICE >= 500000
ORDER BY P.PRICE DESC;


/*
2. 문제 2: 제품 가격에 따른 순위 부여
제품 가격을 기준으로 순위를 매기고, 해당 제품의 순위와 함께 출력하세요.
출력할 컬럼: 제품명, 가격, 순위
힌트:
윈도우 함수인 RANK() 또는 ROW_NUMBER()를 활용하여 순위를 부여하세요. 
*/
-- GPT도 동일
SELECT
	P.PRODUCT_NAME,
	P.PRICE,
	ROW_NUMBER() OVER(ORDER BY P.PRICE DESC) AS "순위"
FROM PRODUCTS P;

/*
3. 문제 3: 제품명에 특정 문자열이 포함된 제품 조회
제품명에 '갤럭시'라는 단어가 포함된 제품을 조회하세요.
출력할 컬럼: 제품명, 가격, 제조사명 
 */

SELECT * FROM MANUFACTURERS m ;
SELECT P.PRODUCT_NAME,
	P.PRICE,
	M.MANUFACTURER_NAME FROM PRODUCTS p
INNER JOIN  MANUFACTURERS m
on p.MANUFACTURER_ID =m.MANUFACTURER_ID
WHERE p.PRODUCT_NAME LIKE '%갤럭시%';

SELECT * FROM USER_TABLES;



SELECT
	P.PRODUCT_NAME,
	P.PRICE,
	M.MANUFACTURER_NAME
FROM PRODUCTS P
JOIN MANUFACTURERS M ON P.MANUFACTURER_ID = M.MANUFACTURER_ID
WHERE INSTR(P.PRODUCT_NAME, '갤럭시') > 0;

-- 학생 테이블에서 성씨별로 점수 순위를 내림 차순 기준으로 조회하시오
-- 출력 형태는 아래와 같이 조회하세요 순위는 건너뛰지 않습니다.
-- 순위 학번 성씨 학과명 평점

SELECT std_name,count(*) FROM STUDENT s
GROUP BY std_name
ORDER BY std_name DESC ;

