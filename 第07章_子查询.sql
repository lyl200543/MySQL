# 第07章_子查询

#1. 由一个具体的需求，引入子查询
#需求：谁的工资比Abel的高？
#方式1：
SELECT salary
FROM employees
WHERE last_name = 'Abel';

SELECT last_name,salary
FROM employees
WHERE salary > 11000;

SELECT salary
FROM employees
WHERE last_name='Abel';

SELECT last_name,salary
FROM employees
WHERE salary>11000;

#方式2：自连接
SELECT e2.last_name,e2.salary
FROM employees e1,employees e2
WHERE e2.`salary` > e1.`salary` #多表的连接条件
AND e1.last_name = 'Abel';

SELECT e1.last_name,e1.salary
FROM employees e1 JOIN employees e2
ON e1.salary>e2.salary
AND e2.last_name='Abel';


#方式3：子查询
SELECT last_name,salary
FROM employees
WHERE salary > (
		SELECT salary
		FROM employees
		WHERE last_name = 'Abel'
		);


SELECT last_name,salary
FROM employees
WHERE salary>(
              SELECT salary
              FROM employees
              WHERE last_name='Abel'
              );
              
              
#2. 称谓的规范：外查询（或主查询）、内查询（或子查询）

/*
- 子查询（内查询）在主查询之前一次执行完成。
- 子查询的结果被主查询（外查询）使用 。
- 注意事项
  - 子查询要包含在括号内
  - 将子查询放在比较条件的右侧
  - 单行操作符对应单行子查询，多行操作符对应多行子查询

*/

#不推荐：
SELECT last_name,salary
FROM employees
WHERE  (
	SELECT salary
	FROM employees
	WHERE last_name = 'Abel'
		) < salary;
		
/*
3. 子查询的分类
角度1：从内查询返回的结果的条目数
	单行子查询  vs  多行子查询

角度2：内查询是否被执行多次
	相关子查询  vs  不相关子查询
	
 比如：相关子查询的需求：查询工资大于本部门平均工资的员工信息。
       不相关子查询的需求：查询工资大于本公司平均工资的员工信息。
 
*/


#子查询的编写技巧（或步骤）：① 从里往外写  ② 从外往里写

#4. 单行子查询
#4.1 单行操作符： =  !=  >   >=  <  <= 

#题目：查询工资大于149号员工工资的员工的信息
SELECT last_name,salary
FROM employees
WHERE salary>(
              SELECT salary
              FROM employees
              WHERE employee_id=149
              );


SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
		SELECT salary
		FROM employees
		WHERE employee_id = 149
		);


#题目：返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
SELECT last_name,job_id,salary
FROM employees
WHERE job_id=(
		SELECT job_id
		FROM employees
		WHERE employee_id=141
	     )
AND salary > (
		SELECT salary
		FROM employees
		WHERE employee_id=143
	     );


SELECT last_name,job_id,salary
FROM employees
WHERE job_id = (
		SELECT job_id
		FROM employees
		WHERE employee_id = 141
		)
AND salary > (
		SELECT salary
		FROM employees
		WHERE employee_id = 143
		);


#题目：返回公司工资最少的员工的last_name,job_id和salary

SELECT last_name,job_id,salary
FROM employees
WHERE salary=(
              SELECT MIN(salary)
              FROM employees
              );


SELECT last_name,job_id,salary
FROM employees
WHERE salary = (
		SELECT MIN(salary)
		FROM employees
		);

#题目：查询与141号员工的manager_id和department_id相同的其他员工
#的employee_id，manager_id，department_id。
#方式1：

SELECT employee_id,manager_id,department_id
FROM employees
WHERE manager_id=(
                  SELECT manager_id
                  FROM employees
                  WHERE employee_id=141
                  )
AND department_id=(
                   SELECT department_id
                   FROM employees
                   WHERE employee_id=141
                   )
AND employee_id !=141;

SELECT employee_id,manager_id,department_id
FROM employees
WHERE manager_id = (
		    SELECT manager_id
		    FROM employees
		    WHERE employee_id = 141
		   )
