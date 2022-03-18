-- 프로시저
--함수와 비슷한 구조입니다
--함수는 결과 리턴이 있지만 프로시저는 결과리턴이 없는 것이 특징입니다.(리턴을 위한 별도의 코드(변수) 가 있습니다)

--프로시저의 생성
--CREATE OR REPLACE PROCEDURE 프로시저이름(
--    매개변수1 [ IN | OUT | IN OUT ] 데이터타입[:=DEFAULT VALUE],
--    매개변수2 [ IN | OUT | IN OUT ] 데이터타입[:=DEFAULT VALUE],
--    ...
--)

--IS[AS]
--    변수, 상수 선언
--BEGIN
--    실행부
--    [EXCEPTION
--        예외처리부]
--END [프로시저 이름];
    
--CREATE OR REPLACE PROCEDURE : 프로시저를 생성하는 구문입니다
--    매개변수1 [ IN | OUT | IN OUT ] : 매개변수를 만들되 전달되는 전달인수를 받는 IN 변수와
--                                      리턴역할을 할 수 있는 OUT 변수를 만들때 사용합니다. 입력변수와 출력변수의 역할이 동시에 부여되려면
--                                      IN OUT 을 같이 기술합니다
--                                      프로시저는 기본적으로 리턴값이 없지만(실제 RETURN 명령을 사용하지 않음) 변수의 속성에 OUT 속성하나를
--                                      부여함으로써 리턴의 역할을 흉내낼 수 있게는 사용이 가능합니다
--                                      변수 속성이 IN 인경우 생략이 가능합니다

-- 테이블에 레코드를 추가하는 프로시저

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

-- JOBS 테이블에 레코드를 추가화되, 추가할 내용의 JOB_ID 가 이미 존재하는 값이면,
--해당 내용들로 수정 없으면 입력 INSERT 를 실행하는 프로시저를 생성하세요
--실행할 명령구문은 아래와 같습니다
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
    COMMIT; -- INSERT UPDATE DELETE 후에 COMMIT 꼭 할것
END;

EXEC my_new_job_proc('test_id', 'test_title_update', 30000, 40000); -- UPDATE
EXEC my_new_job_proc('id_new', 'title_new', 30000, 40000);

SELECT * FROM JOBS WHERE job_id = 'test_id';
SELECT * FROM JOBS WHERE job_id = 'id_new';

-- OUT, IN OUT 매개변수 사용
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
    COMMIT; -- INSERT UPDATE DELETE 후에 COMMIT 꼭 할것
    p_upd_date := vn_cur_date;
END;

DECLARE
    vd_cur_date jobs.update_date%TYPE;
BEGIN
    -- 익명 블록에서 프로시저를 호출하면 EXEC 사용 안함
    my_new_job_porc('out_test', 'test_title', 30000, 40000, vd_cur_date);
    -- 다섯번째 인수로 넣어준 현재 익명블록의 변수에, 
--    프로시저의 out 변수가 연결되어 그 값을 돌려받듯이 받아서 사용이 가능합니다
--    프로시저 내에서 out 변수에 값을 대입하면, 현재 위치의 전달인수로 넣어준 vd_cur_date 변수에 넣은 것과 같은 효과를 갖습니다
    DBMS_OUTPUT.PUT_LINE(vd_cur_date);
END;

-- 디폴트 밸류
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
    COMMIT; -- INSERT UPDATE DELETE 후에 COMMIT 꼭 할것
END;
EXEC my_new_job_proc('default_id', 'test_title');

SELECT * FROM JOBS WHERE job_id = 'default_id';
-- default_id	test_title	100	800	22/03/18	22/03/18


-- 매개변수 인수 전달시, 순서 변경
EXEC my_new_job_proc(p_min_salary => 5000, p_job_id => 'change_id', p_job_title => 'test_title', p_max_salary => 10000);

SELECT * FROM JOBS WHERE job_id = 'change_id';
-- change_id	test_title	5000	10000	22/03/18	22/03/18

--IN 변수와 OUT 변수와 IN OUT 변수
CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_var_in IN VARCHAR2,
    p_var_out OUT VARCHAR2,
    p_var_inout IN OUT VARCHAR2
)
IS
BEGIN  
    DBMS_OUTPUT.PUT_LINE('p_var_in' || p_var_in); 
    DBMS_OUTPUT.PUT_LINE('p_var_out' || p_var_out); -- OUT 변수는 전달된 값이 있어도 적용이 되지 않습니다.
    DBMS_OUTPUT.PUT_LINE('p_var_inout' || p_var_inout);
    -- OUT 변수에 넣어준 값은 호출에 사용된 전달인수로서의 변수(익명블럭의 p_var_out, p_var_inout)에 적용됩니다
    -- p_var_in := 'A2' ; -- IN 변수는 전달인수에 의해 값이 정해질뿐 임의로 값을 변경 못합니다.
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

--IN OUT 변수의 사용규칙
--1. IN 변수는 전달인수로 전달되어 저장된 값을 참조만 할 수 있고, 값을 할당할 수 없습니다
--2. OUT 변수에는 전달인수로 값을 전달할 수는 있지만, 참조할 수 없으므로 의미가 없는 전달입니다.
--3. OUT 변수와 IN OUT 변수는 디폴트값을 지정할 수 없습니다
--4. IN 변수에는 변수, 상수, 각 데이터형에 따른 값을 전달인수로 전달할 수 있지만, OUT 변수와 IN OUT 변수는 반드시 변수 형태로 전달인수를 넣어줘야합니다.

-- RETURN 문 : 프로시저에서 RETURN 은 값을 리턴하겠다는 명령이 아니고, 현시점에서 프로시저를 끝내겠다는 뜻입니다
    자바에서 void 메서드 실행중에, return 명령으로 중간에 메서드를 종료하는 것과 비슷합니다
    

CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_salary IN jobs.min_salary%TYPE := 10,
    p_max_salary IN jobs.max_salary%TYPE := 80
)
IS
    vn_cnt NUMBER := 0;
BEGIN
    -- 1000보다 작으면 메세지 출력 후 빠져나간다
    IF p_min_salary < 1000 THEN
        DBMS_OUTPUT.PUT_LINE('최소 급여값은 1000이상이어야 합니다'); 
        RETURN;
    END IF;
    -- IF 문 조건이 참이면 아래 명령은 실행되지 않고 프로시저는 종료하게 됩니다
    -- 조건이 거짓일때 아래 명령을 실행
END;

EXEC my_new_job_proc('return_id', 'test_title');

SELECT * FROM JOBS WHERE job_id = 'return_id';








SET SERVEROUTPUT ON


















    