#第05章_单行函数

#1.数值函数
#基本的操作
SELECT ABS(-123),ABS(32),SIGN(-23),SIGN(43),PI(),CEIL(32.32),CEILING(-43.23),FLOOR(32.32),
FLOOR(-43.23),MOD(12,5),12 MOD 5,12 % 5
FROM DUAL;

#取随机数
SELECT RAND(),RAND(),RAND(10),RAND(10),RAND(-1),RAND(-1)
FROM DUAL;

SELECT RAND(),RAND(10),RAND(10)
FROM DUAL;

#四舍五入，截断操作
SELECT ROUND(123.556),ROUND(123.456,0),ROUND(123.456,1),ROUND(123.456,2),
ROUND(123.456,-1),ROUND(153.456,-2)
FROM DUAL;

SELECT TRUNCATE(123.456,0),TRUNCATE(123.496,1),TRUNCATE(129.45,-1)
FROM DUAL;

SELECT ROUND(123.23),ROUND(123.58),ROUND(123.58,1),ROUND(123.45,-2)
FROM DUAL;

SELECT TRUNCATE(123.56,0),TRUNCATE(123.56,1)
FROM DUAL;

#单行函数可以嵌套
SELECT TRUNCATE(ROUND(123.456,2),0)
FROM DUAL;

#角度与弧度的互换

SELECT RADIANS(30),RADIANS(45),RADIANS(60),RADIANS(90),
DEGREES(2*PI()),DEGREES(RADIANS(60))
FROM DUAL;


#三角函数
SELECT SIN(RADIANS(30)),DEGREES(ASIN(1)),TAN(RADIANS(45)),DEGREES(ATAN(1))
FROM DUAL;

#指数和对数
SELECT POW(2,5),POWER(2,4),EXP(2)
FROM DUAL;

SELECT LN(EXP(2)),LOG(EXP(2)),LOG10(10),LOG2(4)
FROM DUAL;

#进制间的转换
SELECT BIN(10),HEX(10),OCT(10),CONV(10,10,8)
FROM DUAL;


#2. 字符串函数
#ASCII():返回首个字符的ASCII值
#CHAR_LENGTH:返回字符串的字符数
#LENGTH：返回字符串的字节数

SELECT ASCII('Abcdfsf'),CHAR_LENGTH('hello'),CHAR_LENGTH('我们'),
LENGTH('hello'),LENGTH('我们')
FROM DUAL;

SELECT ASCII('abcde'),CHAR_LENGTH('heool'),CHAR_LENGTH('我们'),
LENGTH('heool'),LENGTH('我们')
FROM DUAL;


# xxx worked for yyy
SELECT CONCAT(emp.last_name,' worked for ',mgr.last_name) "details"
FROM employees emp JOIN employees mgr
WHERE emp.`manager_id` = mgr.employee_id;

SELECT CONCAT_WS('-','hello','world','hello','beijing')
FROM DUAL;

SELECT CONCAT(e.last_name,' work for ',m.last_name) "details"
FROM employees e JOIN employees m
ON e.manager_id=m.employee_id;

SELECT CONCAT_WS('-','hello','world','!!!')
FROM DUAL;


#字符串的索引是从1开始的！
SELECT INSERT('helloworld',2,3,'aaaaa'),REPLACE('hello','lol','mmm')
FROM DUAL;

SELECT INSERT('helloworld',2,0,'aaaaa'),REPLACE('helloworld','world','China')
FROM DUAL;

SELECT UPPER('HelLo'),LOWER('HelLo')
FROM DUAL;

SELECT UPPER('abcdefg'),LOWER('AOIFNV')
FROM DUAL;

SELECT last_name,salary
FROM employees
WHERE LOWER(last_name) = 'King';

SELECT last_name,salary
FROM employees
WHERE LOWER(last_name)='king';

SELECT LEFT('hello',2),RIGHT('hello',3),RIGHT('hello',13)
FROM DUAL;

