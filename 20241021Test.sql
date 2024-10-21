--1. 다음은 음식점의 메뉴 테이블을 생성한 SQL문이다.
--메뉴명이 반드시 저장되야 되는데 메뉴명을 넣지 않아도 등록되는 문제가 발생했고, 알수 없는 CREATE문의 문제도 생겼다.
--
--문제에 대한 원인과 이를 해결하는 SQL문을 작성하시오.
CREATE VIEW FOOD_MENU( --테이블 생성 VIEW X -> TABLE
	MENU_NO CHAR(4) PRIMARY KEY, -- 메뉴번호
	MENU_NAME VARCHAR2(100), -- 메뉴명 반드시 저장 NOT NULL입력
	PRICE NUMBER(5), -- 금액
	IS_SOLD CHAR(1) -- 매진여부 ('Y' 또는 'N')
);
CREATE TABLE FOOD_MENU(
	MENU_NO CHAR(4) PRIMARY KEY,
	MENU_NAME VARCHAR2(100) NOT NULL,
	PRICE NUMBER(5),
	IS_SOLD CHAR(1)
);

DROP TABLE FOOD_MENU;



--2. 다음은 데이터 5건 추가되는 SQL문인데 오류가 생겼다.
--문제에 대한 원인과 이를 해결하는 SQL문을 작성하시오.
INSERT INTO FOOD_MENU VALUES ('0001', '치즈버거', 6000); -- 데이터값이 부족함
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES ('0002', '감자튀김', 'N'); -- 중간값이 없음
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES ('0003', '콜라', 'Y', 1500); -- 순서가 잘못됨
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES ('0004', '치킨버거', 6500, 'Y'); --정상
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES (0005, '사이다', 1500, 'Y'); -- MENU_NO : 데이터타입이 문자열인데 ''가 없음

INSERT INTO FOOD_MENU VALUES('0001', '치즈버거', 6000, 'Y');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES ('0002', '감자튀김', 3000,'N');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES ('0003', '콜라', 1500, 'Y');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES ('0004', '치킨버거', 6500, 'Y');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD) VALUES ('0005', '사이다', 1500, 'Y');


SELECT * FROM FOOD_MENU;

--3. 다음은 메뉴에 버거가 들어가는 메뉴를 조회 SQL문인데 조회가 되지 않는 문제가 발생했다.
--문제에 대한 원인과 이를 해결하는 SQL문을 작성하시오.
SELECT * FROM FOOD_MENU WHERE MENU_NAME LIKE '_버거'; -- _은 버거앞 문자 개수 1개만 조회 하기때문에 %를 사용
SELECT * FROM FOOD_MENU WHERE MENU_NAME LIKE '%버거'; 

--4. 다음은 현재 판매중인 메뉴 중 금액인 3000원 이상, 7000원 이하인 메뉴를 조회 할려고 하니 조회결과가 잘못되었다.
--문제에 대한 원인과 이를 해결하는 SQL문을 작성하시오.
SELECT * FROM FOOD_MENU
WHERE IS_SOLD = 'N' AND PRICE < 3000 AND PRICE > 7000; -- 관계 연산자가 잘못되었다 반대로 수정과 =포함 또는 BETWEEN 사용

SELECT * FROM FOOD_MENU
WHERE IS_SOLD = 'N' AND PRICE >= 3000 AND PRICE <= 7000;

SELECT * FROM FOOD_MENU
WHERE PRICE BETWEEN 3000 AND 7000 AND IS_SOLD = 'N';

SELECT * FROM (SELECT PRICE FROM FOOD_MENU WHERE PRICE BETWEEN 3000 AND 7000 AND IS_SOLD = 'N');


--5. 다음은 사이다와 콜라를 1000원씩 인상하는 SQL문인데 문제가 발생하였다.
--문제에 대한 원인과 이를 해결하는 SQL문을 작성하시오.
UPDATE FOOD_MENU SET PRICE = PRICE - 1000 WHERE MENU_NAME = ('사이다', '콜라'); -- 두 값을 추가 할땐 = 가 아니라 IN

