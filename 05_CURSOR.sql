-- CURSOR
--�ַ� ���ν��� ������ SQL ��� �� SELECT ����� ����� �ټ��� ������ ������� �� ����ϴ� ����� �����ϴ� �޸� ������ ��Ī�մϴ�
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
-- ���� ����� ��� (job_id)�� �ϳ��� ������ ���������ؼ� ������ ����

--���� �͸���� SELECT ����� ����� 1��(ROW) �̹Ƿ� ������ ����������, SELECT ����� ����� 2�� �̻��̶��
--������ �߻��մϴ�. 2�� �̻��� ����� ���� �� �ִ� �޸� ����(�Ǵ� ����)���� ����ϴ� ���� CURSOR �̸�
--�ڹ��� ����Ʈ�� ����� ������ ���� �ֽ��ϴ� �Ǵ� �ݺ����๮�� �̿��Ͽ� �� ������ �����ϰ� ����ϰ� ������ �� �ֽ��ϴ�

-- CURSOR �� ����ܰ�
--1. CURSOR �� ���� (����)
-------------------------------------------------------------------------------------
--CURSOR ����� Ŀ���� �̸� [(�Ű�����1, �Ű�����2, ...)]
--IS
--SELECT ... SQL ����
-------------------------------------------------------------------------------------
--�Ű������� ���� : SELECT ��ɿ��� ����� ���� (�ַ� WHERE ������ ����� ����)
--SELECT ... SQL ���� : CURSOR �� ���Ǿ� ����� �Ȱ��� SQL ���
--
--2. CURSOR �� OPEN(ȣ��)
-------------------------------------------------------------------------------------
--OPEN Ŀ���̸� [(�����μ�1, �����μ�2, ...)]
-------------------------------------------------------------------------------------
--������ �����μ��� �����Ͽ� Ŀ���� �����ϰ� ����� ����
--
--3. ����� �ݺ����๮�� �Բ� �ʿ信 �°� ó��
-------------------------------------------------------------------------------------
--LOOP
--    FETCH Ŀ���̸� INTO ����;
--    EXIT WHEN Ŀ���̸�%NOTFOUND;      -- ���� select �� ���� ����� ���ڵ尡 �� �����Ǿ� ����������
--    �ʿ信 �´� ó�� ����
--END LOOP;
-------------------------------------------------------------------------------------
--FETCH Ŀ���̸� INTO ����; Ŀ���� ��� �����͵� �� ���پ� ������ ������ �ִ� �����Դϴ�
--EXIT WHEN Ŀ���̸�%NOTFOUND; ���´µ� �����Ͱ� ������ �����մϴ�
--LOOP �ȿ��� �ʿ信 �´� ó���� �����Ͱ� ���� ������ �ݺ��մϴ�
--
--4. CURSOR �ݱ�
-------------------------------------------------------------------------------------
--CLOSE Ŀ����
-------------------------------------------------------------------------------------

-- CURSOR �� ���
-- �����μ��� �μ���ȣ�� ������ �� �� �μ��� ����̸����� ������ Ŀ��

DECLARE
    vs_emp_name employees.emp_name%TYPE; -- ������� �����ϱ� ���� ����
    vs_employee_id employees.employee_id%TYPE; -- ��� ��ȣ�� �����ϱ� ���� ����
    
    -- 1. CURSOR ����(����, ����) -- �μ���ȣ�� Ŀ���� �����ؼ� �� �μ� ��ȣ�� ���� ����� �����ȣ�� �̸��� ���� Ŀ�� ����
    CURSOR cur_emp_dept(cp_department_id employees.department_id%TYPE)
    IS
    SELECT employee_id, emp_name FROM employees WHERE department_id = cp_department_id;
BEGIN
    -- 2. ȣ�� -- Ŀ���� �����մϴ�(�����μ��� �μ���ȣ 90�� �־��ݴϴ�)
    OPEN cur_emp_dept(90);
    
    -- 3. �ݺ����๮���� Ŀ���� ����� �����͸� �ų��� ����մϴ�
    LOOP
        -- �ݺ��� ����Ǵ� ���� Ŀ���� ����� �����͸� ���྿ ������ vs_employee_id, vs_emp_name ������ �����մϴ�
        FETCH cur_emp_dept INTO vs_employee_id, vs_emp_name;
        EXIT WHEN cur_emp_dept%NOTFOUND; -- ���� ���ڵ尡 ���������� �ݺ��մϴ�
        DBMS_OUTPUT.PUT_LINE(vs_employee_id || '-' || vs_emp_name); -- ���� ������ ���
    END LOOP;
