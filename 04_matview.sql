-- 04_matview.sql
USE bestbuy_dw;

-- Simulated materialized view (summary table + refresh proc)
CREATE TABLE IF NOT EXISTS MaterializedProductSales (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  TotalUnitsSold INT,
  TotalRevenue DECIMAL(10,2),
  LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

DROP PROCEDURE IF EXISTS RefreshMaterializedProductSales;
DELIMITER $$
CREATE PROCEDURE RefreshMaterializedProductSales()
BEGIN
  TRUNCATE TABLE MaterializedProductSales;
  INSERT INTO MaterializedProductSales (ProductID, ProductName, TotalUnitsSold, TotalRevenue)
  SELECT p.ProductID, p.ProductName,
         IFNULL(SUM(od.Quantity), 0),
         IFNULL(SUM(od.Quantity * od.UnitPrice), 0)
  FROM Products p
  LEFT JOIN Order_Details od ON p.ProductID = od.ProductID
  GROUP BY p.ProductID, p.ProductName;
END $$
DELIMITER ;

-- Initial refresh
CALL RefreshMaterializedProductSales();

-- Optional: enable event scheduler and auto-refresh (commented)
-- SET GLOBAL event_scheduler = ON;
-- CREATE EVENT IF NOT EXISTS ev_refresh_mps
--   ON SCHEDULE EVERY 1 HOUR
--   DO CALL RefreshMaterializedProductSales();