UPDATE FOOD_MENU SET PRICE = PRICE + 1000 WHERE MENU_NAME IN ('사이다', '콜라');

SELECT * FROM FOOD_MENU;

--6. FOOD 테이블에 메뉴 등록한 시간을 저장할려고 하여 메뉴 등록 시간을 추가하는 SQL문을 작성해서 실행 했으나 에러가 발생했다.
--발생한 이유와 이를 해결하는 SQL문을 작성하시오. 메뉴 등록시 기본값으로 현재 날짜 시간이 등록되어야 한다.

ALTER TABLE FOOD_MENU MODIFY COLUMN REGISTER_MENU_TIME DEFAULT SYSDATE; -- 추가하는 ADD 와 데이터타입이 없음

ALTER TABLE FOOD_MENU ADD REGISTER_MENU_TIME DATE DEFAULT SYSDATE;

SELECT * FROM FOOD_MENU;

DROP TABLE FOOD_MENU;

--------------------------------------------------------------------------------------------------------------------------------------------

--지금부터 해야될 작업은 음식점과 메뉴를 등록하는 테이블을 만들고, 데이터를 삽입하고,
--조회하는 과정에서 문제가 생겼다, 아래 생긴 문제 및 오류들을 보고 무슨 문제가 생겼는지 원인을 파악하여 기재하고,
--
--해당하는 SQL문을 수정해서 제출하세요.

--
--1. 아래 SQL문으로 테이블을 생성하니까 음식점 테이블에 아이디 값이 기본키인데 중복으로 저장이 되는 오류와,
--음식 메뉴 테이블에도 메뉴 번호가 기본키인데 데이터가 중복이 되었다,
--그리고 메뉴 테이블에 음식점 아이디 컬럼이 음식점 테이블 음식점 아이디에 외래키로 지정하였는데, 아무런 값이 등록이 되는 문제가 생겼으며, 
--메뉴금액이 음수가 등록되는 문제가 생겼다.
--아래 SQL문을 참고하여 누락된 부분이나, 에러의 원인을 쓰고, 수정한 SQL문을 제출하세요

CREATE TABLE STORE(
	STORE_ID CHAR(4), --음식점 아이디 번호 기본키 PRIMARY KEY가 지정 안되어 있음
	STORE_NAME VARCHAR2(50),
	STORE_OWNER VARCHAR2(30),
	STORE_TEL CHAR(11),
	STORE_ADDRESS VARCHAR2(200)
);
CREATE TABLE FOOD_MENU (
	MENU_NO CHAR(4),--메뉴 번호 기본키 PRIMARY KEY가 지정 안되어 있음
	MENU_NAME VARCHAR2(100),
	PRICE NUMBER(5), -- 음수가 들어가지 않게 제약조건 CHECK 추가 또는 ALTER
	IS_SOLD CHAR(1),
	STORE_ID CHAR(4) --음식점 아이디 외래키로 STORE 지정 또는 ALTER 추가
);
-----------------------------------------------------------
CREATE TABLE STORE(
	STORE_ID CHAR(4) PRIMARY KEY, --음식점 아이디 번호
	STORE_NAME VARCHAR2(50),
	STORE_OWNER VARCHAR2(30),
	STORE_TEL CHAR(11),
	STORE_ADDRESS VARCHAR2(200)
);
CREATE TABLE FOOD_MENU (
	MENU_NO CHAR(4) PRIMARY KEY,--메뉴 번호
	MENU_NAME VARCHAR2(100),
	PRICE NUMBER(5),
	IS_SOLD CHAR(1),
	STORE_ID CHAR(4), --음식점 아이디
	
	CONSTRAINTS FOOD_MENU_STORE_ID_FK
	FOREIGN KEY(STORE_ID) REFERENCES STORE(STORE_ID),
	
	CONSTRAINTS FOOD_MENU_PRICE_CHK CHECK(PRICE > 0)
);
ALTER TABLE STORE ADD CONSTRAINT STORE_STORE_ID_PK
PRIMARY KEY(STORE_ID);
ALTER TABLE FOOD_MENU ADD CONSTRAINT FOOD_MENU_PRICE_CHK CHECK(PRICE > 0);
ALTER TABLE FOOD_MENU ADD CONSTRAINTS FOOD_MENU_STORE_ID_FK
FOREIGN KEY(STORE_ID) REFERENCES STORE(STORE_ID);

