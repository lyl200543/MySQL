#第14章_变量、流程控制与游标

#1. 变量
#1.1 变量： 系统变量（全局系统变量、会话系统变量）  vs 用户自定义变量

#1.2 查看系统变量
#查询全局系统变量
SHOW GLOBAL VARIABLES; #617

SHOW GLOBAL VARIABLES;

#查询会话系统变量
SHOW SESSION VARIABLES; #640

SHOW VARIABLES; #默认查询的是会话系统变量

SHOW SESSION VARIABLES;
SHOW VARIABLES;

#查询部分系统变量

SHOW GLOBAL VARIABLES LIKE 'admin_%';

SHOW VARIABLES LIKE 'character_%';

SHOW GLOBAL VARIABLES LIKE 'admin_%';

SHOW VARIABLES LIKE 'character_%';

#1.3 查看指定系统变量

SELECT @@global.max_connections;
SELECT @@global.character_set_client;

SELECT @@global.max_connections;
SELECT @@global.character_set_client;
#错误：
SELECT @@global.pseudo_thread_id;

#错误：
SELECT @@session.max_connections;

SELECT @@session.character_set_client;

SELECT @@session.pseudo_thread_id;

SELECT @@character_set_client; #先查询会话系统变量，再查询全局系统变量

SELECT @@session.character_set_client;
SELECT @@session.pseudo_thread_id;


#1.4 修改系统变量的值
#全局系统变量：
#方式1：
SET @@global.max_connections = 161;
#方式2：
SET GLOBAL max_connections = 171;

#针对于当前的数据库实例是有效的，一旦重启mysql服务，就失效了。
SELECT @@global.max_connections;
SET @@global.max_connections =161;
SET GLOBAL max_connections=171;

#会话系统变量：
#方式1：
SET @@session.character_set_client = 'gbk';
#方式2：
SET SESSION character_set_client = 'gbk';

#?重启服务器后字符集仍为gbk
SELECT @@session.character_set_client;
SET @@session.character_set_client='gbk';
SET SESSION character_set_client='gbk';

#针对于当前会话是有效的，一旦结束会话，重新建立起新的会话，就失效了。


#1.5 用户变量
/*
① 用户变量 ： 会话用户变量 vs 局部变量

② 会话用户变量：使用"@"开头，作用域为当前会话。

③ 局部变量：只能使用在存储过程和存储函数中的。

*/

#1.6 会话用户变量
/*
① 变量的声明和赋值：
#方式1：“=”或“:=”
SET @用户变量 = 值;
SET @用户变量 := 值;

#方式2：“:=” 或 INTO关键字
SELECT @用户变量 := 表达式 [FROM 等子句];
SELECT 表达式 INTO @用户变量  [FROM 等子句];

② 使用
SELECT @变量名

*/
#准备工作
CREATE DATABASE dbtest16;

USE dbtest16;

CREATE TABLE employees
AS
SELECT * FROM atguigudb.`employees`;

CREATE TABLE departments
AS
SELECT * FROM atguigudb.`departments`;

SELECT * FROM employees;
SELECT * FROM departments;

#测试：
#方式1：
SET @m1 = 1;
SET @m2 := 2;
SET @sum := @m1 + @m2;

SELECT @sum;

SET @m1=1;
SET @m2=2;
SET @sum=@m1+@m2;

SELECT @sum;

#方式2：
SELECT @count := COUNT(*) FROM employees;

SELECT @count;

SELECT AVG(salary) INTO @avg_sal FROM employees;

SELECT @avg_sal;

SELECT @count:=COUNT(*)
FROM employees;

SELECT @count;

SELECT AVG(salary) INTO @avg_sal
FROM employees;

SELECT @avg_sal;

#1.7 局部变量
/*
1、局部变量必须满足：
① 使用DECLARE声明 
② 声明并使用在BEGIN ... END 中 （使用在存储过程、函数中）
③ DECLARE的方式声明的局部变量必须声明在BEGIN中的首行的位置。

2、声明格式：
DECLARE 变量名 类型 [default 值];  # 如果没有DEFAULT子句，初始值为NULL

3、赋值：
方式1：
SET 变量名=值;
SET 变量名:=值;

方式2：
SELECT 字段名或表达式 INTO 变量名 FROM 表;

4、使用
SELECT 局部变量名;
*/

#举例：
DELIMITER //

CREATE PROCEDURE test_var()

BEGIN
	#1、声明局部变量
	DECLARE a INT DEFAULT 0;
	DECLARE b INT ;
	#DECLARE a,b INT DEFAULT 0;
	DECLARE emp_name VARCHAR(25);
	
	#2、赋值
	SET a = 1;
	SET b := 2;
	
	SELECT last_name INTO emp_name FROM employees WHERE employee_id = 101;
	
	#3、使用
	SELECT a,b,emp_name;	
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE test_var()

BEGIN 
	DECLARE a INT DEFAULT 0;
	DECLARE b INT;
	DECLARE emp_name VARCHAR(25);
	
	SET a=1;
	SET b:=2;
	
	SELECT last_name INTO emp_name 
	FROM employees
	WHERE employee_id=102;
	
	SELECT a,b,emp_name;
	
END //

DELIMITER ;


#调用存储过程
CALL test_var();

CALL test_var();

#举例1：声明局部变量，并分别赋值为employees表中employee_id为102
#的last_name和salary
DELIMITER //

CREATE PROCEDURE test_pro()
BEGIN 
	DECLARE NAME VARCHAR(25);
	DECLARE sal DOUBLE;
	
	SELECT last_name,salary INTO NAME,sal
	FROM employees
	WHERE employee_id=102;
	
	SELECT NAME,sal;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE test_pro()
BEGIN
	#声明
	DECLARE emp_name VARCHAR(25);
	DECLARE sal DOUBLE(10,2) DEFAULT 0.0;
	#赋值
	SELECT last_name,salary INTO emp_name,sal
	FROM employees
	WHERE employee_id = 102;
	#使用
	SELECT emp_name,sal;
	
END //

DELIMITER ;

#调用存储过程

CALL test_pro();

CALL test_pro();

SELECT last_name,salary FROM employees
WHERE employee_id = 102;

