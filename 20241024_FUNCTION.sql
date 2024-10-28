--PL / SQL
--	데이터베이스에서 사용되는 절차적 언어
-- 프로시저, 함수, 트리거 등의 형태로 작성을 할 수 있음
-- 데이터 조직 및 비지니스 로직을 데이터베이스 내에서 직접 처리할 수 있음
----------------------------------------------------------------------------
--함수
/*
CREATE OR REPLACE FUNCTION GET_ODD_EVEN(
	N IN NUMBER -- 외부에서 숫자(N)를 받아오는 매개변수
)
RETURN VARCHAR2 -- 반환값이 문자열 타입(VARCHAR2)임을 명시
IS --사용할 변수 선언 영역
	MSG VARCHAR2(100); -- 문자열 변수를 선언, 최대 100글자까지 저장 가능
	
BEGIN --실행 영역
	-- 조건문을 통해 숫자의 홀짝 여부를 확인
	IF N = 0 THEN 
		MSG := '0입니다.'; -- N이 0이면 '0입니다.'라는 문자열을 저장
		
	ELSIF MOD(N, 2) = 0 THEN -- N을 2로 나눈 나머지가 0이면 짝수
		MSG := '짝수입니다.'; -- 짝수일 때 '짝수입니다.'라는 문자열을 저장
	
	ELSE -- 위 조건이 모두 아니면 홀수로 판단
		MSG := '홀수입니다.'; -- 홀수일 때 '홀수입니다.'라는 문자열을 저장
	
	END IF; -- IF 조건문 종료
	
	RETURN MSG; -- 함수 실행 결과를 MSG로 담아 외부로 반환
	
END;--함수의 끝 부분
*/

CREATE OR REPLACE FUNCTION GET_ODD_EVEN(
	N IN NUMBER --외부에서 정수 값을 받아온다(IN)
)
RETURN VARCHAR2 --결과값을 문자로
IS --사용할 변수 선언
	MSG VARCHAR2(100); --문자열 변수 선언
	
BEGIN --실행 영역
	IF N = 0 THEN 
		MSG := '0입니다.'; -- := 저장할 값
		
	ELSIF MOD(N, 2) = 0 THEN -- 조건식이 끝날때 마다 THEN으로 마감
		MSG := '짝수입니다.';
	--MOD() : 나머지값 구하는 함수
	
	ELSE -- 조건식이 없으면 ELSE
		MSG := '홀수입니다.';
	
	END IF; -- IF문의 끝
	
	RETURN MSG; --외부로 전송
	
END;--함수 종료부분

SELECT 
	GET_ODD_EVEN(0),
	GET_ODD_EVEN(20),
	GET_ODD_EVEN(-10),
	GET_ODD_EVEN(33)
FROM DUAL;


---------------------------------------------------------------------------
--성적 등급 함수
CREATE OR REPLACE FUNCTION GET_SCORE_GRADE(SCORE IN NUMBER)
RETURN VARCHAR2
IS 
    MSG VARCHAR2(100);
    USER_EXCEPTION EXCEPTION;  -- 사용자 정의 예외 선언
    ZERO_EXCEPTION EXCEPTION; 
    
BEGIN 
    -- 점수가 음수일 경우 예외 발생
    IF SCORE < 0 THEN
        RAISE ZERO_EXCEPTION; -- 0미만 EXCEPTION
    ELSIF SCORE > 100 THEN
    	RAISE USER_EXCEPTION; -- 100이상 EXCEPTION
    END IF;
   
    
    -- 점수에 따른 등급 처리
    IF SCORE >= 90 THEN
        MSG := '점수는 A등급 입니다.';
    ELSIF SCORE >= 80 THEN
        MSG := '점수는 B등급 입니다.';
    ELSIF SCORE >= 70 THEN
        MSG := '점수는 C등급 입니다.';
    ELSIF SCORE >= 60 THEN
        MSG := '점수는 D등급 입니다.';
    ELSE
        MSG := '점수는 F등급 입니다.';
    END IF;
    
    RETURN MSG;  -- 정상 처리 시 메시지를 반환
    
EXCEPTION
    -- 사용자 정의 예외 처리
    WHEN ZERO_EXCEPTION THEN
        RETURN '점수는 0이상 입력해야 합니다.';
       
    WHEN USER_EXCEPTION THEN
    	RETURN '점수는 100이 최대 입니다.';
    	
    -- 기타 예외 처리
    WHEN OTHERS THEN
        RETURN '알 수 없는 에러 발생';
END;


SELECT
	GET_SCORE_GRADE(45) AS GRADE_1, 
	GET_SCORE_GRADE(65) AS GRADE_2,
	GET_SCORE_GRADE(75) AS GRADE_3,
	GET_SCORE_GRADE(85) AS GRADE_4,
	GET_SCORE_GRADE(95) AS GRADE_5,
	GET_SCORE_GRADE(-95) AS GRADE_6,
	GET_SCORE_GRADE(101) AS GRADE_7
FROM DUAL;

DROP FUNCTION GET_SCORE_GRADE;
------------------------------------------------------------------------
--학과 번호를 받아서 학과명을 리턴하는 함수

CREATE OR REPLACE FUNCTION GET_MAJOR_NAME(V_MAJOR_NO IN VARCHAR2)
RETURN VARCHAR2

IS 
	MSG VARCHAR2(30);

BEGIN
	
	SELECT 
		M.MAJOR_NAME INTO MSG --INTO : 조회된 값 MSG에 넣어주기
	FROM 
		MAJOR M 
	WHERE 
		M.MAJOR_NO = V_MAJOR_NO;

	RETURN MSG;

EXCEPTION
	WHEN NO_DATA_FOUND THEN --NULL값 예외처리
		RETURN '해당 학과가 없습니다.';
	WHEN OTHERS THEN -- OTHERS : 기타 예외 처리
        RETURN '알수없음';
END;

SELECT 
	GET_MAJOR_NAME('99') AS MAJOR_NAME_1,
	GET_MAJOR_NAME('01') AS MAJOR_NAME_2,
	GET_MAJOR_NAME('04') AS MAJOR_NAME_3,
	GET_MAJOR_NAME('06') AS MAJOR_NAME_4
FROM DUAL;

DROP FUNCTION GET_MAJOR_NAME;

-------------------------------------------------------------------------------------
--반복문 함수
CREATE OR REPLACE FUNCTION GET_TOTAL(N1 IN NUMBER, N2 IN NUMBER)
RETURN NUMBER
IS
    TOTAL NUMBER;  -- 합계를 저장할 변수
    I NUMBER;  -- 반복을 위한 변수
BEGIN
    TOTAL := 0;  -- 합계를 0으로 초기화
    I := N1;  -- I에 N1 값을 할당하여 시작 값 설정

	-- 반복문 시작 DO_WHILE 형태
--    LOOP
--        TOTAL := TOTAL + I;  -- I의 값을 TOTAL에 더함
--        I := I + 1;  -- I 값을 1 증가시킴
--
--        EXIT WHEN I > N2;  -- I가 N2보다 커지면 반복문 종료
--    END LOOP;-- 반복문 종료
    
    -- WHILE 반복문
--    WHILE (I <= N2) -- WHILE 반복문을 사용하여 I가 N2보다 작거나 같은 동안 I의 값을 계속 더하기
--    LOOP
--        TOTAL := TOTAL + I;  -- I의 값을 TOTAL에 더함
--        I := I + 1;  -- I 값을 1 증가시킴
--    END LOOP;  -- 반복문 종료
    
   -- FOR 반복문
   FOR I IN N1 .. N2  -- N1부터 N2까지 순회
   LOOP
	   TOTAL := TOTAL + I;  -- I의 값을 TOTAL에 더함
   END LOOP;
   
    RETURN TOTAL;  -- 결과 반환
END;



SELECT GET_TOTAL(1, 100) FROM DUAL;


DROP FUNCTION GET_TOTAL;

---------------------------------------------------------------------------------------------
-- 트리거
-- 데이터베이스에서 발생하는 이벤트에 대한 반응으로 자동으로 실행되는 절차적 SQL
-- INSERT, UPDATE, DELETE -등의 이벤트에 대한 반응으로 실행
-- 테이블에 대한 이벤트가 발생하면 자동으로 실행되는 PL/SQL 블록
-- 트리거는 테이블에 종속적이기 때문에 테이블 생성 후 트리거 생성
---------------------------------------------------------------------------------------------
CREATE TABLE DATA_LOG(
    LOG_DATE DATE DEFAULT SYSDATE,    -- 로그 날짜 (디폴트 값으로 현재 날짜)
    LOG_DETAIL VARCHAR2(1000)         -- 로그 세부 정보 (최대 1000자의 텍스트)
);
---------------------------------------------------------------------------------------------

