-- �Լ�
--PL/SQL �ڵ� �ۼ��ÿ��� ���ݱ��� ����ϴ� �͸� ���� �� ������� �ʽ��ϴ�
--�Ϲ������� �̸��� �ִ� ���� ���α׷�(�Լ�) �Ǵ� ���ν����� ����ϴ� ���� ��κ��Դϴ�
--�͸� ���� �� �� ����ϰ� ���� ������ ������ �ֹ߼� ��������
--�Լ� �Ǵ� ���ν����� �������� ���� �����ͺ��̽��� ����Ǿ� ������ ������ �����Դϴ�

-- �Լ��� ����
-- CREATE OR REPLACE FUNCTION �Լ��̸�(�Ű�����1, �Ű�����2 ...)
--RETURN ������Ÿ��;
--IS[AS]
--    ����, ��� ����
--BEGIN
--    �����
--    RETURN ���ϰ�;
--    [EXCEPTION 
--        ����ó����]
--END [�Լ��̸�]; -- �Լ��̸� ��������

--�󼼳���
--CERATE OR REPLACE FUNCTION : CREATE OR REPLACE FUNCTION ��� ������ �̿��Ͽ� �Լ��� �����մϴ�
--�Լ��� ����� �����ϴ��� �� ������ ��� ������ �Ҽ� �ְ�,
--���������� ������ �� ������ �Լ��� ����� �̸����� ���˴ϴ�

--�Ű����� : �����μ��� �����ϴ� ������ "�����̸� ������ �ڷ���" ���·� �ۼ��մϴ�
--ù��° RETURN ���� �������� ���ϵ� �ڷ��� �ڷ����� ����,
--�Ʒ��� �ι�° RETURN ���� ������ �� �ڷ������� ���� ���ϵ� �� �Ǵ� ���� �̸��� ���ݴϴ�

-- �ΰ��� ������ �����ؼ� ù���簪�� �ι�° ������ ���� �������� ���� �������ִ� �Լ�
CREATE OR REPLACE FUNCTION myMod(num1 NUMBER, num2 NUMBER)
    RETURN NUMBER
IS
    vn_remainder NUMBER := 0; -- �������� ������ ����
    vn_quotient NUMBER := 0; -- ���� ������ ����
BEGIN
    vn_quotient := FLOOR(num1 / num2); -- ���� �򿡼� ������ ����(�Ҽ��� ����)
    vn_remainder := num1 - (num2 * vn_quotient); -- �� * ������ �������� ���� ������ ���
    RETURN vn_remainder; -- ������ ��ȯ
--END mymod;
END;

SELECT myMod(14, 3) FROM dual;

-- �Լ��� select ���� ���ÿ� �����ϸ� PLS-00103: Encountered the symbol "SELECT" ���� �߻� ������ �����Ұ�

SELECT * FROM countries;

CREATE OR REPLACE FUNCTION fn_getCountryName(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE; -- �����̸��� ������ ����
BEGIN
    SELECT country_name
    INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    RETURN vs_country_name;
END;

SELECT fn_getCountryName(52790) FROM dual;
--United States of America

-- �� select ��� ����� 10000 �� id �� '�ش籹�� ����' �̶�� ��µǵ��� fn_getCountryName �Լ��� �����ϼ���


CREATE OR REPLACE FUNCTION fn_getCountryName(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE; -- �����̸��� ������ ����
BEGIN
    SELECT country_name
    INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    IF vs_country_name IS NULL THEN
        vs_country_name := '�ش籹�� ����';   
    END IF;
    RETURN vs_country_name;
END;
SELECT fn_getCountryName(52790), fn_getCountryName(10000) FROM dual;
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getCountryName(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE; -- �����̸��� ������ ����
    vn_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vn_count FROM countries WHERE country_id = p_country_id;
    IF vn_count = 0 THEN
        vs_country_name := '�ش籹�� ����';
    ELSE
        SELECT country_name INTO vs_country_name FROM countries WHERE country_id = p_country_id;
    END IF;
    RETURN vs_country_name;
END;
SELECT fn_getCountryName(52790), fn_getCountryName(10000) FROM dual;


-- �Ű������� ���� �Լ�
CREATE OR REPLACE FUNCTION fn_get_user -- �Ű������� ���� �Լ��� ��ȣ ���� �����ϱ⵵ �մϴ�
    RETURN VARCHAR2 -- ��ȯ ������ Ÿ���� VARCHAR2
IS
    vs_user_name VARCHAR2(80);
BEGIN
    SELECT USER
    INTO vs_user_name
    FROM DUAL;
    RETURN vs_user_name; -- ����� �̸� ��ȯ
END;

SELECT fn_get_user(), fn_get_user FROM DUAL; -- �Ű������� ���� �Լ��� ��ȣ ���� ȣ���ϱ⵵ �մϴ�
--SCOTT	SCOTT

-- ���� ����
-- employees ���̺��� �� �μ� ��ȣ�� �Է¹޾Ƽ� �޿��� ����� ����ϴ� �Լ��� �����ϼ���
-- �μ��� �ο��� ������, ��հ��� 0���� ����մϴ�
-- ������ �Լ��� ȣ���� �Ʒ��� �����ϴ�
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