SELECT LEFT('helloworld',5),RIGHT('helloworld',5)
FROM DUAL;

# LPAD:实现右对齐效果
# RPAD:实现左对齐效果
SELECT employee_id,last_name,LPAD(salary,10,' ')
FROM employees;

SELECT employee_id,last_name,LPAD(salary,10,'*')
FROM employees;

SELECT CONCAT('---',LTRIM('    h  el  lo   '),'***'),
TRIM('oo' FROM 'ooheollo')
FROM DUAL;

SELECT CONCAT('---',TRIM('   he    ll  o      '),'***') "concat",
TRIM('oo'FROM 'ooheollooloo')
FROM DUAL;


SELECT REPEAT('hello',4),LENGTH(SPACE(5)),STRCMP('abc','abe')
FROM DUAL;

SELECT REPEAT('happy',4),SPACE(5),STRCMP('ldfj','sjf;')
FROM DUAL;

SELECT SUBSTR('hello',2,2),LOCATE('lll','hello')
FROM DUAL;

SELECT SUBSTR('aioewhfs',2,3),LOCATE('ll','iefjsopplllookj')
FROM DUAL;

SELECT ELT(2,'a','b','c','d'),FIELD('mm','gg','jj','mm','dd','mm'),
FIND_IN_SET('mm','gg,mm,jj,dd,mm,gg')
FROM DUAL;

SELECT ELT(2,'aaaa','jjjjj','iiiii'),FIELD('jj','oodfi','jj','ioefh'),
FIND_IN_SET('mm','jjds,sodifh,mm,sdjs')
FROM DUAL;

#NULLIF(s1,s2):如果s1=s2,则返回NULL，如果不相等，则返回s1
SELECT employee_id,NULLIF(LENGTH(first_name),LENGTH(last_name)) "compare"
FROM employees;

SELECT first_name,last_name,NULLIF(LENGTH(last_name),LENGTH(first_name)) "compare"
FROM employees;

#3. 日期和时间函数

#3.1  获取日期、时间
SELECT CURDATE(),CURRENT_DATE(),CURTIME(),NOW(),SYSDATE(),
UTC_DATE(),UTC_TIME()
FROM DUAL;

SELECT CURDATE(),CURTIME(),NOW()
FROM DUAL;

SELECT CURDATE(),CURDATE() + 0,CURTIME() + 0,NOW() + 0
FROM DUAL;

#3.2 日期与时间戳的转换
SELECT UNIX_TIMESTAMP(),UNIX_TIMESTAMP('2021-10-01 12:12:32'),
FROM_UNIXTIME(1635173853),FROM_UNIXTIME(1633061552)
FROM DUAL;

SELECT UNIX_TIMESTAMP(),UNIX_TIMESTAMP('2005-4-30 00.45.12'),
FROM_UNIXTIME(1744953012),FROM_UNIXTIME(0)
FROM DUAL;

#3.3 获取月份、星期、星期数、天数等函数
SELECT YEAR(CURDATE()),MONTH(CURDATE()),DAY(CURDATE()),
HOUR(CURTIME()),MINUTE(NOW()),SECOND(SYSDATE())
FROM DUAL;


SELECT MONTHNAME('2021-10-26'),DAYNAME('2021-10-26'),WEEKDAY('2021-10-26'),
QUARTER(CURDATE()),WEEK(CURDATE()),DAYOFYEAR(NOW()),
DAYOFMONTH(NOW()),DAYOFWEEK(NOW())
FROM DUAL;

#3.4 日期的操作函数

SELECT EXTRACT(SECOND FROM NOW()),EXTRACT(DAY FROM NOW()),
EXTRACT(HOUR_MINUTE FROM NOW()),EXTRACT(QUARTER FROM '2021-05-12')
FROM DUAL;

