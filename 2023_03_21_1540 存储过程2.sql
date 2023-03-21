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




#流程控制-分支语句-if
#输入学生成绩，判断成绩级别
delimiter $$
create procedure stu_grade(in in_score int, out out_grade varchar(40))
begin
	if in_score >= 0 and in_score < 60
		then set out_grade = '不及格';
	elseif in_score < 80
		then set out_grade = '及格';
	elseif in_score < 90
		then set out_grade = '良好';
	elseif in_score <= 100
		then set out_grade = '优秀';
	else
		set out_grade = '成绩输入错误，请重新输入';
	end if;
end $$
delimiter ;
call stu_grade(1000, @out_grade);
select @out_grade;

# 输入员工名字，判断工资情况
delimiter $$
create procedure proc06(in in_ename varchar(20), out out_result varchar(20))
begin
	declare var_sal decimal(8, 2);
	select sal into var_sal from emp where emp.ename = in_ename;
	if var_sal < 10000
		then set out_result = '试用薪资';
	elseif var_sal < 30000
		then set out_result = '转正薪资';
	else
		set out_result = '元老薪资';
	end if;
end $$
delimiter ;

call proc06('庞统', @out_result);
select @out_result;

#流程控制-分支语句-case
# 语法1
create table orders(
	oid int primary key comment'订单id',
	price double comment'订单价格',
	payType int -- 1.微信 2.支付宝 3.银行卡支付 4.其它
);
insert into orders values(1,1200,1);
insert into orders values(2,1000,2);
insert into orders values(3,200,3);
insert into orders values(4,3000,1);
insert into orders values(5,1500,2);



delimiter $$
create procedure proc_case1(in in_oid int)
begin
	declare pay_type varchar(20);
	case 
		when (select payType from orders where in_oid = orders.oid) = 1 then set pay_type = '微信支付';
		when (select payType from orders where in_oid = orders.oid) = 2 then set pay_type = '支付宝支付';
		when (select payType from orders where in_oid = orders.oid) = 3 then set pay_type = '银行卡支付';
		when (select payType from orders where in_oid = orders.oid) = 4 then set pay_type = '其它支付';
		else set pay_type = '输入有误';
	end case;
	select pay_type;
end $$
delimiter ;
call proc_case1(7);

# 语法2
# 输入员工名字，判断工资情况
delimiter $$
create procedure proc07(in in_ename varchar(20), out out_result varchar(20))
begin
	declare var_sal decimal(8, 2);
	select sal into var_sal from emp where emp.ename = in_ename;
	case 
		when var_sal < 10000
			then set out_result = '试用薪资';
		when var_sal < 30000
			then set out_result = '转正薪资';
		else
			set out_result = '元老薪资';
	end case;
end $$
delimiter ;

call proc07('庞统', @out_result);
select @out_result;
# 流程控制-循环语句
# while循环
create table user (
    uid int primary key,
    username varchar (50),
    password varchar (50)
);
TRUNCATE table user;
drop PROCEDURE while1;
delimiter $$
create procedure while1(in insercount int)
begin
	declare i int default 1;
	xun1: while i <= insercount do
		if i = 5
			then
				set i = i + 1;	
				iterate xun1;
-- 				leave xun1;
		end if;
		insert into user values(i, concat('user-', i), concat('123456', i));
		set i = i + 1;
	end while xun1;
end $$
delimiter ;


call while1(10);
select * from user;

# repeat循环
TRUNCATE table user;
drop procedure repeat1;
delimiter $$
create procedure repeat1(in insertnum int)
begin
	declare i int default 0;
	xun1:repeat
		set i = i + 1;
		if i = 5 
			then iterate xun1;
		end if;
		insert into user values(i, concat('user-', i), concat('123456', i));
		until i >= insertnum
	end repeat xun1;
end $$
delimiter ;
call repeat1(10);
select * from user;

# loop 循环
TRUNCATE table user;
drop procedure loop1;
delimiter $$
create procedure loop1(in insertnum int)
begin
	declare i int default 0;
	xun1:loop
		set i = i + 1;
		if i = 5 
			then iterate xun1;
		end if;
		insert into user values(i, concat('user-', i), concat('123456', i));
		if i >= 10
			then leave xun1;
		end if;
	end loop xun1;
end $$
delimiter ;
call loop1(10);
select * from user;



























