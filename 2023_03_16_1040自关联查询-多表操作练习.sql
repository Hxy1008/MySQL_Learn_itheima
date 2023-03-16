# 自关联查询
/*
select 字段列表 from 表1 a , 表1 b where 条件;
或者 
select 字段列表 from 表1 a [left] join 表1 b on 条件;
*/
-- 创建表,并建立自关联约束
use mydb1_itheima_learn;
create table t_sanguo(
    eid int primary key ,
    ename varchar(20),
    manager_id int,
 foreign key (manager_id) references t_sanguo (eid)  -- 添加自关联约束
);
-- 添加数据 
insert into t_sanguo values(1,'刘协',NULL);
insert into t_sanguo values(2,'刘备',1);
insert into t_sanguo values(3,'关羽',2);
insert into t_sanguo values(4,'张飞',2);
insert into t_sanguo values(5,'曹操',1);
insert into t_sanguo values(6,'许褚',5);
insert into t_sanguo values(7,'典韦',5);
insert into t_sanguo values(8,'孙权',1);
insert into t_sanguo values(9,'周瑜',8);
insert into t_sanguo values(10,'鲁肃',8);
# 查询每个三国人物及他的上级
select a.ename, b.ename from t_sanguo a left join t_sanguo b on a.manager_id = b.eid;
-- 左外连接，左表的内容全部输出，右表没有补null
# 查询所有人物、上级、上上级
select 
	a.ename, b.ename, c.ename 
from 
	t_sanguo a left join t_sanguo b on a.manager_id = b.eid
						 left join t_sanguo c on b.manager_id = c.eid;


-- 多表操作的练习
-- 创建部门表
create table dept(
	deptno int primary key comment'部门编号',
	dname varchar(14) comment'部门名称',
	loc varchar(13) comment'部门地址'
);
insert into dept values(10, 'accounting', 'new york');
insert into dept values(20, 'research', 'dallas');
insert into dept values(30, 'sales', 'chicago');
insert into dept values(40, 'operations', 'boston');
-- 创建员工表
create table emp(
	empno int primary key comment'员工编号',
	ename varchar(10) comment'员工姓名',
	job varchar(9) comment'员工工作',
	mgr int comment'员工直属领导编号',
	hiredate date comment'入职时间',
	sal double comment'工资',
	comm double comment'奖金',
	deptno int comment'对应dept表的外键'
);
alter table emp add constraint emp_fk foreign key emp(deptno) references dept(deptno);

insert into emp values(7369,'smith', 'clerk',7902,'1980-12-17',800,null,20);
insert into emp values(7499,'allen', 'salesman',7698,'1981-02-20',1600,300,30);
insert into emp values(7521,'ward','salesman',7698,'1981-02-22',1250,500,30);
insert into emp values(7566,'jones', 'manager',7839,'1981-04-02',2975,null,20);
insert into emp values(7654,'martin','salesman',7698,'1981-09-28',1250,1400,30);
insert into emp values(7698,'blake','manager',7839,'1981-05-01',2850,null,30);
insert into emp values(7782,'clark','manager',7839,'1981-06-09',2450,null,10);
insert into emp values(7788,'scott','analyst',7566,'1987-07-03',3000,null,20);
insert into emp values(7839,'king','president',null,'1981-11-17',5000,null,10);
insert into emp values(7844,'turner','salesman',7698,'1981-09-08',1500,0,30);
insert into emp values(7876,'adams', 'clerk',7788,'1987-07-13',1100,null,20);
insert into emp values(7900,'james','clerk',7698,'1981-12-03',950,null,30);
insert into emp values(7902,'ford','analyst',7566,'1981-12-03',3000,null,20);
insert into emp values(7934,'miller','clerk',7782,'1981-01-23',1300,null,10);
-- 创建工资等级表
create table salgrade(
	grade int comment'等级',
	losal double comment'最低工资',
	hisal double comment'最高工资'
);
insert into salgrade values(1, 700, 1200);
insert into salgrade values(2, 1201, 1400);
insert into salgrade values(3, 1401, 2000);
insert into salgrade values(4, 2001, 3000);
insert into salgrade values(5, 3001, 9999);

-- 1. 返回拥有员工的部门名，部门号
select dname, deptno from dept as a where exists(select deptno from emp as b where a.deptno = b.deptno);
select distinct a.dname, a.deptno  from dept as a inner join emp as b on a.deptno = b.deptno; 
select a.dname, a.deptno from dept as a where a.deptno in(select deptno from emp);
select a.dname, a.deptno from dept as a where a.deptno = any(select deptno from emp);
-- 2. 工资水平多于smith的员工信息

-- 3. 返回员工和所属经理的姓名
alter table emp add constraint emp_fk_inner foreign key emp(mgr) references emp(empno);
select a.ename, b.ename, c.ename from emp a left join emp b on a.mgr = b.empno
                                            left join emp c on b.mgr = c.empno;

-- 4. 返回雇员的雇佣日期早于其经理雇佣日期的员工及其经理姓名
select a.ename, b.ename from emp a join emp b on a.mgr = b.empno and(a.hiredate < b.hiredate);
-- 5.返回员工姓名及其所在的部门名称
select emp.ename, dept.dname from emp join dept on emp.deptno = dept.deptno;
-- 6. 返回从事clerk工作的员工姓名和所在部门名称
select emp.ename, dept.dname from emp join dept on emp.deptno = dept.deptno and job = 'clerk';
-- 7. 返回部门号及本部门的最低工资
select emp.deptno, min(emp.sal) as a from emp group by deptno order by a desc;
-- 8. 返回销售部的所有员工姓名
select emp.ename from emp join dept on emp.deptno = dept.deptno and dept.dname = 'sales';
-- 9. 返回工资水平多于平均工资的员工
select ename from emp where sal > (select avg(sal) from emp);
-- 10. 返回于scott从事相同工作的员工
select ename from emp where (job = (select job from emp where ename = 'scott')) and ename != 'scott';
-- 11. 返回工资高于30部门所有员工工资水平的员工信息
select * from emp where sal > all(select sal from emp where deptno = 30);
-- 12. 返回员工工作及从事此工作的最低工资
select job, min(sal) from emp group by job;  -- 13. 计算出员工的年薪，并以年薪排序
select ename, ((sal * 12) + ifnull(comm, 0)) as total_sal from emp order by total_sal desc;
-- 14. 返回工资处于第四级别的员工姓名
select ename, sal from emp where sal BETWEEN(SELECT losal from salgrade where grade = 4) and (select hisal from salgrade where grade = 4);
-- 15. 返回工资为二等级的职员名字、部门所在地
select emp.ename, dept.loc from emp inner join dept on emp.deptno = dept.deptno and (emp.sal BETWEEN(SELECT losal from salgrade where grade = 2) and (select hisal from salgrade where grade = 2));


select 
emp.ename, dept.loc
from emp 
inner join dept on emp.deptno = dept.deptno
inner join salgrade on grade = 2
and emp.sal BETWEEN salgrade.losal and salgrade.hisal;












