#3.5 时间和秒钟转换的函数
SELECT TIME_TO_SEC(CURTIME()),
SEC_TO_TIME(83355)
FROM DUAL;

#3.6 计算日期和时间的函数

SELECT NOW(),DATE_ADD(NOW(),INTERVAL 1 YEAR),
DATE_ADD(NOW(),INTERVAL -1 YEAR),
DATE_SUB(NOW(),INTERVAL 1 YEAR)
FROM DUAL;

SELECT NOW(),DATE_ADD(NOW(),INTERVAL 1 YEAR),
DATE_ADD(NOW(),INTERVAL -2 HOUR)
FROM DUAL;

SELECT DATE_ADD(NOW(), INTERVAL 1 DAY) AS col1,DATE_ADD('2021-10-21 23:32:12',INTERVAL 1 SECOND) AS col2,
ADDDATE('2021-10-21 23:32:12',INTERVAL 1 SECOND) AS col3,
DATE_ADD('2021-10-21 23:32:12',INTERVAL '1_1' MINUTE_SECOND) AS col4,
DATE_ADD(NOW(), INTERVAL -1 YEAR) AS col5, #可以是负数
DATE_ADD(NOW(), INTERVAL '1_1' YEAR_MONTH) AS col6 #需要单引号
FROM DUAL;


SELECT ADDTIME(NOW(),20),SUBTIME(NOW(),30),SUBTIME(NOW(),'1:1:3'),DATEDIFF(NOW(),'2021-10-01'),
TIMEDIFF(NOW(),'2021-10-25 22:10:10'),FROM_DAYS(366),TO_DAYS('0000-12-25'),
LAST_DAY(NOW()),MAKEDATE(YEAR(NOW()),32),MAKETIME(10,21,23),PERIOD_ADD(20200101010101,10)
FROM DUAL;

SELECT NOW(),ADDTIME(NOW(),20),SUBTIME(NOW(),20),
DATEDIFF(NOW(),'2025-4-17'),TIMEDIFF(NOW(),'2025-4-18 13:30:00')
FROM DUAL;

#3.7 日期的格式化与解析
# 格式化：日期 ---> 字符串
# 解析：  字符串 ----> 日期

#此时我们谈的是日期的显式格式化和解析

#之前，我们接触过隐式的格式化或解析
SELECT *
FROM employees
WHERE hire_date = '1990-01-13';

#格式化：
SELECT DATE_FORMAT(CURDATE(),'%Y-%M-%D'),
DATE_FORMAT(NOW(),'%Y-%m-%d'),TIME_FORMAT(CURTIME(),'%h:%i:%S'),
DATE_FORMAT(NOW(),'%Y-%M-%D %h:%i:%S %W %w %T %r')
FROM DUAL;

SELECT DATE_FORMAT(CURDATE(),'%Y-%M-%D'),
TIME_FORMAT(NOW(),'%h:%i:%S'),DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%S %W %w %T %r')
FROM DUAL;

#解析：格式化的逆过程
SELECT STR_TO_DATE('2021-October-25th 11:37:30 Monday 1','%Y-%M-%D %h:%i:%S %W %w')
FROM DUAL;

SELECT GET_FORMAT(DATE,'USA')
FROM DUAL;

SELECT DATE_FORMAT(CURDATE(),GET_FORMAT(DATE,'USA'))
FROM DUAL;


SELECT STR_TO_DATE('2025-4-18 4:00:00','%Y-%m-%d %h:%i:%S')
FROM DUAL;

SELECT GET_FORMAT(DATE,'USA')
FROM DUAL;

SELECT DATE_FORMAT(NOW(),GET_FORMAT(TIME,'USA'))
FROM DUAL;



#4.流程控制函数
#4.1 IF(VALUE,VALUE1,VALUE2)
#VALUE为真时执行VALUE1,为假时执行VALUE2

SELECT last_name,salary,IF(salary >= 6000,'高工资','低工资') "details"
FROM employees;

