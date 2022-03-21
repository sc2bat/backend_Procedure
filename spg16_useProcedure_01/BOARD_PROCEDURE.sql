CREATE OR REPLACE PROCEDURE getMember(
    p_userid IN member.userid%TYPE,
    p_curvar OUT SYS_REFCURSOR
)
IS
    result_cur SYS_REFCURSOR;
BEGIN
    OPEN result_cur FOR SELECT * FROM member WHERE userid = p_userid;
    p_curvar := result_cur;
END;

--EXEC getMember(전달인수로서의 아이디);


CREATE OR REPLACE PROCEDURE selectBoard(
    p_curvar OUT SYS_REFCURSOR
)
IS
    result_cur SYS_REFCURSOR;
BEGIN
    OPEN result_cur FOR SELECT * FROM board ORDER BY num DESC;
    p_curvar := result_cur;
END;



CREATE OR REPLACE PROCEDURE getAllCount(
    p_cnt OUT NUMBER
)
IS
    v_cnt NUMBER;
BEGIN
   SELECT COUNT(*) INTO v_cnt FROM board;
    p_cnt := v_cnt;
END;

-----------paging 적용
CREATE OR REPLACE PROCEDURE selectBoard(
    p_startNum IN NUMBER,
    p_endNum IN NUMBER,
    p_curvar OUT SYS_REFCURSOR
)
IS
    result_cur SYS_REFCURSOR;
BEGIN
    OPEN result_cur FOR 
        SELECT * FROM (
            SELECT * FROM (
                SELECT ROWNUM AS rn, b.* FROM board b ORDER BY num DESC
            ) WHERE rn >= p_startNum
        ) WHERE rn <= p_endNum;
    p_curvar := result_cur;
END;

---------------------------
CREATE OR REPLACE PROCEDURE selectBoard(
    p_startNum IN NUMBER,
    p_endNum IN NUMBER,
    p_curvar OUT SYS_REFCURSOR
)
IS
    temp_cur SYS_REFCURSOR; -- 결과 저장용 커서
    vs_num NUMBER; -- 검색된 게시물의 게시물 번호 저장용
    vs_rownum NUMBER; -- 검색된 게시물의 행번호
    vs_replycnt NUMBER; -- 게시물의 댓글갯수
BEGIN
    OPEN temp_cur FOR 
        SELECT * FROM (
            SELECT * FROM (
                SELECT b.num, ROWNUM AS rn FROM board b ORDER BY num DESC
            ) WHERE rn >= p_startNum
        ) WHERE rn <= p_endNum;
    LOOP
        FETCH temp_cur INTO vs_num, vs_rownum;
        EXIT WHEN temp_cur%NOTFOUND;
        SELECT COUNT(*) INTO vs_replycnt FROM reply WHERE boardnum = vs_num; -- 게시물 번호로 댓글테이블에서 갯수 검색
        UPDATE board SET replycnt = vs_replycnt WHERE NUM = vs_num; -- 해당 게시물에 replycnt 를 업데이트
    END LOOP;
    COMMIT;
    
    OPEN p_curvar FOR 
        SELECT * FROM (
            SELECT * FROM (
                SELECT ROWNUM AS rn, b.* FROM board b ORDER BY num DESC
            ) WHERE rn >= p_startNum
        ) WHERE rn <= p_endNum;
END;