#举例2：声明两个变量，求和并打印 （分别使用会话用户变量、局部变量的方式实现）

#方式1：使用会话用户变量
SET @v1 = 10;
SET @v2 := 20;
SET @result := @v1 + @v2;

SET @v1=10;
SET @v2:=20;
SET @result=@v1+@v2;

#查看
SELECT @result;

SELECT @result;

#方式2：使用局部变量
DROP PROCEDURE add_value;

DELIMITER //

CREATE PROCEDURE add_value()
BEGIN
	DECLARE value1,value2 INT;
	
	SET value1=10;
	SET value2=100;
	
	SELECT value1+value2;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE add_value()
BEGIN
	#声明
	DECLARE value1,value2,sum_val INT;
	
	#赋值
	SET value1 = 10;
	SET value2 := 100;
	
	SET sum_val = value1 + value2;
	#使用
	SELECT sum_val;
END //

DELIMITER ;

#调用存储过程
CALL add_value();

CALL add_value();

#举例3：创建存储过程“different_salary”查询某员工和他领导的薪资差距
#并用IN参数emp_id接收员工id，
#用OUT参数dif_salary输出薪资差距结果。
DELIMITER //

CREATE PROCEDURE different_salary(IN emp_id INT,OUT dif_salary DOUBLE)
BEGIN
	DECLARE emp_sal DOUBLE;
	DECLARE mgr_sal DOUBLE;	
	
	SELECT salary INTO emp_sal
	FROM employees
	WHERE employee_id=emp_id;
	
	SELECT salary INTO mgr_sal
	FROM employees
	WHERE employee_id=(
				SELECT manager_id
				FROM employees
				WHERE employee_id=emp_id
				);
	
	SET dif_salary=mgr_sal-emp_sal;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE different_salary(IN emp_id INT,OUT dif_salary DOUBLE)
BEGIN
	#分析：查询出emp_id员工的工资;查询出emp_id员工的管理者的id;查询管理者id的工资;计算两个工资的差值
	
	#声明变量
	DECLARE emp_sal DOUBLE DEFAULT 0.0; #记录员工的工资
	DECLARE mgr_sal DOUBLE DEFAULT 0.0; #记录管理者的工资
	
	DECLARE mgr_id INT DEFAULT 0; #记录管理者的id
	
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	
	SELECT manager_id INTO mgr_id FROM employees WHERE employee_id = emp_id;
	SELECT salary INTO mgr_sal FROM employees WHERE employee_id = mgr_id;
	
	SET dif_salary = mgr_sal - emp_sal;

END //
DELIMITER ;

#调用存储过程
SET @emp_id := 103;
SET @dif_sal := 0;
CALL different_salary(@emp_id,@dif_sal);

SELECT @dif_sal;

SELECT * FROM employees;

SET @emp_id=102;
CALL different_salary(@emp_id,@dif_sal);

SELECT @dif_sal;

#2. 定义条件和处理程序

#2.1 错误演示：

#错误代码： 1364
#Field 'email' doesn't have a default value
INSERT INTO employees(last_name)
VALUES('Tom');

DESC employees;

#错误演示：
DELIMITER //

CREATE PROCEDURE UpdateDataNoCondition()
	BEGIN
		SET @x = 1;
		UPDATE employees SET email = NULL WHERE last_name = 'Abel';
		SET @x = 2;
		UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
		SET @x = 3;
	END //

DELIMITER ;

#调用存储过程
#错误代码： 1048
#Column 'email' cannot be null
CALL UpdateDataNoCondition();

SELECT @x;


#2.2 定义条件
#格式：DECLARE 错误名称 CONDITION FOR 错误码（或错误条件）

#举例1：定义“Field_Not_Be_NULL”错误名与MySQL中违反非空约束的错误类型
#是“ERROR 1048 (23000)”对应。
#方式1：使用MySQL_error_code
DECLARE Field_Not_Be_NULL CONDITION FOR 1048;

DECLARE Field_Not_Be_NULL CONDITION FOR 1048;

#方式2：使用sqlstate_value
DECLARE Field_Not_Be_NULL CONDITION FOR SQLSTATE '23000';

DECLARE Field_Not_Be_NULL CONDITION FOR SQLSTATE '23000';

#举例2：定义"ERROR 1148(42000)"错误，名称为command_not_allowed。
#方式1：使用MySQL_error_code
DECLARE command_not_allowed CONDITION FOR 1148;

DECLARE command_not_allowed CONDITION FOR 1148;

#方式2：使用sqlstate_value
DECLARE command_not_allowed CONDITION FOR SQLSTATE '42000';

DECLARE command_not_allowed CONDITION FOR SQLSTATE '42000';


#2.3 定义处理程序
#格式：DECLARE 处理方式 HANDLER FOR 错误类型 处理语句

#举例：
#方法1：捕获sqlstate_value
DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @info = 'NO_SUCH_TABLE';

#方法2：捕获mysql_error_value
DECLARE CONTINUE HANDLER FOR 1146 SET @info = 'NO_SUCH_TABLE';

#方法3：先定义条件，再调用
DECLARE no_such_table CONDITION FOR 1146;
DECLARE CONTINUE HANDLER FOR no_such_table SET @info = 'NO_SUCH_TABLE';

#方法4：使用SQLWARNING
DECLARE EXIT HANDLER FOR SQLWARNING SET @info = 'ERROR';

#方法5：使用NOT FOUND
DECLARE EXIT HANDLER FOR NOT FOUND SET @info = 'NO_SUCH_TABLE';

#方法6：使用SQLEXCEPTION
DECLARE EXIT HANDLER FOR SQLEXCEPTION SET @info = 'ERROR';


#2.4 案例的处理

DROP PROCEDURE UpdateDataNoCondition;

#重新定义存储过程，体现错误的处理程序
DELIMITER //

CREATE PROCEDURE UpdateDataNoCondition()
	BEGIN
		#声明处理程序
		#处理方式1：
		DECLARE CONTINUE HANDLER FOR 1048 SET @prc_value = -1;
		
		DECLARE CONTINUE HANDLER FOR 1048 SET @prc_value = -1;
		#处理方式2：
		#DECLARE CONTINUE HANDLER FOR sqlstate '23000' SET @prc_value = -1;
		
		DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @prc_value = -1;	
	
		SET @x = 1;
		UPDATE employees SET email = NULL WHERE last_name = 'Abel';
		SET @x = 2;
		UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
		SET @x = 3;
	END //

