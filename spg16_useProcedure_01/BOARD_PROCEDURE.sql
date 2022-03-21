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

--EXEC getMember(�����μ��μ��� ���̵�);


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

-----------paging ����
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
    temp_cur SYS_REFCURSOR; -- ��� ����� Ŀ��
    vs_num NUMBER; -- �˻��� �Խù��� �Խù� ��ȣ �����
    vs_rownum NUMBER; -- �˻��� �Խù��� ���ȣ
    vs_replycnt NUMBER; -- �Խù��� ��۰���
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
        SELECT COUNT(*) INTO vs_replycnt FROM reply WHERE boardnum = vs_num; -- �Խù� ��ȣ�� ������̺��� ���� �˻�
        UPDATE board SET replycnt = vs_replycnt WHERE NUM = vs_num; -- �ش� �Խù��� replycnt �� ������Ʈ
    END LOOP;
    COMMIT;
    
    OPEN p_curvar FOR 
        SELECT * FROM (
            SELECT * FROM (
                SELECT ROWNUM AS rn, b.* FROM board b ORDER BY num DESC
            ) WHERE rn >= p_startNum
        ) WHERE rn <= p_endNum;
END;








