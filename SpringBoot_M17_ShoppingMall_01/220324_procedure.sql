CREATE OR REPLACE PROCEDURE getBestNewProduct(
    p_cur_best OUT SYS_REFCURSOR,
    p_cur_new OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cur_best FOR
        SELECT * FROM best_pro_view;
    OPEN p_cur_new FOR
        SELECT * FROM new_pro_view;
END;


--------------getKindList
CREATE OR REPLACE PROCEDURE getKindList(
    p_kind IN product.kind%TYPE,
    p_cur_kind OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cur_kind FOR       
        SELECT * FROM product WHERE kind=p_kind ORDER BY pseq DESC;
END;

-----member table 수정
ALTER TABLE member ADD indate DATE DEFAULT SYSDATE;

--- getMember_shop
create or replace PROCEDURE getMember_shop(
    p_userid IN member.userid%TYPE,
    p_curvar OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_curvar FOR SELECT * FROM member WHERE userid = p_userid;
END;

----selectAddressByDong
CREATE OR REPLACE PROCEDURE selectAddressByDong(
    p_dong IN member.address%TYPE,
    p_curvar OUT SYS_REFCURSOR    
)
IS
BEGIN
    OPEN p_curvar FOR SELECT * FROM address WHERE dong LIKE '%'||p_dong||'%' ORDER BY dong;  
END;

----insertMember_shop
CREATE OR REPLACE PROCEDURE insertMember_shop(
    p_userid IN member.userid%TYPE,
    p_pwd IN member.pwd%TYPE,
    p_name IN member.name%TYPE,
    p_email IN member.email%TYPE,
    p_phone IN member.phone%TYPE,
    p_zip_num IN member.zip_num%TYPE,
    p_address IN member.address%TYPE,
    p_address2 IN member.address2%TYPE
)
IS
BEGIN
    INSERT INTO member(userid, pwd, name, email, phone, zip_num, address, address2)
        VALUES(p_userid, p_pwd, p_name, p_email, p_phone, p_zip_num, p_address, p_address2);
    COMMIT;
END;

-----updateMember
CREATE OR REPLACE PROCEDURE updateMember(
    p_userid IN member.userid%TYPE,
    p_pwd IN member.pwd%TYPE,
    p_name IN member.name%TYPE,
    p_email IN member.email%TYPE,
    p_phone IN member.phone%TYPE,
    p_zip_num IN member.zip_num%TYPE,
    p_address IN member.address%TYPE,
    p_address2 IN member.address2%TYPE
)
IS
BEGIN
    UPDATE member SET pwd=p_pwd, name=p_name, email=p_email, phone=p_phone, zip_num=p_zip_num, address=p_address, address2=p_address2 WHERE userid=p_userid;
    COMMIT;
END;

--------------getProductDetail
CREATE OR REPLACE PROCEDURE getProductDetail(
    p_pseq IN product.pseq%TYPE,
    p_cur_kind OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cur_kind FOR       
        SELECT * FROM product WHERE pseq=p_pseq;
END;

--------------insertCart
CREATE OR REPLACE PROCEDURE insertCart(
    p_userid IN cart.id%TYPE,
    p_pseq IN cart.pseq%TYPE,
    p_quantity IN cart.quantity%TYPE
)
IS
BEGIN
    INSERT INTO cart(cseq, id, pseq, quantity)
        VALUES(cart_seq.nextVal, p_userid, p_pseq, p_quantity);
    COMMIT;
END;

--------------selectCartList
CREATE OR REPLACE PROCEDURE selectCartList(
    p_id IN cart.id%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM cart_view WHERE id=p_id ORDER BY cseq DESC;
END;



------------------deleteCart
CREATE OR REPLACE PROCEDURE deleteCart(
    p_cseq IN cart.cseq%TYPE
)
IS
BEGIN
    DELETE FROM cart WHERE cseq=p_cseq;
    COMMIT;
END;


------insertOrder
CREATE OR REPLACE PROCEDURE insertOrder(
    p_userid IN orders.id%TYPE,
    p_oseq OUT orders.oseq%TYPE
)
IS
    v_oseqMax orders.oseq%TYPE;
    temp_cursor SYS_REFCURSOR;
    v_cseq cart.cseq%TYPE;
    v_pseq cart.pseq%TYPE;
    v_quantity cart.quantity%TYPE;
BEGIN
    -- orders table 레코드 추가
    INSERT INTO orders(oseq, id) VALUES(orders_seq.nextVal, p_userid);
    -- orders 테이블에서 가장 큰 oseq 조회
    SELECT MAX(oseq) INTO v_oseqMax FROM orders;
    -- cart table 에서 id로 목록 조회
    OPEN temp_cursor FOR
        SELECT cseq, pseq, quantity FROM cart WHERE id=p_userid AND result='1';
    -- 목록과 oseq 로 order_detail 테이블에 레코드 추가
    LOOP
        FETCH temp_cursor
        INTO v_cseq, v_pseq, v_quantity;
        EXIT WHEN temp_cursor%NOTFOUND;
        INSERT INTO order_detail(odseq, oseq, pseq, quantity)
            VALUES(order_detail_seq.nextVal, v_oseqMax, v_pseq, v_quantity);
        DELETE FROM cart WHERE cseq=v_cseq;
    END LOOP;
    p_oseq := v_oseqMax;
    COMMIT;
END;


-----------------getOrderList
CREATE OR REPLACE PROCEDURE getOrderList(
    p_oseq IN orders.oseq%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM order_view WHERE oseq=p_oseq ORDER BY odseq DESC;
END;









