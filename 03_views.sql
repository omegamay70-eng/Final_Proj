-- 03_views.sql
USE bestbuy_dw;

-- Product sales summary KPIs
CREATE OR REPLACE VIEW ProductSalesSummary AS
SELECT p.ProductID,
       p.ProductName,
       p.Price,
       (SELECT SUM(od.Quantity) FROM Order_Details od WHERE od.ProductID = p.ProductID) AS TotalUnitsSold,
       (SELECT SUM(od.Quantity * od.UnitPrice) FROM Order_Details od WHERE od.ProductID = p.ProductID) AS TotalRevenue
FROM Products p;

-- Low stock quick list
CREATE OR REPLACE VIEW LowStockProducts AS
SELECT ProductID, ProductName, Stock, Price,
       CASE WHEN Stock = 0 THEN 'Out of Stock'
            WHEN Stock <= 5 THEN 'Low Stock'
            ELSE 'In Stock' END AS StockStatus
FROM Products
WHERE Stock <= 5;