AND department_id = (
		    SELECT department_id
		    FROM employees
		    WHERE employee_id = 141
		   )
AND employee_id <> 141;


#方式2：了解
SELECT employee_id,manager_id,department_id
FROM employees
WHERE (manager_id,department_id) = (
				    SELECT manager_id,department_id
			            FROM employees
				    WHERE employee_id = 141
				   )
AND employee_id <> 141;

#题目：查询最低工资大于110号部门最低工资的部门id和其最低工资

SELECT department_id,MIN(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING MIN(salary)>(
			SELECT MIN(salary)
			FROM employees
			WHERE department_id=110
			);

SELECT department_id,MIN(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING MIN(salary) > (
			SELECT MIN(salary)
			FROM employees
			WHERE department_id = 110
		     );

#题目：显式员工的employee_id,last_name和location。
#其中，若员工department_id与location_id为1800的department_id相同，
#则location为’Canada’，其余则为’USA’。

SELECT employee_id,last_name,CASE department_id WHEN (SELECT department_id
						      FROM departments
						      WHERE location_id=1800
						      ) THEN 'Canada'
						ELSE 'USA' END "location"
FROM employees;


SELECT employee_id,last_name,CASE department_id WHEN (SELECT department_id FROM departments WHERE location_id = 1800) THEN 'Canada'
						ELSE 'USA' END "location"
FROM employees;

#4.2 子查询中的空值问题
SELECT last_name, job_id
FROM   employees
WHERE  job_id =
                (SELECT job_id
                 FROM   employees
                 WHERE  last_name = 'Haas');
                 
#4.3 非法使用子查询
#错误：Subquery returns more than 1 row
SELECT employee_id, last_name
FROM   employees
WHERE  salary =
                (SELECT   MIN(salary)
                 FROM     employees
                 GROUP BY department_id);         



#5.多行子查询
#5.1 多行子查询的操作符： IN  ANY  ALL  SOME(同ANY)

#5.2举例：
# IN:
SELECT employee_id, last_name
FROM   employees
WHERE  salary IN
                (SELECT   MIN(salary)
                 FROM     employees
                 GROUP BY department_id); 
                

SELECT employee_id, last_name
FROM   employees
WHERE  salary IN
                (SELECT   MIN(salary)
                 FROM     employees
                 GROUP BY department_id);         
 
 
# ANY / ALL:
#题目：返回其它job_id中比job_id为‘IT_PROG’部门任一工资低的员工的员工号、
#姓名、job_id 以及salary

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id !='IT_PROG'
AND salary < ANY (
		SELECT salary
		FROM employees
		WHERE job_id='IT_PROG'
		);


SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id <> 'IT_PROG'
AND salary < ANY (
		SELECT salary
		FROM employees
		WHERE job_id = 'IT_PROG'
		);


#题目：返回其它job_id中比job_id为‘IT_PROG’部门所有工资低的员工的员工号、
#姓名、job_id 以及salary

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id !='IT_PROG'
AND salary < ALL (
		SELECT salary
		FROM employees
		WHERE job_id='IT_PROG'
		);


SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id <> 'IT_PROG'
AND salary < ALL (
		SELECT salary
		FROM employees
		WHERE job_id = 'IT_PROG'
		);
		
		
#题目：查询平均工资最低的部门id
#MySQL中聚合函数是不能嵌套使用的。
#方式1：把各个部门的平均工资看作一张新的表
SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary)=(
                    SELECT MIN(avg_sal)
		    FROM(	SELECT AVG(salary) "avg_sal"
				FROM employees
				GROUP BY department_id) dep_avg_sal
			);



SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
			SELECT MIN(avg_sal)
			FROM(
				SELECT AVG(salary) avg_sal
				FROM employees
				GROUP BY department_id
				) t_dept_avg_sal
			);

#方式2：
SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) <= ALL(	
			SELECT AVG(salary) avg_sal
			FROM employees
			GROUP BY department_id
			) 
			

SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary)<= ALL (	SELECT AVG(salary)
				FROM employees
				GROUP BY department_id
			);			


