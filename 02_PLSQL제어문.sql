--IF ��
--����� ���� �� �� �ϳ��̰�, �ܵ� if �� ����Ҷ� 
--if ���� then
--    ���๮1
--end if
--
--����� ���� �� �� �ϳ��̰�, else �� �Բ� ����Ҷ�
--if ���� then
--    ���๮1
--else
--    ���๮2
--end if
--
--����� ���� �� �̻��� ��
--if ����1 then
--    ���๮1
--elsif ����2 then    ���� ��ü�� elesif �� �ƴ϶� elsif ��
--    ���๮2
--else
--    ���๮3
--end if



DECLARE
    vn_num1 NUMBER := 1;
    vn_num2 NUMBER := 2;
BEGIN
    IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '�� ū ��');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 || '�� ū ��');
    END IF;
END;

-- employees ���̺��� ���� �Ѹ��� �����Ͽ�, �� ����(salary) �� �ݾ׿� ����
--����, �߰�, ���� �̶�� �ܾ ����ϴ� �͸� ���� �����մϴ� (1 ~ 3000 ���� 3001~6000 ���� 6001~10000 ����)
--����� �����ϴ� ����� RANDOM.VALUE �Լ��� �̿��մϴ�. 
--������ �μ���ȣ�� ��ȸ�ϵǱ� �μ��� ����� �����̸� ù��° ������� ����

DECLARE
    -- ���õ� ����� �޿�-����(salary) �� ������ ����
    vn_salary NUMBER := 0;
    -- �������� �߻��� �μ���ȣ�� ������ ����
    vn_department_id NUMBER := 0;
BEGIN
    -- �����ϰ� �μ���ȣ�� �߻�
    -- DBMS_RANDOM.VALUE(���ۼ���, ������) : ���� ���ں��� ������ ������ ���� ���ڸ� �߻�
    -- ROUND(����, �ݿø��ڸ���) : ���ڸ� ������ �ݿø��ڸ����� �ݿø��մϴ�
    -- �ݿø��ڸ����� 1 �̸� �Ҽ�����°�ڸ����� �ݿø��ؼ� ù°�ڸ����� ����
    -- �ݿø��ڸ����� 2 �̸� �Ҽ�����°�ڸ����� �ݿø��ؼ� ��°�ڸ����� ����
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
    DBMS_OUTPUT.PUT_LINE(vn_department_id);
    SELECT salary
    INTO vn_salary
    FROM employees
    WHERE department_id = vn_department_id AND ROWNUM = 1;
    
    IF vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�ֻ���');
    END IF;
END;


-- ��ø IF ��
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

-- CASE ��
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
        DBMS_OUTPUT.PUT_LINE('����');
    WHEN vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    WHEN vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�ֻ���');
    END CASE;
END;

-- CASE ���� 1
--CASE
--    WHEN ���ǽ� 1 THEN
--        ���๮1
--    WHEN ���ǽ� 2 THEN
--        ���๮2
--    ELSE
--        ���๮3
--END CASE;

-- CASE ���� 2
-- CASE ���ǽ� �Ǵ� ǥ���� �Ǵ� ����
--CASE
--    WHEN �� 1 THEN
--        ���๮1
--    WHEN �� 2 THEN
--        ���๮2
--    ELSE
--        ���๮3
--END CASE;

-- LOOP ��
-- �ݺ����� ����1
-- LOOP
--    ���๮;
--    EXIT [WHEN ����];
--END LOOP;

DECLARE
    vn_base_num NUMBER := 4; -- ��
    vn_cnt NUMBER := 1; -- �ݺ� ���� ������ �¼�
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
--EIXT �̻���
--
--���� ���� -
--ORA-20000: ORU-10027: buffer overflow, limit of 1000000 bytes
--ORA-06512: at "SYS.DBMS_OUTPUT", line 32
--ORA-06512: at "SYS.DBMS_OUTPUT", line 97
--ORA-06512: at "SYS.DBMS_OUTPUT", line 112
--ORA-06512: at line 6
--20000. 00000 -  "%s"
--*Cause:    The stored procedure 'raise_application_error'
--           was called which causes this error to be generated.

--�ݺ����� ����2
--WHILE ����
--LOOP
--    ���๮
--END LOOP;

DECLARE
    vn_base_num NUMBER := 6; -- ��
    vn_cnt NUMBER := 1; -- �ݺ� ���� ������ �¼�
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

--WHILE �� EXIT WHEN �� ȥ�ջ��

DECLARE
    vn_base_num NUMBER := 7; -- ��
    vn_cnt NUMBER := 1; -- �ݺ� ���� ������ �¼�
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

--FOR �� 
--
--FOR ������ IN [REVERSE] ���۰�... ����
--LOOP
--    ���๮
--END LOOP;
--���۰����� �������� �ݺ������մϴ�. REVERSE ���������, �ݴ������ ������������ �ݺ�����

DECLARE
    vn_base_num NUMBER := 8;
BEGIN
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

-- REVERSE ���
DECLARE
    vn_base_num NUMBER := 8;
BEGIN
    FOR i IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE('REVERSE ��� ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

-- CONTINUE ���
DECLARE
    vn_base_num NUMBER := 9;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i = 5; -- ������ �����ϸ� �ݺ����� ������ ������ ����� �������� �ʰ� ���� �ݺ����� ����
        DBMS_OUTPUT.PUT_LINE('CONTINUE ��� ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

--FOR �� ���� IN ���۰��� ���� ���̿� . �� �� 2���� ����Ͽ��� �Ѵ�
--ORA-06550: line 4, column 15:
--PLS-00103: Encountered the symbol "." when expecting one of the following:
--
--   * & - + / at mod remainder rem .. <an exponent (**)> ||
--   multiset
--The symbol ".. was inserted before "." to continue.
--06550. 00000 -  "line %s, column %s:\n%s"
--*Cause:    Usually a PL/SQL compilation error.

-- GOTO �� -- ��õ���� �ʴ� �ݺ���
DECLARE
    vn_base_num NUMBER := 9;
BEGIN
    <<fifth>> -- ���̶�� �θ��ϴ�. GOTO ���� �̵� �������� ���ǰ� �մϴ�
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE('GOTO ��� ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
        IF i = 3 THEN
             GOTO sixth;
        END IF;
    END LOOP; 
    
    <<sixth>> 
    vn_base_num := 6;
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE('GOTO ��� ' || vn_base_num || ' x ' || i || ' = ' || vn_base_num * i);
    END LOOP;
END;

--NULL �� : IF �� �Ǵ� CASE WHEN ��� �ش� ��쿡 �����ؾ��� ����� �ϳ��� ���� �� ���� �����Դϴ�
--IF vn_variable = 'A' THEN
--    ó������1;
--ELSIF vn_variable = 'B' THEN
--    ó������2;
--...
--ELSE NULL;
--END IF;

--CASE 
--    WHEN vn_variable = 'A' THEN
--        ó������1;
--    WHEN vn_variable = 'B' THEN
--        ó������2;
--    ...
--    ELSE 
--        NULL;
--END CASE;





















SET SERVEROUTPUT ON
SELECT * FROM employees;

