----------------------------------------------------------------------------------------
-- 매개변수가 없는 프로시저 생성
-- PROCEDURE_EX1: 단순히 'HELLO WORLD' 메시지를 출력하는 예제
----------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PROCEDURE_EX1
IS
	-- 변수 선언
	TEST_VAR VARCHAR2(100); -- VARCHAR2 타입의 변수 TEST_VAR 선언
BEGIN
	-- 실행부
	TEST_VAR := 'HELLO WORLD'; -- 변수에 문자열 'HELLO WORLD' 할당
	DBMS_OUTPUT.PUT_LINE(TEST_VAR); -- DBMS 콘솔에 TEST_VAR의 내용을 출력
END;
----------------------------------------------------------------------------------------
--GPT개선 PROCEDURE_EX1 기존 코드에서 불필요한 변수를 제거하고, 직접 문자열 출력으로 대체
CREATE OR REPLACE PROCEDURE PROCEDURE_EX1
AS
BEGIN
	DBMS_OUTPUT.PUT_LINE('HELLO WORLD'); -- 변수를 사용하지 않고 직접 출력
END;
/* 
IS와 AS는 프로시저나 함수 정의에서 거의 동일한 기능을 수행하는 키워드로, 
둘 다 블록의 시작을 알리는 역할을 합니다. IS와 AS 중 무엇을 사용해도 문법적으로 문제는 없지만, 약간의 스타일 차이가 있습니다.

IS: 주로 PL/SQL 표준에서 권장되며, 오라클에서는 IS를 사용하는 경우가 많습니다.
AS: 특정 SQL 문서나 스타일에서 선호되는 표현이며, 가독성 차이를 위해 쓰기도 합니다.
따라서 CREATE PROCEDURE 구문에서는 IS나 AS 모두 사용 가능하며, 동작상의 차이는 없고 개인의 스타일이나 가독성에 따라 선택할 수 있습니다.
*/
----------------------------------------------------------------------------------------
-- 서버 콘솔 출력을 활성화/비활성화
SET SERVEROUTPUT ON;
SET SERVEROUTPUT OFF;

-- 프로시저 실행
BEGIN
	PROCEDURE_EX1(); -- 매개변수 없는 PROCEDURE_EX1 호출
END;

----------------------------------------------------------------------------------------
-- 매개변수가 있는 프로시저 생성
-- PROCEDURE_EX2: PID, 이름, 나이를 받아 PERSON 테이블에 삽입
----------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PROCEDURE_EX2(
	V_PID IN VARCHAR2,  -- 학생 ID를 입력으로 받는 매개변수
	V_PNAME IN VARCHAR2, -- 학생 이름을 입력으로 받는 매개변수
	V_PAGE IN NUMBER     -- 학생 나이를 입력으로 받는 매개변수
)
IS
	TEST_VAR VARCHAR2(100); -- VARCHAR2 타입의 변수 TEST_VAR 선언
BEGIN
	TEST_VAR := 'HELLO WORLD';
	DBMS_OUTPUT.PUT_LINE(V_PID || ' ' || V_PNAME || ' ' || V_PAGE); -- 매개변수 출력
	INSERT INTO PERSON VALUES(V_PID, V_PNAME, V_PAGE); -- 전달받은 값을 PERSON 테이블에 삽입
	COMMIT; -- 문제가 없을 시 DB에 반영
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('ERROR'); -- 오류 발생 시 메시지 출력
		ROLLBACK; -- 오류 발생 시 트랜잭션을 롤백하여 DB 상태 복구
END;
----------------------------------------------------------------------------------------
/* GPT개선 PROCEDURE_EX2
트랜잭션 제어는 불필요하게 COMMIT 및 ROLLBACK을 포함하는 대신, INSERT의 성공 여부에 따라 처리됩니다.
오류 메시지도 구체화했습니다. */
CREATE OR REPLACE PROCEDURE PROCEDURE_EX2(
	V_PID IN VARCHAR2, 
	V_PNAME IN VARCHAR2,
	V_PAGE IN NUMBER
)
AS
BEGIN
	-- 매개변수를 출력하여 삽입 내용 확인
	DBMS_OUTPUT.PUT_LINE('삽입하려는 정보: ' || V_PID || ' ' || V_PNAME || ' ' || V_PAGE);

	-- PERSON 테이블에 데이터 삽입
	INSERT INTO PERSON (PID, PNAME, PAGE) VALUES (V_PID, V_PNAME, V_PAGE);
	
	-- 삽입 성공 메시지
	DBMS_OUTPUT.PUT_LINE('데이터 삽입 성공');
	
EXCEPTION
	-- 예외 발생 시 오류 메시지와 함께 롤백
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('데이터 삽입 중 오류 발생: ' || SQLERRM); -- 구체적 오류 메시지 출력
END;

----------------------------------------------------------------------------------------
-- 프로시저 호출 및 실행
BEGIN
	PROCEDURE_EX2('0005','이씨', 20); -- 매개변수를 입력하여 PROCEDURE_EX2 실행
END;
SELECT * FROM PERSON; -- 결과 확인을 위해 PERSON 테이블의 모든 레코드를 조회
----------------------------------------------------------------------------------------
-- 값을 외부로 전달하는 프로시저 생성
-- PROCEDURE_EX3: 팩토리얼 계산 후 결과를 외부로 전달하는 예제
----------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PROCEDURE_EX3(
	NUM IN NUMBER, -- 입력으로 받는 숫자
	RESULT OUT NUMBER -- 팩토리얼 결과를 외부로 반환하는 매개변수
)
IS
	I NUMBER; -- 반복문에 사용할 변수 I 선언
	USER_EXCEPTION EXCEPTION; -- 사용자 정의 예외 선언
BEGIN
	-- 예외 조건 확인
	IF NUM <= 0 THEN
		RAISE USER_EXCEPTION; -- 입력된 숫자가 0 이하이면 예외 발생
	END IF;

	-- 팩토리얼 계산
	RESULT := 1;
	FOR I IN 1 .. NUM -- 1부터 NUM까지 반복하여 팩토리얼 계산
	LOOP
		RESULT := RESULT * I; -- RESULT에 결과값 누적
	END LOOP;

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('숫자는 0보다 커야합니다.'); -- 예외 발생 시 메시지 출력
		RESULT := -1; -- 예외 발생 시 RESULT에 -1 할당
END;
----------------------------------------------------------------------------------------
-- 프로시저 호출 및 출력
DECLARE
	FAC NUMBER; -- 팩토리얼 결과를 저장할 변수 FAC 선언
BEGIN
	PROCEDURE_EX3(5, FAC); -- 5를 NUM으로 전달하여 PROCEDURE_EX3 호출
	DBMS_OUTPUT.PUT_LINE(FAC); -- 결과 출력 (120로 출력됨, 5의 팩토리얼 값)
END;

-- 숫자 0보다 작으면 에러 발생
DECLARE
	FAC NUMBER; -- 팩토리얼 결과를 저장할 변수 FAC 선언
BEGIN
	PROCEDURE_EX3(-5, FAC); -- -5를 NUM으로 전달하여 PROCEDURE_EX3 호출
	DBMS_OUTPUT.PUT_LINE(FAC); -- 결과 출력 (-1로 출력됨, 예외가 발생했기 때문)
END;