SELECT last_name,commission_pct,IF(commission_pct IS NOT NULL,commission_pct,0) "details",
salary * 12 * (1 + IF(commission_pct IS NOT NULL,commission_pct,0)) "annual_sal"
FROM employees;


SELECT last_name,salary,IF(salary>=8000,'高工资','低工资') "details"
FROM employees;

SELECT last_name,commission_pct,IF(commission_pct IS NOT NULL,commission_pct,0) "details",
salary*12,salary*12*(1+IF(commission_pct IS NOT NULL,commission_pct,0)) "annual_sal"
FROM employees;


#4.2 IFNULL(VALUE1,VALUE2):看做是IF(VALUE,VALUE1,VALUE2)的特殊情况
#不为NULL时执行VALUE1，否则执行VALUE2

SELECT last_name,commission_pct,IFNULL(commission_pct,0) "details"
FROM employees;

SELECT last_name,salary*12*(1+IFNULL(commission_pct,0)) annul_sal
FROM employees;


#4.3 CASE WHEN ... THEN ...WHEN ... THEN ... ELSE ... END
# 类似于java的if ... else if ... else if ... else
SELECT last_name,salary,CASE WHEN salary >= 15000 THEN '白骨精' 
			     WHEN salary >= 10000 THEN '潜力股'
			     WHEN salary >= 8000 THEN '小屌丝'
			     ELSE '草根' END "details",department_id
FROM employees;

SELECT last_name,salary,CASE WHEN salary >= 15000 THEN '白骨精' 
			     WHEN salary >= 10000 THEN '潜力股'
			     WHEN salary >= 8000 THEN '小屌丝'
			     END "details"
FROM employees;

SELECT last_name,salary,CASE WHEN salary>=15000 THEN '小富'
                             WHEN salary>=10000 THEN '小资'
                             WHEN salary>=5000  THEN '普通'
                             ELSE '贫困' END "details"
FROM employees;


#4.4 CASE ... WHEN ... THEN ... WHEN ... THEN ... ELSE ... END
# 类似于java的swich ... case...
/*

练习1
查询部门号为 10,20, 30 的员工信息, 
若部门号为 10, 则打印其工资的 1.1 倍, 
20 号部门, 则打印其工资的 1.2 倍, 
30 号部门,打印其工资的 1.3 倍数,
其他部门,打印其工资的 1.4 倍数

*/
SELECT employee_id,last_name,department_id,salary,CASE department_id WHEN 10 THEN salary * 1.1
								     WHEN 20 THEN salary * 1.2
								     WHEN 30 THEN salary * 1.3
								     ELSE salary * 1.4 END "details"
FROM employees;

/*

练习2
查询部门号为 10,20, 30 的员工信息, 
若部门号为 10, 则打印其工资的 1.1 倍, 
20 号部门, 则打印其工资的 1.2 倍, 
30 号部门打印其工资的 1.3 倍数

*/
SELECT employee_id,last_name,department_id,salary,CASE department_id WHEN 10 THEN salary * 1.1
								     WHEN 20 THEN salary * 1.2
								     WHEN 30 THEN salary * 1.3
								     END "details"
FROM employees
WHERE department_id IN (10,20,30);

SELECT employee_id,salary,department_id,CASE department_id WHEN 10 THEN salary*1.1
                                                           WHEN 20 THEN salary*1.2
                                                           WHEN 30 THEN salary*1.3
                                                           END "details"
FROM employees
WHERE department_id IN (10,20,30);


#5. 加密与解密的函数
# PASSWORD()在mysql8.0中弃用。
SELECT MD5('mysql'),SHA('mysql'),MD5(MD5('mysql'))
FROM DUAL;

SELECT MD5('i love you'),SHA('i love you')
FROM DUAL;

#ENCODE()\DECODE() 在mysql8.0中弃用。
/*
SELECT ENCODE('atguigu','mysql'),DECODE(ENCODE('atguigu','mysql'),'mysql')
FROM DUAL;
*/

