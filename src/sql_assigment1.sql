CREATE DATABASE ecommerce

Create Table gold_members_data
(User_Id Int Primary key, 
User_name varchar(100), singup_date Date)
INSERT INTO gold_members_data values (001, 'Logesh', '2024-03-04'),
(002, 'Suba', '2013-04-20'),
(003, 'Thillai', '2014-06-10'),
(004, 'Kathir', '2015-05-27'),
(005, 'vicky', '2016-07-15'),
(006, 'prasanna', '2017-01-17')


Create Table Users_data(User_Id Int Primary key, 
User_name varchar(100), singup_date Date)
INSERT INTO Users_data VALUES
(001, 'Logesh', '2024-03-04'),
(002, 'Suba', '2018-04-20'),
(003, 'Thillai', '2016-06-10'),
(007, 'Muku', '2018-05-01'),
(008, 'kalai', '2019-03-25'),
(009, 'vidhya', '2020-08-13'),
(010, 'Mani', '2021-09-23'),
(006, 'prasanna', '2019-01-17')

create table sales_data(user_id INT,
USer_name varchar (100), created_date DATE,
product_id int)
Insert into sales_data values
(001, 'Logesh',   '2024-03-10',1),
(001, 'Logesh',   '2024-03-15',2),
(002, 'Suba',     '2019-04-20',1),
(003, 'Thillai',  '2019-06-10',1),
(007, 'Muku',     '2019-05-01',1),
(008, 'kalai',    '2019-12-25',3),
(009, 'vidhya',   '2021-08-13',1),
(010, 'Mani',     '2021-12-23',1),
(006, 'prasanna', '2020-05-17',1),
(004, 'Kathir',   '2015-07-27',2),
(005, 'vicky',    '2017-07-15',2),
(004, 'Kathir',   '2015-09-27',3),
(005, 'vicky',    '2016-12-15',3),
(002, 'Suba',     '2018-04-20',1),
(003, 'Thillai',  '2019-06-10',2),
(007, 'Muku',     '2020-05-01',2),
(008, 'kalai',    '2021-03-25',2),
(009, 'vidhya',   '2020-08-03',2),
(010, 'Mani',     '2022-09-23',2),
(006, 'prasanna', '2024-01-17',2)

CREATE TABLE Product_data (product_id int primary key,
product_name varchar(50),price int)
INSERT INTO Product_data values (1, 'mobile',20000),
(2,'laptop',45000),(3,'headset',2000)

--Show all the tables in the same database
SELECT * from gold_members_data
SELECT * from Users_data
SELECT * from sales_data
SELECT * from Product_data

--Count all the records of all four tables using single query
SELECT 'gold_members_data' as Table_name, count(*) as RecordCount
from  gold_members_data UNION ALL 
SELECT 'Users_data' , count(*) as RecordCount
from  Users_data UNION all 
SELECT 'Product_ID' , count(*) as RecordCount
from  Product_data UNION all 
SELECT 'Sales_data', count(*) as RecordCount
from  sales_data

----total amount each customer spent on ecommerce company
select u.USER_ID,u.USER_NAME, sum(price) as Total_amount from Users_data u
left join sales_data s on u.User_Id= s. user_id
left join Product_data p on s.product_id = p.product_id
group by u.user_id, u.user_name order by Total_amount DESC;

--distinct dates of each customer visited the website
SELECT DISTINCT s.created_date AS Date, u.User_name AS CustomerName
FROM sales_data s
INNER JOIN Users_data u ON s.user_id = u.User_Id
ORDER BY Date, CustomerName;

-- first product purchased by each customer 
SELECT u.user_name,min( p.product_name) as First_product
FROM Users_data u
JOIN sales_data s ON u.User_Id = s.user_id
JOIN Product_data p ON s.product_id = p.product_id
GROUP BY u.user_name
ORDER BY MIN(s.created_date);

--most purchased item of each customer and how many times the customer has purchased it
SELECT s.user_id, u.user_name, p.product_name, COUNT(*) AS item_count
FROM sales_data s
JOIN Users_data u ON s.user_id = u.user_id
JOIN Product_data p ON s.product_id = p.product_id
GROUP BY s.user_id, u.user_name, p.product_name
ORDER BY s.user_id, item_count DESC;

--customer who is not the gold_member_user
SELECT *
FROM Users_data
WHERE user_id NOT IN (SELECT user_id FROM gold_members_data);

--amount spent by each customer when he was the gold_member user
SELECT u.user_name, SUM(p.price) AS total_spent
FROM gold_members_data g
JOIN sales_data s ON g.User_Id = s.user_id
JOIN Product_data p ON s.product_id = p.product_id
JOIN Users_data u ON g.User_Id = u.User_Id
GROUP BY u.user_name;

--Customers names whose name starts with M
SELECT *
FROM Users_data
WHERE user_name LIKE 'M%';

--Distinct customer Id of each customer
SELECT DISTINCT user_id, user_name
FROM Users_data;

--Change the Column name from product table as price_value from price
EXEC sp_rename 'product_data.price', 'price_value', 'COLUMN';

select * from Product_data

--Change the Column value product_name – Ipad to Iphone from product table
UPDATE Product_data
SET product_name = 'Iphone'
WHERE product_name = 'mobile';

--Change the table name of gold_member_users to gold_membership_users
EXEC sp_rename 'gold_members_data', 'gold_membership_users';

 --Create a new column as Status in the table create above gold_membership_users
-- Alter column to change its data type
ALTER TABLE gold_membership_users 
ALTER COLUMN Status VARCHAR(3);

-- Add default constraint
ALTER TABLE gold_membership_users 
ADD CONSTRAINT DF_Status DEFAULT 'No' FOR Status;

-- Add check constraint
ALTER TABLE gold_membership_users
ADD CONSTRAINT CK_Status CHECK (Status IN ('Yes', 'No'));

--Insert one more record as same (3,'Laptop',330) as product table
INSERT INTO Product_data (product_id, product_name,price_value) VALUES (4, 'Laptop3', 330);

--to find the duplicates in product table
SELECT product_id, product_name, price_value, COUNT(*) AS duplicate_count
FROM Product_data
GROUP BY product_id, product_name, price_value
HAVING COUNT(*) > 1;


