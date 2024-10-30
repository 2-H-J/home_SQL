--테스트 사용자 생성
--          C##사용자명               암호
CREATE USER C##TEST IDENTIFIED BY 123456;
-- 권한 부여
GRANT RESOURCE, CONNECT, CREATE VIEW TO C##TEST;
-- 저장소 사용량 부여
ALTER USER C##TEST DEFAULT TABLESPACE 
USERS QUOTA UNLIMITED ON USERS;

-- 뷰(조인, 서브쿼리), 시퀸스, 인덱스, 함수, 트리거


-- 1. BOOKS 테이블과 PUBLISHER 테이블을 조인하여 각 도서의 ISBN, 도서명, 저자, 
-- 출판사명, 가격을 조회하는 뷰 BOOKS_VIEW를 생성한다. 이때, 가격이 20,000원 이상인 도서만 포함되도록 하는데, 
-- 뷰생성 도중 에러가 발생했다 발생한 원인을 서술하고, 수정한 SQL문을 제출하세요

CREATE OR REPLACE VIEW BOOKS_VIEW AS -- CREATE OR REPLACE TABLE BOOKS_VIEW AS : TABLE가 아니라 VIEW
SELECT
B.ISBN,
B.BOOK_NAME,
B.AUTHOR,
P.PUBLISHER_NAME,
B.PRICE
FROM
BOOKS B
JOIN PUBLISHER P ON B.ISBN = P.PUBLISHER_CODE
WHERE
B.PRICE >= 20000;




-- 2. 향후 도서 판매 정보를 저장할 때 사용될 판매 번호를 자동으로 생성하기 위한 시퀀스 SEQ_SALE_NO를 생성하세요. 
-- 이 시퀀스는 1부터 시작하여 1씩 증가합니다.시퀸스의 최대값은 9999 입니다. 

-- 해당 시퀸스는 순환형태 인데, 만드는 도중 오류가 생겼습니다. 발생한 원인을 서술하고, 수정한 SQL문을 제출하세요

CREATE SEQUENCE SEQ_SALE_NO
START WITH 1
INCREMENT BY 1
MAXVALUE 9999 -- MINVALUE : 최대값 설정은 MAXVALUE
NOCACHE
CYCLE;



-- 3. BOOKS 테이블에서 BOOK_NAME 컬럼을 사용하여 도서 정보를 효율적으로 검색할 수 있도록 
-- IDX_BOOKS_NAME이라는 이름의 인덱스를 생성하는데 오류가 생겼습니다. 

-- 발생한 원인을 서술하고, 수정한 SQL문을 제출하세요

CREATE INDEX IDX_BOOKS_NAME ON BOOKS(BOOK_NAME); -- AUTHOR : BOOK_NAME컬럼을 지정해야 하는데 다른 컬럼이 들어가 있고
-- IDX_BOOKS_NAME 라는 인덱스가 이미 존재해서 DROP하거나 다른 인덱스 이름 IDX_BOOKS_NAME2으로 만들었다
DROP INDEX IDX_BOOKS_NAME;

CREATE INDEX IDX_BOOKS_NAME2 ON BOOKS(AUTHOR);



-- 4. 출판사 코드(PUBLISHER_CODE)를 입력받아 출판사 이름(PUBLISHER_NAME)을 반환하는 함수 FN_GET_PUBLISHER_NAME을 작성하세요. 

-- 만약 해당 코드의 출판사가 없을 경우 'Unknown Publisher'를 반환하도록 하는데 문제가 생겼다. 발생한 원인을 서술하고, 수정한 SQL문을 제출하세요.

CREATE OR REPLACE FUNCTION FN_GET_PUBLISHER_NAME(p_code CHAR)
RETURN VARCHAR2 IS
    v_name VARCHAR2(100); -- 데이터를 받아야하는 변수 v_name이 선언 되지 않아 선언했다.
BEGIN
SELECT PUBLISHER_NAME INTO v_name -- INTO로 v_name에 조회한 데이터를 입력받아야 한다
FROM PUBLISHER
WHERE PUBLISHER_CODE = p_code;
RETURN v_name;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN 'Unknown Publisher';
END;

SELECT FN_GET_PUBLISHER_NAME('7B2047') FROM DUAL;

DROP FUNCTION FN_GET_PUBLISHER_NAME;



-- 5. BOOKS 테이블에서 도서 정보가 삭제될 때마다 실행되는 트리거 TRG_BOOKS_DELETE_LOG를 작성하세요. 
-- 이 트리거는 이전에 만든 SQL_LOGS 테이블에 다음 정보를 저장하는데 문제가 생겼다. 발생한 원인을 서술하고, 수정한 SQL문을 제출하세요.

CREATE OR REPLACE TRIGGER TRG_BOOKS_DELETE_LOG
AFTER DELETE ON BOOKS -- INSERT로 되어 있는걸 삭제 트리거라면 DELETE로 변경
FOR EACH ROW
BEGIN
    INSERT INTO SQL_LOGS (EXECUTED_COMMAND,TABLE_NAME,CHANGED_CONTENT)
     VALUES ('DELETE','BOOKS','ISBN: ' || :OLD.ISBN ||', BOOK_NAME: ' || :OLD.BOOK_NAME || ', AUTHOR: ' || :OLD.AUTHOR ||', PUBLISHER_CODE: ' || :OLD.PUBLISHER_CODE );
END; -- END트리거 종료 부분이 없어서 추가

