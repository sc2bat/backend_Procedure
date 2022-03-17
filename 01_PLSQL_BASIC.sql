commit;

SELECT * FROM tab;

-- test
-- 다수의 SQL 명령이 모여서 하나의 작업모듈 또는 트랜잭션을 이룰때 이를 하나의 블럭으로 묶어서 
-- 한번에 실행하게하는 단위실행명령입니다

-- 예를 들어 shoes shop 쇼핑몰 예제의경우, 장바구니에 있던 상품들을 주문하려고 할때
-- Orders 테이블에 새로운 레코드 insert
-- Orders 테이블ㅇ서 가장 큰 oseq 조회
-- 장바구니에서 상품목록을 조회
-- 조회된 oseq 와 상품 목록을 order_detail 에 insert
-- 장바구니에서 방금 주문한 상품 삭제

-- 위 동작을 오라클이 제공하는 프로그래밍 요소와 함께 SQL 명령 그룹(블럭)을 만들어 한번에 실행할 수 있게 합니다
-- 그렇게 만들어진 PL/SQL 블럭은 MyBatis 에서 활용됩니다


-- 구성요소

-- 블럭
-- PL/SQL 에는 여러 블럭으로 구성되어 있는데, 쉽게 짐작할 수 있는 실행할 SQL 명령이 모여있는 블럭 등이 있으며,
-- 이는 명령의 실행단위가 됩니다.
-- 이외 익명 블럭, 이름이 있는 블럭 등도 있고, 기능별로 이름부, 선언부, 실행부, 예외처리부로도 나누기도 합니다

-- PL/SQL 문의 구성에 
-- PL/SQL 로 하나의 단위명령을 실행할 때 아래와 같이 각 위치, 기능별 구성이 이루어 집니다

IS(AS)
-- 이름부
DECLARE
-- 선언부 (변수 선언 등등)
BEGIN
-- 실행부 (SQL 명령)
EXCEPTION
-- 예외처리부 
END;
-- BEGIN, END 를 제외한 나머지는 필요에 의해 생략이 가능합니다

-- 익명 블럭

DECLARE
    num NUMBER(10); -- 변수 선언
    
BEGIN
    num := 100; -- 실행 명령1
    DBMS_OUTPUT.PUT_LINE(num); -- 실행 명령2
END;

-- 화면 출력을 하기위해 기능을 ON 합니다
SET SERVEROUTPUT ON
-- 실행 시간을 출력하기 위한 기능을 ON 합니다
--SET TIMING ON
--SET TIMING OFF

-- 우리의 현재 목표는 웹사이트에서 전달받은 전달인수로 연산(SQL) 하고 결과를 웹사이트로 다시 리턴해주는 것이지만
-- 현재는 그 상황까지 공부하지 않았기에 내가 값을 넣어주고(num := 100;), 결과를 화면으로 출력하빈다 DBMS_OUTPUT.PUT_LINE(num);

-- 변수 : 첫번째 SQL 에서 Orders 테이블에 레코드를 삽입하고, 가장 큰 oseq 를 조회한 다음 
-- 그 값을 order_detail의 입력값으로 사용하려면 변수를 선언하고 값을 저장해서 활용합니다

-- 변수 선언방법
-- 변수명 변수자료타입 := 초기값; SQL 명령내의 '='과 구분하기 위해 := 으로 사용합니다

-- PL/SQL 의 자료형
-- 기존의 SQL 자료형은 모두 포함하며, 자유롭게 사용할 수 있습니다
-- BOOLEAN : TRUE, FALSE, NULL 을 갖을 수 있는 자료형
-- PLS_INTEGER : -2147483649 ~ 2147483647 값을 갖는 정수 NUMBER 형에 비해 저장 공간을 덜 차지합니다
-- BINARY_INTEGER : PLS_INTEGER 와 같은 용량 같은 용도로 사용합니다
-- NATRAL : PLS_INTESER 중 양수(0포함)
-- NATRALN : NATRAL 과 같지만, NULL 허용이 없고 선언과 동시에 초기화가 필요합니다.
-- POSITIVE : PLS_INTEGER 중 음수(0 미포함)
-- POSITIVEN : POSITIVE 와 같지만, NULL 허용이 없고 선언과 동시에 초기화가 필요합니다
-- SIGNTYPE : -1, 0, 1
-- SIMPLE_INTEGER : PLS_INTEGER 중 NULL 이 아닌 모든 값, 선언과 동시에 초기화가 필요합니다

-- 연산자
-- ** : 제곱(자승) 연산 -> 3**4 3의4승
-- +, - : 양수 음수 구분 연산
-- 사칙연산 +, -, *, /, ||(문자연결)
-- 비교연산 =, >, <, >=, <=, <>, !=, IS NULL, LIKE, BETWEEN, IN
-- 논리연산 NOT AND OR

DECLARE
    a INTEGER := 2**2*3**2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a = ' || TO_CHAR(a));
END;

