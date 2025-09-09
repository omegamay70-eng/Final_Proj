-- 07_perf_indexes.sql
USE bestbuy_dw;

-- BEFORE: recent orders for a customer (expect filesort without composite)
EXPLAIN
SELECT OrderID, OrderDate, Status
FROM Orders
WHERE CustomerID = 1
ORDER BY OrderDate DESC
LIMIT 20;

-- Composite index for recent orders page
CREATE INDEX idx_orders_customer_orderdate ON Orders (CustomerID, OrderDate);

-- AFTER
EXPLAIN
SELECT OrderID, OrderDate, Status
FROM Orders
WHERE CustomerID = 1
ORDER BY OrderDate DESC
LIMIT 20;

-- BEFORE: order total (expect table access without covering)
EXPLAIN
SELECT od.OrderID, SUM(od.Quantity * od.UnitPrice) AS order_total
FROM Order_Details od
WHERE od.OrderID = 1
GROUP BY od.OrderID;

-- Covering index for order_total
CREATE INDEX idx_orderdetails_orderid_qty_price ON Order_Details (OrderID, Quantity, UnitPrice);

-- AFTER
EXPLAIN
SELECT od.OrderID, SUM(od.Quantity * od.UnitPrice) AS order_total
FROM Order_Details od
WHERE od.OrderID = 1
GROUP BY od.OrderID;