-- MAJOR 테이블에 내용이 UPDATE되면 해당 기록을 저장하는 트리거
CREATE OR REPLACE TRIGGER UPDATE_MAJOR_LOG
AFTER 
	UPDATE ON MAJOR       -- MAJOR 테이블에서 UPDATE 작업이 완료된 후 실행
FOR EACH ROW                -- 각 행마다 트리거가 실행됨
BEGIN
    -- DATA_LOG 테이블에 변경된 학과 정보 기록
    -- 이전 학과 번호(:OLD.MAJOR_NO)와 변경 후 학과 번호(:NEW.MAJOR_NO)
    -- 그리고 이전 학과 이름(:OLD.MAJOR_NAME)과 변경 후 학과 이름(:NEW.MAJOR_NAME)을 기록
    INSERT INTO DATA_LOG(LOG_DETAIL)
    VALUES(:OLD.MAJOR_NO || '-' || :NEW.MAJOR_NO
    || ',' || :OLD.MAJOR_NAME || '-' || :NEW.MAJOR_NAME);
END;


SELECT * FROM MAJOR;

ALTER TABLE MAJOR ADD CONSTRAINT PK_MAJOR_NO PRIMARY KEY (MAJOR_NO); -- MAJOR_NO 기본키

UPDATE MAJOR SET MAJOR_NAME = '디지털문화콘텐츠학과'
WHERE MAJOR_NO = 'C9';
DROP TRIGGER UPDATE_MAJOR_LOG;
---------------------------------------------------------------------------------------------

-- 트리거 생성 또는 기존 트리거 대체
CREATE OR REPLACE TRIGGER INSERT_MAJOR_TRIGGER
-- INSERT 작업 후 트리거가 실행됨
AFTER 
    INSERT ON MAJOR  -- MAJOR 테이블에서 INSERT 작업이 일어날 때
-- 각 행마다 트리거가 실행됨
FOR EACH ROW
-- 트리거 본문 시작
BEGIN
    -- DATA_LOG 테이블에 로그 삽입
    -- 새로운 학과 번호(MAJOR_NO)와 학과 이름(MAJOR_NAME)을 결합해 LOG_DETAIL에 기록
    INSERT INTO DATA_LOG(LOG_DETAIL)
    VALUES(:NEW.MAJOR_NO || '-' || :NEW.MAJOR_NAME);  -- :NEW는 새로 삽입된 데이터를 의미함
END;  -- 트리거 끝

-- MAJOR 테이블에 새 학과를 삽입하는 SQL문
-- 새로운 학과 번호 'C9'와 학과 이름 '게임학과'를 삽입
-- 이 INSERT 문이 실행되면, 트리거가 작동하여 DATA_LOG 테이블에 로그가 기록됨
INSERT INTO MAJOR VALUES('C9','게임학과');
DELETE MAJOR WHERE MAJOR_NO = 'C9';

-- DATA_LOG 테이블에 삽입된 로그 데이터를 조회하는 SELECT 문
-- 트리거 실행 후 기록된 로그를 확인하기 위해 사용
SELECT * FROM DATA_LOG;
DROP TRIGGER UPDATE_MAJOR_TRIGGER;

---------------------------------------------------------------------------------------------
--학과 정보 삭제시 발동되는 트리거
--MAJOR 테이블에 내용이 DELETE되면 해당 기록을 저장하는 트리거
CREATE OR REPLACE TRIGGER DELETE_MAJOR_LOG
AFTER 
	DELETE ON MAJOR
FOR EACH ROW
BEGIN

    INSERT INTO DATA_LOG(LOG_DETAIL)
    VALUES(:OLD.MAJOR_NO || '-' || :OLD.MAJOR_NAME); 
END;  -- 트리거 끝

SELECT * FROM MAJOR;

DELETE FROM MAJOR WHERE MAJOR_NO = 'C9';
SELECT * FROM DATA_LOG;
DROP TRIGGER DELETE_MAJOR_LOG;
---------------------------------------------------------------------------------------------
--트리거 INSERT, UPDATE, DELETE 합치기
---------------------------------------------------------------------------------------------
-- MAJOR 테이블에 대해 INSERT, UPDATE, DELETE 작업이 발생할 때마다 실행되는 트리거
CREATE OR REPLACE TRIGGER MAJOR_TRIGGER
AFTER
    -- INSERT, UPDATE, DELETE 작업 후에 트리거가 실행됨
    INSERT OR UPDATE OR DELETE ON MAJOR
