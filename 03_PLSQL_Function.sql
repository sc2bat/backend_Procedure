-- 함수
--PL/SQL 코드 작성시에는 지금까지 사용하던 익명 블럭은 잘 사용하지 않습니다
--일반적으로 이름이 있는 서브 프로그램(함수) 또는 프로시저를 사용하는 것이 대부분입니다
--익명 블럭은 한 번 사용하고 나면 없어져 버리는 휘발성 블럭이지만
--함수 또는 프로시저는 컴파일을 거쳐 데이터베이스에 저장되어 재사용이 가능한 구조입니다

-- 함수의 형태
-- CREATE OR REPLACE FUNCTION 함수이름(매개변수1, 매개변수2 ...)
--RETURN 데이터타입;
--IS[AS]
--    변수, 상수 선언
--BEGIN
--    실행부
--    RETURN 리턴값;
--    [EXCEPTION 
--        예외처리부]
--END [함수이름]; -- 함수이름 생략가능

--상세내용
--CERATE OR REPLACE FUNCTION : CREATE OR REPLACE FUNCTION 라는 구문을 이요하여 함수를 생성합니다
--함수를 만들고 수정하더라도 이 구문을 계속 컴파일 할수 있고,
--마지막으로 컴파일 한 내용이 함수의 내용과 이름으로 사용됩니다

--매개변수 : 전달인수를 저장하는 변수로 "변수이름 변수의 자료형" 형태로 작성합니다
--첫번째 RETURN 구분 다음에는 리턴될 자료의 자료형을 쓰고,
--아래쪽 두번째 RETURN 구문 옆에는 그 자료형으로 실제 리턴될 값 또는 변수 이름을 써줍니다

-- 두개의 정수를 전달해서 첫번재값을 두번째 값으로 나눈 나머지를 구해 리턴해주는 함수
CREATE OR REPLACE FUNCTION myMod(num1 NUMBER, num2 NUMBER)
    RETURN NUMBER
IS
    vn_remainder NUMBER := 0; -- 나머지를 저장할 변수
    vn_quotient NUMBER := 0; -- 몫을 저장할 변수
BEGIN
    vn_quotient := FLOOR(num1 / num2); -- 나눈 몫에서 정수만 저장(소수점 절사)
    vn_remainder := num1 - (num2 * vn_quotient); -- 몫 * 젯수로 피젯수를 빼면 나머지 계산
    RETURN vn_remainder; -- 나머지 반환
--END mymod;
END;

SELECT myMod(14, 3) FROM dual;

-- 함수와 select 문을 동시에 실행하면 PLS-00103: Encountered the symbol "SELECT" 에러 발생 나눠서 실행할것

SELECT * FROM countries;

CREATE OR REPLACE FUNCTION fn_getCountryName(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE; -- 나라이름을 저장할 변수
BEGIN
    SELECT country_name
    INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    RETURN vs_country_name;
END;

SELECT fn_getCountryName(52790) FROM dual;
--United States of America

-- 위 select 명령 실행시 10000 번 id 는 '해당국가 없음' 이라고 출력되도록 fn_getCountryName 함수를 수정하세요


CREATE OR REPLACE FUNCTION fn_getCountryName(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE; -- 나라이름을 저장할 변수
BEGIN
    SELECT country_name
    INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    IF vs_country_name IS NULL THEN
        vs_country_name := '해당국가 없음';   
    END IF;
    RETURN vs_country_name;
END;
SELECT fn_getCountryName(52790), fn_getCountryName(10000) FROM dual;
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getCountryName(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE; -- 나라이름을 저장할 변수
    vn_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vn_count FROM countries WHERE country_id = p_country_id;
    IF vn_count = 0 THEN
        vs_country_name := '해당국가 없음';
    ELSE
        SELECT country_name INTO vs_country_name FROM countries WHERE country_id = p_country_id;
    END IF;
    RETURN vs_country_name;
END;
SELECT fn_getCountryName(52790), fn_getCountryName(10000) FROM dual;


-- 매개변수가 없는 함수
CREATE OR REPLACE FUNCTION fn_get_user -- 매개변수가 없는 함수는 괄호 없이 정의하기도 합니다
    RETURN VARCHAR2 -- 반환 데이터 타입은 VARCHAR2
IS
    vs_user_name VARCHAR2(80);
BEGIN
    SELECT USER
    INTO vs_user_name
    FROM DUAL;
    RETURN vs_user_name; -- 사용자 이름 반환
END;

SELECT fn_get_user(), fn_get_user FROM DUAL; -- 매개변수가 없는 함수는 괄호 없이 호출하기도 합니다
--SCOTT	SCOTT

-- 연습 문제
-- employees 테이블에서 각 부서 번호를 입력받아서 급여의 평균을 계산하는 함수를 생성하세요
-- 부서의 인원이 없으면, 평균값은 0으로 출력합니다
-- 실행중 함수의 호출은 아래와 같습니다
SELECT salAvgDept(10), salAvgDept(20), salAvgDept(30), salAvgDept(120) FROM dual;

--CREATE OR REPLACE FUNCTION salAvgDept(vn_department_id NUMBER)
--    RETURN DOUBLE
--IS
--    vn_cnt NUMBER := 0;
--    vn_avg DOUBLE := 0;
--BEGIN
--    SELECT COUNT(*) INTO vn_cnt FROM employees WHERE department_id = vn_department_id;
--    IF vn_cnt = 0 THEN
--        vn_avg := 0;
--    ELSE
--        SELECT AVG(salary) INTO vn_avg FROM employees WHERE department_id = vn_department_id GROUP BY salary;
--    END IF;
--    RETURN vn_avg;
--END;

CREATE OR REPLACE FUNCTION salAvgDept(p_deptNo NUMBER)
    RETURN NUMBER
IS
    vn_avg NUMBER := 0;
    vn_cnt NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vn_cnt FROM employees WHERE department_id = p_deptNo;
    IF vn_cnt = 0 THEN
        vn_avg := 0;
    ELSE
        SELECT AVG(salary) INTO vn_avg FROM employees WHERE department_id = p_deptNo;
    END IF;
    RETURN vn_avg;
END;

SELECT salAvgDept(10), salAvgDept(20), salAvgDept(30), salAvgDept(120) FROM dual;
--4400	9500	4150	0














