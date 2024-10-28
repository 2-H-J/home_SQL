--전체 게시글 조회

--글번호, 제목, 작성자, 작성자 닉네임, 조회수, 작성일, 글내용
SELECT
	B.BNO , B.TITLE , B.ID , BM.NICKNAME , B.BCOUNT , B.WRITE_DATE , B.CONTENT 
FROM BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID;

--글번호, 제목, 작성자, 작성자 닉네임, 조회수, 작성일, 글내용, 게시판좋아요, 게시판싫어요
--글 번호별 좋아요 개수 조회
SELECT 
	BNO, COUNT(*) AS BLIKE
FROM BOARD_CONTENT_LIKE
GROUP BY BNO;

--글 번호별 싫어요 개수 조회
SELECT 
	BNO, COUNT(*) AS BHATE
FROM BOARD_CONTENT_HATE
GROUP BY BNO;

--전체 게시글과 위에 2개 SQL문을 조합-----------------------------------------------------------------
SELECT 
    B.BNO, -- 게시글 번호
    B.TITLE, -- 게시글 제목
    B.CONTENT, -- 게시글 내용
    BM.NICKNAME,
    NVL(LIKES.BLIKE, 0) AS BLIKE, -- 좋아요 개수 (값이 없을 때 0으로 대체)
    NVL(HATES.BHATE, 0) AS BHATE -- 싫어요 개수 (값이 없을 때 0으로 대체)
FROM 
    BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID 
LEFT JOIN 
    (SELECT BNO, COUNT(*) AS BLIKE FROM BOARD_CONTENT_LIKE GROUP BY BNO) LIKES
    ON B.BNO = LIKES.BNO
LEFT JOIN 
    (SELECT BNO, COUNT(*) AS BHATE FROM BOARD_CONTENT_HATE GROUP BY BNO) HATES
    ON B.BNO = HATES.BNO;
-----------
SELECT
	B.BNO , B.TITLE , B.ID , BM.NICKNAME , B.BCOUNT , B.WRITE_DATE , B.CONTENT , BL.BLIKE,0, BH.BHATE
FROM BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID
JOIN (SELECT BNO, COUNT(*) AS BLIKE FROM BOARD_CONTENT_LIKE GROUP BY BNO) BL ON B.BNO = BL.BNO
JOIN (SELECT BNO, COUNT(*) AS BHATE FROM BOARD_CONTENT_HATE GROUP BY BNO) BH ON B.BNO = BH.BNO
ORDER BY B.BNO;
-------------------------------------------강사님 풀이------------------------------------------------
--FROM 서브쿼리
SELECT B.*, BM.NICKNAME, BLIKE , BHATE
FROM BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID
JOIN (SELECT BNO, COUNT(*) AS BLIKE FROM BOARD_CONTENT_LIKE GROUP BY BNO) BL
ON BL.BNO = B.BNO
JOIN (SELECT BNO, COUNT(*) AS BHATE FROM BOARD_CONTENT_HATE GROUP BY BNO) BH
ON BH.BNO = B.BNO;

--SELECT 서브쿼리
SELECT B.*, BM.NICKNAME,
(SELECT COUNT(*) FROM BOARD_CONTENT_LIKE BCL WHERE B.BNO = BCL.BNO) AS BLIKE,
(SELECT COUNT(*) FROM BOARD_CONTENT_HATE BCH WHERE B.BNO = BCH.BNO) AS BHATE
FROM BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID;
------------------------------------------------------------------------------------------------------

--게시물 좋아요,싫어요, 전체 조회 NULL값은 O으로 표시(NVL적용)
SELECT B.*, BM.NICKNAME, NVL(BL.BLIKE, 0) AS BLIKE  , NVL(BH.BHATE, 0) AS BHATE
FROM BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID
LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS BLIKE FROM BOARD_CONTENT_LIKE GROUP BY BNO) BL
ON BL.BNO = B.BNO
LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS BHATE FROM BOARD_CONTENT_HATE GROUP BY BNO) BH
ON BH.BNO = B.BNO
ORDER BY B.BNO DESC;

-----------------------------------------------------------------------------------------------------
--글번호, 제목, 작성자, 작성자 닉네임, 조회수, 작성일, 글내용, 게시판좋아요, 게시판싫어요, 게시글 댓글 개수
--게시글별로 댓글 개수를 조회
SELECT 
	BNO , COUNT(*) AS BCM_COUNT