FOR EACH ROW  -- 각 행마다 트리거가 실행됨 (한 번에 여러 행이 수정되면 각 행마다 실행됨)
BEGIN
    -- INSERT 작업이 발생했을 때 실행되는 부분
    IF INSERTING THEN
        -- 새로운 학과 번호와 학과 이름을 'INSERT'로 기록
        INSERT INTO DATA_LOG(LOG_DETAIL)
        VALUES('INSERT : ' || :NEW.MAJOR_NO || '-' || :NEW.MAJOR_NAME);

    -- UPDATE 작업이 발생했을 때 실행되는 부분
    ELSIF UPDATING THEN
        -- 업데이트된 행의 이전 학과 번호와 새로운 학과 번호, 그리고 이전 학과 이름과 새로운 학과 이름을 기록
        INSERT INTO DATA_LOG(LOG_DETAIL)
        VALUES('UPDATE : ' || :OLD.MAJOR_NO || '-' || :NEW.MAJOR_NO
        || ',' || :OLD.MAJOR_NAME || '-' || :NEW.MAJOR_NAME);

    -- DELETE 작업이 발생했을 때 실행되는 부분
    ELSIF DELETING THEN
        -- 삭제된 학과 번호와 학과 이름을 'DELETE'로 기록
        INSERT INTO DATA_LOG(LOG_DETAIL)
        VALUES('DELETE : ' || :OLD.MAJOR_NO || '-' || :OLD.MAJOR_NAME);
    END IF;

END;  -- 트리거 끝

-- MAJOR 테이블에 학과 번호 'C9'와 학과 이름 '게임학과'를 삽입
INSERT INTO MAJOR VALUES('C9', '게임학과');

-- MAJOR 테이블에서 학과 번호 'C9'의 학과 이름을 '디지털문화콘텐츠학과'로 수정
UPDATE MAJOR SET MAJOR_NAME = '디지털문화콘텐츠학과'
WHERE MAJOR_NO = 'C9';

-- MAJOR 테이블에서 학과 번호 'C9'인 데이터를 삭제
DELETE FROM MAJOR WHERE MAJOR_NO = 'C9';

-- DATA_LOG 테이블의 모든 데이터를 조회하여 로그 확인
SELECT * FROM DATA_LOG;
SELECT * FROM MAJOR;



-- 현재 세션에서 접속한 사용자의 정보를 조회하는 SQL 구문
SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') FROM DUAL;
---------------------------------------------------------------------------------------------------
--사용자 생성
-- CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
-- 권한 부여 : GRANT RESOURCE, CONNECT TO 사용자명;
-- ALTER USER 사용자명 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

-- "가져올계정"의 INSERT, UPDATE, DELETE, SELECT 권한을 "사용할계정"에 주는법 DROP같은 다른 권한은X
-- 다른 권한을 추가 할 수있다.
-- GRANT INSERT, UPDATE, DELETE, SELECT ON C##SCOTT.MAJOR TO C##USER; 
CREATE USER C##USER IDENTIFIED BY 123456;

GRANT RESOURCE, CONNECT TO C##USER;

ALTER USER C##USER DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

-- C##SCOTT의 MAJOR 테이블만 INSERT, UPDATE, DELETE, SELECT 권한을 C##USER 에 주는법 DROP같은 다른 권한은X
GRANT INSERT, UPDATE, DELETE, SELECT ON C##SCOTT.MAJOR TO C##USER;


-- MAJOR 테이블에 대해 INSERT, UPDATE, DELETE 작업이 발생할 때마다 실행되는 트리거
CREATE OR REPLACE TRIGGER MAJOR_TRIGGER
AFTER
    -- INSERT, UPDATE, DELETE 작업 후에 트리거가 실행됨
    INSERT OR UPDATE OR DELETE ON MAJOR
