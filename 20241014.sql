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

-- 제조사 테이블 생성
CREATE TABLE MANUFACTURERS (
    MANUFACTURER_ID CHAR(10) PRIMARY KEY,   -- 제조사번호
    MANUFACTURER_NAME VARCHAR2(60)  -- 제조사명
);

SELECT * FROM MANUFACTURERS;
DROP TABLE MANUFACTURERS;