DELIMITER ;

#调用存储过程：
CALL UpdateDataNoCondition();

#查看变量：
SELECT @x,@prc_value;

#2.5 再举一个例子：
#创建一个名称为“InsertDataWithCondition”的存储过程

#① 准备工作
CREATE TABLE departments
AS
SELECT * FROM atguigudb.`departments`;

DESC departments;

ALTER TABLE departments
ADD CONSTRAINT uk_dept_name UNIQUE(department_id);

ALTER TABLE departments
ADD UNIQUE(department_id);

#② 定义存储过程：
DELIMITER //

CREATE PROCEDURE InsertDataWithCondition()
	BEGIN		
		SET @x = 1;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 2;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 3;
	END //

DELIMITER ;

#③ 调用
CALL InsertDataWithCondition();

SELECT @x;  #2

#④ 删除此存储过程
DROP PROCEDURE IF EXISTS InsertDataWithCondition;

#⑤ 重新定义存储过程（考虑到错误的处理程序）

DELIMITER //

CREATE PROCEDURE InsertDataWithCondition()
	BEGIN		
		
		#处理程序
		#方式1：
		#declare exit handler for 1062 set @pro_value = -1;
		
		DECLARE EXIT HANDLER FOR 1062 SET @pro_value = -1;
		#方式2：
		#declare exit handler for sqlstate '23000' set @pro_value = -1;
		
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET @pro_value = -1;		
		#方式3：
		#定义条件
		DECLARE duplicate_entry CONDITION FOR 1062;
		DECLARE EXIT HANDLER FOR duplicate_entry SET @pro_value = -1;
		
		DECLARE duplicate_entry CONDITION foe 1062;
		DECLARE EXIT HANDLER FOR duplicate_entry SET @pro_value = -1;		
		
		
		SET @x = 1;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 2;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 3;
	END //

DELIMITER ;

#调用
CALL InsertDataWithCondition();

SELECT @x,@pro_value;



#3. 流程控制
#3.1 分支结构之 IF

#举例1

DELIMITER //

CREATE PROCEDURE test_if()

BEGIN	
	#情况1：
	#声明局部变量
	#declare stu_name varchar(15);
	
	#if stu_name is null 
	#	then select 'stu_name is null';
	#end if;
	
	#情况2：二选一
	#declare email varchar(25) default 'aaa';
	
	#if email is null
	#	then select 'email is null';
	#else
	#	select 'email is not null';
	#end if;
	
	#情况3：多选一
	DECLARE age INT DEFAULT 20;
	
	IF age > 40
		THEN SELECT '中老年';
	ELSEIF age > 18
		THEN SELECT '青壮年';
	ELSEIF age > 8
		THEN SELECT '青少年';
	ELSE
		SELECT '婴幼儿';
	END IF;
	

END //

DELIMITER ;

#调用
CALL test_if();

DROP PROCEDURE test_if;


DELIMITER //

CREATE PROCEDURE test_if()
BEGIN 
	#1.
	#declare emp_name varchar(15);
	
	#if emp_name is null then select 'emp_name is null';
	#end if;
	
	#2.
	#declare email varchar(25);
	
	#if email is null then select 'email is null';
	#else select 'email is not null';
	#end if;
	
	#3.
	DECLARE age INT DEFAULT 20;
	
	IF age>40 THEN SELECT '老壮年';
	ELSEIF age>20 THEN SELECT '青壮年';
	ELSEIF age>6 THEN SELECT '青少年';
	ELSE SELECT '婴幼年';
	END IF;
	
END //

DELIMITER ;

CALL test_if();

DROP PROCEDURE test_if;

#举例2：声明存储过程“update_salary_by_eid1”，定义IN参数emp_id，输入员工编号。
#判断该员工薪资如果低于8000元并且入职时间超过5年，就涨薪500元；否则就不变。
DELIMITER //

CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
BEGIN 
	DECLARE sal DOUBLE;
	DECLARE diff_date DOUBLE;
	
	SELECT salary,DATEDIFF(CURDATE(),hire_date)/365 INTO sal,diff_date
	FROM employees
	WHERE employee_id=emp_id;
	
	IF sal<8000 AND diff_date>=5 
			THEN UPDATE employees
			SET salary=salary+500 
			WHERE employee_id=emp_id;
	END IF;
END //

DELIMITER ;

CALL update_salary_by_eid1(104);

SELECT * FROM employees;


DELIMITER //

CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
BEGIN
	#声明局部变量
	DECLARE emp_sal DOUBLE; #记录员工的工资
	DECLARE hire_year DOUBLE; #记录员工入职公司的年头
	
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	
	SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employees WHERE employee_id = emp_id;
	
	#判断
	IF emp_sal < 8000 AND hire_year >= 5
		THEN UPDATE employees SET salary = salary + 500 WHERE employee_id = emp_id;
	END IF;
END //

DELIMITER ;

#调用存储过程
CALL update_salary_by_eid1(104);

SELECT DATEDIFF(CURDATE(),hire_date)/365, employee_id,salary
FROM employees
WHERE salary < 8000 AND DATEDIFF(CURDATE(),hire_date)/365 >= 5;

DROP PROCEDURE update_salary_by_eid1;


#举例3：声明存储过程“update_salary_by_eid2”，定义IN参数emp_id，输入员工编号。
#判断该员工薪资如果低于9000元并且入职时间超过5年，就涨薪500元；否则就涨薪100元。

DELIMITER //

CREATE PROCEDURE update_salary_by_eid2(IN emp_id INT)
BEGIN
	#声明局部变量
	DECLARE emp_sal DOUBLE; #记录员工的工资
	DECLARE hire_year DOUBLE; #记录员工入职公司的年头
	
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	
	SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employees WHERE employee_id = emp_id;
	
	#判断
	IF emp_sal < 9000 AND hire_year >= 5
		THEN UPDATE employees SET salary = salary + 500 WHERE employee_id = emp_id;
	ELSE
		UPDATE employees SET salary=salary+100 WHERE employee_id=emp_id;
	END IF;
