commit;

SELECT * FROM tab;

-- test
-- �ټ��� SQL ����� �𿩼� �ϳ��� �۾���� �Ǵ� Ʈ������� �̷궧 �̸� �ϳ��� ������ ��� 
-- �ѹ��� �����ϰ��ϴ� �����������Դϴ�

-- ���� ��� shoes shop ���θ� �����ǰ��, ��ٱ��Ͽ� �ִ� ��ǰ���� �ֹ��Ϸ��� �Ҷ�
-- Orders ���̺� ���ο� ���ڵ� insert
-- Orders ���̺��� ���� ū oseq ��ȸ
-- ��ٱ��Ͽ��� ��ǰ����� ��ȸ
-- ��ȸ�� oseq �� ��ǰ ����� order_detail �� insert
-- ��ٱ��Ͽ��� ��� �ֹ��� ��ǰ ����

-- �� ������ ����Ŭ�� �����ϴ� ���α׷��� ��ҿ� �Բ� SQL ��� �׷�(��)�� ����� �ѹ��� ������ �� �ְ� �մϴ�
-- �׷��� ������� PL/SQL ���� MyBatis ���� Ȱ��˴ϴ�


-- �������

-- ��
-- PL/SQL ���� ���� ������ �����Ǿ� �ִµ�, ���� ������ �� �ִ� ������ SQL ����� ���ִ� �� ���� ������,
-- �̴� ����� ��������� �˴ϴ�.
-- �̿� �͸� ��, �̸��� �ִ� �� � �ְ�, ��ɺ��� �̸���, �����, �����, ����ó���ηε� �����⵵ �մϴ�

-- PL/SQL ���� ������ 
-- PL/SQL �� �ϳ��� ��������� ������ �� �Ʒ��� ���� �� ��ġ, ��ɺ� ������ �̷�� ���ϴ�

IS(AS)
-- �̸���
DECLARE
-- ����� (���� ���� ���)
BEGIN
-- ����� (SQL ���)
EXCEPTION
-- ����ó���� 
END;
-- BEGIN, END �� ������ �������� �ʿ信 ���� ������ �����մϴ�

-- �͸� ��

DECLARE
    num NUMBER(10); -- ���� ����
    
BEGIN
    num := 100; -- ���� ���1
    DBMS_OUTPUT.PUT_LINE(num); -- ���� ���2
END;

-- ȭ�� ����� �ϱ����� ����� ON �մϴ�
SET SERVEROUTPUT ON
-- ���� �ð��� ����ϱ� ���� ����� ON �մϴ�
--SET TIMING ON
--SET TIMING OFF

-- �츮�� ���� ��ǥ�� ������Ʈ���� ���޹��� �����μ��� ����(SQL) �ϰ� ����� ������Ʈ�� �ٽ� �������ִ� ��������
-- ����� �� ��Ȳ���� �������� �ʾұ⿡ ���� ���� �־��ְ�(num := 100;), ����� ȭ������ ����Ϻ�� DBMS_OUTPUT.PUT_LINE(num);

-- ���� : ù��° SQL ���� Orders ���̺� ���ڵ带 �����ϰ�, ���� ū oseq �� ��ȸ�� ���� 
-- �� ���� order_detail�� �Է°����� ����Ϸ��� ������ �����ϰ� ���� �����ؼ� Ȱ���մϴ�

-- ���� ������
-- ������ �����ڷ�Ÿ�� := �ʱⰪ; SQL ��ɳ��� '='�� �����ϱ� ���� := ���� ����մϴ�

-- PL/SQL �� �ڷ���
-- ������ SQL �ڷ����� ��� �����ϸ�, �����Ӱ� ����� �� �ֽ��ϴ�
-- BOOLEAN : TRUE, FALSE, NULL �� ���� �� �ִ� �ڷ���
-- PLS_INTEGER : -2147483649 ~ 2147483647 ���� ���� ���� NUMBER ���� ���� ���� ������ �� �����մϴ�
-- BINARY_INTEGER : PLS_INTEGER �� ���� �뷮 ���� �뵵�� ����մϴ�
-- NATRAL : PLS_INTESER �� ���(0����)
-- NATRALN : NATRAL �� ������, NULL ����� ���� ����� ���ÿ� �ʱ�ȭ�� �ʿ��մϴ�.
-- POSITIVE : PLS_INTEGER �� ����(0 ������)
-- POSITIVEN : POSITIVE �� ������, NULL ����� ���� ����� ���ÿ� �ʱ�ȭ�� �ʿ��մϴ�
-- SIGNTYPE : -1, 0, 1
-- SIMPLE_INTEGER : PLS_INTEGER �� NULL �� �ƴ� ��� ��, ����� ���ÿ� �ʱ�ȭ�� �ʿ��մϴ�

