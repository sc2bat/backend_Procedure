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


-----insertMember Procedure

CREATE OR REPLACE PROCEDURE insertMember(
    p_userid IN member.userid%TYPE,
    p_pwd IN member.pwd%TYPE,
    p_name IN member.name%TYPE,
    p_email IN member.email%TYPE,
    p_phone IN member.phone%TYPE
)
IS
    
BEGIN
    INSERT INTO member(userid, pwd, name, email, phone)
        VALUES(p_userid, p_pwd, p_name, p_email, p_phone);
    COMMIT;
END;
-- COMMIT 잊지 말기


--------------updateMember
CREATE OR REPLACE PROCEDURE updateMember(
    p_userid IN member.userid%TYPE,
    p_pwd IN member.pwd%TYPE,
    p_name IN member.name%TYPE,
    p_email IN member.email%TYPE,
    p_phone IN member.phone%TYPE
)
IS
BEGIN
    UPDATE member SET pwd=p_pwd, name=p_name, email=p_email, phone=p_phone WHERE userid=p_userid;
    COMMIT;
END;

---------plusReadCount
CREATE OR REPLACE PROCEDURE plusReadCount(
    p_num IN board.num%TYPE
)
IS
BEGIN
    UPDATE board SET readcount = readcount+1 WHERE num=p_num;
    COMMIT;
END;

----------boardView
CREATE OR REPLACE PROCEDURE boardView(
    p_num IN board.num%TYPE,
    p_curvar1 OUT SYS_REFCURSOR,
    p_curvar2 OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_curvar1 FOR SELECT * FROM board WHERE num=p_num ORDER BY num DESC;
    OPEN p_curvar2 FOR SELECT * FROM reply WHERE boardnum=p_num ORDER BY num DESC;
END;

------------insertReply
CREATE OR REPLACE PROCEDURE insertReply(
    p_boardnum IN reply.boardnum%TYPE,
    p_userid IN reply.userid%TYPE,
    p_content IN reply.content%TYPE
)
IS
BEGIN
    INSERT INTO reply(num, boardnum, userid, content)
        VALUES(reply_seq.nextVal, p_boardnum, p_userid, p_content);
    COMMIT;
END;

-------------deleteReply
CREATE OR REPLACE PROCEDURE deleteReply(
    p_num IN reply.num%TYPE
)
IS
BEGIN
    DELETE FROM reply WHERE num = p_num;
    COMMIT;
END;

---------getBoardOne
CREATE OR REPLACE PROCEDURE getBoardOne(
    p_num IN board.num%TYPE,
    p_cur OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cur FOR SELECT * FROM board WHERE num = p_num ORDER BY num DESC;
END;


------updateBoard
CREATE OR REPLACE PROCEDURE updateBoard(
    p_num IN board.num%TYPE,
    p_userid IN board.userid%TYPE,
    p_pass IN board.pass%TYPE,
    p_email IN board.email%TYPE,
    p_title IN board.title%TYPE,
    p_content IN board.content%TYPE,
    p_imgfilename IN board.imgfilename%TYPE
)
IS
BEGIN
    UPDATE board SET userid=p_userid, pass=p_pass, email=p_email, title=p_title, content=p_content, imgfilename=p_imgfilename
        WHERE num = p_num;
    COMMIT;
END;

----------deleteBoard
CREATE OR REPLACE PROCEDURE deleteBoard(
    p_num IN board.num%TYPE
)
IS
BEGIN
    DELETE FROM board WHERE num=p_num;
    COMMIT;
END;

----------insertBoard
CREATE OR REPLACE PROCEDURE insertBoard(
    p_userid IN board.userid%TYPE,
    p_pass IN board.pass%TYPE,
    p_email IN board.email%TYPE,
    p_title IN board.title%TYPE,
    p_content IN board.content%TYPE,
    p_imgfilename IN board.imgfilename%TYPE
)
IS
BEGIN
    INSERT INTO board(num, userid, pass, email, title, content, imgfilename)
        VALUES(board_seq.nextVal, p_userid, p_pass, p_email, p_title, p_content, p_imgfilename);
    COMMIT;
END;

