END //

DELIMITER ;

#调用
CALL update_salary_by_eid2(103);
CALL update_salary_by_eid2(104);

SELECT * FROM employees
WHERE employee_id IN (103,104);


#举例4：声明存储过程“update_salary_by_eid3”，定义IN参数emp_id，输入员工编号。
#判断该员工薪资如果低于9000元，就更新薪资为9000元；薪资如果大于等于9000元且
#低于10000的，但是奖金比例为NULL的，就更新奖金比例为0.01；其他的涨薪100元。
DELIMITER //

CREATE PROCEDURE update_salary_by_eid3(IN emp_id INT)
BEGIN
	DECLARE sal DOUBLE;
	DECLARE bonus DOUBLE;
	
	SELECT salary,commission_pct INTO sal,bonus
	FROM employees
	WHERE employee_id=emp_id;
	
	IF sal <9000 
			THEN UPDATE employees
			SET salary=9000
			WHERE employee_id=emp_id;
	ELSEIF sal <10000 AND bonus IS NULL
			THEN UPDATE employees
			SET commission_pct=0.01
			WHERE employee_id=emp_id;
	ELSE 
			UPDATE employees
			SET salary=salary+100
			WHERE employee_id=emp_id;
	END IF;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE update_salary_by_eid3(IN emp_id INT)
BEGIN
	#声明变量
	DECLARE emp_sal DOUBLE; #记录员工工资
	DECLARE bonus DOUBLE; #记录员工的奖金率
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	SELECT commission_pct INTO bonus FROM employees WHERE employee_id = emp_id;
	
	
	#判断
	IF emp_sal < 9000 
		THEN UPDATE employees SET salary = 9000 WHERE employee_id = emp_id;
	ELSEIF emp_sal < 10000 AND bonus IS NULL
		THEN UPDATE employees SET commission_pct = 0.01 WHERE employee_id = emp_id;
	ELSE 
		UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
	END IF;

END //


DELIMITER ;

#调用
CALL update_salary_by_eid3(102);
CALL update_salary_by_eid3(103);
CALL update_salary_by_eid3(104);

SELECT *
FROM employees
WHERE employee_id IN (102,103,104);


##3.2 分支结构之case

#举例1:基本使用
DELIMITER //
CREATE PROCEDURE test_case()
BEGIN
	#演示1：case ... when ...then ...
	/*
	declare var int default 2;
	
	case var
		when 1 then select 'var = 1';
		when 2 then select 'var = 2';
		when 3 then select 'var = 3';
		else select 'other value';
	end case;
	*/
	#演示2：case when ... then ....
	DECLARE var1 INT DEFAULT 10;
	CASE 
	WHEN var1 >= 100 THEN SELECT '三位数';
	WHEN var1 >= 10 THEN SELECT '两位数';
	ELSE SELECT '个数位';
	END CASE;

END //

DELIMITER ;

#调用
CALL test_case();

DROP PROCEDURE test_case;

#举例2：声明存储过程“update_salary_by_eid4”，定义IN参数emp_id，输入员工编号。
#判断该员工薪资如果低于9000元，就更新薪资为9000元；薪资大于等于9000元且低于10000的，
#但是奖金比例为NULL的，就更新奖金比例为0.01；其他的涨薪100元。
DELIMITER //

CREATE PROCEDURE update_salary_by_eid4(IN emp_id INT)
BEGIN
	DECLARE sal DOUBLE;
	DECLARE bonus DOUBLE;
	
	SELECT salary,commission_pct INTO sal,bonus
	FROM employees
	WHERE employee_id=emp_id;
	
	CASE WHEN sal<9000
			THEN UPDATE employees
			SET salary=9000
			WHERE employee_id=emp_id;
	WHEN sal <10000 AND bonus IS NULL
			THEN UPDATE employees
			SET commission_pct=0.01
			WHERE employee_id=emp_id;
	ELSE 
			UPDATE employees
			SET salary=salary+100
			WHERE employee_id=emp_id;
	END CASE;
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE update_salary_by_eid4(IN emp_id INT)
BEGIN
	#局部变量的声明
	DECLARE emp_sal DOUBLE; #记录员工的工资
	DECLARE bonus DOUBLE; #记录员工的奖金率
	
	#局部变量的赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	SELECT commission_pct INTO bonus FROM employees WHERE employee_id = emp_id;
	
	CASE
	WHEN emp_sal < 9000 THEN UPDATE employees SET salary = 9000 WHERE employee_id = emp_id;
	WHEN emp_sal < 10000 AND bonus IS NULL THEN UPDATE employees SET commission_pct = 0.01 
						    WHERE employee_id = emp_id;
	ELSE UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
	END CASE;
	

END //

DELIMITER ;

#调用
CALL update_salary_by_eid4(103);
CALL update_salary_by_eid4(104);
CALL update_salary_by_eid4(105);

SELECT *
FROM employees
WHERE employee_id IN (103,104,105);

#举例3：声明存储过程update_salary_by_eid5，定义IN参数emp_id，输入员工编号。
#判断该员工的入职年限，如果是0年，薪资涨50；如果是1年，薪资涨100；
#如果是2年，薪资涨200；如果是3年，薪资涨300；如果是4年，薪资涨400；其他的涨薪500。
DELIMITER //

CREATE PROCEDURE update_salary_by_eid5(IN emp_id INT)
BEGIN
	DECLARE diff_date INT;
	
	SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO diff_date
	FROM employees
	WHERE employee_id=emp_id;
	
	CASE diff_date  
	WHEN 0
			THEN UPDATE employees
			SET salary=salary+50
			WHERE employee_id=emp_id;
	WHEN 1
			THEN UPDATE employees
			SET salary=salary+100
			WHERE employee_id=emp_id;
	WHEN 2
			THEN UPDATE employees
			SET salary=salary+200
			WHERE employee_id=emp_id;
	WHEN 3
			THEN UPDATE employees
			SET salary=salary+300
			WHERE employee_id=emp_id;
	WHEN 4
			THEN UPDATE employees
			SET salary=salary+400
			WHERE employee_id=emp_id;
	ELSE
			UPDATE employees
			SET salary=salary+500
			WHERE employee_id=emp_id;
	END CASE;