-- ������
-- ** : ����(�ڽ�) ���� -> 3**4 3��4��
-- +, - : ��� ���� ���� ����
-- ��Ģ���� +, -, *, /, ||(���ڿ���)
-- �񱳿��� =, >, <, >=, <=, <>, !=, IS NULL, LIKE, BETWEEN, IN
-- ������ NOT AND OR

DECLARE
    a INTEGER := 2**2*3**2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a = ' || TO_CHAR(a));
END;

-- BEGIN ���� �������� �ѹ����� SQL ���� �ϳ��� ��ɾ��, �����ڸ� ������ �Ϲݸ�ɾ �ϳ��� ��ɾ�� �ν��ؼ�
-- �� �ڿ� ';' �� �ִ� ������ ����

-- SQL ��ɰ� ���� ����Ǵ� PL/SQL 
-- �����ȣ�� 100�� ����� �̸�
SELECT emp_name FROM employees WHERE employee_id=100;

DECLARE
    e_name VARCHAR2(30);
BEGIN
    SELECT emp_name 
    INTO e_name -- SELECT ������ ����� ������ �����ϴ� ���
    FROM employees 
    WHERE employee_id=100;
    DBMS_OUTPUT.PUT_LINE(e_name);
END;


-- SELECT ���� ���ؼ� ����� ����� 2�� �̻��̶�� SQL �������� ���� ������ INTO ���� ��� �ʵ��� ������ �°� ��ġ��ŵ�ϴ�
-- �����ȣ�� 100�� ����� �̸��� �μ���
SELECT emp_name, department_id FROM employees WHERE employee_id=100;


DECLARE
    vs_emp_name VARCHAR2(80); -- ����� ����
    vs_dept_name VARCHAR2(80);  -- �μ��� ����
BEGIN
    SELECT emp_name, department_id
    INTO vs_emp_name, vs_dept_name -- 
    FROM employees 
    WHERE employee_id=100;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_dept_name);
END;
-- Steven King - 90

-- ������ ������ ���� ��� �ڷ����� ������ ���缭 �����ϱⰡ ���ŷο�Ƿ�, 
-- ��Ī�� �ʵ��� �̸��� %Type �� �̿��Ͽ� �ڵ����� �ڷ����� ���������� �մϴ�

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


-- ��������1
-- DBMS_OUTPUT.PUT_LINE(); �� 9�� ����Ͽ� ������ 3���� ����ϴ� �͸� ���� �����ϼ���
-- �̾���̱� ���굵 ����մϴ�
-- ����� ������ �ʿ����� �ʱ� ������ DECLARE �� ���� �ʾƵ� �˴ϴ�
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

-- ��������2
-- ������̺�(employees)���� 201 �� ����� �̸��� �̸����ּҸ� ����ϴ� �͸� ����� ���弼��
-- �̸� - �̸��� �������� ��ũ��Ʈ ����ϼ���
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

-- ��������3
-- SELECT �� �� ���� INSERT ��ɿ� ����մϴ�
-- ������̺�(employees) ���̺��� ���� ū �����ȣ�� ��ȸ�ǰ�,
-- �� �����ȣ���� 1 ��ŭ ū ���ڸ� ���մ� �Է� ���ڵ��� �����ȣ�� �Ͽ� ���ڵ帣 �߰��ϼ���
-- ������ �Է»��� : 
-- ����� : Harrison Ford
-- �̸��� : HARRISON
-- �Ի���¥ : ���� ��¥
-- �μ���ȣ : 50
-- ����ο��� ������ ��� commit; �� �־��ּ���
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

COMMIT; -- INSERT UPDATE DELETE ��� �ڿ��� �ݵ�� COMMIT �� ����մϴ�

SELECT * FROM employees;




























































