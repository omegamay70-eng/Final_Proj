-- 06_core_queries.sql
USE bestbuy_dw;

-- 1) Total sales per product
SELECT p.ProductName, SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Order_Details od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSales DESC;

-- 2) Customers who purchased a specific product (example: ProductID = 1)
SELECT c.FirstName, c.LastName, c.Email
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
WHERE od.ProductID = 1;

-- 3) Orders per month/year
SELECT YEAR(o.OrderDate) AS Year, MONTH(o.OrderDate) AS Month, COUNT(*) AS OrdersCount
FROM Orders o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY Year, Month;

-- 4) Products stock status
SELECT ProductName, Stock,
       CASE WHEN Stock = 0 THEN 'Out of Stock'
            WHEN Stock < 10 THEN 'Low Stock'
            ELSE 'In Stock' END AS StockStatus
FROM Products;

-- 5) Top 5 employees by sales
SELECT e.FirstName, e.LastName, SUM(od.Quantity * od.UnitPrice) AS SalesAmount
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY SalesAmount DESC
LIMIT 5;

-- 6) Orders with totals, customer, employee
SELECT o.OrderID,
       c.FirstName AS CustomerFirstName, c.LastName AS CustomerLastName,
       e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName,
       (SELECT SUM(od.Quantity * od.UnitPrice) FROM Order_Details od WHERE od.OrderID = o.OrderID) AS TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID;

-- 7) Customers with pending orders and last product
SELECT c.FirstName, c.LastName, o.Status,
       ( SELECT p.ProductName
         FROM Order_Details od
         JOIN Products p ON od.ProductID = p.ProductID
         WHERE od.OrderID = o.OrderID
         ORDER BY od.OrderDetailID DESC
         LIMIT 1 ) AS LastProductPurchased
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Status = 'Pending';

-- 8) All orders with products
SELECT o.OrderID, c.FirstName, c.LastName, p.ProductName, od.Quantity
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

-- 9) Find Top 5 Most Expensive Products (ties included)
SELECT p.ProductName, p.Price
FROM Products p
WHERE p.Price >= (
  SELECT DISTINCT Price FROM Products
  ORDER BY Price DESC
  LIMIT 1 OFFSET 4
);

-- 10) Monthly revenue trend
WITH monthly AS (
  SELECT DATE_FORMAT(o.OrderDate,'%Y-%m-01') AS month_start,
         SUM(od.Quantity * od.UnitPrice) AS revenue
  FROM Orders o
  JOIN Order_Details od ON o.OrderID = od.OrderID
  GROUP BY DATE_FORMAT(o.OrderDate,'%Y-%m-01')
)
SELECT * FROM monthly ORDER BY month_start;
