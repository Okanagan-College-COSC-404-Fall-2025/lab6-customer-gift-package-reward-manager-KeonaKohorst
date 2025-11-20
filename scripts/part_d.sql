SET SERVEROUTPUT ON SIZE 1000000;
CREATE OR REPLACE PROCEDURE join_rewards_and_gifts 
AS
  v_i NUMBER := 1;
BEGIN
    FOR rec IN (
        SELECT cr.reward_id, cr.customer_email, cr.reward_date, t.column_value AS gifts
        FROM customer_rewards cr
        JOIN gift_catalog g ON cr.gift_id = g.gift_id,
             TABLE(g.gifts) t
    ) LOOP
        dbms_output.put_line(rec.reward_id || ' ' || rec.customer_email || ' ' || rec.reward_date || ' ' || rec.gifts);

        -- go through nested table
        -- FOR j IN 1 .. rec.gifts.COUNT LOOP
        --     dbms_output.put_line('   Gift:' || rec.gifts(j));
        -- END LOOP;

        EXIT WHEN v_i = 5;
        v_i := v_i + 1;
    END LOOP;
END;
/


BEGIN
    join_rewards_and_gifts();
END;