#5.3 空值问题
SELECT last_name
FROM employees
WHERE employee_id NOT IN (
			SELECT manager_id
			FROM employees
			#where manager_id is not null
			);
			
			

			
#6. 相关子查询
#回顾：查询员工中工资大于公司平均工资的员工的last_name,salary和其department_id
#6.1 
SELECT last_name,salary,department_id
FROM employees
WHERE salary > (
		SELECT AVG(salary)
		FROM employees
		);

SELECT last_name,salary,department_id
FROM employees
WHERE salary > (
		SELECT AVG(salary)
                FROM employees
                );
		
		
#题目：查询员工中工资大于本部门平均工资的员工的last_name,salary和其department_id
#方式1：使用相关子查询
SELECT last_name,salary,department_id
FROM employees e1
WHERE salary > (
		SELECT AVG(salary)
		FROM employees e2
		WHERE e2.department_id=e1.department_id
		)



SELECT last_name,salary,department_id
FROM employees e1
WHERE salary > (
		SELECT AVG(salary)
		FROM employees e2
		WHERE department_id = e1.`department_id`
		);


#方式2：在FROM中声明子查询

SELECT e.last_name,e.salary,e.department_id
FROM employees e,(
		  SELECT department_id,AVG(salary) "avg_sal"
		  FROM employees
		  GROUP BY department_id
		  ) t_dept_avg_sal
WHERE e.department_id=t_dept_avg_sal.department_id
AND e.salary > t_dept_avg_sal.avg_sal;


SELECT e.last_name,e.salary,e.department_id
FROM employees e,(
		SELECT department_id,AVG(salary) avg_sal
		FROM employees
		GROUP BY department_id) t_dept_avg_sal
WHERE e.department_id = t_dept_avg_sal.department_id
AND e.salary > t_dept_avg_sal.avg_sal


#题目：查询员工的id,salary,按照department_name 排序

SELECT employee_id,salary
FROM employees e
ORDER BY (
	  SELECT department_name 
	  FROM departments d
	  WHERE d.department_id=e.department_id
	  );


SELECT employee_id,salary
FROM employees e
ORDER BY (
	 SELECT department_name
	 FROM departments d
	 WHERE e.`department_id` = d.`department_id`
	) ASC;


#结论：在SELECT中，除了GROUP BY 和 LIMIT之外，其他位置都可以声明子查询！
/*
SELECT ....,....,....(存在聚合函数)
FROM ... (LEFT / RIGHT)JOIN ....ON 多表的连接条件 
(LEFT / RIGHT)JOIN ... ON ....
WHERE 不包含聚合函数的过滤条件
GROUP BY ...,....
HAVING 包含聚合函数的过滤条件
ORDER BY ....,...(ASC / DESC )
LIMIT ...,....
*/

#题目：若employees表中employee_id与job_history表中employee_id相同的数目不小于2，
#输出这些相同id的员工的employee_id,last_name和其job_id

SELECT employee_id,last_name,job_id
FROM employees e
WHERE 2<= (
	   SELECT COUNT(*)
	   FROM job_history j
	   WHERE j.employee_id=e.employee_id
	   )

SELECT *
FROM job_history;

SELECT employee_id,last_name,job_id
FROM employees e
WHERE 2 <= (
	    SELECT COUNT(*)
	    FROM job_history j
	    WHERE e.`employee_id` = j.`employee_id`
		)


#6.2 EXISTS 与 NOT EXISTS关键字

#题目：查询公司管理者的employee_id，last_name，job_id，department_id信息
#方式1：自连接

SELECT DISTINCT m.employee_id,m.last_name,m.job_id,m.department_id
FROM employees e JOIN employees m
ON e.manager_id=m.employee_id;


SELECT DISTINCT mgr.employee_id,mgr.last_name,mgr.job_id,mgr.department_id
FROM employees emp JOIN employees mgr
ON emp.manager_id = mgr.employee_id;

#方式2：子查询

SELECT employee_id,last_name,job_id,department_id
FROM employees
WHERE employee_id IN (
		      SELECT DISTINCT manager_id
		      FROM employees
		      )