FOR EACH ROW  -- 각 행마다 트리거가 실행됨 (한 번에 여러 행이 수정되면 각 행마다 실행됨)
BEGIN
    -- INSERT 작업이 발생했을 때 실행되는 부분
    IF INSERTING THEN
        -- 새로운 학과 번호와 학과 이름을 'INSERT'로 기록
        INSERT INTO DATA_LOG(LOG_DETAIL)
        VALUES('INSERT : ' || :NEW.MAJOR_NO || '-' || :NEW.MAJOR_NAME || 
		'/ 계정명 : ' || SYS_CONTEXT('USERENV', 'SESSION_USER'));

    -- UPDATE 작업이 발생했을 때 실행되는 부분
    ELSIF UPDATING THEN
        -- 업데이트된 행의 이전 학과 번호와 새로운 학과 번호, 그리고 이전 학과 이름과 새로운 학과 이름을 기록
        INSERT INTO DATA_LOG(LOG_DETAIL)
        VALUES('UPDATE : ' || :OLD.MAJOR_NO || '-' || :NEW.MAJOR_NO
        || ',' || :OLD.MAJOR_NAME || '-' || :NEW.MAJOR_NAME || 
		'/ 계정명 : ' || SYS_CONTEXT('USERENV', 'SESSION_USER'));

    -- DELETE 작업이 발생했을 때 실행되는 부분
    ELSIF DELETING THEN
        -- 삭제된 학과 번호와 학과 이름을 'DELETE'로 기록
        INSERT INTO DATA_LOG(LOG_DETAIL)
        VALUES('DELETE : ' || :OLD.MAJOR_NO || '-' || :OLD.MAJOR_NAME || 
		'/ 계정명 : ' || SYS_CONTEXT('USERENV', 'SESSION_USER'));
    END IF;

END;  -- 트리거 끝

DROP TRIGGER MAJOR_TRIGGER;

SELECT * FROM C##SCOTT.MAJOR;

-- MAJOR 테이블에 학과 번호 'C9'와 학과 이름 '게임학과'를 삽입
INSERT INTO C##SCOTT.MAJOR VALUES('C9', '게임학과');

-- MAJOR 테이블에서 학과 번호 'C9'의 학과 이름을 '디지털문화콘텐츠학과'로 수정
UPDATE C##SCOTT.MAJOR SET MAJOR_NAME = '디지털문화콘텐츠학과'
WHERE MAJOR_NO = 'C9';

-- MAJOR 테이블에서 학과 번호 'C9'인 데이터를 삭제
DELETE FROM C##SCOTT.MAJOR WHERE MAJOR_NO = 'C9';

-- DATA_LOG 테이블의 모든 데이터를 조회하여 로그 확인
SELECT * FROM DATA_LOG;
---------------------------------------------------------------------------------------------------
/*
	LOG_ID 자동으로 줄 번호
	ACTION 어떤 걸했는지
	USER 누가
	BOARD 어떤 테이블(게시물)
	POST_(추가된,추가된내용)
	BEFORE_(사라진,사라진내용)
	TIMESTAMP 자동 시스템
*/
--로그를 저장할 테이블
-- 로그를 저장할 테이블 생성
CREATE TABLE BOARD_LOG (
    -- LOG_ID는 자동으로 증가하는 고유한 로그 ID (기본 키로 설정)
    LOG_ID          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- ACTION_TYPE은 수행된 작업의 종류 (INSERT, UPDATE, DELETE 등) 저장
    ACTION_TYPE     VARCHAR2(10),
    -- USER_ID는 작업을 수행한 사용자의 ID를 저장
    USER_ID         VARCHAR2(50),
    -- BOARD_NO는 어떤 게시물에 대한 작업인지를 나타내는 게시물 번호
    BOARD_NO        NUMBER,
    -- POST_TITLE는 새롭게 추가되거나 수정된 게시물의 제목을 저장 (DELETE에는 NULL)
    POST_TITLE      VARCHAR2(150),
    -- POST_CONTENT는 새롭게 추가되거나 수정된 게시물의 내용을 저장 (DELETE에는 NULL)
    POST_CONTENT    VARCHAR2(3000),
    -- BEFORE_TITLE은 업데이트 또는 삭제 전 게시물의 제목을 저장 (INSERT에는 NULL)
    BEFORE_TITLE    VARCHAR2(150),
    -- BEFORE_CONTENT는 업데이트 또는 삭제 전 게시물의 내용을 저장 (INSERT에는 NULL)
    BEFORE_CONTENT  VARCHAR2(3000),
    -- ACTION_TIMESTAMP는 작업이 발생한 시간, 디폴트 값으로 현재 시스템 시간을 저장
    ACTION_TIMESTAMP TIMESTAMP DEFAULT SYSTIMESTAMP
);


