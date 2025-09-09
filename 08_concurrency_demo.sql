-- 08_concurrency_demo.sql
-- Run this demo in TWO Workbench tabs.

-- TAB A
-- =====
-- USE bestbuy_dw;
-- SET autocommit = 0;
-- START TRANSACTION;
-- -- Lock product row (hold this tab open for 30-60s)
-- SELECT Stock, Price FROM Products WHERE ProductID = 1 FOR UPDATE;

-- TAB B
-- =====
-- USE bestbuy_dw;
-- CALL place_order_single(1, 1, 1, 1, NULL, @oid, @msg);
-- SELECT @oid AS order_id, @msg AS message;

-- TAB A (release lock)
-- ====================
-- COMMIT;
-- SET autocommit = 1;