SELECT employee_id,last_name,job_id,department_id
FROM employees
WHERE employee_id IN (
			SELECT DISTINCT manager_id
			FROM employees
			);


#方式3：使用EXISTS

SELECT e1.employee_id, e1.last_name,e1.job_id,e1.department_id
FROM employees e1
WHERE EXISTS(
	     SELECT *
	     FROM employees e2
	     WHERE e1.employee_id=e2.manager_id
	     )



SELECT employee_id,last_name,job_id,department_id
FROM employees e1
WHERE EXISTS (
	       SELECT *
	       FROM employees e2
	       WHERE e1.`employee_id` = e2.`manager_id`
	     );


#题目：查询departments表中，不存在于employees表中的部门的department_id和department_name

#方式1：右外连接-内连接
SELECT department_id,department_name
FROM departments d
WHERE NOT department_id IN (
			SELECT department_id
			FROM employees e
			WHERE d.department_id=e.department_id
			)


SELECT d.department_id,d.department_name
FROM employees e RIGHT JOIN departments d
ON e.department_id=d.department_id
WHERE e.department_id IS NULL


SELECT d.department_id,d.department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`department_id` IS NULL;

#方式2：

SELECT department_id,department_name
FROM departments d
WHERE NOT EXISTS(
		 SELECT *
		 FROM employees e
		 WHERE d.department_id=e.department_id
		)



SELECT department_id,department_name
FROM departments d
WHERE NOT EXISTS (
		SELECT *
		FROM employees e
		WHERE d.`department_id` = e.`department_id`
		);

SELECT COUNT(*)
FROM departments;

#练习
#1.查询和Zlotkey(人名)相同部门的员工姓名和工资
SELECT last_name,salary
FROM employees
WHERE department_id  = (
			SELECT department_id
			FROM employees
			WHERE last_name='Zlotkey'
			)


#2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
		SELECT AVG(salary)
		FROM employees
		);

#3.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name, job_id, salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary > ALL (
			SELECT salary
			FROM employees
			WHERE job_id = 'SA_MAN'
			);
			
#4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT employee_id,last_name
FROM employees
WHERE department_id IN (
			SELECT department_id
			FROM employees
			WHERE last_name LIKE '%u%'
			)
AND last_name NOT LIKE '%u%'		
			
#5.查询在部门的location_id为1700的部门工作的员工的员工号
SELECT employee_id
FROM employees
WHERE department_id IN (
			SELECT department_id
			FROM departments
			WHERE location_id=1700
			);
			
#6.查询管理者是King的员工姓名和工资
SELECT last_name,salary
FROM employees
WHERE manager_id IN    (
			SELECT employee_id
			FROM employees
			WHERE last_name='King'
			);			
			
#7.查询工资最低的员工信息: last_name, salary
SELECT last_name, salary
FROM employees
WHERE salary <=(
		SELECT MIN(salary)
		FROM employees
		)

#######8.查询平均工资最低的部门信息
# 方式1：
SELECT *
FROM departments
WHERE department_id =(SELECT department_id
		      FROM employees
		      GROUP BY department_id
		      HAVING AVG(salary)=(SELECT MIN(avg_sal)
					  FROM(SELECT AVG(salary) avg_sal
					       FROM employees
					       GROUP BY department_id
					       ) t_dept_avg_sal
					 )
                      )

#方式2：
SELECT *
FROM departments
WHERE department_id=(SELECT department_id
		     FROM employees
		     GROUP BY department_id
		     HAVING AVG(salary) <= ALL(SELECT AVG(salary)
					       FROM employees
					       GROUP BY department_id
						)
		    )


#方式3：LIMIT
SELECT *
FROM departments
WHERE department_id=(
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary)=(    SELECT AVG(salary) avg_sal
						FROM employees
						GROUP BY department_id
						ORDER BY avg_sal
						LIMIT 1
						)
			)


#方式4：
SELECT d.*
FROM departments d,    (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary)=(    SELECT AVG(salary) avg_sal
						FROM employees
						GROUP BY department_id
						ORDER BY avg_sal
						LIMIT 0,1
						)
			) t_dept_min_sal
			