END;

--100-Steven King
--101-Neena Kochhar
--102-Lex De Haan


-- Ŀ���� FOR ��
--������ FOR ��
--FOR �ε������� IN [REVERSE] ó����.. ����
--LOOP
--    ���๮
--END LOOP;
---------------------------------------------------------------------------------------
--
--Ŀ���� �Բ� ����ϴ� FOR��
--FOR ���ڵ庯�� IN Ŀ���̸�(�����μ�1, �����μ�2..)
--LOOP
--    ���๮
--END LOOP;
-------------------------------------------------------------------------------------

-- FOR ���ڵ� ���� IN Ŀ���̸�(�����μ�1, �����μ�2..) : OPEN ���� ����(ȣ��)�ϴ� ������ FOR���� IN�������� �̵�
-- �������� �ϳ���(1��, 1���ڵ�) ���ڵ� ������ ����Ǿ� �ݺ�����Ǻ��.
-- �ڵ����� �������� ������ŭ �ݺ�����˴ϴ�

DECLARE
    -- ���ڵ� ������ ����ϱ� ������ �� �ʵ尪�� ������ ������ ������ �ʽ��ϴ�
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


-- ���ݴ� ������ FOR ���� Ŀ���� ���
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

-- ��������
-- �μ���ȣ�� 30���� ����� �̸�, �μ���, �޿�, �޿�(����, ����, ����) �� ����ϼ���
-- �޿�(salary�� 5000 �̸� ����, 10000 �̸� ���� ������ ���� ���� ����ϼ���
-- �̸� - �μ��� - �޿� - ���� ������ ����ϼ���
SELECT * FROM employees;
DECLARE
    vn_salary_value VARCHAR2(30);
BEGIN
    FOR emp_rec IN (SELECT emp_name, employee_id, salary FROM employees WHERE department_id=30)
    LOOP
        IF emp_rec.salary < 5000 THEN
            vn_salary_value := '����';
        ELSIF emp_rec.salary < 10000 THEN
            vn_salary_value := '����';
        ELSE
            vn_salary_value := '����';
        END IF;
        DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name || '-' || emp_rec.employee_id || '-' || emp_rec.salary || '-' || vn_salary_value);         
    END LOOP;
END;

--Den Raphaely-114-11000-����
--Alexander Khoo-115-3100-����
--Shelli Baida-116-2900-����
--Sigal Tobias-117-2800-����
--Guy Himuro-118-2600-����
--Karen Colmenares-119-2500-����
DECLARE
    vn_salary_value VARCHAR2(30);
BEGIN
    FOR emp_rec IN (SELECT emp_name, employee_id, salary FROM employees WHERE department_id=30)
    LOOP
        IF emp_rec.salary BETWEEN 1 AND 5000 THEN
            vn_salary_value := '����';
        ELSIF emp_rec.salary BETWEEN 5001 AND 10000 THEN
            vn_salary_value := '����';
        ELSE
            vn_salary_value := '����';
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
            level := '����';
        ELSIF emp_rec.salary <= 10000 THEN
            level := '����';
        ELSE
            level := '����';
        END IF;
        DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name || '-' || emp_rec.department_name || '-' || emp_rec.salary || '-' || level);         
    END LOOP;
END;

-- Ŀ�� ����
-- TYPE ����� Ŀ���� Ÿ���̸� ID REF CURSOR [RETURN ��ȯŸ��] ; -> ������ Ŀ��Ÿ���� �̸����� Ŀ�� ������ ������ �����Դϴ�
-- Ŀ�������̸� Ŀ��Ÿ���̸�;
-- Ŀ�� Ÿ���� ���鶧 RETURN ���� �����ϸ� ���� Ŀ��Ÿ���� �����Ǵ°��̰�, RETURN �� ������ ���� Ŀ��Ÿ���̶�� ��Ī�մϴ�
--TYPE dep_curtype1 IS REF CURSOR RETURN departments&ROWTYPE; -- ���� Ŀ��Ÿ��
--TYPE dep_curtype2 IS REF CURSOR; -- ���� Ŀ��Ÿ��

-- �� ������ ����� Ŀ���� �̸��� ������ ���� �ƴ϶�, Ŀ���� ������ �� �ִ� Ŀ���ڷ����� �����Ѱ̴ϴ�
-- ������ Ŀ�� �ڷ����� Ŀ�� ������ ������ �� �ֽ��ϴ�

cursor1 dep_curtype1;
cursor2 dep_curtype2;
-- cursor1�� cursor2 �������� select ����� ��Ƽ� Ŀ���� �ϼ��� �� �ֽ��ϴ�
-- ���� Ŀ������(select ��)�� ���������� �ʰ� �ٲ� �� �ֽ��ϴ�
-- �ٸ� cursor1 �� ���� Ŀ�� Ÿ���̹Ƿ� ���ǵǾ� �ִµ��� (RETURN departments%ROWTYPE) ���ڵ� ��ü�� ����� ��� select �� ������ �� �ֽ��ϴ�

OPEN cursor1 FOR SELECT employee_id, emp_name FROM employees WHERE department_id = 90; -- ����Ÿ���� ���� �ʱ� ������ �Ұ���
OPEN cursor1 FOR SELECT * FROM departments WHERE department_id = 90; -- ����

-- � SELECT ������ �͵�����
OPEN cursor2 FOR SELECT employee_id, emp_name FROM employees WHERE department_id = 90; -- ����
OPEN cursor2 FOR SELECT * FROM departments WHERE department_id = 90; -- ����

-- Ŀ�������� ���� �ʿ��Ҷ����� Ŀ�� ������ �����ϰ� ȣ���ؼ� �� ����� ����Ϸ��� ������ ����ϴ�
DECLARE
    vs_emp_name employees.emp_name%TYPE; -- �Ϲ� ���� ����
    TYPE emp_dept_curtype IS REF CURSOR; -- ���� Ŀ��Ÿ�� ����
    emp_dept_curvar emp_dept_curtype; -- ������ Ŀ��Ÿ������ Ŀ�� ���� ����
BEGIN
    OPEN emp_dept_curvar FOR SELECT emp_name FROM employees WHERE department_id = 90; -- Ŀ�������� select �� ����
    LOOP
        FETCH emp_dept_curvar INTO vs_emp_name;
        EXIT WHEN emp_dept_curvar%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vs_emp_name);
    END LOOP;
END;

--Steven King
--Neena Kochhar
--Lex De Haan

dep_curtype3 SYS_REFCURSOR; -- �ý��ۿ��� �������ִ� Ŀ�� Ÿ��

-- SYS_REFCURSOR �� ����ϸ�
--TYPE emp_dep_curtype IS REF CURSOR; -- Ŀ��Ÿ�� ���� ��������
--emp_dep_curvar emp_dep_curtype; -- ���� ���� SYS_REFCURSOR ���·� ����
DECLARE
    vs_emp_name employees.emp_name%TYPE; 
    vs_salary employees.salary%TYPE; 
    emp_dep_curvar SYS_REFCURSOR; -- SYS_CURSOR Ÿ���� Ŀ������ ����
BEGIN
    OPEN emp_dep_curvar FOR SELECT emp_name, salary FROM employees WHERE department_id = 90; -- Ŀ�������� select �� ����
    LOOP
        FETCH emp_dep_curvar INTO vs_emp_name, vs_salary;
        EXIT WHEN emp_dep_curvar%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vs_emp_name || '-' || vs_salary);
    END LOOP;
END;
--Steven King-24000
--Neena Kochhar-17000
--Lex De Haan-17000
--1. SYS_REFCURSOR ���� ����
--2. ������ select ����
--3. FETCH �� ������ ó��

-- ���ν��������� Ŀ�� ��� �� -- SELECT �� ����� Ŀ���� ��Ƽ� ���ν����� ȣ���� ������ �����ַ� �մϴ�
CREATE OR REPLACE PROCEDURE testCursorArg(
    p_curvar OUT SYS_REFCURSOR
)
IS
    temp_curvar SYS_REFCURSOR; -- ���ν������� ����� Ŀ�� ����
BEGIN
    OPEN temp_curvar FOR SELECT emp_name, salary FROM employees WHERE department_id=90;
    -- ���� ��ġ���� Ŀ���� ������ FETCH �Ұ� �ƴ϶� �ݺ����൵ FETCH �� ���� �ʽ��ϴ�
    p_curvar := temp_curvar;
END;

DECLARE
    out_curvar SYS_REFCURSOR; -- Ŀ������ ����
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
-- mybatis ���� ���ν��� ����� ��ȸ �����͸� �����ϴ� �߿��� ������ �ϴ� ���� cursor �Դϴ�
-- ���� ���� ������ Ŀ���� �����μ��� �����ؼ� ��ȸ����� ��ƿ� �� �ִ� �������� �̷������ ���ÿ�
-- mybatis ���� ����ϱ� �� ���� �����̹Ƿ� �߿��� ������ ����صΰ� �ʿ�� �����Ͻô� ���� �����ϴ�
