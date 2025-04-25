#第16章_MySQL8.0的其它新特性
CREATE DATABASE dbtest18;
USE dbtest18;

#一.新特性1：窗口函数
CREATE TABLE sales(
id INT PRIMARY KEY AUTO_INCREMENT,
city VARCHAR(15),
county VARCHAR(15),
sales_value DECIMAL
);

INSERT INTO sales(city,county,sales_value)
VALUES
('北京','海淀',10.00),
('北京','朝阳',20.00),
('上海','黄埔',30.00),
('上海','长宁',10.00);

SELECT * FROM sales;

#1.问题引入：

#现在计算这个网站在每个城市的销售总额、在全国的销售总额、每个区的销售额占所在
#城市销售额中的比率，以及占总销售额中的比率

#方式一：
CREATE TEMPORARY TABLE a   -- 创建临时表
AS
SELECT SUM(sales_value) AS sales_value -- 计算总计金额
FROM sales;

CREATE TEMPORARY TABLE b    -- 创建临时表
AS
SELECT city,SUM(sales_value) AS sales_value  -- 计算城市销售合计
FROM sales
GROUP BY city;

SELECT s.city AS 城市,s.county AS 区,s.sales_value AS 区销售额,
b.sales_value AS 市销售额,s.sales_value/b.sales_value AS 市比率,
a.sales_value AS 总销售额,s.sales_value/a.sales_value AS 总比率
FROM sales s
JOIN b ON (s.city=b.city) -- 连接市统计结果临时表
JOIN a                   -- 连接总计金额临时表
ORDER BY s.city,s.county;



CREATE TABLE sum_sales
AS 
SELECT SUM(sales_value) AS sum_sales
FROM sales;

SELECT * FROM sum_sales;

CREATE TABLE city_sales
AS
SELECT city,SUM(sales_value) AS city_sales
FROM sales
GROUP BY city;

SELECT * FROM city_sales;

CREATE TABLE percent_sales
AS
SELECT s.id,s.city,s.county,s.sales_value,cs.city_sales,ss.sum_sales,
       s.sales_value/cs.city_sales AS city_percent,s.sales_value/ss.sum_sales AS sum_percent
FROM sales s JOIN sum_sales ss
JOIN city_sales cs 
ON s.city=cs.city

SELECT * FROM percent_sales;


#方式二：
SELECT 
    city AS 城市,
    county AS 区,
    sales_value AS 区销售额,
    SUM(sales_value) OVER (PARTITION BY city) AS 市销售额,
    sales_value / SUM(sales_value) OVER (PARTITION BY city) AS 市比率,
    SUM(sales_value) OVER () AS 总销售额,
    sales_value / SUM(sales_value) OVER () AS 总比率
FROM 
    sales
ORDER BY 
    city,
    county;
    
SELECT city AS 城市,county AS 区,sales_value AS 区销售额,
SUM(sales_value) OVER (PARTITION BY city) AS 市销售额,
sales_value/SUM(sales_value) OVER (PARTITION BY city) AS 市比率,
SUM(sales_value) OVER () AS 总销售额,
sales_value/SUM(sales_value) OVER () AS 总比率
FROM sales;

#2.语法结构：
#函数 OVER（[PARTITION BY 字段名 ORDER BY 字段名 ASC|DESC]）

#函数 OVER 窗口名 … WINDOW 窗口名 AS （[PARTITION BY 字段名 ORDER BY 字段名 ASC|DESC]）

#3.分类：
CREATE TABLE goods(
id INT PRIMARY KEY AUTO_INCREMENT,
category_id INT,
category VARCHAR(15),
NAME VARCHAR(30),
price DECIMAL(10,2),
stock INT,
upper_time DATETIME
);

INSERT INTO goods(category_id,category,NAME,price,stock,upper_time)
VALUES
(1, '女装/女士精品', 'T恤', 39.90, 1000, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '连衣裙', 79.90, 2500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '卫衣', 89.90, 1500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '牛仔裤', 89.90, 3500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '百褶裙', 29.90, 500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '呢绒外套', 399.90, 1200, '2020-11-10 00:00:00'),
(2, '户外运动', '自行车', 399.90, 1000, '2020-11-10 00:00:00'),
(2, '户外运动', '山地自行车', 1399.90, 2500, '2020-11-10 00:00:00'),
(2, '户外运动', '登山杖', 59.90, 1500, '2020-11-10 00:00:00'),
(2, '户外运动', '骑行装备', 399.90, 3500, '2020-11-10 00:00:00'),
(2, '户外运动', '运动外套', 799.90, 500, '2020-11-10 00:00:00'),
(2, '户外运动', '滑板', 499.90, 1200, '2020-11-10 00:00:00');