WHERE d.department_id=t_dept_min_sal.department_id


#9.查询平均工资最低的部门信息和该部门的平均工资（相关子查询）
SELECT d.*,AVG(salary)
FROM departments d,employees e
WHERE d.department_id=e.department_id
GROUP BY d.department_id
HAVING AVG(salary)=(
			SELECT AVG(salary)
			FROM employees
			GROUP BY department_id
			ORDER BY AVG(salary)
			LIMIT 0,1
			);


SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id=d.department_id) avg_sal
FROM departments d
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary ) = (
						SELECT MIN(avg_sal)
						FROM (
							SELECT AVG(salary) avg_sal
							FROM employees
							GROUP BY department_id
							) t_dept_avg_sal

						)
			);


#10.查询平均工资最高的 job 信息
SELECT * FROM jobs;

SELECT * 
FROM jobs
WHERE job_id =(
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) =(
					SELECT AVG(salary)
					FROM employees
					GROUP BY job_id
					ORDER BY AVG(salary) DESC
					LIMIT 0,1			
					)

		);


#11.查询平均工资高于公司平均工资的部门有哪些?
SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary)>(
			SELECT AVG(salary)
			FROM employees
			)

#12.查询出公司中所有 manager 的详细信息
SELECT DISTINCT *
FROM employees e ,(SELECT manager_id FROM employees ) m
WHERE e.employee_id=m.manager_id	 	
	
#13.各个部门中 最高工资中最低的那个部门的 最低工资是多少?
SELECT MIN(salary)
FROM employees
WHERE department_id=(
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING MAX(salary)=(
						SELECT MAX(salary)
						FROM employees
						GROUP BY department_id
						ORDER BY MAX(salary)
						LIMIT 0,1
						)
			)

#14.查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id=(
			SELECT manager_id
			FROM departments
			WHERE department_id=(
						SELECT department_id
						FROM employees
						GROUP BY department_id
						HAVING AVG(salary)=(
									SELECT AVG(salary)
									FROM employees
									GROUP BY department_id
									ORDER BY AVG(salary) DESC
									LIMIT 0,1
									)
						)

			);

#15. 查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号
SELECT department_id
FROM departments
WHERE department_id NOT IN (
				SELECT department_id
				FROM employees
				WHERE job_id ='ST_CLERK'
				);

#16. 选择所有没有管理者的员工的last_name
SELECT last_name
FROM employees
WHERE manager_id <=> NULL;

SELECT last_name
FROM employees emp
WHERE NOT EXISTS (
		SELECT *
		FROM employees mgr
		WHERE emp.`manager_id` = mgr.`employee_id`
		);
		
#17．查询员工号、姓名、雇用时间、工资，其中员工的管理者为 'De Haan'
SELECT employee_id,last_name,hire_date,salary
FROM employees
WHERE manager_id=(
			SELECT employee_id
			FROM employees
			WHERE last_name='De Haan'
			)		
			
#18.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资（相关子查询）
SELECT employee_id,last_name,salary
FROM employees e1
WHERE salary > (
		SELECT AVG(salary)
		FROM employees e2
		WHERE e2.department_id=e1.department_id
		)
		
#19.查询每个部门下的部门人数大于 5 的部门名称（相关子查询）
SELECT department_name
FROM departments d
WHERE 5 < (
		SELECT COUNT(*)
		FROM employees e
		WHERE e.department_id=d.department_id
		)
		
#20.查询每个国家下的部门个数大于 2 的国家编号（相关子查询）
SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM departments;
SELECT * FROM locations;

SELECT country_id
FROM locations l
WHERE 2<(
	SELECT COUNT(*)
	FROM departments d
	WHERE d.location_id=l.location_id
	)
	
/* 
子查询的编写技巧（或步骤）：① 从里往外写  ② 从外往里写

如何选择？
① 如果子查询相对较简单，建议从外往里写。一旦子查询结构较复杂，则建议从里往外写
② 如果是相关子查询的话，通常都是从外往里写。

*/