-- BEGIN 등의 각영역은 한문장의 SQL 문도 하나의 명령어로, 연산자를 포함한 일반명령어도 하나의 명령어로 인식해서
-- 맨 뒤에 ';' 이 있는 곳까지 실행

-- SQL 명령과 같이 실행되는 PL/SQL 
-- 사원번호가 100인 사원의 이름
SELECT emp_name FROM employees WHERE employee_id=100;

DECLARE
    e_name VARCHAR2(30);
BEGIN
    SELECT emp_name 
    INTO e_name -- SELECT 문에서 결과를 변수로 저장하는 방법
    FROM employees 
    WHERE employee_id=100;
    DBMS_OUTPUT.PUT_LINE(e_name);
END;


-- SELECT 문에 의해서 도출된 결과가 2개 이상이라면 SQL 실행결과를 담을 변수를 INTO 절에 결과 필드의 순서에 맞게 위치시킵니다
-- 사원번호가 100인 사원의 이름과 부서명
SELECT emp_name, department_id FROM employees WHERE employee_id=100;


DECLARE
    vs_emp_name VARCHAR2(80); -- 사원명 변수
    vs_dept_name VARCHAR2(80);  -- 부서명 변수
BEGIN
    SELECT emp_name, department_id
    INTO vs_emp_name, vs_dept_name -- 
    FROM employees 
    WHERE employee_id=100;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_dept_name);
END;
-- Steven King - 90

-- 변수의 갯수가 많은 경우 자료형을 일일히 맞춰서 선언하기가 번거로우므로, 
-- 매칭할 필드의 이름과 %Type 을 이요하여 자동으로 자료형이 맞춰지도록 합니다

DECLARE
    e_name employees.emp_name%TYPE;
    d_id employees.department_id%TYPE;
BEGIN
    SELECT emp_name, department_id
    INTO e_name, d_id
    FROM employees
    WHERE employee_id=100;
    DBMS_OUTPUT.PUT_LINE(e_name || ' - ' || d_id);
END;
-- Steven King - 90


-- 연습문제1
-- DBMS_OUTPUT.PUT_LINE(); 을 9번 사용하여 구구단 3단을 출력하는 익명 블럭을 제작하세요
-- 이어붙이기 연산도 사용합니다
-- 현재는 변수가 필요하지 않기 때문에 DECLARE 도 쓰지 않아도 됩니다
-- 3X1=3 3X2=6 3X3=9 3X4=12 3X5=15 
BEGIN
    DBMS_OUTPUT.PUT_LINE('3*1=' || 3*1);
    DBMS_OUTPUT.PUT_LINE('3*2=' || 3*2);
    DBMS_OUTPUT.PUT_LINE('3*3=' || 3*3);
    DBMS_OUTPUT.PUT_LINE('3*4=' || 3*4);
    DBMS_OUTPUT.PUT_LINE('3*5=' || 3*5);
    DBMS_OUTPUT.PUT_LINE('3*6=' || 3*6);
    DBMS_OUTPUT.PUT_LINE('3*7=' || 3*7);
    DBMS_OUTPUT.PUT_LINE('3*8=' || 3*8);
    DBMS_OUTPUT.PUT_LINE('3*9=' || 3*9);
END;

-- 연습문제2
-- 사원테이블(employees)에서 201 번 사원의 이름과 이메일주소를 출력하는 익명 블록을 만드세요
-- 이름 - 이메일 형식으로 스크립트 출력하세요
SELECT * FROM employees;

DECLARE
    var_emp_name employees.emp_name%TYPE;
    var_email employees.email%TYPE;
BEGIN
    SELECT emp_name, email
    INTO var_emp_name, var_email
    FROM employees
    WHERE employee_id=201;
    DBMS_OUTPUT.PUT_LINE(var_emp_name || ' - ' || var_email);
END;
-- Michael Hartstein - MHARTSTE

-- 연습문제3
-- SELECT 로 얻어낸 값을 INSERT 명령에 사용합니다
-- 사원테이블(employees) 테이블에서 가장 큰 사원번호로 조회되고,
-- 그 사원번호보다 1 만큼 큰 숫자를 새롱누 입력 레코드의 사원번호로 하여 레코드르 추가하세요
-- 나머지 입력사항 : 
-- 사원명 : Harrison Ford
-- 이메일 : HARRISON
-- 입사일짜 : 현재 날짜
-- 부서번호 : 50
-- 실행부에서 마지막 명령 commit; 을 넣어주세요
SELECT * FROM employees;

DECLARE
    max_id employees.employee_id%TYPE;
BEGIN
    SELECT MAX(employee_id)
    INTO max_id
    FROM employees;
    
    INSERT INTO employees(employee_id, emp_name, email, hire_date, department_id) VALUES(max_id+1, 'Harrison Ford', 'HARRISON', sysdate, 50);
    
    DBMS_OUTPUT.PUT_LINE(max_id);
END;

COMMIT; -- INSERT UPDATE DELETE 명령 뒤에는 반드시 COMMIT 을 사용합니다

SELECT * FROM employees;




























