END //
DELIMITER ;


DELIMITER //

CREATE PROCEDURE update_salary_by_eid5(IN emp_id INT)
BEGIN
	#声明局部变量
	DECLARE hire_year INT; #记录员工入职公司的总时间（单位：年）
	
	#赋值
	SELECT ROUND(DATEDIFF(CURDATE(),hire_date) / 365) INTO hire_year 
	FROM employees WHERE employee_id = emp_id;
	
	#判断
	CASE hire_year
		WHEN 0 THEN UPDATE employees SET salary = salary + 50 WHERE employee_id = emp_id;
		WHEN 1 THEN UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
		WHEN 2 THEN UPDATE employees SET salary = salary + 200 WHERE employee_id = emp_id;
		WHEN 3 THEN UPDATE employees SET salary = salary + 300 WHERE employee_id = emp_id;
		WHEN 4 THEN UPDATE employees SET salary = salary + 400 WHERE employee_id = emp_id;
		ELSE UPDATE employees SET salary = salary + 500 WHERE employee_id = emp_id;
	END CASE;
END //

DELIMITER ;

#调用
CALL update_salary_by_eid5(101);


SELECT *
FROM employees

DROP PROCEDURE update_salary_by_eid5;



#4.1 循环结构之LOOP
/*
[loop_label:] LOOP
	循环执行的语句
END LOOP [loop_label]


*/
#举例1：

DELIMITER //
CREATE PROCEDURE test_loop()
BEGIN
	#声明局部变量
	DECLARE num INT DEFAULT 1;
	
	loop_label:LOOP
		#重新赋值
		SET num = num + 1;
		
		#可以考虑某个代码程序反复执行。（略）
		
		IF num >= 10 THEN LEAVE loop_label;
		END IF;
	END LOOP loop_label;
	
	#查看num
	SELECT num;

END //

DELIMITER ;

#调用
CALL test_loop();

DELIMITER //

CREATE PROCEDURE test_loop()
BEGIN 
	DECLARE num INT DEFAULT 0;
	
	loop_label:LOOP
		IF num>=10 THEN LEAVE loop_label;
		END IF;
		SET num=num+1;
	END LOOP loop_label;
	
	SELECT num;
END //

DELIMITER ;

CALL test_loop();

#举例2：当市场环境变好时，公司为了奖励大家，决定给大家涨工资。
#声明存储过程“update_salary_loop()”，声明OUT参数num，输出循环次数。
#存储过程中实现循环给大家涨薪，薪资涨为原来的1.1倍。直到全公司的平
#均薪资达到12000结束。并统计循环次数。
DELIMITER //
CREATE PROCEDURE update_salary_loop(OUT num INT)
BEGIN

	DECLARE avg_sal DOUBLE;
	DECLARE loop_count INT DEFAULT 0;
	
	loop_label:LOOP
		SELECT AVG(salary) INTO avg_sal
		FROM employees;
		
		IF avg_sal>=12000 THEN LEAVE loop_label;
		END IF;
		
		UPDATE employees 
		SET salary=salary*1.1;
		
		SET loop_count=loop_count+1;
		
	END LOOP loop_label;
	
	SET num=loop_count;
	
END //
DELIMITER ;

CALL update_salary_loop(@num);
SELECT @num;

DELIMITER //

CREATE PROCEDURE update_salary_loop(OUT num INT)
BEGIN
	#声明变量
	DECLARE avg_sal DOUBLE ; #记录员工的平均工资
	
	DECLARE loop_count INT DEFAULT 0;#记录循环的次数
	
	#① 初始化条件
	#获取员工的平均工资
	SELECT AVG(salary) INTO avg_sal FROM employees;
	
	loop_lab:LOOP
		#② 循环条件
		#结束循环的条件
		IF avg_sal >= 12000
			THEN LEAVE loop_lab;
		END IF;
		
		#③ 循环体
		#如果低于12000，更新员工的工资
		UPDATE employees SET salary = salary * 1.1;
		
		#④ 迭代条件
		#更新avg_sal变量的值
		SELECT AVG(salary) INTO avg_sal FROM employees;
		
		#记录循环次数
		SET loop_count = loop_count + 1;
		
	END LOOP loop_lab;
			
	#给num赋值
	SET num = loop_count;	

END //


DELIMITER ;

SELECT AVG(salary) FROM employees;

CALL update_salary_loop(@num);
SELECT @num;



#4.2 循环结构之WHILE
#先判断再执行

/*
[while_label:] WHILE 循环条件  DO
	循环体
END WHILE [while_label];

*/
#举例1：
DELIMITER //
CREATE PROCEDURE test_while()

BEGIN	
	#初始化条件
	DECLARE num INT DEFAULT 1;
	#循环条件
	WHILE num <= 10 DO
		#循环体（略）
		
		#迭代条件
		SET num = num + 1;
	END WHILE;
	
	#查询
	SELECT num;

END //

DELIMITER ;

#调用
CALL test_while();


DELIMITER //

CREATE PROCEDURE test_while()
BEGIN
	DECLARE num INT DEFAULT 1;
	
	WHILE num <=10 DO
		SET num=num+1;
	END WHILE;
	
	SELECT num;
END //

DELIMITER ;

CALL test_while();

#举例2：市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。
#声明存储过程“update_salary_while()”，声明OUT参数num，输出循环次数。
#存储过程中实现循环给大家降薪，薪资降为原来的90%。直到全公司的平均薪资
#达到5000结束。并统计循环次数。
DELIMITER //

CREATE PROCEDURE update_salary_while(OUT num INT)
BEGIN 
	DECLARE COUNT INT DEFAULT 0;
	DECLARE avg_sal DOUBLE;
	
	SELECT AVG(salary) INTO avg_sal FROM employees;
	
	WHILE avg_sal >5000 DO
		UPDATE employees
		SET salary=salary*0.9;
		
		SET COUNT=COUNT+1;
		SELECT AVG(salary) INTO avg_sal FROM employees;
	END WHILE;
	
	SET num=COUNT;