DROP TABLE STORE;
DROP TABLE FOOD_MENU;
-----------------------------------------------------------

--※1번 문제가 끝나면 아래 SQL문 실행 후 다음 작업 이어서 하세요

--추가할 데이터

INSERT INTO STORE (STORE_ID, STORE_NAME, STORE_OWNER, STORE_TEL, STORE_ADDRESS) VALUES
('0001', '맛있는 떡볶이 가게', '김철수', '01012345678', '서울시 강남구 역삼동 123-456');
INSERT INTO STORE (STORE_ID, STORE_NAME, STORE_OWNER, STORE_TEL, STORE_ADDRESS) VALUES
('0002', '행복한 김밥 가게', '이영희', '01023456789', '서울시 서초구 서초동 789-123');
INSERT INTO STORE (STORE_ID, STORE_NAME, STORE_OWNER, STORE_TEL, STORE_ADDRESS) VALUES
('0003', '새콤달콤 과일 가게', '박영자', '01034567890', '서울시 송파구 잠실동 456-789');
INSERT INTO STORE (STORE_ID, STORE_NAME, STORE_OWNER, STORE_TEL, STORE_ADDRESS) VALUES
('0004', '친절한 커피숍', '정민수', '01045678901', '서울시 강동구 천호동 987-654');
INSERT INTO STORE (STORE_ID, STORE_NAME, STORE_OWNER, STORE_TEL, STORE_ADDRESS) VALUES
('0005', '신선한 생선 가게', '홍길동', '01056789012', '서울시 마포구 망원동 321-654');

INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0001', '매운 떡볶이', 5000, 'Y', '0001');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0002', '치즈 떡볶이', 6000, 'Y', '0001');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0003', '맛있는 김밥', 3000, 'Y', '0002');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0004', '치즈 김밥', 3500, 'Y', '0002');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0005', '달달한 과일샐러드', 7000, 'Y', '0003');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0006', '상큼한 과일주스', 5000, 'Y', '0003');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0007', '아메리카노', 3500, 'Y', '0004');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0008', '카페라떼', 4000, 'Y', '0004');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0009', '생선구이', 8000, 'Y', '0003');
INSERT INTO FOOD_MENU (MENU_NO, MENU_NAME, PRICE, IS_SOLD, STORE_ID) VALUES
('0010', '회덮밥', 7000, 'Y', '0004');



--2. 메뉴 조회시 메뉴 번호, 메뉴명, 금액, 음식점 명이 나오게끔 처리했는데 메뉴명 컬럼에서 오류가 발생하였다.
--아래 SQL문을 참고하여 원인을 쓰고, 수정한 SQL문을 제출하세요
SELECT FM.MENU_NO, FM.MENU_NAME, FM.PRICE, S.STORE_NAME
FROM FOOD_MENU FM; -- 음식점 명은 조인이 없어 조회가 안됨

SELECT 
	FM.MENU_NO, FM.MENU_NAME, FM.PRICE, S.STORE_NAME
FROM STORE S JOIN FOOD_MENU FM ON S.STORE_ID = FM.STORE_ID;

SELECT * FROM STORE;

CREATE OR REPLACE VIEW FOOD_MENU_NAME_VIEW AS SELECT 
	FM.MENU_NO, FM.MENU_NAME, FM.PRICE, S.STORE_NAME
