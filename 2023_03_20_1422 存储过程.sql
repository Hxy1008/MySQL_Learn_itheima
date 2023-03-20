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
-- 	FOREIGN KEY (mgr) REFERENCES emp(empno),
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


# 入门案例
delimiter $$
create procedure proc01()
begin
	select empno, ename from emp;
end $$
delimiter ;

-- 调用存储过程
call proc01();

# 局部变量
delimiter $$
create procedure proc02()
begin
	declare var_name01 varchar(20) default'aaa';
	set var_name01 = '张三';
	select var_name01;
end $$
delimiter ;
select var_name01;
call proc02();

# 第二种给变量赋值的方式
delimiter $$
create procedure proc03()
begin
	declare my_name01 varchar(20) default'aaa';
	select ename into my_name01 from emp where empno = 1001;
	select my_name01;
end $$
delimiter ;
drop procedure proc03;
call proc03();
# 用户变量
delimiter $$
create procedure if not exists proc04()
begin
	set @var_name01 = 'ZS';
end $$
delimiter ;
call proc04();
select @var_name01;

# 系统变量-全局变量
-- 查看全局变量
show global variables;
-- 查看某个全局变量
select @@global.auto_increment_increment;
select @@global.sort_buffer_size;
-- 修改某个全局变量的值
set global sort_buffer_size = 40000;
set @@global.sort_buffer_size = 35000;
# 系统变量-会话变量
-- 查看会话变量
show session variables;
-- 查看某个全局变量
select @@session.auto_increment_increment;
-- 修改某个全局变量的值
set session sort_buffer_size = 40000;
set @@session.sort_buffer_size = 35000;

# 参数传递in
-- 传入员工编号查询员工信息
delimiter $$
create procedure emp_infom(in emp_empno int)
begin
	select * from emp where emp_empno = emp.empno;
end $$
delimiter ;
call emp_infom(1001);
-- 封装有参数的存储过程，通过传入部门名和薪资，查询指定部门，并且薪资大于指定值的员工信息
delimiter $$
create procedure emp_infom1(in emp_dname varchar(20), emp_sal decimal(8, 2))
begin
	select * from dept join emp on dept.deptno = emp.deptno and dept.dname = emp_dname and emp.sal > emp_sal;
end $$
delimiter ;
call emp_infom1('学工部', 20000);
call emp_infom1('销售部', 20000);
# 参数传递out
-- 封装有参数的存储过程，传入员工编号，返回员工名字
delimiter $$
create procedure emp_name(in param_empno int, out param_ename varchar(20))
begin
	select ename into param_ename from emp where emp.empno = param_empno;
end $$
delimiter ;
call emp_name(1001, @out_ename);
select @out_ename;
-- 封装有参数的存储过程，传入员工编号，返回员工名字和薪资
delimiter $$
create procedure emp_name_sal(in in_empno int, out out_ename varchar(20), out out_sal decimal(8, 2))
begin
	select ename, sal into out_ename, out_sal from emp where empno = in_empno;
end $$delimiter ;
call emp_name_sal(1002, @out_ename, @out_sal);
select @out_ename, @out_sal;
-- 传入员工名，拼接部门号，传入薪资，求出年薪
delimiter $$
create procedure inout_test(inout inout_ename varchar(20), inout inout_sal int)
begin
	set inout_sal = (inout_sal * 12) + ifnull((select emp.comm from emp where emp.ename = inout_ename), 0);
	select concat(inout_ename, '-', deptno) into inout_ename from emp where emp.ename = inout_ename;
end $$
delimiter ;
set @inout_ename = '关羽';
set @inout_sal = 10000;

call inout_test(@inout_ename, @inout_sal);
select @inout_sal, @inout_ename;






















