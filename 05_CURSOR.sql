-- CURSOR
--주로 프로시저 내부의 SQL 명령 중 SELECT 명령의 결과가 다수의 행으로 얻어졌을 때 사용하는 결과를 저장하는 메모리 영역을 지칭합니다
SET SERVEROUTPUT ON;

DECLARE
    vs_job_id VARCHAR2(30);
BEGIN
    SELECT job_id INTO vs_job_id
    FROM employees
    WHERE department_id = 30;
    DBMS_OUTPUT.PUT_LINE(vs_job_id);
END; 
--ORA-01422: exact fetch returns more than requested number of rows
-- 여러 사원의 결과 (job_id)를 하나의 변수에 담으려고해서 나오는 에러

--위의 익명블럭은 SELECT 명령의 결과가 1행(ROW) 이므로 실행이 가능하지만, SELECT 명령의 결과가 2행 이상이라면
--에러가 발생합니다. 2행 이상의 결과를 담을 수 있는 메모리 영역(또는 변수)으로 사용하는 것이 CURSOR 이며
--자바의 리스트와 비슷한 구조를 갖고 있습니다 또는 반복실행문을 이용하여 그 값들을 참조하고 출력하고 리턴할 수 있습니다

-- CURSOR 의 실행단계
--1. CURSOR 의 생성 (정의)
-------------------------------------------------------------------------------------
--CURSOR 사용할 커서의 이름 [(매개변수1, 매개변수2, ...)]
--IS
--SELECT ... SQL 문장
-------------------------------------------------------------------------------------
--매개변수의 역할 : SELECT 명령에서 사용할 값들 (주로 WHERE 절에서 사용할 값들)
--SELECT ... SQL 문장 : CURSOR 에 사용되어 결과를 안겨줄 SQL 명령
--
--2. CURSOR 의 OPEN(호출)
-------------------------------------------------------------------------------------
--OPEN 커서이름 [(전달인수1, 전달인수2, ...)]
-------------------------------------------------------------------------------------
--실제로 전달인수를 전달하여 커서를 실행하고 결과를 저장
--
--3. 결과를 반복실행문과 함께 필요에 맞게 처리
-------------------------------------------------------------------------------------
--LOOP
--    FETCH 커서이름 INTO 변수;
--    EXIT WHEN 커서이름%NOTFOUND;      -- 다음 select 에 의해 얻어진 레코드가 다 소진되어 없을때까지
--    필요에 맞는 처리 실행
--END LOOP;
-------------------------------------------------------------------------------------
--FETCH 커서이름 INTO 변수; 커서에 담긴 데이터들 중 한줄씩 꺼내서 변수에 넣는 동작입니다
--EXIT WHEN 커서이름%NOTFOUND; 꺼냈는데 데이터가 없으면 종료합니다
--LOOP 안에서 필요에 맞는 처리르 데이터가 없을 때까지 반복합니다
--
--4. CURSOR 닫기
-------------------------------------------------------------------------------------
--CLOSE 커서명
-------------------------------------------------------------------------------------

-- CURSOR 의 사용
-- 전달인수로 부서번호를 전달한 후 그 부서의 사원이름들을 얻어오는 커서

DECLARE
    vs_emp_name employees.emp_name%TYPE; -- 사원명을 저장하기 위한 변수
    vs_employee_id employees.employee_id%TYPE; -- 사원 번호를 저장하기 위한 변수
    
    -- 1. CURSOR 선언(생성, 정의) -- 부서번호를 커서에 전달해서 그 부서 번호와 같은 사원의 사원번호와 이름을 얻어내는 커서 선언
    CURSOR cur_emp_dept(cp_department_id employees.department_id%TYPE)
    IS
    SELECT employee_id, emp_name FROM employees WHERE department_id = cp_department_id;
BEGIN
    -- 2. 호출 -- 커서를 실행합니다(전달인수로 부서번호 90을 넣어줍니다)
    OPEN cur_emp_dept(90);
    
    -- 3. 반복실행문으로 커서에 저장된 데이터를 거내서 출력합니다
    LOOP
        -- 반복이 실행되는 동안 커서의 저장된 데이터를 한행씩 꺼내서 vs_employee_id, vs_emp_name 변수에 저장합니다
        FETCH cur_emp_dept INTO vs_employee_id, vs_emp_name;
        EXIT WHEN cur_emp_dept%NOTFOUND; -- 다음 레코드가 없을때까지 반복합니다
        DBMS_OUTPUT.PUT_LINE(vs_employee_id || '-' || vs_emp_name); -- 꺼낸 내용을 출력
    END LOOP;
END;

--100-Steven King
--101-Neena Kochhar
--102-Lex De Haan


-- 커서와 FOR 문
--기존의 FOR 문
--FOR 인덱스변수 IN [REVERSE] 처음값.. 끝값
--LOOP
--    실행문
--END LOOP;
---------------------------------------------------------------------------------------
--
--커서와 함께 사용하는 FOR문
--FOR 레코드변수 IN 커서이름(전달인수1, 전달인수2..)
--LOOP
--    실행문
--END LOOP;
-------------------------------------------------------------------------------------