#6. MySQL信息函数

SELECT VERSION(),CONNECTION_ID(),DATABASE(),SCHEMA(),
USER(),CURRENT_USER(),CHARSET('尚硅谷'),COLLATION('尚硅谷')
FROM DUAL;


#7. 其他函数
#如果n的值小于或者等于0，则只保留整数部分
SELECT FORMAT(123.125,2),FORMAT(123.125,0),FORMAT(123.125,-2)
FROM DUAL;

#将数字在不同的进制间进行转换
SELECT CONV(16, 10, 2), CONV(8888,10,16), CONV(NULL, 10, 2)
FROM DUAL;

# 将端口号转换为一串数字
#以“192.168.1.100”为例，计算方式为192乘以256的3次方，加上168乘以256的2次方，加上1乘以256，再加上100。
SELECT INET_ATON('192.168.1.100'),INET_NTOA(3232235876)
FROM DUAL;

#BENCHMARK()用于测试表达式的执行效率
SELECT BENCHMARK(100000,MD5('mysql'))
FROM DUAL;

SELECT BENCHMARK(100000,MD5('mysql'))
FROM DUAL;

# CONVERT():可以实现字符集的转换
SELECT CHARSET('atguigu'),CHARSET(CONVERT('atguigu' USING 'gbk'))
FROM DUAL;


#练习
# 1.显示系统时间(注：日期+时间)
SELECT NOW()
FROM DUAL;

# 2.查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
SELECT employee_id,last_name,salary,salary*1.2 "new salary"
FROM employees;

# 3.将员工的姓名按首字母排序，并写出姓名的长度（length）
SELECT last_name,LENGTH(last_name) "length"
FROM employees
ORDER BY last_name;

# 4.查询员工id,last_name,salary，并作为一个列输出，别名为OUT_PUT
SELECT CONCAT(employee_id,' ',last_name,' ',salary) out_put
FROM employees;

# 5.查询公司各员工工作的年数、工作的天数，并按工作年数的降序排序
DESC employees;

SELECT last_name,(YEAR(NOW())-YEAR(hire_date)) "work_year",DATEDIFF(NOW(),hire_date) "work_day"
FROM employees
ORDER BY work_year DESC;

# 6.查询员工姓名，hire_date , department_id，满足以下条件：
#雇用时间在1997年之后，department_id 为80 或 90 或110, commission_pct不为空
SELECT last_name,hire_date,department_id
FROM employees
WHERE YEAR(hire_date)>=1997 
AND department_id IN (80,90,100)
AND commission_pct IS NOT NULL;

# 7.查询公司中入职超过10000天的员工姓名、入职时间
SELECT last_name,hire_date
FROM employees
WHERE DATEDIFF(NOW(),hire_date)>10000;

# 8.做一个查询，产生下面的结果
#<last_name> earns <salary> monthly but wants <salary*3> 
SELECT last_name,'earns',salary,'monthly but wants',salary*3 "new_sal"
FROM employees;

SELECT CONCAT(last_name,' earns ',TRUNCATE(salary,0),' monthly but wants ',TRUNCATE(salary*3,0)) "Dream salary"
FROM employees; 

# 9.使用case-when，按照下面的条件：
/*job                  grade
AD_PRES              	A
ST_MAN               	B
IT_PROG              	C
SA_REP               	D
ST_CLERK             	E
产生下面的结果:
*/

SELECT *
FROM employees;

SELECT job_id,CASE WHEN job_id='AD_PRES' THEN 'A'
                   WHEN job_id='ST_MAN' THEN 'B'
                   WHEN job_id='IT_PROG' THEN 'C'
                   WHEN job_id='SA_REP' THEN 'D'
                   WHEN job_id='ST_CLERK' THEN 'E'
                   END "grade"
FROM employees;