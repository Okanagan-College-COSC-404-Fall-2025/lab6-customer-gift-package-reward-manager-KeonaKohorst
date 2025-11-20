--package specification
CREATE OR REPLACE PACKAGE customer_manager AS
    FUNCTION get_total_purchase(p_customer_id NUMBER) RETURN NUMBER;

    PROCEDURE assign_gifts_to_all;
END customer_manager;
/

--package body
CREATE OR REPLACE PACKAGE BODY customer_manager AS
    
    -- accepts a customer ID and returns the 
    -- total value of all purchases made by that 
    -- customer.
    FUNCTION get_total_purchase(p_customer_id NUMBER) 
    RETURN NUMBER
    AS
        total NUMBER;
    BEGIN
        SELECT SUM(unit_price) INTO total
        FROM order_items oi, orders o
        WHERE oi.order_id = o.order_id AND
              o.customer_id = p_customer_id;

        RETURN total;
    END get_total_purchase;

    -- A private function CHOOSE_GIFT_PACKAGE(p_total_purchase): 
    -- Requirements:
    --    Use a CASE expression or CASE logic
    --    Select the gift package from GIFT_CATALOG where: MIN_PURCHASE is the largest value <= p_total_purchase
    --    Return the GIFT_ID of the chosen package.
    --    If no package applies, return NULL.
    FUNCTION choose_gift_package(p_total_purchase NUMBER) 
    RETURN NUMBER
    AS
        id NUMBER;
        max_min_purchase NUMBER;
    BEGIN
        SELECT MAX(min_purchase)
        INTO max_min_purchase
        FROM gift_catalog
        WHERE min_purchase <= p_total_purchase;

        SELECT CASE
                    WHEN max_min_purchase IS NOT NULL THEN
                        (SELECT gift_id
                        FROM gift_catalog
                        WHERE min_purchase = max_min_purchase)
                    ELSE
                        NULL
                END
        INTO id
        FROM dual;

        RETURN id;

    END choose_gift_package;

    PROCEDURE assign_gifts_to_all
    AS
        v_total NUMBER;
        v_gift_id NUMBER;
        CURSOR customer_cursor IS
            SELECT * FROM customers;
    
    BEGIN
        
        FOR customer IN customer_cursor LOOP
            v_total := get_total_purchase(customer.customer_id);
            v_gift_id := choose_gift_package(v_total);

            IF v_gift_id IS NOT NULL THEN
                INSERT INTO customer_rewards (customer_email, gift_id, reward_date) 
                VALUES (
                    customer.email_address,
                    v_gift_id,
                    SYSDATE
                );
            END IF;
        END LOOP;
     
    END assign_gifts_to_all;

END customer_manager;