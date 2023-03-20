create table dept(
	deptno int primary key,
  dname varchar(20),
	loc varchar(20)
);
insert into dept values(10, '教研部','北京'),
(20, '学工部','上海'),
(30, '销售部','广州'),
(40, '财务部','武汉');

create table emp(
	empno int primary key,
	ename varchar(20),
	job varchar(20),
	mgr int,
	hiredate date,
	sal numeric(8,2),
	comm numeric(8, 2),
	deptno int,
 	-- FOREIGN KEY(mgr) REFERENCES emp(empno),
	FOREIGN KEY (deptno) REFERENCES dept(deptno) ON DELETE SET NULL ON UPDATE CASCADE
);
insert into emp values
(1001, '甘宁', '文员', 1013, '2000-12-17', 8000.00, null, 20),
(1002, '黛绮丝', '销售员', 1006, '2001-02-20', 16000.00, 3000.00, 30),
(1003, '殷天正', '销售员', 1006, '2001-02-22', 12500.00, 5000.00, 30),
(1004, '刘备', '经理', 1009, '2001-4-02', 29750.00, null, 20),
(1005, '谢逊', '销售员', 1006, '2001-9-28', 12500.00, 14000.00, 30),
(1006, '关羽', '经理', 1009, '2001-05-01', 28500.00, null, 30),
(1007, '张飞', '经理', 1009, '2001-09-01', 24500.00, null, 10),
(1008, '诸葛亮', '分析师', 1004, '2007-04-19', 30000.00, null, 20),
(1009, '曾阿牛', '董事长', null, '2001-11-17', 50000.00, null, 10),
(1010, '韦一笑', '销售员', 1006, '2001-09-08', 15000.00, 0.00, 30),
(1011, '周泰', '文员', 1008, '2007-05-23', 11000.00, null, 20),
(1012, '程普', '文员', 1006, '2001-12-03', 9500.00, null, 30),
(1013, '庞统', '分析师', 1004, '2001-12-03', 30000.00, null, 20),
(1014, '黄盖', '文员', 1007, '2002-01-23', 13000.00, null, 10);

create table salgrade(
	grade int primary key,
	losal int,
	hisal int
);
insert into salgrade values
(1, 7000, 12000),
(2, 12010, 14000),
(3, 14010, 20000),
(4, 20010, 30000),
(5, 30010, 99990);
use mydby_6;
# 创建视图
create or replace 
view view1_emp
as 
select ename, job from emp;

-- 查看表和视图
show tables;
show full tables;

select * from view1_emp; -- 虽然可以这样写，但是view1_emp并不是一张表，只是一个视图，表的数据变了，它也会变

# 更新视图
-- 不能更新的情况
/*
聚合函数（SUM(), MIN(), MAX(), COUNT()等）
DISTINCT
GROUP BY
HAVING
UNION或UNION ALL
位于选择列表中的子查询
JOIN
FROM子句中的不可更新视图
WHERE子句中的子查询，引用FROM子句中的表。
仅引用文字值（在该情况下，没有要更新的基本表）
*/
create or replace view view1_emp
as
select ename, job from emp;
update view1_emp set ename = '鲁肃' where ename = '周瑜';
insert into view1_emp values('孙权', '文员');
-- ----------视图包含聚合函数不能更新----------------
create or replace view view2_emp
as
select count(*) rrr from emp;
insert into view2_emp values(100);   -- The target table view2_emp of the INSERT is not insertable-into
update view2_emp set rrr = 100;   -- The target table view2_emp of the UPDATE is not updatable
-- ---------视图包含distinct不可更新--------------------
create or replace view view3_emp
as
select distinct job from emp;
insert into view3_emp values('123');  -- The target table view3_emp of the INSERT is not insertable-into
-- -----------视图中有group by 和 having不可更新 -----------------
create or replace view view4_emp
as
select deptno, count(*) cnt from emp group by deptno;
insert into view4_emp values('123', 1000);  -- The target table view3_emp of the INSERT is not insertable-into
-- -----------视图中用union和union all 不可更新-------------
create or replace view view5_emp
as
select * from emp where empno <= 1005
union all
select * from emp where empno > 1005;

insert into view5_emp values(1015, '黄xx', '文员', 1007, '2002-01-23', 13000.00, null, 10);
-- 这里就算按所有格式插入都不行
-- The target table view5_emp of the INSERT is not insertable-into
-- --------无论是select或者where后面包含子查询都不可更新-----------
-- ---------两张表jion的也不可更改---------
-- ------------视图是常量（仅引用文字）不可更新
create or replace view view6_emp
as
select '行政部' dname, '杨过' ename;

insert into view6_emp values('行政部', '韦小宝');
-- The target table view6_emp of the INSERT is not insertable-into
# 重命名视图
rename table view6_emp to my_view6_emp;
# 删除视图
drop view if exists my_view6_emp;








# 练习
# 1.查询部门平均薪资水平最高的部门名称
create or replace view avg_sal
as
select deptno, avg(sal) as avg_sal from emp GROUP BY emp.deptno; 
create or replace view max_sal_dname
as
select dname from dept where deptno = (select deptno from avg_sal where avg_sal.avg_sal = (select max(avg_sal) from avg_sal));


select dept.dname
from
dept inner join
(
select *, rank()over(order by avg_sal desc) as rn
from
(
select deptno, avg(sal) avg_sal from emp group by deptno
) as t1
) as t2
on t2.deptno = dept.deptno and t2.rn = 1;
# 2.查询员工比所属领导薪资高的部门名、员工名、员工领导编号
#子查询
select dept.dname, t2.ename, t2.mgr
from
dept inner join
(
select t1.ename, t1.mgr, t1.deptno
from
(
	select a.sal as sal1, b.sal as sal2, a.ename, a.mgr, a.deptno from emp a join emp b on a.mgr = b.empno
) as t1
where t1.sal1 > t1.sal2
) as t2
on t2.deptno = dept.deptno;
# 查询工资等级为4级，2000年以后入职的工作地点为北京的员工编号、姓名和工资，并查询出薪资在前三名的员工信息
select *
from
salgrade inner join
(
select emp.sal, emp.ename, emp.empno
from emp inner join dept 
on emp.deptno = dept.deptno and emp.hiredate >= '2000-01-01' and dept.loc = '北京'
) as t1
on salgrade.grade = 4 and t1.sal BETWEEN (select salgrade.losal from salgrade where salgrade.grade = 4) and (select salgrade.hisal from salgrade where salgrade.grade = 4);



select *
from
salgrade inner join
(
select emp.sal, emp.ename, emp.empno
from emp inner join dept 
on emp.deptno = dept.deptno and emp.hiredate >= '2000-01-01' and dept.loc = '北京'
) as t1
on salgrade.grade = 4 and t1.sal BETWEEN salgrade.losal and salgrade.hisal;

select emp.sal, emp.ename, emp.empno from emp 
inner join dept on dept.deptno = emp.deptno and dept.loc = '北京' 
inner join salgrade on salgrade.grade = 4 and emp.sal BETWEEN salgrade.losal and salgrade.hisal
and emp.hiredate >= '2000-01-01';			