SELECT * FROM goods;

#3.1序号函数：
#3.1.1．ROW_NUMBER()函数
#ROW_NUMBER()函数能够对数据中的序号进行顺序显示。

#举例1：查询 goods 数据表中每个商品分类下价格降序排列的各个商品信息。
SELECT ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num,
id,category_id,category,NAME,price
FROM goods;

#举例：查询 goods 数据表中每个商品分类下价格最高的3种商品信息。
SELECT *
FROM (
	SELECT ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num,
	id,category_id,category,NAME,price
	FROM goods
	) t
WHERE row_num <=3;


#3.1.2．RANK()函数
#使用RANK()函数能够对序号进行并列排序，并且会跳过重复的序号，比如序号为1、1、3

#举例：使用RANK()函数获取 goods 数据表中类别为“女装/女士精品”的价格最高的4款商品信息。
SELECT *
FROM (
	SELECT RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_num,
	id,category_id,category,NAME,price
	FROM goods
	)t
WHERE rank_num<=4 AND category_id=1;


#3.1.3．DENSE_RANK()函数
#DENSE_RANK()函数对序号进行并列排序，并且不会跳过重复的序号，比如序号为1、1、2。

#举例：使用DENSE_RANK()函数获取 goods 数据表中类别为“女装/女士精品”的价格最高的4款商品信息。
SELECT *
FROM (
	SELECT DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_num,
	id,category_id,category,NAME,price
	FROM goods
	)t
WHERE category_id=1
LIMIT 0,4;



#3.2分布函数：
#3.2.1．PERCENT_RANK()函数
#PERCENT_RANK()函数是等级值百分比函数。按照如下方式进行计算
#(rank - 1) / (row - 1)
#其中，rank的值为使用RANK()函数产生的序号，rows的值为当前窗口的总记录数

#举例：计算 goods 数据表中名称为“女装/女士精品”的类别下的商品的PERCENT_RANK值。
SELECT RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num,
PERCENT_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS per_rank,
id,category_id,category,NAME,price
FROM goods
WHERE category_id=1;


#3.2.2．CUME_DIST()函数
#CUME_DIST()函数主要用于查询小于或等于某个值的比例

#举例：查询goods数据表中小于或等于当前价格的比例。
SELECT CUME_DIST() OVER (PARTITION BY category_id ORDER BY price) AS cume,
id,category_id,category,NAME,price
FROM goods;



#3.3前后函数：
#3.3.1．LAG(expr,n)函数
#LAG(expr,n)函数返回当前行的前n行的expr的值。

#举例：查询goods数据表中前一个商品价格与当前商品价格的差值。
SELECT *,lag_price-price AS diff_price
FROM (
	SELECT id,category_id,category,NAME,price,
	LAG(price,1) OVER (PARTITION BY category_id) AS lag_price
	FROM goods
	)t;

#3.3.2．LEAD(expr,n)函数
#LEAD(expr,n)函数返回当前行的后n行的expr的值

#举例：查询goods数据表中后一个商品价格与当前商品价格的差值。
SELECT *,price-lead_price AS diff_price
FROM (
	SELECT id,category_id,category,NAME,price,
	LEAD(price,1) OVER (PARTITION BY category_id) AS lead_price
	FROM goods
	)t;



#3.4首尾函数：
#3.4.1．FIRST_VALUE(expr)函数
#FIRST_VALUE(expr)函数返回第一个expr的值。

#举例：按照价格排序，查询第1个商品的价格信息。
SELECT *,FIRST_VALUE(price) OVER (PARTITION BY category_id ORDER BY price) AS first_price
FROM goods

#3.4.2．LAST_VALUE(expr)函数
#LAST_VALUE(expr)函数返回最后一个expr的值。

#举例：按照价格排序，查询最后一个商品的价格信息。
SELECT *,LAST_VALUE(price) OVER (PARTITION BY category_id ORDER BY price) AS last_price
FROM goods


