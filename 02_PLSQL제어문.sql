--IF 문
--경우의 수가 둘 중 하나이고, 단독 if 로 사용할때 
--if 조건 then
--    실행문1
--end if
--
--경우의 수가 둘 중 하나이고, else 와 함께 사용할때
--if 조건 then
--    실행문1
--else
--    실행문2
--end if
--
--경우의 수가 셋 이상일 때
--if 조건1 then
--    실행문1
--elsif 조건2 then    문법 자체가 elesif 가 아니라 elsif 임
--    실행문2
--else
--    실행문3
--end if



DECLARE
    vn_num1 NUMBER := 1;
    vn_num2 NUMBER := 2;
BEGIN
    IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '이 큰 수');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 || '이 큰 수');
    END IF;
END;

-- employees 테이블에서 사우너 한명을 선별하여, 그 월급(salary) 의 금액에 따라
--낮음, 중간, 높음 이라는 단어를 출력하는 익명 블럭을 제작합니다 (1 ~ 3000 낮음 3001~6000 보통 6001~10000 높음)
--사원을 선별하는 방법은 RANDOM.VALUE 함수를 이용합니다. 
--랜덤한 부서번호로 조회하되그 부서에 사원이 여럿이면 첫번째 사원으로 선택

DECLARE
    -- 선택된 사원의 급여-월급(salary) 를 저장할 변수
    vn_salary NUMBER := 0;
    -- 랜덤으로 발생한 부서번호를 저장할 변수
    vn_department_id NUMBER := 0;