FROM BOARD_COMMENT
GROUP BY BNO;

--조합
SELECT --조회목록
	B.*, BM.NICKNAME, NVL(BL.B_LIKE, 0) AS B_LIKE  , NVL(BH.B_HATE, 0) AS B_HATE, NVL(BC.BCM_COUNT, 0) AS BCM_COUNT 
FROM 
	BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID -- 조인목록
	LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS B_LIKE FROM BOARD_CONTENT_LIKE GROUP BY BNO) BL --게시물 좋아요 조인+서브쿼리
	ON BL.BNO = B.BNO
	LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS B_HATE FROM BOARD_CONTENT_HATE GROUP BY BNO) BH -- 게시물 싫어요 조인+서브쿼리
	ON BH.BNO = B.BNO
	LEFT OUTER JOIN (SELECT BNO , COUNT(*) AS BCM_COUNT FROM BOARD_COMMENT GROUP BY BNO) BC -- 게시물 댓글 개수 조인+서브쿼리
	ON BC.BNO = B.BNO
ORDER BY B.BNO DESC; -- 정렬
-----------------------------------------------------------------------------------------------------
--페이지 번호 추가해서 조회
--BOARD_VIEW를 기준으로 행번호 추가해서 조회
--VIEW로 게시판조회 만들기(게시물 좋아요/싫어요, 게시물 댓글 개수 조인+서브쿼리)
CREATE OR REPLACE VIEW BOARD_VIEW
AS
SELECT --조회목록
	B.*, BM.NICKNAME, NVL(BL.B_LIKE, 0) AS B_LIKE  , NVL(BH.B_HATE, 0) AS B_HATE, NVL(BC.BCM_COUNT, 0) AS BCM_COUNT 
FROM 
	BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID -- 조인목록
	LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS B_LIKE FROM BOARD_CONTENT_LIKE GROUP BY BNO) BL --게시물 좋아요 조인+서브쿼리
	ON BL.BNO = B.BNO
	LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS B_HATE FROM BOARD_CONTENT_HATE GROUP BY BNO) BH -- 게시물 싫어요 조인+서브쿼리
	ON BH.BNO = B.BNO
	LEFT OUTER JOIN (SELECT BNO , COUNT(*) AS BCM_COUNT FROM BOARD_COMMENT GROUP BY BNO) BC -- 게시물 댓글 개수 조인+서브쿼리
	ON BC.BNO = B.BNO
ORDER BY B.BNO DESC;

SELECT * FROM BOARD_VIEW; 

--VIEW로 만든 데이터 조회 (VIEW로 만들어서 그 안에 만든 컬럼을 사용 가능)
--행번호로 페이지 나누기
SELECT CEIL(ROW_NUMBER() OVER(ORDER BY BCM_COUNT DESC) / 30) AS PAGE, BV.*
FROM BOARD_VIEW BV;

--특정 PAGE만 조회하기
SELECT * FROM (SELECT CEIL(ROW_NUMBER() OVER(ORDER BY BCM_COUNT DESC) / 30) AS PAGE, BV.*
FROM BOARD_VIEW BV) 
WHERE PAGE = 3;
-----------------------------------------------------------------------------------------------------

--전체 댓글 조회
--글번호, 댓글번호, 작성자(아이디), 작성자(닉네임), 내용, 작성일
SELECT
	B.BNO , BC.CNO , BM.ID , BM.NICKNAME , BC.CONTENT, BC.CDATE 
FROM BOARD_COMMENT BC JOIN BOARD_MEMBER BM ON BC.ID = BM.ID 
JOIN BOARD B ON B.BNO = BC.BNO;

--댓글 좋아요
SELECT CNO, COUNT(*) AS BCL_COUNT FROM BOARD_COMMENT_LIKE GROUP BY CNO;

--댓글 싫어요
SELECT CNO, COUNT(*) AS BCH_COUNT FROM BOARD_COMMENT_HATE GROUP BY CNO;

--댓글 목록 조회
SELECT 
	BC.*, BM.NICKNAME
FROM BOARD_COMMENT BC JOIN BOARD_MEMBER BM ON BC.ID = BM.ID;

--합친 결과
--댓글 번호, 글번호, 댓글내용, 댓글 작성일, 댓글 좋아요, 댓글 싫어요, 댓글 작성 아이디, 댓글작성 닉네임
SELECT 
	BC.*, BM.NICKNAME, NVL(BCL.BCL_COUNT, 0) AS BCL_COUNT, NVL(BCH.BCH_COUNT, 0) AS BCH_COUNT