END //
DELIMITER ;

CALL update_salary_while(@num);
SELECT @num;



DELIMITER //
CREATE PROCEDURE update_salary_while(OUT num INT)

BEGIN
	#声明变量
	DECLARE avg_sal DOUBLE ; #记录平均工资
	DECLARE while_count INT DEFAULT 0; #记录循环次数
	
	#赋值
	SELECT AVG(salary) INTO avg_sal FROM employees;
	
	WHILE avg_sal > 5000 DO
		UPDATE employees SET salary = salary * 0.9 ;
		SET while_count = while_count + 1;
		
		SELECT AVG(salary) INTO avg_sal FROM employees;
		
	END WHILE;
	
	#给num赋值
	SET num = while_count;		
		

END //

DELIMITER ;


#调用
CALL update_salary_while(@num);

SELECT @num;

SELECT AVG(salary) FROM employees;



#4.3 循环结构之REPEAT
#先执行再判断

/*
[repeat_label:] REPEAT
　　　　循环体的语句
UNTIL 结束循环的条件表达式
END REPEAT [repeat_label]

*/

#举例1：

DELIMITER //

CREATE PROCEDURE test_repeat()
BEGIN
	#声明变量
	DECLARE num INT DEFAULT 1;
	
	REPEAT
		SET num = num + 1;
		UNTIL num >= 10
	END REPEAT;
	
	#查看
	SELECT num;

END //


DELIMITER ;

#调用
CALL test_repeat();


DELIMITER //
CREATE PROCEDURE test_repeat()
BEGIN
	DECLARE num INT DEFAULT 1;
	
	REPEAT
		SET num=num+1;
	UNTIL num >=10
	END REPEAT;
	
	SELECT num;
END //

DELIMITER ;

CALL test_repeat();

#举例2：当市场环境变好时，公司为了奖励大家，决定给大家涨工资。
#声明存储过程“update_salary_repeat()”，声明OUT参数num，输出循环次数。
#存储过程中实现循环给大家涨薪，薪资涨为原来的1.15倍。直到全公司的平均
#薪资达到13000结束。并统计循环次数。
DELIMITER //

CREATE PROCEDURE update_salary_repeat(OUT num INT)
BEGIN 
	DECLARE COUNT INT DEFAULT 0;
	DECLARE avg_sal DOUBLE;
	
	REPEAT 
		UPDATE employees SET salary=salary*1.15;
		SELECT AVG(salary) INTO avg_sal FROM employees;
		SET COUNT=COUNT+1;
		
	UNTIL avg_sal >= 13000
	END REPEAT;
	
	SET num=COUNT;
END //
DELIMITER ;

CALL update_salary_repeat(@num);
SELECT @num;

DROP PROCEDURE update_salary_repeat;


DELIMITER //
CREATE PROCEDURE update_salary_repeat(OUT num INT)

BEGIN
	#声明变量
	DECLARE avg_sal DOUBLE ; #记录平均工资
	DECLARE repeat_count INT DEFAULT 0; #记录循环次数
	
	#赋值
	SELECT AVG(salary) INTO avg_sal FROM employees;
	
	REPEAT
		UPDATE employees SET salary = salary * 1.15;
		SET repeat_count = repeat_count + 1;
		
		SELECT AVG(salary) INTO avg_sal FROM employees;
		
		UNTIL avg_sal >= 13000
	
	END REPEAT;
	
	#给num赋值
	SET num = repeat_count;		
		

END //

DELIMITER ;

#调用
CALL update_salary_repeat(@num);
SELECT @num;


SELECT AVG(salary) FROM employees;


/*
凡是循环结构，一定具备4个要素：
1. 初始化条件
2. 循环条件
3. 循环体
4. 迭代条件

*/



#5.1 LEAVE的使用
/*
**举例1：**创建存储过程 “leave_begin()”，声明INT类型的IN参数num。给BEGIN...END加标记名，
并在BEGIN...END中使用IF语句判断num参数的值。

- 如果num<=0，则使用LEAVE语句退出BEGIN...END；
- 如果num=1，则查询“employees”表的平均薪资；
- 如果num=2，则查询“employees”表的最低薪资；
- 如果num>2，则查询“employees”表的最高薪资。

IF语句结束后查询“employees”表的总人数。

*/
DELIMITER //
CREATE PROCEDURE leave_begin(IN num INT)
begin_label:BEGIN 
	IF num <=0 
		THEN LEAVE begin_label;
	ELSEIF num=1
		THEN SELECT AVG(salary) FROM employees;
	ELSEIF num=2
		THEN SELECT MIN(salary) FROM employees;
	ELSEIF num>2
		THEN SELECT MAX(salary) FROM employees;
	END IF;
	
	SELECT COUNT(*) FROM employees;
END //
DELIMITER ;

CALL leave_begin(3);



DELIMITER //

CREATE PROCEDURE leave_begin(IN num INT)

begin_label:BEGIN
	IF num <= 0
		THEN LEAVE begin_label;
	ELSEIF num = 1
		THEN SELECT AVG(salary) FROM employees;
	ELSEIF num = 2
		THEN SELECT MIN(salary) FROM employees;
	ELSE 
		SELECT MAX(salary) FROM employees;
	END IF;
	
	#查询总人数
	SELECT COUNT(*) FROM employees;

END //

DELIMITER ;

#调用
CALL leave_begin(1);


#举例2：当市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。
#声明存储过程“leave_while()”，声明OUT参数num，输出循环次数，存储过程中使用WHILE
#循环给大家降低薪资为原来薪资的90%，直到全公司的平均薪资小于等于10000，并统计循环次数。

DELIMITER //
CREATE PROCEDURE leave_while(OUT num INT)

BEGIN 
	#
	DECLARE avg_sal DOUBLE;#记录平均工资
	DECLARE while_count INT DEFAULT 0; #记录循环次数
	
	SELECT AVG(salary) INTO avg_sal FROM employees; #① 初始化条件
	
	while_label:WHILE TRUE DO  #② 循环条件
		
		#③ 循环体
		IF avg_sal <= 10000 THEN
			LEAVE while_label;
		END IF;
		
		UPDATE employees SET salary  = salary * 0.9;
		SET while_count = while_count + 1;
		
		#④ 迭代条件
		SELECT AVG(salary) INTO avg_sal FROM employees;
	
	END WHILE;
	
	#赋值
	SET num = while_count;

