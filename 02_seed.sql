-- 02_seed.sql
USE bestbuy_dw;
-- NOTE: Include at least 500 rows across tables for meaningful analytics.
-- Below are small starter samples; extend with your full dataset as needed.

-- Employees (sample)
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, City, Email, Phone) VALUES
(1,'Ava','Lopez','Sales','Los Angeles','ava.lopez@bestbuy.local','555-1001'),
(2,'Ben','Kim','Sales','San Diego','ben.kim@bestbuy.local','555-1002'),
(3,'Cara','Singh','Support','San Jose','cara.singh@bestbuy.local','555-1003');

-- Customers (sample)
INSERT INTO Customers (FirstName, LastName, Email, Phone, City, State, ZipCode) VALUES
('John','Doe','john.doe@example.com','555-2001','Los Angeles','CA','90001'),
('Jane','Smith','jane.smith@example.com','555-2002','San Diego','CA','92101'),
('Mike','Brown','mike.brown@example.com','555-2003','San Jose','CA','95112');

-- Products (sample)
INSERT INTO Products (ProductName, Category, Supplier, ModelYear, Price, Stock, Location) VALUES
('4K TV 55"','TV','Samsung','2024',799.00,50,'LA-WH1'),
('Noise Cancelling Headphones','Audio','Sony','2024',249.99,120,'LA-WH2'),
('Gaming Laptop 15"','Computers','ASUS','2025',1499.00,35,'SD-WH1');

-- Orders (sample)
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, Status, PaymentStatus, ShippingMethod) VALUES
(1,1,NOW(),'Placed','Pending','Standard'),
(2,2,NOW(),'Placed','Pending','Express'),
(3,1,NOW(),'Placed','Pending','Standard');

-- Order_Details (sample)
INSERT INTO Order_Details (OrderID, ProductID, Quantity, UnitPrice, DiscountApplied) VALUES
(1,1,1,799.00,0.00),
(1,2,2,249.99,0.00),
(2,3,1,1499.00,0.00);

-- Payment (sample)
INSERT INTO Payment (OrderID, PaymentMethod, AmountPaid, PaymentDate, Status) VALUES
(1,'Credit Card',1298.98,NOW(),'Completed'),
(2,'PayPal',1499.00,NOW(),'Completed');

-- >>> Add your larger synthetic dataset here (CSV imports or bulk INSERTs) <<<
