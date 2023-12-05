create database daproject;
use daproject;
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 
INSERT INTO goldusers_signup (userid, gold_signup_date)
VALUES 
    (1, '2017-09-22'),
    (3, '2017-04-21');
    
drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 
INSERT INTO users (userid, signup_date)
VALUES 
    (1, '2014-09-02'),
    (2, '2015-01-15'),
    (3, '2014-04-11');
drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 
INSERT INTO sales (userid, created_date, product_id)
VALUES 
    (1, '2017-04-19', 2),
    (3, '2019-12-18', 1),
    (2, '2020-07-20', 3),
    (1, '2019-10-23', 2),
    (1, '2018-03-19', 3),
    (3, '2016-12-20', 2),
    (1, '2016-11-09', 1),
    (1, '2016-05-20', 3),
    (2, '2017-09-24', 1),
    (1, '2017-03-11', 2),
    (1, '2016-03-11', 1),
    (3, '2016-11-10', 1),
    (3, '2017-12-07', 2),
    (3, '2016-12-15', 2),
    (2, '2017-11-08', 2),
    (2, '2018-09-10', 3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 
INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);
select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

-- Total amount each customer spent on Zomato?
select a.userid,a.product_id,sum(b.price) as Total_amount_spent from sales a inner join product b on a.product_id=b.product_id group by a.userid;
--  How many days has each customer vsited Zomato?
select userid,count(distinct created_date) as distinct_days from sales group by userid;
-- What was the first product purchased by each customer?
select * from(select *,rank() over(partition by userid order by created_date) as rnk from sales) as alias_name where rnk=1;

-- most purchased item on the menu and how many times was it purchased by all customer?

SELECT userid, COUNT(product_id) as cnt
FROM sales
WHERE product_id = (SELECT MAX(product_id) 
                    FROM sales 
                    GROUP BY product_id 
                    ORDER BY COUNT(product_id) DESC 
                    LIMIT 1)
GROUP BY userid;

-- Most popular item for each customer?
select * from (select *,rank() over(partition by userid order by cnt desc) rnk from (select userid,product_id,count(product_id) cnt from sales group by userid,product_id)as a)as b where rnk=1;