-------------------------------------------------------------------------------------------------
-- 게시판(BOARD) 테이블에서 작업(INSERT, UPDATE, DELETE)이 발생할 때
-- 로그를 기록하는 트리거 생성
CREATE OR REPLACE TRIGGER TRG_BOARD_ACTIONS
AFTER
    INSERT OR UPDATE OR DELETE ON BOARD   -- INSERT, UPDATE, DELETE 작업 발생 후 실행
FOR EACH ROW   -- 각 행마다 트리거 실행 (한 번에 여러 행이 수정되면 각 행에 대해 실행)
DECLARE
    -- 사용자 ID를 저장할 변수 선언
    V_USER_ID VARCHAR2(50);
BEGIN
    -- 현재 세션의 사용자 ID를 가져와 V_USER_ID에 저장
    SELECT SYS_CONTEXT('USERENV','SESSION_USER') INTO V_USER_ID 
    FROM DUAL;

    -- INSERT 작업이 발생했을 때
    IF INSERTING THEN
        -- 새로 추가된 게시물의 정보를 로그 테이블에 삽입
        INSERT INTO 
            BOARD_LOG(
                ACTION_TYPE, USER_ID, BOARD_NO, POST_TITLE, POST_CONTENT)
        -- 작업 유형(ACTION_TYPE)을 'INSERT'로 기록
        -- V_USER_ID는 현재 사용자, NEW는 삽입된 새 데이터
        VALUES('INSERT', V_USER_ID, :NEW.BNO, :NEW.TITLE, :NEW.CONTENT);

    -- UPDATE 작업이 발생했을 때
    ELSIF UPDATING THEN
        -- 업데이트된 게시물의 새로운 내용과 기존 내용을 로그 테이블에 삽입
        INSERT INTO 
            BOARD_LOG(
                ACTION_TYPE, USER_ID, BOARD_NO, POST_TITLE, POST_CONTENT, 
                BEFORE_TITLE, BEFORE_CONTENT)
        -- 작업 유형(ACTION_TYPE)을 'UPDATE'로 기록
        -- :NEW는 업데이트 후의 데이터, :OLD는 업데이트 전의 데이터
        VALUES('UPDATE', V_USER_ID, :NEW.BNO, :NEW.TITLE, :NEW.CONTENT, :OLD.TITLE, :OLD.CONTENT);
		/*
		UPDATING: UPDATE 작업이 발생했을 때 실행됩니다.
		:NEW.BNO, :NEW.TITLE, :NEW.CONTENT: 새로운 데이터 (수정된 데이터)입니다. 
		즉, 업데이트된 후의 값을 의미합니다.
		:OLD.TITLE, :OLD.CONTENT: 업데이트 이전의 데이터, 
		즉 수정되기 전의 값입니다. 이 값들은 기존 게시물의 제목과 내용을 기록합니다.
		*/
    -- DELETE 작업이 발생했을 때
    ELSIF DELETING THEN
        -- 삭제된 게시물의 기존 내용을 로그 테이블에 삽입
        INSERT INTO 
            BOARD_LOG(
                ACTION_TYPE, USER_ID, BOARD_NO, BEFORE_TITLE, BEFORE_CONTENT)
        -- 작업 유형(ACTION_TYPE)을 'DELETE'로 기록
        -- :OLD는 삭제된 데이터
        VALUES('DELETE', V_USER_ID, :OLD.BNO, :OLD.TITLE, :OLD.CONTENT);
		-- :OLD.BNO, :OLD.TITLE, :OLD.CONTENT: 삭제되기 전의 데이터를 의미합니다. 
		-- DELETE 작업에서는 삭제된 행의 값을 기록해야 하므로 이전 값인 :OLD를 사용합니다

    END IF;
END;

DROP TRIGGER TRG_BOARD_ACTIONS; 

-- BOARD 테이블에 새 게시물 삽입
INSERT INTO BOARD(BNO,TITLE, CONTENT, ID) 
VALUES(999999,'제목1','내용1','gouzr6264');

-- BOARD 테이블에서 BNO가 999999인 게시물의 제목과 내용을 업데이트
UPDATE BOARD SET TITLE = '제목2', CONTENT = '내용2' WHERE BNO = 999999;

-- BOARD 테이블에서 BNO가 999999인 게시물 삭제
DELETE FROM BOARD WHERE BNO = 999999;

-- 로그 테이블에서 모든 로그 조회
SELECT * FROM BOARD_LOG;