END //

DELIMITER ;

#调用
CALL leave_while(@num);
SELECT @num;

SELECT AVG(salary) FROM employees;



#5.2 ITERATE的使用
#相当于java中的continue

/*
举例： 定义局部变量num，初始值为0。循环结构中执行num + 1操作。

- 如果num < 10，则继续执行循环；
- 如果num > 15，则退出循环结构；

*/
DELIMITER //
CREATE PROCEDURE test_iterate()
BEGIN
	DECLARE num INT DEFAULT 0;
	
	loop_label:LOOP
		SET num=num+1;
		
		IF num <10 
			THEN ITERATE loop_label;
		ELSEIF num >15
			THEN LEAVE loop_label;
		END IF;
		
		SELECT '明天会更好';
	END LOOP;
	
END //

DELIMITER ;

CALL test_iterate();



DELIMITER //

CREATE PROCEDURE test_iterate()

BEGIN
	DECLARE num INT DEFAULT 0;
	
	loop_label:LOOP
		#赋值
		SET num = num + 1;
		
		IF num  < 10
			THEN ITERATE loop_label;
		ELSEIF num > 15
			THEN LEAVE loop_label;
		END IF;
		
		SELECT '尚硅谷：让天下没有难学的技术';
	
	END LOOP;

END //

DELIMITER ;

CALL test_iterate();

SELECT * FROM employees;



#6. 游标的使用
#可以具体操作每一条数据的每个字段

/*
游标使用的步骤：
① 声明游标
② 打开游标
③ 使用游标（从游标中获取数据）
④ 关闭游标


*/

#举例：创建存储过程“get_count_by_limit_total_salary()”，声明IN参数 limit_total_salary，
#DOUBLE类型；声明OUT参数total_count，INT类型。函数的功能可以实现累加薪资最高的几个员工的薪资值，
#直到薪资总和达到limit_total_salary参数的值，返回累加的人数给total_count。
DELIMITER //
CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE,OUT total_count INT)
BEGIN
	DECLARE sum_sal DOUBLE DEFAULT 0.0;
	DECLARE emp_sal DOUBLE ;
	DECLARE COUNT INT DEFAULT 0;
	
	DECLARE sal_cursor CURSOR FOR 
					SELECT salary 
					FROM employees
					ORDER BY salary DESC;
	OPEN sal_cursor;
	
	WHILE sum_sal < limit_total_salary DO
		FETCH sal_cursor INTO emp_sal;
		SET sum_sal=sum_sal+emp_sal;
		SET COUNT =COUNT+1;	
	END WHILE;
	
	CLOSE sal_cursor;
	
	SET total_count=COUNT;
END //
DELIMITER ;

CALL get_count_by_limit_total_salary(200000,@total_count);
SELECT @total_count;



DELIMITER //

CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE,OUT total_count INT)
BEGIN

	#声明局部变量
	DECLARE sum_sal DOUBLE DEFAULT 0.0; #记录累加的工资总额
	DECLARE emp_sal DOUBLE; #记录每一个员工的工资
	DECLARE emp_count INT DEFAULT 0;#记录累加的人数
	
	
	#1.声明游标
	DECLARE emp_cursor CURSOR FOR SELECT salary FROM employees ORDER BY salary DESC;
	
	#2.打开游标
	OPEN emp_cursor;
	
	REPEAT
		
		#3.使用游标
		FETCH emp_cursor INTO emp_sal;
		
		SET sum_sal = sum_sal + emp_sal;
		SET emp_count = emp_count + 1;
		UNTIL sum_sal >= limit_total_salary
	END REPEAT;
	
	SET total_count = emp_count;
	
	#4.关闭游标
	CLOSE emp_cursor;
	
END //


DELIMITER ;

#调用
CALL get_count_by_limit_total_salary(200000,@total_count);
SELECT @total_count;




#练习1：测试变量的使用  

#存储函数的练习

#0. 准备工作
CREATE DATABASE test16_var_cursor;

USE test16_var_cursor;

CREATE TABLE employees
AS
SELECT * FROM atguigudb.`employees`;

CREATE TABLE departments
AS
SELECT * FROM atguigudb.`departments`;

SET GLOBAL log_bin_trust_function_creators = 1;

#无参有返回
#1. 创建函数get_count(),返回公司的员工个数
DELIMITER //
CREATE FUNCTION get_count()
RETURNS INT
BEGIN
	#定义局部变量
	DECLARE emp_num INT;
	SELECT COUNT(*) INTO emp_num FROM employees;
	RETURN emp_num;
END //
DELIMITER ;

SELECT get_count();

#有参有返回
#2. 创建函数ename_salary(),根据员工姓名，返回它的工资
DELIMITER //
CREATE FUNCTION ename_salary(NAME VARCHAR(15))
RETURNS DOUBLE
BEGIN
	#定义系统会话变量
	SET @sal =0;	
	
	SELECT salary INTO @sal
	FROM employees
	WHERE last_name=NAME;	
		
	RETURN @sal;
END //
DELIMITER ;

SELECT ename_salary('Abel');
SELECT @sal;

DROP FUNCTION ename_salary;

#3. 创建函数dept_sal() ,根据部门名，返回该部门的平均工资
DELIMITER //
CREATE FUNCTION dept_sal(dept_name VARCHAR(30))
RETURNS DOUBLE
BEGIN
	DECLARE avg_sal DOUBLE;
	
	SELECT AVG(salary) INTO avg_sal
	FROM employees e JOIN departments d
	ON e.department_id=d.department_id
	WHERE department_name=dept_name;
	
	RETURN avg_sal;
END //
DELIMITER ;

SELECT dept_sal('IT');

DESC departments;
DROP FUNCTION dept_sal;

#4. 创建函数add_float()，实现传入两个float，返回二者之和
DELIMITER //
CREATE FUNCTION add_float(f1 FLOAT,f2 FLOAT)
RETURNS FLOAT
BEGIN
	DECLARE float_sum FLOAT;
	SET float_sum=f1+f2;
	RETURN float_sum;