-- FOR 레코드 변수 IN 커서이름(전달인수1, 전달인수2..) : OPEN 으로 실행(호출)하던 동작이 FOR문의 IN다음으로 이동
-- 실행결과는 하나씩(1행, 1레코드) 레코드 변수에 저장되어 반복실행되빈다.
-- 자동으로 실행결과의 갯수만큼 반복실행됩니다

DECLARE
    -- 레코드 변수를 사용하기 때문에 각 필드값을 저장할 변수는 만들지 않습니다
    CURSOR cur_emp_dept(cp_department_id employees.department_id%TYPE)
    IS
    SELECT employee_id, emp_name FROM employees WHERE department_id = cp_department_id;
BEGIN
    FOR emp_rec IN cur_emp_dept(90)
    LOOP
        DBMS_OUTPUT.PUT_LINE(emp_rec.employee_id || '-' || emp_rec.emp_name); 
    END LOOP;
END;
--100-Steven King
--101-Neena Kochhar
--102-Lex De Haan


-- 조금더 간결한 FOR 문과 커서의 사용
DECLARE
BEGIN
    FOR emp_rec IN (SELECT employee_id, emp_name
                    FROM employees
                    WHERE department_id = 90)
    LOOP
        DBMS_OUTPUT.PUT_LINE(emp_rec.employee_id || '-' || emp_rec.emp_name);         
    END LOOP;
END;

--100-Steven King
--101-Neena Kochhar
--102-Lex De Haan

-- 연습문제
-- 부서번호가 30번인 사원의 이름, 부서명, 급여, 급여(높음, 보통, 낮음) 을 출력하세요
-- 급여(salary는 5000 미만 낮은, 10000 미만 보통 나머지 높음 으로 출력하세요
-- 이름 - 부서명 - 급여 - 높음 순으로 출력하세요
SELECT * FROM employees;
DECLARE
    vn_salary_value VARCHAR2(30);
BEGIN
    FOR emp_rec IN (SELECT emp_name, employee_id, salary FROM employees WHERE department_id=30)
    LOOP
        IF emp_rec.salary < 5000 THEN
            vn_salary_value := '낮음';
        ELSIF emp_rec.salary < 10000 THEN
            vn_salary_value := '보통';
        ELSE
            vn_salary_value := '높음';
        END IF;
        DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name || '-' || emp_rec.employee_id || '-' || emp_rec.salary || '-' || vn_salary_value);         
    END LOOP;
END;

--Den Raphaely-114-11000-높음
--Alexander Khoo-115-3100-낮음
--Shelli Baida-116-2900-낮음
--Sigal Tobias-117-2800-낮음
--Guy Himuro-118-2600-낮음
--Karen Colmenares-119-2500-낮음
DECLARE
    vn_salary_value VARCHAR2(30);
BEGIN
    FOR emp_rec IN (SELECT emp_name, employee_id, salary FROM employees WHERE department_id=30)
    LOOP
        IF emp_rec.salary BETWEEN 1 AND 5000 THEN
            vn_salary_value := '낮음';
        ELSIF emp_rec.salary BETWEEN 5001 AND 10000 THEN
            vn_salary_value := '보통';
        ELSE
            vn_salary_value := '높음';
        END IF;
        DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name || '-' || emp_rec.employee_id || '-' || emp_rec.salary || '-' || vn_salary_value);         
    END LOOP;
END;

DECLARE
    level VARCHAR2(10);
BEGIN
    FOR emp_rec IN (SELECT a.emp_name, b.department_name, a.salary FROM employees a, departments b 
                        WHERE a.department_id=30 AND a.department_id = b.department_id)
     LOOP
        IF emp_rec.salary <= 5000 THEN
            level := '낮음';
        ELSIF emp_rec.salary <= 10000 THEN
            level := '보통';
        ELSE
            level := '높음';
        END IF;
        DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name || '-' || emp_rec.department_name || '-' || emp_rec.salary || '-' || level);         
    END LOOP;
END;

-- 커서 변수
-- TYPE 사용할 커서의 타입이름 ID REF CURSOR [RETURN 반환타입] ; -> 생성된 커서타임의 이름으로 커서 변수를 선언할 예정입니다
-- 커서변수이름 커서타입이름;
-- 커서 타입을 만들때 RETURN 값을 지정하면 강한 커서타입이 생성되는것이고, RETURN 이 없으면 약한 커서타입이라고 지칭합니다
--TYPE dep_curtype1 IS REF CURSOR RETURN departments&ROWTYPE; -- 강한 커서타입
--TYPE dep_curtype2 IS REF CURSOR; -- 약한 커서타입