BEGIN
    -- 랜덤하게 부서번호를 발생
    -- DBMS_RANDOM.VALUE(시작숫자, 끝숫자) : 시작 숫자부터 끝숫자 사이의 임의 숫자를 발생
    -- ROUND(숫자, 반올림자리수) : 숫자를 지정된 반올림자리에서 반올림합니다
    -- 반올림자리수가 1 이면 소수점둘째자리에서 반올림해서 첫째자리까지 남김
    -- 반올림자리수가 2 이면 소수점셋째자리에서 반올림해서 둘째자리까지 남김
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
    DBMS_OUTPUT.PUT_LINE(vn_department_id);
    SELECT salary
    INTO vn_salary
    FROM employees
    WHERE department_id = vn_department_id AND ROWNUM = 1;
    
    IF vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('낮음');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('보통');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('높음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('최상위');
    END IF;
END;


-- 중첩 IF 문
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
    vn_commission NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
    SELECT salary, nvl(commission_pct, 1)
    INTO vn_salary, vn_commission
    FROM employees
    WHERE department_id = vn_department_id AND ROWNUM = 1;
    IF vn_commission > 0 THEN
        IF vn_commission < 0.15 THEN
            DBMS_OUTPUT.PUT_LINE('vn_salary * vn_commission =' || vn_salary * vn_commission);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('vn_salary' || vn_salary);
        END IF;
    END IF;
--    IF vn_commission != NULL THEN
--        IF vn_commission > 0 THEN
--            IF vn_commission < 0.15 THEN
--                DBMS_OUTPUT.PUT_LINE('vn_salary * vn_commission = ' || vn_salary * vn_commission);
--            ELSE 
--                DBMS_OUTPUT.PUT_LINE('vn_salary = ' || vn_salary);
--            END IF;
--        END IF;
--    ELSE
--        DBMS_OUTPUT.PUT_LINE('vn_salary' || vn_salary);
--        DBMS_OUTPUT.PUT_LINE('vn_commission' || vn_commission);        
--    END IF;
END;

-- CASE 문
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
    vn_commission NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
    SELECT salary
    INTO vn_salary
    FROM employees
    WHERE department_id = vn_department_id AND ROWNUM = 1;
    
    CASE 
    WHEN vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('낮음');
    WHEN vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('보통');
    WHEN vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('높음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('최상위');
    END CASE;
END;

-- CASE 유형 1
--CASE
--    WHEN 조건식 1 THEN
--        실행문1
--    WHEN 조건식 2 THEN
--        실행문2
--    ELSE
--        실행문3
--END CASE;

-- CASE 유형 2
-- CASE 조건식 또는 표현식 또는 변수
--CASE
--    WHEN 값 1 THEN
--        실행문1
--    WHEN 값 2 THEN
--        실행문2
--    ELSE
--        실행문3
--END CASE;

-- LOOP 문
-- 반복실행 유형1
-- LOOP
--    실행문;
--    EXIT [WHEN 조건];
--END LOOP;

DECLARE
    vn_base_num NUMBER := 4; -- 단
    vn_cnt NUMBER := 1; -- 반복 제어 변수겸 승수
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || ' x ' || vn_cnt || ' = ' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;
        EXIT WHEN vn_cnt > 9;
    END LOOP;
END;

--4 x 1 = 4
--4 x 2 = 8
--4 x 3 = 12
--4 x 4 = 16
--4 x 5 = 20
--4 x 6 = 24
--4 x 7 = 28
--4 x 8 = 32
--4 x 9 = 36
--
--EIXT 미사용시
--
--오류 보고 -
--ORA-20000: ORU-10027: buffer overflow, limit of 1000000 bytes
--ORA-06512: at "SYS.DBMS_OUTPUT", line 32
--ORA-06512: at "SYS.DBMS_OUTPUT", line 97
--ORA-06512: at "SYS.DBMS_OUTPUT", line 112
--ORA-06512: at line 6
--20000. 00000 -  "%s"
--*Cause:    The stored procedure 'raise_application_error'
--           was called which causes this error to be generated.

--반복실행 유형2
--WHILE 조건
--LOOP
--    실행문
--END LOOP;

DECLARE
    vn_base_num NUMBER := 6; -- 단
    vn_cnt NUMBER := 1; -- 반복 제어 변수겸 승수
BEGIN
    WHILE vn_cnt <= 9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || ' x ' || vn_cnt || ' = ' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;


--6 x 1 = 6
--6 x 2 = 12
--6 x 3 = 18
--6 x 4 = 24
--6 x 5 = 30
--6 x 6 = 36
--6 x 7 = 42
--6 x 8 = 48
--6 x 9 = 54

--WHILE 과 EXIT WHEN 의 혼합사용

DECLARE
    vn_base_num NUMBER := 7; -- 단
    vn_cnt NUMBER := 1; -- 반복 제어 변수겸 승수
BEGIN
    WHILE vn_cnt <= 9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || ' x ' || vn_cnt || ' = ' || vn_base_num * vn_cnt);
        EXIT WHEN vn_cnt = 5;
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;

--7 x 1 = 7
--7 x 2 = 14
--7 x 3 = 21
--7 x 4 = 28
--7 x 5 = 35

--FOR 문 
--
--FOR 변수명 IN [REVERSE] 시작값... 끝값
--LOOP
--    실행문
--END LOOP;
--시작값부터 끝값까지 반복실행합니다. REVERSE 쓰여진경우, 반대방향의 숫자진행으로 반복실행

DECLARE
    vn_base_num NUMBER := 8;
BEGIN
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

-- REVERSE 사용
DECLARE
    vn_base_num NUMBER := 8;
BEGIN
    FOR i IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE('REVERSE 사용 ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

-- CONTINUE 사용
DECLARE
    vn_base_num NUMBER := 9;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i = 5; -- 조건이 충족하면 반복실행 영역중 나머지 명령을 실행하지 않고 다음 반복으로 진행
        DBMS_OUTPUT.PUT_LINE('CONTINUE 사용 ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

--FOR 문 사용시 IN 시작값과 끝값 사이에 . 은 단 2개만 사용하여야 한다
--ORA-06550: line 4, column 15:
--PLS-00103: Encountered the symbol "." when expecting one of the following:
--
--   * & - + / at mod remainder rem .. <an exponent (**)> ||
--   multiset
--The symbol ".. was inserted before "." to continue.
--06550. 00000 -  "line %s, column %s:\n%s"
--*Cause:    Usually a PL/SQL compilation error.

-- GOTO 문 -- 추천되지 않는 반복문
DECLARE
    vn_base_num NUMBER := 9;
BEGIN
    <<fifth>> -- 라벨이라고 부릅니다. GOTO 문의 이동 목적지로 사용되곤 합니다
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE('GOTO 사용 ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
        IF i = 3 THEN
             GOTO sixth;
        END IF;
    END LOOP; 
    
    <<sixth>> 
    vn_base_num := 6;
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE('GOTO 사용 ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

--NULL 문 : IF 문 또는 CASE WHEN 등에서 해당 경우에 실행해야할 명령이 하나도 없을 때 쓰는 구문입니다
--IF vn_variable = 'A' THEN
--    처리로직1;
--ELSIF vn_variable = 'B' THEN
--    처리로직2;
--...
--ELSE NULL;
--END IF;

--CASE 
--    WHEN vn_variable = 'A' THEN
--        처리로직1;
--    WHEN vn_variable = 'B' THEN
--        처리로직2;
--    ...
--    ELSE 
--        NULL;
--END CASE;





















SET SERVEROUTPUT ON
SELECT * FROM employees;

