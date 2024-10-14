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
