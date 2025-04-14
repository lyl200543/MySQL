SELECT * FROM employees;
SELECT 1+1,2*3;
SELECT 1+1,2*3 FROM DUAL;
SELECT employee_id,first_name
FROM employees;
#6.列的别名
#as:全称:alias(别名)可以省略
#列的别名可以使用一对"引起来，不要使用''。
/*SELECT employee id emp id,last name As lname,department id "部门id",salary * 12 As "annual sal'
FROM employees;*/

SELECT * FROM employees;
SELECT employee_id emp_id,last_name lname,department_id AS dep_id,salary*12 "Annual sal"
FROM employees;

# 7. 去除重复行
#查询员工表中一共有哪些部门id呢？
#错误的:没有去重的情况
SELECT department_id
FROM employees;
#正确的：去重的情况
SELECT DISTINCT department_id
FROM employees;

#错误的：
SELECT salary,DISTINCT department_id
FROM employees;

#仅仅是没有报错，但是没有实际意义。
SELECT DISTINCT department_id,salary
FROM employees;

SELECT DISTINCT department_id 
FROM employees;

#8. 空值参与运算
# 1. 空值：null
# 2. null不等同于0，''，'null'
SELECT * FROM employees;

#3. 空值参与运算：结果一定也为空。
SELECT employee_id,salary "月工资",salary * (1 + commission_pct) * 12 "年工资",commission_pct
FROM employees;
#实际问题的解决方案：引入IFNULL
SELECT employee_id,salary "月工资",salary * (1 + IFNULL(commission_pct,0)) * 12 "年工资",commission_pct
FROM `employees`;

SELECT * FROM employees;
SELECT employee_id,salary "月工资",salary*(1+IFNULL(commission_pct,0))*12 "年工资"
FROM employees;

#9. 着重号 ``
#防止命名冲突

SELECT * FROM `order`

#10. 查询常数
SELECT '尚硅谷',123,employee_id,last_name
FROM employees;

SELECT * FROM employees;
SELECT '尚硅谷',123,phone_number,hire_date
FROM employees;

#11.显示表结构

DESCRIBE employees; #显示了表中字段的详细信息

DESC employees;

DESC departments;

SELECT * FROM employees;
DESCRIBE employees;
SELECT * FROM departments;
DESC departments;


#12.过滤数据

#练习：查询90号部门的员工信息
SELECT * 
FROM employees
#过滤条件,声明在FROM结构的后面
WHERE department_id = 90;

#练习：查询last_name为'King'的员工信息
SELECT * 
FROM EMPLOYEES
WHERE LAST_NAME = 'King'; 

SELECT * FROM employees;
SELECT * FROM employees
WHERE department_id=90;

SELECT * FROM employees
WHERE last_name='King';

SELECT * FROM employees
WHERE salary>10000;

# 1.查询员工12个月的工资总和，并起别名为ANNUAL SALARY
SELECT salary*(1+IFNULL(commission_pct,0))*12 "ANNUAL SALARY"
FROM employees;

# 2.查询employees表中去除重复的job_id以后的数据
SELECT DISTINCT job_id
FROM employees;

# 3.查询工资大于12000的员工姓名和工资
SELECT * FROM employees;
SELECT first_name,last_name,salary FROM employees
WHERE salary>12000;

# 4.查询员工号为176的员工的姓名和部门号
SELECT first_name,last_name,employee_id 
FROM employees
WHERE employee_id=176;

# 5.显示表 departments 的结构，并查询其中的全部数据 
DESC departments;
SELECT * FROM departments;
