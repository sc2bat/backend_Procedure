-- ���ν���
--�Լ��� ����� �����Դϴ�
--�Լ��� ��� ������ ������ ���ν����� ��������� ���� ���� Ư¡�Դϴ�.(������ ���� ������ �ڵ�(����) �� �ֽ��ϴ�)

--���ν����� ����
--CREATE OR REPLACE PROCEDURE ���ν����̸�(
--    �Ű�����1 [ IN | OUT | IN OUT ] ������Ÿ��[:=DEFAULT VALUE],
--    �Ű�����2 [ IN | OUT | IN OUT ] ������Ÿ��[:=DEFAULT VALUE],
--    ...
--)

--IS[AS]
--    ����, ��� ����
--BEGIN
--    �����
--    [EXCEPTION
--        ����ó����]
--END [���ν��� �̸�];
    
--CREATE OR REPLACE PROCEDURE : ���ν����� �����ϴ� �����Դϴ�
--    �Ű�����1 [ IN | OUT | IN OUT ] : �Ű������� ����� ���޵Ǵ� �����μ��� �޴� IN ������
--                                      ���Ͽ����� �� �� �ִ� OUT ������ ���鶧 ����մϴ�. �Էº����� ��º����� ������ ���ÿ� �ο��Ƿ���
--                                      IN OUT �� ���� ����մϴ�
--                                      ���ν����� �⺻������ ���ϰ��� ������(���� RETURN ����� ������� ����) ������ �Ӽ��� OUT �Ӽ��ϳ���
--                                      �ο������ν� ������ ������ �䳻�� �� �ְԴ� ����� �����մϴ�
--                                      ���� �Ӽ��� IN �ΰ�� ������ �����մϴ�

-- ���̺� ���ڵ带 �߰��ϴ� ���ν���

CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id IN JOBS.JOB_ID%TYPE,
    p_job_title IN JOBS.JOB_TITLE%TYPE,
    p_min_salary IN JOBS.MIN_SALARY%TYPE,
    p_max_salary IN JOBS.MAX_SALARY%TYPE
)
IS
BEGIN
    INSERT INTO jobs(job_id, job_title, min_salary, max_salary, create_date, update_date)
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, SYSDATE, SYSDATE);
    COMMIT;
END;

EXEC my_new_job_proc('test_id', 'test_title', 30000, 40000);

SELECT * FROM JOBS;
SELECT * FROM JOBS WHERE job_id = 'test_id';
--test_id	test_title	30000	40000	22/03/18	22/03/18

-- JOBS ���̺� ���ڵ带 �߰�ȭ��, �߰��� ������ JOB_ID �� �̹� �����ϴ� ���̸�,
--�ش� ������ ���� ������ �Է� INSERT �� �����ϴ� ���ν����� �����ϼ���
--������ ��ɱ����� �Ʒ��� �����ϴ�
EXEC my_new_job_proc('test_id', 'test_title_update', 30000, 40000); -- UPDATE
EXEC my_new_job_proc('test_id_new', 'test_title_new', 30000, 40000); -- INSERT

CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_salary IN jobs.min_salary%TYPE,
    p_max_salary IN jobs.max_salary%TYPE
)
IS
    vn_cnt NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vn_cnt FROM jobs WHERE job_id = p_job_id;
    IF vn_cnt = 0 THEN
        INSERT INTO jobs(job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, SYSDATE, SYSDATE);
    ELSE
        UPDATE jobs SET job_title = p_job_title, min_salary = p_min_salary, max_salary = p_max_salary 
            WHERE job_id = p_job_id;
    END IF;
    COMMIT; -- INSERT UPDATE DELETE �Ŀ� COMMIT �� �Ұ�
END;

EXEC my_new_job_proc('test_id', 'test_title_update', 30000, 40000); -- UPDATE
EXEC my_new_job_proc('id_new', 'title_new', 30000, 40000);

SELECT * FROM JOBS WHERE job_id = 'test_id';
SELECT * FROM JOBS WHERE job_id = 'id_new';

-- OUT, IN OUT �Ű����� ���
CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_salary IN jobs.min_salary%TYPE,
    p_max_salary IN jobs.max_salary%TYPE,
    p_upd_date OUT jobs.update_date%TYPE
)
IS
    vn_cnt NUMBER := 0;
    vn_cur_date jobs.update_date%TYPE := SYSDATE;
BEGIN
    SELECT COUNT(*) INTO vn_cnt FROM jobs WHERE job_id = p_job_id;
    IF vn_cnt = 0 THEN
        INSERT INTO jobs(job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, SYSDATE, SYSDATE);
    ELSE
        UPDATE jobs SET job_title = p_job_title, min_salary = p_min_salary, max_salary = p_max_salary, update_date = SYSDATE
            WHERE job_id = p_job_id;
    END IF;
    COMMIT; -- INSERT UPDATE DELETE �Ŀ� COMMIT �� �Ұ�
    p_upd_date := vn_cur_date;
END;

DECLARE
    vd_cur_date jobs.update_date%TYPE;
BEGIN
    -- �͸� ��Ͽ��� ���ν����� ȣ���ϸ� EXEC ��� ����
    my_new_job_porc('out_test', 'test_title', 30000, 40000, vd_cur_date);
    -- �ټ���° �μ��� �־��� ���� �͸����� ������, 