FROM BOARD_COMMENT BC JOIN BOARD_MEMBER BM ON BC.ID = BM.ID
LEFT OUTER JOIN (SELECT CNO, COUNT(*) AS BCL_COUNT FROM BOARD_COMMENT_LIKE GROUP BY CNO) BCL
ON BC.CNO = BCL.CNO
LEFT OUTER JOIN (SELECT CNO, COUNT(*) AS BCH_COUNT FROM BOARD_COMMENT_LIKE GROUP BY CNO) BCH
ON BC.CNO = BCH.CNO;

-- VIEW 권한 부여(SYSTEM계정으로 실행)
GRANT RESOURCE, CONNECT, CREATE VIEW TO C##SCOTT;

--댓글 전체 조회 VIEW
CREATE OR REPLACE VIEW BOARD_COMMENT_VIEW
AS
SELECT 
	BC.*, BM.NICKNAME, NVL(BCL.BCL_COUNT, 0) AS BCL_COUNT, NVL(BCH.BCH_COUNT, 0) AS BCH_COUNT
FROM BOARD_COMMENT BC JOIN BOARD_MEMBER BM ON BC.ID = BM.ID
LEFT OUTER JOIN (SELECT CNO, COUNT(*) AS BCL_COUNT FROM BOARD_COMMENT_LIKE GROUP BY CNO) BCL
ON BC.CNO = BCL.CNO
LEFT OUTER JOIN (SELECT CNO, COUNT(*) AS BCH_COUNT FROM BOARD_COMMENT_LIKE GROUP BY CNO) BCH
ON BC.CNO = BCH.CNO;

SELECT * FROM BOARD_COMMENT_VIEW WHERE BNO = 5;


--게시글 작성한 회원들 게시글 개수
SELECT 
	BM.ID, COUNT(*) AS BM_B_COUNT
FROM BOARD_MEMBER BM JOIN BOARD B ON BM.ID = B.ID
GROUP BY BM.ID;

--특정 ID 게시물 확인
SELECT
	ID, TITLE 
FROM BOARD
WHERE ID LIKE 'iossf9320';

--게시물당 좋아요 횟수 확인
SELECT
	B.ID, B.TITLE ,COUNT(BCL.BNO) AS B_LIKE_COUNT
FROM BOARD B JOIN BOARD_CONTENT_LIKE BCL ON B.BNO = BCL.BNO 
WHERE B.ID LIKE 'iossf9320'
GROUP BY B.ID , B.TITLE ,BCL.BNO ;

--특정 ID 게시물 좋아요 총합
SELECT 
	SUM(B_LIKE_COUNT) 
FROM (SELECT
	B.ID, B.TITLE ,COUNT(BCL.BNO) AS B_LIKE_COUNT
FROM BOARD B JOIN BOARD_CONTENT_LIKE BCL ON B.BNO = BCL.BNO 
--WHERE B.ID LIKE 'iossf9320'
GROUP BY B.ID , B.TITLE ,BCL.BNO)

--게시글 작성한 회원들의 게시글 좋아요를 받은 총 횟수

SELECT 
	BM.ID , COUNT(BCL.BNO) AS B_LIKE_COUNT 
FROM BOARD_MEMBER BM 
	JOIN BOARD B ON BM.ID = B.ID
	JOIN BOARD_CONTENT_LIKE BCL ON B.BNO = BCL.BNO
--WHERE BM.ID LIKE 'iossf9320'
GROUP BY BM.ID;

SELECT 
	ID, BNO 
FROM BOARD_CONTENT_LIKE 
WHERE ID LIKE 'iossf9320';

--게시글 작성한 회원들의 게시글 싫어요를 받은 총 횟수
SELECT 
	BM.ID , COUNT(BCH.BNO) AS B_HATE_COUNT 
FROM BOARD_MEMBER BM JOIN BOARD B ON BM.ID = B.ID
JOIN BOARD_CONTENT_HATE BCH ON B.BNO = BCH.BNO
--WHERE B.ID LIKE 'iossf9320'
GROUP BY BM.ID;

--게시글을 작성한 회원들의 게시글 개수, 좋아요를 받은 총 횟수, 싫어요를 받은 총 횟수를 조회 전체

