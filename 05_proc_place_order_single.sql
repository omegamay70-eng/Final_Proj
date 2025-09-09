-- 05_proc_place_order_single.sql
USE bestbuy_dw;

DROP PROCEDURE IF EXISTS place_order_single;
DELIMITER $$
CREATE PROCEDURE place_order_single(
  IN  p_customer_id        INT,
  IN  p_employee_id        INT,
  IN  p_product_id         INT,
  IN  p_quantity_delta     INT,   -- > 0
  IN  p_existing_order_id  INT,   -- NULL=new order; NOT NULL=update that order
  OUT p_order_id           INT,
  OUT p_message            VARCHAR(255)
)
proc: BEGIN
  DECLARE v_stock       INT;
  DECLARE v_price       DECIMAL(10,2);
  DECLARE v_detail_qty  INT;
  DECLARE v_oid         INT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_order_id = NULL;
    SET p_message  = 'ERROR: Unexpected SQL exception, transaction rolled back';
  END;

  IF p_quantity_delta IS NULL OR p_quantity_delta <= 0 THEN
    SET p_order_id = NULL;
    SET p_message  = 'ERROR: Quantity must be a positive integer';
    LEAVE proc;
  END IF;

  START TRANSACTION;

  -- Lock the product row to prevent races
  SELECT Stock, Price INTO v_stock, v_price
  FROM Products
  WHERE ProductID = p_product_id
  FOR UPDATE;

  IF v_stock IS NULL THEN
    ROLLBACK;
    SET p_order_id = NULL;
    SET p_message  = CONCAT('PRODUCT_NOT_FOUND: ProductID=', p_product_id);
    LEAVE proc;
  END IF;

  IF v_stock < p_quantity_delta THEN
    ROLLBACK;
    SET p_order_id = NULL;
    SET p_message  = CONCAT('INSUFFICIENT_STOCK: Requested=', p_quantity_delta, ', Available=', v_stock);
    LEAVE proc;
  END IF;

  -- INSERT CASE
  IF p_existing_order_id IS NULL THEN
    INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, Status, PaymentStatus, ShippingMethod)
    VALUES (p_customer_id, p_employee_id, NOW(), 'Placed', 'Pending', 'Standard');

    SET v_oid = LAST_INSERT_ID();

    INSERT INTO Order_Details (OrderID, ProductID, Quantity, UnitPrice, DiscountApplied)
    VALUES (v_oid, p_product_id, p_quantity_delta, v_price, 0.00);

    UPDATE Products SET Stock = Stock - p_quantity_delta WHERE ProductID = p_product_id;

    COMMIT;
    SET p_order_id = v_oid;
    SET p_message  = CONCAT('SUCCESS_INSERT: Order ', v_oid, ' ProductID=', p_product_id,
                            ' qty=', p_quantity_delta, ' new_stock=', v_stock - p_quantity_delta);
    LEAVE proc;
  END IF;

  -- UPDATE CASE (must belong to same customer and be editable)
  SET v_oid = NULL;
  SELECT o.OrderID INTO v_oid
  FROM Orders o
  WHERE o.OrderID = p_existing_order_id
    AND o.CustomerID = p_customer_id
    AND o.Status IN ('Placed','Pending','Processing')
  LIMIT 1;

  IF v_oid IS NULL THEN
    ROLLBACK;
    SET p_order_id = NULL;
    SET p_message  = CONCAT('ERROR: Existing order ', p_existing_order_id, ' not editable or not owned by this customer');
    LEAVE proc;
  END IF;

  -- Insert or increment detail
  SET v_detail_qty = NULL;
  SELECT od.Quantity INTO v_detail_qty
  FROM Order_Details od
  WHERE od.OrderID = v_oid AND od.ProductID = p_product_id
  LIMIT 1;

  IF v_detail_qty IS NULL THEN
    INSERT INTO Order_Details (OrderID, ProductID, Quantity, UnitPrice, DiscountApplied)
    VALUES (v_oid, p_product_id, p_quantity_delta, v_price, 0.00);
  ELSE
    UPDATE Order_Details
    SET Quantity = Quantity + p_quantity_delta
    WHERE OrderID = v_oid AND ProductID = p_product_id;
  END IF;

  UPDATE Products SET Stock = Stock - p_quantity_delta WHERE ProductID = p_product_id;

  COMMIT;
  SET p_order_id = v_oid;
  SET p_message  = CONCAT('SUCCESS_UPDATE: Order ', v_oid, ' ProductID=', p_product_id,
                          ' +', p_quantity_delta, ' new_stock=', v_stock - p_quantity_delta);
END $$
DELIMITER ;
