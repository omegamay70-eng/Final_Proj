-- 01_schema_oltp.sql
USE bestbuy_dw;

-- Customers
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName   VARCHAR(50) NOT NULL,
  LastName    VARCHAR(50) NOT NULL,
  Email       VARCHAR(100) NOT NULL UNIQUE,
  Phone       VARCHAR(20),
  Street      VARCHAR(100),
  City        VARCHAR(50),
  State       CHAR(2),
  ZipCode     VARCHAR(10),
  CreatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_city (City),
  INDEX idx_state (State),
  INDEX idx_zip (ZipCode),
  INDEX idx_name (LastName, FirstName)
) ENGINE=InnoDB;

-- Employees
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY,
  FirstName  VARCHAR(50),
  LastName   VARCHAR(50),
  Department VARCHAR(50),
  City       VARCHAR(50),
  Email      VARCHAR(100),
  Phone      VARCHAR(20)
) ENGINE=InnoDB;

-- Products (authoritative for Price and Stock)
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
  ProductID    INT AUTO_INCREMENT PRIMARY KEY,
  ProductName  VARCHAR(100) NOT NULL,
  Category     VARCHAR(50)  NOT NULL,
  Supplier     VARCHAR(100) NOT NULL,
  ModelYear    INT NOT NULL CHECK (ModelYear >= 2000),
  Price        DECIMAL(10,2) NOT NULL CHECK (Price > 0),
  Stock        INT NOT NULL CHECK (Stock >= 0),
  Location     VARCHAR(50),
  INDEX idx_category (Category),
  INDEX idx_supplier (Supplier),
  INDEX idx_product_year (ProductName, ModelYear),
  INDEX idx_price (Price)
) ENGINE=InnoDB;

-- Orders
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID        INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID     INT NOT NULL,
  EmployeeID     INT NOT NULL,
  OrderDate      DATETIME NOT NULL,
  Status         VARCHAR(20) NOT NULL,
  PaymentStatus  VARCHAR(20) NOT NULL,
  ShippingMethod VARCHAR(20) NOT NULL,
  CONSTRAINT fk_orders_customer  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  CONSTRAINT fk_orders_employee  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
  INDEX idx_order_date (OrderDate),
  INDEX idx_status (Status),
  INDEX idx_payment_status (PaymentStatus)
) ENGINE=InnoDB;

-- Order_Details
DROP TABLE IF EXISTS Order_Details;
CREATE TABLE Order_Details (
  OrderDetailID    INT AUTO_INCREMENT PRIMARY KEY,
  OrderID          INT NOT NULL,
  ProductID        INT NOT NULL,
  Quantity         INT NOT NULL CHECK (Quantity > 0),
  UnitPrice        DECIMAL(10,2) NOT NULL,
  DiscountApplied  DECIMAL(5,2) DEFAULT 0,
  CONSTRAINT fk_od_order   FOREIGN KEY (OrderID)  REFERENCES Orders(OrderID)   ON DELETE CASCADE,
  CONSTRAINT fk_od_product FOREIGN KEY (ProductID)REFERENCES Products(ProductID) ON DELETE CASCADE,
  INDEX idx_od_order (OrderID),
  INDEX idx_od_product (ProductID)
) ENGINE=InnoDB;

-- Payment
DROP TABLE IF EXISTS Payment;
CREATE TABLE Payment (
  PaymentID     INT AUTO_INCREMENT PRIMARY KEY,
  OrderID       INT NOT NULL,
  PaymentMethod ENUM('Credit Card','PayPal','Bank Transfer') NOT NULL,
  AmountPaid    DECIMAL(10,2) NOT NULL,
  PaymentDate   DATETIME NOT NULL,
  Status        ENUM('Completed','Pending','Failed') NOT NULL DEFAULT 'Pending',
  CONSTRAINT fk_payment_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
  INDEX idx_payment_method (PaymentMethod)
) ENGINE=InnoDB;
