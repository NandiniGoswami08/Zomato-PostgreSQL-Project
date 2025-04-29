-- Zomato Data Analysis using SQL
-- ctrl / which convert the comment into code

CREATE TABLE Customers        -- CHILD TABLE
(
   customer_id INT PRIMARY KEY,
   customer_name VARCHAR(25),
   registered_date DATE
);

CREATE TABLE RESTAURANTS
(
   restaurant_id INT PRIMARY KEY,
   restaurant_name VARCHAR(25),
   city VARCHAR(25),
   opening_hours VARCHAR(25)
);

CREATE TABLE ORDERS
(
   order_id INT PRIMARY KEY,
   customer_id INT,      ---THIS COME FROM CUSTOMER TABLE
   restaurant_id INT,    ---THIS COME FROM RESTAURENT TABLE
   order_item VARCHAR(25),
   order_date DATE,
   order_time TIME,
   order_status VARCHAR(25),
   total_amount FLOAT
);

--ADDING FK CONSTRAINT
ALTER TABLE ORDERS
ADD CONSTRAINT FK_CUSTOMERS
FOREIGN KEY(customer_id)
REFERENCES CUSTOMERS(customer_id);

--ADDING FK CONSTRAINT
ALTER TABLE ORDERS
ADD CONSTRAINT FK_RESTAURANTS
FOREIGN KEY(restaurant_id)
REFERENCES RESTAURANTS(restaurant_id);

CREATE TABLE RIDERS
(
   rider_id INT PRIMARY KEY,
   rider_name VARCHAR(25),
   sign_up_date DATE
);

DROP TABLE IF EXISTS DELIVERY;
CREATE TABLE DELIVERY
(
   delivery_id INT PRIMARY KEY,
   order_id INT,
   delivery_status VARCHAR(25),
   delivery_time TIME,
   rider_id INT,
   CONSTRAINT FK_ORDERS FOREIGN KEY(order_id) REFERENCES ORDERS(order_id),
   CONSTRAINT FK_RIDERS FOREIGN KEY(rider_id) REFERENCES RIDERS(rider_id)
);