--    ���ν����� out ������ ����Ǿ� �� ���� �����޵��� �޾Ƽ� ����� �����մϴ�
--    ���ν��� ������ out ������ ���� �����ϸ�, ���� ��ġ�� �����μ��� �־��� vd_cur_date ������ ���� �Ͱ� ���� ȿ���� �����ϴ�
    DBMS_OUTPUT.PUT_LINE(vd_cur_date);
END;

-- ����Ʈ ���
CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_salary IN jobs.min_salary%TYPE := 100,
    p_max_salary IN jobs.max_salary%TYPE := 800
)
IS
    vn_cnt NUMBER := 0;
    vn_cur_date jobs.update_date%TYPE := SYSDATE;
BEGIN
    SELECT COUNT(*) INTO vn_cnt FROM jobs WHERE job_id = p_job_id;
    IF vn_cnt = 0 THEN
        INSERT INTO jobs(job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, SYSDATE, SYSDATE);
    ELSE
        UPDATE jobs SET job_title = p_job_title, min_salary = p_min_salary, max_salary = p_max_salary, update_date = SYSDATE
            WHERE job_id = p_job_id;
    END IF;
    COMMIT; -- INSERT UPDATE DELETE �Ŀ� COMMIT �� �Ұ�
END;
EXEC my_new_job_proc('default_id', 'test_title');

SELECT * FROM JOBS WHERE job_id = 'default_id';
-- default_id	test_title	100	800	22/03/18	22/03/18


-- �Ű����� �μ� ���޽�, ���� ����
EXEC my_new_job_proc(p_min_salary => 5000, p_job_id => 'change_id', p_job_title => 'test_title', p_max_salary => 10000);

SELECT * FROM JOBS WHERE job_id = 'change_id';
-- change_id	test_title	5000	10000	22/03/18	22/03/18

--IN ������ OUT ������ IN OUT ����
CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_var_in IN VARCHAR2,
    p_var_out OUT VARCHAR2,
    p_var_inout IN OUT VARCHAR2
)
IS
BEGIN  
    DBMS_OUTPUT.PUT_LINE('p_var_in' || p_var_in); 
    DBMS_OUTPUT.PUT_LINE('p_var_out' || p_var_out); -- OUT ������ ���޵� ���� �־ ������ ���� �ʽ��ϴ�.
    DBMS_OUTPUT.PUT_LINE('p_var_inout' || p_var_inout);
    -- OUT ������ �־��� ���� ȣ�⿡ ���� �����μ��μ��� ����(�͸���� p_var_out, p_var_inout)�� ����˴ϴ�
    -- p_var_in := 'A2' ; -- IN ������ �����μ��� ���� ���� �������� ���Ƿ� ���� ���� ���մϴ�.
    p_var_out := 'B2';
    p_var_inout := 'C2';
END;

DECLARE
    v_var_in VARCHAR2(10) := 'A';
    v_var_out VARCHAR2(10) := 'B';
    v_var_inout VARCHAR2(10) := 'C';
BEGIN
    my_new_job_proc(v_var_in, v_var_out, v_var_inout); --p_var_inA     --p_var_out     --p_var_inoutC
    DBMS_OUTPUT.PUT_LINE('v_var_in' || v_var_in); --v_var_inA
    DBMS_OUTPUT.PUT_LINE('v_var_out' || v_var_out); --v_var_outB2 
    DBMS_OUTPUT.PUT_LINE('v_var_inout' || v_var_inout); --v_var_inoutC2
END;

--IN OUT ������ ����Ģ
--1. IN ������ �����μ��� ���޵Ǿ� ����� ���� ������ �� �� �ְ�, ���� �Ҵ��� �� �����ϴ�
--2. OUT �������� �����μ��� ���� ������ ���� ������, ������ �� �����Ƿ� �ǹ̰� ���� �����Դϴ�.
--3. OUT ������ IN OUT ������ ����Ʈ���� ������ �� �����ϴ�
--4. IN �������� ����, ���, �� ���������� ���� ���� �����μ��� ������ �� ������, OUT ������ IN OUT ������ �ݵ�� ���� ���·� �����μ��� �־�����մϴ�.

-- RETURN �� : ���ν������� RETURN �� ���� �����ϰڴٴ� ����� �ƴϰ�, ���������� ���ν����� �����ڴٴ� ���Դϴ�
    �ڹٿ��� void �޼��� �����߿�, return ������� �߰��� �޼��带 �����ϴ� �Ͱ� ����մϴ�
    

CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_salary IN jobs.min_salary%TYPE := 10,
    p_max_salary IN jobs.max_salary%TYPE := 80
)
IS
    vn_cnt NUMBER := 0;
BEGIN
    -- 1000���� ������ �޼��� ��� �� ����������
    IF p_min_salary < 1000 THEN
        DBMS_OUTPUT.PUT_LINE('�ּ� �޿����� 1000�̻��̾�� �մϴ�'); 
        RETURN;
    END IF;
    -- IF �� ������ ���̸� �Ʒ� ����� ������� �ʰ� ���ν����� �����ϰ� �˴ϴ�
    -- ������ �����϶� �Ʒ� ����� ����
END;

EXEC my_new_job_proc('return_id', 'test_title');

SELECT * FROM JOBS WHERE job_id = 'return_id';








SET SERVEROUTPUT ON


















    