END //
DELIMITER ;

SET @f1=1.1;
SET @f2=2.0;

SELECT add_float(@f1,@f2);


#2. 流程控制

/*
分支：if \ case ... when \ case when ...
循环：loop \ while \ repeat
其它：leave \ iterate

*/

#1. 创建函数test_if_case()，实现传入成绩，如果成绩>90,返回A，
#如果成绩>80,返回B，如果成绩>60,返回C，否则返回D
#要求：分别使用if结构和case结构实现

DELIMITER //
CREATE FUNCTION test_if_case(score DOUBLE)
RETURNS CHAR(1)
BEGIN 
	IF score >90
		THEN RETURN 'A';
	ELSEIF score >80
		THEN RETURN 'B';
	ELSEIF score >60
		THEN RETURN 'C';
	ELSE RETURN 'D';
	END IF;
END //
DELIMITER ;

SELECT test_if_case(100);


DELIMITER //
CREATE FUNCTION test_if_case1(score DOUBLE)
RETURNS CHAR(1)
BEGIN 
	CASE WHEN score>90
		THEN RETURN 'A';
	WHEN score>80
		THEN RETURN 'B';
	WHEN score>60
		THEN RETURN 'C';
	ELSE RETURN 'D';
	END CASE;
		
END //
DELIMITER ;

SELECT test_if_case1(59);


#2. 创建存储过程test_if_pro()，传入工资值，如果工资值<3000,则删除工资为此值的员工，
# 如果3000 <= 工资值 <= 5000,则修改此工资值的员工薪资涨1000，否则涨工资500
DELIMITER //
CREATE PROCEDURE test_if_pro(IN sal DOUBLE)
BEGIN
	IF sal<3000
		THEN DELETE FROM employees
		     WHERE salary=sal;
	ELSEIF sal<=5000
		THEN UPDATE employees
		     SET salary=salary+1000
		     WHERE salary=sal;
	ELSE UPDATE employees
	     SET salary=salary+500
	     WHERE salary=sal;
	END IF;
END //
DELIMITER ;

CALL test_if_pro(1200);

SELECT * FROM employees;


#3. 创建存储过程insert_data(),传入参数为 IN 的 INT 类型变量 insert_count
#实现向admin表中批量插入insert_count条记录
CREATE TABLE ADMIN(
id INT PRIMARY KEY AUTO_INCREMENT,
user_name VARCHAR(25) NOT NULL,
user_pwd VARCHAR(35) NOT NULL
);

SELECT * FROM ADMIN;


DELIMITER //
CREATE PROCEDURE insert_data(IN insert_count INT)
BEGIN
	DECLARE num INT;
	SET num=insert_count;
	WHILE num>0 DO
		#insert into admin(user_name,user_pwd)
		#values('Tom','123456');
		INSERT INTO ADMIN(user_name,user_pwd)
		VALUES(CONCAT('atguigu',num),ROUND(RAND()*100000000));		
		
		SET num=num-1;
	END WHILE;
END //
DELIMITER ;

CALL insert_data(10);

DROP PROCEDURE insert_data;


#3. 游标的使用

#创建存储过程update_salary()，参数1为 IN 的INT型变量dept_id，表示部门id；
#参数2为 IN的INT型变量change_sal_count，表示要调整薪资的员工个数。查询指定id部门的员工信息，
#按照salary升序排列，根据hire_date的情况，调整前change_sal_count个员工的薪资，详情如下。

DELIMITER //
CREATE PROCEDURE update_salary(IN dept_id INT,IN change_sal_count INT)
BEGIN
	DECLARE hdate DATE;
	DECLARE COUNT INT DEFAULT 1;
	
	DECLARE emp_cursor CURSOR FOR 
					SELECT hire_date
					FROM employees
					WHERE department_id=dept_id
					ORDER BY salary;
	OPEN emp_cursor;
	
	WHILE COUNT<=change_sal_count DO
	
		FETCH emp_cursor INTO hdate;
		IF YEAR(hdate)<1995
			THEN UPDATE employees
			     SET salary=salary*1.2
			     WHERE hire_date=hdate AND department_id=dept_id;
	        ELSEIF YEAR(hdate)<=1998
			THEN UPDATE employees
			     SET salary=salary*1.15
			     WHERE hire_date=hdate AND department_id=dept_id;
		ELSEIF YEAR(hdate)<=2001
			THEN UPDATE employees
			     SET salary=salary*1.10
			     WHERE hire_date=hdate AND department_id=dept_id;
		ELSE 
			 UPDATE employees
			 SET salary=salary*1.05
			 WHERE hire_date=hdate AND department_id=dept_id;
		END IF;
		
		SET COUNT=COUNT+1;
	END WHILE;	
	
	CLOSE emp_cursor;
	
END //
DELIMITER ;

CALL update_salary(60,3);

SELECT hire_date,salary
FROM employees
WHERE department_id=60
ORDER BY salary;


#改进：
DELIMITER //
CREATE PROCEDURE update_salary(IN dept_id INT,IN change_sal_count INT)
BEGIN
	DECLARE emp_id INT;
	DECLARE emp_date DATE;
	DECLARE COUNT INT DEFAULT 1;
	DECLARE sal_pct DOUBLE;
	
	DECLARE emp_cursor CURSOR FOR 
					SELECT employee_id,hire_date
					FROM employees
					WHERE department_id=dept_id
					ORDER BY salary;
	OPEN emp_cursor;
	
	WHILE COUNT<=change_sal_count DO
	
		FETCH emp_cursor INTO emp_id,emp_date;
		IF YEAR(emp_date)<1995
			THEN SET sal_pct=1.2;
	        ELSEIF YEAR(emp_date)<=1998
			THEN SET sal_pct=1.15;
		ELSEIF YEAR(emp_date)<=2001
			THEN SET sal_pct=1.10;
		ELSE 
			SET sal_pct=1.05;
		END IF;
		
		UPDATE employees
		SET salary=salary*sal_pct
		WHERE employee_id=emp_id;		
		
		SET COUNT=COUNT+1;
	END WHILE;	
	
	CLOSE emp_cursor;
	
END //
DELIMITER ;