FROM STORE S JOIN FOOD_MENU FM ON S.STORE_ID = FM.STORE_ID;

SELECT * FROM FOOD_MENU_NAME_VIEW;

--3. 제일 비싼 메뉴 정보를 출력하는데, 조회할 컬럼은 메뉴 테이블에 있는 모든 컬럼인데 조건식에서 오류가 발생하였다.
--아래 SQL문을 참고하여 원인을 쓰고, 수정한 SQL문을 제출하세요
SELECT * FROM FOOD_MENU WHERE PRICE = MAX(PRICE) GROUP BY MENU_NO ; -- 그룹함수 사용 불가

SELECT 
	MAX(PRICE),
	
FROM FOOD_MENU
GROUP BY PRICE;

SELECT * FROM FOOD_MENU WHERE PRICE = (SELECT MAX(PRICE) FROM FOOD_MENU); -- 특정 값 조회를 할때 서브쿼리 사용

--4. 가계별로 메뉴개수, 메뉴의 평균 금액, 최대 메뉴 금액, 최저 메뉴 금액을 조회하는데, 오류가 발생하였다.
--조회할 컬럼명은 가계 아이디, 가계 명, 평균 금액, 최대 메뉴 금액, 최저 메뉴 금액이고, 모든 음식점 데이터가 출력되어야 한다.
--평균 값의 경우 소수점을 절삭 해야하며, 매칭되지않아 NULL 값인 나오는 경우 0으로 출력해야 한다.
--아래 SQL문을 참고하여 원인을 쓰고, 수정한 SQL문을 제출하세요

SELECT
	S.STORE_ID,
	S.STORE_NAME,
	COUNT(*) AS MENU_COUNT,
	TRUNC(AVG(FM.PRICE),0) AS AVG_PRICE,
	MAX(FM.PRICE) AS MAX_PRICE,
	MIN(FM.PRICE) AS MIN_PRICE
FROM STORE S INNER JOIN FOOD_MENU FM ON S.STORE_ID = FM.MENU_NO 
-- JOIN연결이 잘못됨 매칭되지 않는 데이터도 표현하기 위해 LEFT 또는 FULL사용
GROUP BY S.STORE_ID, FM.MENU_NO; -- GROUP BY표현식이 잘 못됨 


SELECT
	S.STORE_ID,
	S.STORE_NAME,
	COUNT(*) AS MENU_COUNT,
	TRUNC(AVG(FM.PRICE),0) AS AVG_PRICE,
	MAX(FM.PRICE) AS MAX_PRICE,
	MIN(FM.PRICE) AS MIN_PRICE
FROM STORE S FULL JOIN FOOD_MENU FM ON S.STORE_ID = FM.STORE_ID
GROUP BY S.STORE_ID,S.STORE_NAME;

SELECT * FROM STORE;

--5.메뉴를 하나도 등록을 하지 않은 가계들을 삭제하는 SQL문이다, 삭제가 되지 않는 문제가 생겼다.
--아래 SQL문을 참고하여 원인을 쓰고, 수정한 SQL문을 제출하세요
DELETE FROM STORE WHERE STORE_ID = (SELECT STORE_ID FROM FOOD_MENU FM WHERE MENU_NO IS NULL);

DELETE FROM STORE 
WHERE STORE_ID = (
	SELECT S.STORE_ID 
	FROM STORE S 
	LEFT JOIN FOOD_MENU FM ON S.STORE_ID = FM.STORE_ID 
	WHERE FM.STORE_ID IS NULL 
);

SELECT * FROM STORE S LEFT JOIN FOOD_MENU FM ON S.STORE_ID = FM.STORE_ID WHERE MENU_NO IS NULL;
SELECT * FROM STORE S LEFT JOIN FOOD_MENU FM ON S.STORE_ID = FM.STORE_ID;