-- 위 두줄의 명령은 커서의 이름을 생성한 것이 아니라, 커서를 선언할 수 있는 커서자료형을 생성한겁니다
-- 생성된 커서 자료형을 커서 변수를 생성할 수 있습니다

cursor1 dep_curtype1;
cursor2 dep_curtype2;
-- cursor1과 cursor2 변수에는 select 명령을 담아서 커서를 완성할 수 있습니다
-- 또한 커서내용(select 문)이 고정적이지 않고 바뀔 수 있습니다
-- 다만 cursor1 은 강한 커서 타압이므로 정의되어 있는데로 (RETURN departments%ROWTYPE) 레코드 전체의 결과를 얻는 select 만 저장할 수 있습니다

OPEN cursor1 FOR SELECT employee_id, emp_name FROM employees WHERE department_id = 90; -- 리턴타입이 맞지 않기 때문에 불가능
OPEN cursor1 FOR SELECT * FROM departments WHERE department_id = 90; -- 가능

-- 어떤 SELECT 구문이 와도가능
OPEN cursor2 FOR SELECT employee_id, emp_name FROM employees WHERE department_id = 90; -- 가능
OPEN cursor2 FOR SELECT * FROM departments WHERE department_id = 90; -- 가능

-- 커서변수를 만들어서 필요할때마다 커서 내용을 저장하고 호출해서 그 결과를 사용하려고 변수를 만듭니다
DECLARE
    vs_emp_name employees.emp_name%TYPE; -- 일반 변수 선언
    TYPE emp_dept_curtype IS REF CURSOR; -- 약한 커서타입 선언
    emp_dept_curvar emp_dept_curtype; -- 생성한 커서타입으로 커서 변수 선언
BEGIN
    OPEN emp_dept_curvar FOR SELECT emp_name FROM employees WHERE department_id = 90; -- 커서변수에 select 문 설정
    LOOP
        FETCH emp_dept_curvar INTO vs_emp_name;
        EXIT WHEN emp_dept_curvar%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vs_emp_name);
    END LOOP;
END;

--Steven King
--Neena Kochhar
--Lex De Haan

dep_curtype3 SYS_REFCURSOR; -- 시스템에서 제공해주는 커서 타입

-- SYS_REFCURSOR 를 사용하면
--TYPE emp_dep_curtype IS REF CURSOR; -- 커서타입 생성 생략가능
--emp_dep_curvar emp_dep_curtype; -- 변수 선언 SYS_REFCURSOR 형태로 선언
DECLARE
    vs_emp_name employees.emp_name%TYPE; 
    vs_salary employees.salary%TYPE; 
    emp_dep_curvar SYS_REFCURSOR; -- SYS_CURSOR 타입의 커서변수 선언
BEGIN
    OPEN emp_dep_curvar FOR SELECT emp_name, salary FROM employees WHERE department_id = 90; -- 커서변수에 select 문 설정
    LOOP
        FETCH emp_dep_curvar INTO vs_emp_name, vs_salary;
        EXIT WHEN emp_dep_curvar%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vs_emp_name || '-' || vs_salary);
    END LOOP;
END;
--Steven King-24000
--Neena Kochhar-17000
--Lex De Haan-17000
--1. SYS_REFCURSOR 변수 생성
--2. 변수에 select 연결
--3. FETCH 로 꺼내서 처리

-- 프로시저에서의 커서 사용 예 -- SELECT 의 결과를 커서에 담아서 프로시저를 호출한 지점에 보내주려 합니다
CREATE OR REPLACE PROCEDURE testCursorArg(
    p_curvar OUT SYS_REFCURSOR
)
IS
    temp_curvar SYS_REFCURSOR; -- 프로시저에서 사용할 커서 변수
BEGIN
    OPEN temp_curvar FOR SELECT emp_name, salary FROM employees WHERE department_id=90;
    -- 현재 위치에서 커서의 내요을 FETCH 할게 아니라 반복실행도 FETCH 도 쓰지 않습니다
    p_curvar := temp_curvar;
END;

DECLARE
    out_curvar SYS_REFCURSOR; -- 커서변수 생성
    vs_emp_name employees.emp_name%TYPE;
    vs_salary employees.salary%TYPE;
BEGIN
    testCursorArg(out_curvar);
    LOOP
        FETCH out_curvar INTO vs_emp_name, vs_salary;
        EXIT WHEN out_curvar%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vs_emp_name || '-' || vs_salary);        
    END LOOP;
END;

--Steven King-24000
--Neena Kochhar-17000
--Lex De Haan-17000
-- mybatis 에서 프로시저 실행시 조회 데이터를 전달하는 중요한 역할을 하는 것이 cursor 입니다
-- 따라서 위의 예제는 커서를 전달인수로 전달해서 조회결과를 담아올 수 있는 형식으로 이루어짐과 동시에
-- mybatis 에서 사용하기 딱 좋은 형식이므로 중요한 예제로 기억해두고 필요시 참고하시는 것이 좋습니다
