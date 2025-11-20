-- Create a nested table type to store 
-- multiple gift items 
-- (e.g., 'Teddy Bear', 'Chocolate Box').

CREATE OR REPLACE TYPE GIFT_ITEMS_T AS TABLE OF VARCHAR2(55);
/

-- Create a table GIFT_CATALOG with the 
-- following columns:
--   GIFT_ID (NUMBER)— PRIMARY KEY
--   MIN_PURCHASE (NUMBER) — the minimum purchase 
--     amount to qualify for the gift package
--   a nested table of gift items 
--     (use the type created above)

CREATE TABLE gift_catalog (
    gift_id NUMBER PRIMARY KEY,
    min_purchase NUMBER,
    gifts GIFT_ITEMS_T
)
NESTED TABLE gifts STORE AS gift_items_tab;

-- Insert at least three gift packages, 
-- each containing multiple gift items.

INSERT INTO gift_catalog VALUES (
    1,
    100,
    GIFT_ITEMS_T('Stickers', 'Pen Set')
);

INSERT INTO gift_catalog VALUES (
    2, 
    1000,
    GIFT_ITEMS_T('Teddy Bear', 'Mug', 'Perfume Sample')
);

INSERT INTO gift_catalog VALUES (
    3, 
    10000,
    GIFT_ITEMS_T('Backpack', 'Thermos Bottle', 'Box of Chocolate')
);

SELECT * FROM gift_catalog;