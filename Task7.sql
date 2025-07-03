CREATE DATABASE EcommerceDB;
USE EcommerceDB;

DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price_at_purchase DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10, 2),
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers (name, email, phone, address) VALUES 
('Ankit', 'ankit@example.com', '9876543210', 'Delhi'),
('shruti', 'shruti@example.com', NULL, 'Mumbai'),
('tanshu', NULL, '9998887776', 'Bangalore'),
('janak', 'janak@example.com', '8889990000', NULL);

INSERT INTO Products (name, description, price, stock_quantity) VALUES 
('Laptop', '15-inch screen, 8GB RAM', 55000.00, 10),
('Smartphone', '128GB, 5G-enabled', 25000.00, 0),
('Headphones', NULL, 1500.00, 50),
('Wireless Mouse', 'Ergonomic design', 800.00, 20);

INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2024-06-15', 80000.00),
(2, '2024-06-16', 25000.00),
(3, '2024-06-17', NULL);

INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 55000.00),
(1, 3, 2, 1500.00),
(2, 2, 1, 25000.00),
(3, 4, 1, 800.00);

INSERT INTO Payments (order_id, payment_date, amount_paid, payment_method) VALUES
(1, '2024-06-15', 58000.00, 'Credit Card'),
(2, '2024-06-16', NULL, 'UPI'),
(3, '2024-06-17', 800.00, NULL);

UPDATE Customers
SET phone = '9123456789'
WHERE customer_id = 2 AND phone IS NULL;

UPDATE Customers
SET email = 'charlie.khan@example.com'
WHERE customer_id = 3 AND email IS NULL;

UPDATE Orders
SET total_amount = 800.00
WHERE order_id = 3 AND total_amount IS NULL;

UPDATE Products
SET description = 'Basic over-ear headphones'
WHERE product_id = 3 AND description IS NULL;

UPDATE Payments
SET amount_paid = 25000.00
WHERE payment_id = 2 AND amount_paid IS NULL;

UPDATE Payments
SET payment_method = 'Cash'
WHERE payment_id = 3 AND payment_method IS NULL;

DELETE FROM Orders
WHERE order_id = 3 AND total_amount IS NULL;

DELETE FROM Customers
WHERE customer_id = 3 AND email IS NULL;

DELETE FROM Products
WHERE product_id = 2 AND stock_quantity = 0;

SELECT * FROM Customers;

SELECT name, email FROM Customers;

SELECT * FROM Products
WHERE stock_quantity = 0;

SELECT * FROM Customers
WHERE address = 'Delhi' OR phone IS NULL;

SELECT * FROM Customers
WHERE email LIKE 'shruti@example.com';

SELECT * FROM Products
WHERE price BETWEEN 1000 AND 30000;

SELECT * FROM Products
ORDER BY price ASC;

SELECT * FROM Orders
ORDER BY order_date DESC
LIMIT 2;

SELECT COUNT(*) AS total_customers FROM Customers;

SELECT AVG(price) AS average_product_price FROM Products;

SELECT SUM(stock_quantity) AS total_stock FROM Products;

SELECT MIN(price) AS cheapest_product, MAX(price) AS most_expensive_product FROM Products;

SELECT product_id, COUNT(*) AS times_ordered FROM Order_Items GROUP BY product_id;

SELECT order_id, SUM(quantity) AS total_items_ordered FROM Order_Items GROUP BY order_id;

SELECT customer_id, COUNT(*) AS total_orders FROM Orders GROUP BY customer_id;

SELECT payment_method, SUM(amount_paid) AS total_collected FROM Payments GROUP BY payment_method;

SELECT payment_method, COUNT(*) AS method_count FROM Payments GROUP BY payment_method;

SELECT customer_id, MAX(total_amount) AS highest_order_value FROM Orders GROUP BY customer_id;

SELECT Customers.name, Orders.order_id, Orders.total_amount
FROM Customers
INNER JOIN Orders ON Customers.customer_id = Orders.customer_id;

SELECT Orders.order_id, Order_Items.product_id, Order_Items.quantity
FROM Orders
LEFT JOIN Order_Items ON Orders.order_id = Order_Items.order_id;

SELECT Products.name, Order_Items.quantity
FROM Order_Items
RIGHT JOIN Products ON Order_Items.product_id = Products.product_id;

SELECT Customers.name, Payments.amount_paid
FROM Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id
LEFT JOIN Payments ON Orders.order_id = Payments.order_id;

SELECT Orders.order_id, Payments.payment_date
FROM Orders
LEFT JOIN Payments ON Orders.order_id = Payments.order_id;

SELECT Products.name, Order_Items.price_at_purchase
FROM Products
INNER JOIN Order_Items ON Products.product_id = Order_Items.product_id;

SELECT Customers.name, Orders.order_id, Payments.amount_paid
FROM Customers
INNER JOIN Orders ON Customers.customer_id = Orders.customer_id
INNER JOIN Payments ON Orders.order_id = Payments.order_id;

SELECT Order_Items.order_id, Products.name, Order_Items.quantity
FROM Order_Items
INNER JOIN Products ON Order_Items.product_id = Products.product_id;

SELECT Orders.order_id, Customers.name
FROM Orders
RIGHT JOIN Customers ON Orders.customer_id = Customers.customer_id;

SELECT Customers.name, Orders.order_id, Payments.payment_id
FROM Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id
LEFT JOIN Payments ON Orders.order_id = Payments.order_id;

SELECT name,
       (SELECT COUNT(*) FROM Orders WHERE Orders.customer_id = Customers.customer_id) AS total_orders
FROM Customers;

SELECT name,
       (SELECT AVG(price) FROM Products) AS average_price
FROM Products;

SELECT name FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

SELECT name FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Orders WHERE total_amount > 2000);

SELECT order_id, total_amount FROM Orders
WHERE total_amount = (SELECT MAX(total_amount) FROM Orders);

SELECT customer_id, total_orders
FROM (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM Orders
    GROUP BY customer_id
) AS OrderCounts;

SELECT AVG(total_orders) AS avg_orders_per_customer
FROM (
    SELECT COUNT(*) AS total_orders
    FROM Orders
    GROUP BY customer_id
) AS grouped_orders;

CREATE VIEW CustomerOrders AS
SELECT Customers.name, Orders.order_id, Orders.total_amount
FROM Customers
INNER JOIN Orders ON Customers.customer_id = Orders.customer_id;

CREATE VIEW HighValueOrders AS
SELECT order_id, customer_id, total_amount
FROM Orders
WHERE total_amount > 2000;

CREATE VIEW ProductSummary AS
SELECT name, price, stock_quantity
FROM Products
WHERE stock_quantity > 0;

CREATE VIEW PaymentDetails AS
SELECT Payments.payment_id, Customers.name, Payments.amount_paid, Payments.payment_method
FROM Payments
JOIN Orders ON Payments.order_id = Orders.order_id
JOIN Customers ON Orders.customer_id = Customers.customer_id;

SELECT * FROM CustomerOrders;

SELECT * FROM HighValueOrders;

SELECT * FROM ProductSummary;

SELECT * FROM PaymentDetails;