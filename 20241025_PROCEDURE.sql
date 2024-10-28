-- 프로시저
-- 	  SQL 쿼리문으로 로직을 조합해서 사용하는 데이터베이스 코드
--	  SQL문과 제어문을 이용해서, 데이터를 검색, 삽입, 수정, 삭제를 할수 있음
--	  결과를 외부로 전달할 수도 있음.
--    하나의 트랜잭션 구성시 사용을 함.
-----------------------------------------------------------------------
--	매개변수가 없는 프로시저
CREATE OR REPLACE PROCEDURE PROCEDURE_EX1
IS
	--변수 선언
	TEST_VAR VARCHAR2(100);
BEGIN
	--실행부
	TEST_VAR := 'HELLO WORLD';
	DBMS_OUTPUT.PUT_LINE(TEST_VAR);	
END;

SET SERVEROUTPUT ON;
SET SERVEROUTPUT OFF;

--프로시저 실행되는 부분
BEGIN
	--실행부
	PROCEDURE_EX1();
END;
----------------------------------------------------------------------------------------

--매개변수가 있는 프로시저
--	IN : 입력 매개변수
CREATE OR REPLACE PROCEDURE PROCEDURE_EX2(
	V_PID IN VARCHAR2, 
	V_PNAME IN VARCHAR2,
	V_PAGE IN NUMBER)
IS
	TEST_VAR VARCHAR2(100);
BEGIN
	TEST_VAR := 'HELLO WORLD';
	DBMS_OUTPUT.PUT_LINE(V_PID || ' ' || V_PNAME || ' ' || V_PAGE);
	INSERT INTO PERSON VALUES(V_PID, V_PNAME, V_PAGE);
	COMMIT; -- 문제가 없을시 커밋 해서 DB에 반영

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('ERROR');
		ROLLBACK; -- 문제가 생겼을시 롤백
END;

BEGIN
	PROCEDURE_EX2('0005','이씨', 20);
END;
SELECT * FROM PERSON;
----------------------------------------------------------------------------------------
--값을 외부로 전달하는 프로시저
CREATE OR REPLACE PROCEDURE PROCEDURE_EX3(
	NUM IN NUMBER,
	RESULT OUT NUMBER)
IS
	I NUMBER;
	USER_EXCEPTION EXCEPTION;
BEGIN
	IF NUM <= 0 THEN
		RAISE USER_EXCEPTION;
	END IF;
	--반복문 이용해서 1~NUM까지 곱하는 팩토리얼 계산
	--결과 값을 RESULT에 저장
	RESULT := 1;
	FOR I IN 1 .. NUM
	LOOP
		RESULT := RESULT * I;
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('숫자는 0보다 커야합니다.');
		RESULT := -1;
END;

DECLARE
	FAC NUMBER;
BEGIN
	PROCEDURE_EX3(-5, FAC);
	DBMS_OUTPUT.PUT_LINE(FAC);
END;