#3.5其他函数：
#3.5.1．NTH_VALUE(expr,n)函数
#NTH_VALUE(expr,n)函数返回第n个expr的值。

#举例：查询goods数据表中排名第2和第3的价格信息。
SELECT *,NTH_VALUE(price,2) OVER (PARTITION BY category_id ORDER BY price) AS order2_price,
NTH_VALUE(price,3) OVER (PARTITION BY category_id ORDER BY price) AS order3_price
FROM goods;

#3.5.2．NTILE(n)函数
#NTILE(n)函数将分区中的有序数据分为n个桶，记录桶编号。

#举例：将goods表中的商品按照价格分为3组。
SELECT *,NTILE(7) OVER (PARTITION BY category_id ORDER BY price) AS ntile_num
FROM goods;



#二.新特性2：公用表表达式(CTE)
#1. 普通公用表表达式 
#普通公用表表达式类似于子查询，不过，跟子查询不同的是，它可以被多次引用
#而且可以被其他的普通公用表表达式所引用。

#普通公用表表达式的语法结构是：
WITH CTE名称 
AS （子查询）
SELECT|DELETE|UPDATE 语句;


#举例：查询员工所在的部门的详细信息。
CREATE TABLE employees
AS 
SELECT * 
FROM atguigudb.employees;

CREATE TABLE departments
AS 
SELECT * 
FROM atguigudb.departments;

SELECT * 
FROM departments
WHERE department_id=(
	SELECT department_id
	FROM employees
	WHERE last_name='Abel'
			);


#之前的版本：
SELECT * FROM departments
WHERE department_id IN (
			SELECT DISTINCT department_id
			FROM employees);


#公用表表达式：
WITH cte_dept
AS (SELECT DISTINCT department_id FROM employees)
SELECT *
FROM departments d JOIN cte_dept c
ON d.department_id=c.department_id;


WITH emp_dept_id
AS (SELECT DISTINCT department_id FROM employees)
SELECT *
FROM departments d JOIN emp_dept_id e
ON d.department_id = e.department_id;


#2 递归公用表表达式 
#递归公用表表达式也是一种公用表表达式，只不过，除了普通公用表表达式的特点以外
#它还有自己的特点，就是可以调用自己

#语法结构：
WITH RECURSIVE
CTE名称 AS （子查询）
SELECT|DELETE|UPDATE 语句;

#递归公用表表达式由 2 部分组成，分别是种子查询和递归查询，中间通过关键字 UNION [ALL]进行连接。
#这里的种子查询，意思就是获得递归的初始值。这个查询只会运行一次，以创建初始数据集
#之后递归查询会一直执行，直到没有任何新的查询数据产生，递归返回



#下面我们尝试用查询语句列出所有具有下下属身份的人员信息。
WITH RECURSIVE cte 
AS 
(
SELECT employee_id,last_name,manager_id,1 AS n FROM employees WHERE manager_id IS NULL
-- 种子查询，找到第一代领导
UNION ALL
SELECT a.employee_id,a.last_name,a.manager_id,n+1 FROM employees AS a JOIN cte
ON (a.manager_id = cte.employee_id) 
-- 递归查询，找出以递归公用表表达式的人为领导的人
)
SELECT employee_id,last_name FROM cte WHERE n >= 3; 


#练习：
#1. 创建students数据表，如下

CREATE DATABASE test18_mysql8;

USE test18_mysql8;

CREATE TABLE students(
id INT PRIMARY KEY AUTO_INCREMENT,
student VARCHAR(15),
points TINYINT
);

#2. 向表中添加数据如下
INSERT INTO students(student,points)
VALUES
('张三',89),
('李四',77),
('王五',88),
('赵六',90),
('孙七',90),
('周八',88);

SELECT * FROM students;

#3. 分别使用RANK()、DENSE_RANK() 和 ROW_NUMBER()函数对学生成绩降序排列情况进行显示
SELECT RANK() OVER (ORDER BY points DESC) AS rk,DENSE_RANK() OVER (ORDER BY points DESC) AS dr,
ROW_NUMBER() OVER (ORDER BY points DESC) AS rn,id,student,points
FROM students;

DROP DATABASE dbtest17;