# 游标
-- 声明游标
-- 打开游标
-- 通过游标获取值
-- 关闭游标
-- 输入部门名，查询该部门员工的编号，名字，薪资
drop procedure if exists proc08;

delimiter $$
create procedure proc08(in in_dname varchar(50))
begin
	-- 定义局部变量
	declare out_empno int;
	declare out_ename varchar(20);
	declare out_sal decimal(7,2);
	-- 声明游标
	declare my_cursor cursor for 
		select empno, ename, sal from dept join emp on dept.deptno = emp.deptno and dept.dname = in_dname;
	-- 打开游标
	open my_cursor;
	-- 取值
	fetch my_cursor into out_empno, out_ename, out_sal;
	select out_empno, out_ename, out_sal;
	-- 关闭游标
	close my_cursor;
end $$
delimiter ;

call proc08('销售部');

# 异常处理
-- handler 句柄
/*
DECLARE handler_action HANDLER
    FOR condition_value [, condition_value] ...
    statement
 
handler_action: {
    CONTINUE
  | EXIT
  | UNDO
}
 
condition_value: {
    mysql_error_code
  | condition_name
  | SQLWARNING
  | NOT FOUND
  | SQLEXCEPTION
*/
-- 输入部门名，查询该部门员工的编号，名字，薪资
drop procedure if exists proc08;

delimiter $$
create procedure proc08(in in_dname varchar(50))
begin
	-- 定义局部变量
	declare out_empno int;
	declare out_ename varchar(20);
	declare out_sal decimal(7,2);
	-- 定义标记
	declare flag int default 0;
	-- 声明游标
	declare my_cursor cursor for 
		select empno, ename, sal from dept join emp on dept.deptno = emp.deptno and dept.dname = in_dname;
	-- 声明handler
	declare continue handler for 1329 set flag = 1;
	
	-- 打开游标
	open my_cursor;
	-- 取值
	xunhuan: loop
		fetch my_cursor into out_empno, out_ename, out_sal;
		if flag = 0
			then select out_empno, out_ename, out_sal;
		else 
			leave xunhuan;
		end if;
	end loop xunhuan;
	-- 关闭游标
	close my_cursor;
end $$
delimiter ;

call proc08('销售部');





# 练习
/* 
要求 创建下个月每天对应的表user_2023_04_01、user_2023_04_02、...
需求描述：
我们需要用某个表记录很多数据，比如记录某某用户的搜索、购买行为(注意，此处是假设用数据库保存)，当每天记录较多时，如果把所有数据都记录到一张表中太庞大，需要分表，我们的要求是，每天一张表，存当天的统计数据，就要求提前生产这些表——每月月底创建下一个月每天的表！
*/
drop procedure if exists test;

delimiter $$
create procedure test(in current_date1 date)
begin
	declare next_month_month int;
	declare next_month_year int;
	declare next_month_day int default 1;
	declare date_last int;
	declare next_month_everyday varchar(20);
	declare next_month_str varchar(20);
	declare next_month_day_str varchar(20);
	declare everyday_table varchar(20);
	set next_month_year = year(adddate(current_date1, interval 1 month));
	set next_month_month = month(adddate(current_date1, interval 1 month));
	set date_last = DAY(LAST_DAY(adddate(current_date1, interval 1 month)));
	if next_month_month < 10
		then set next_month_str = CONCAT('0', next_month_month);
	else
		set next_month_str = concat('', next_month_month);
	end if;
	xunhuan: while next_month_day <= date_last do
		set next_month_everyday = concat_ws('_', 'user', next_month_year);
		set everyday_table = '';
		if next_month_day < 10
			then set next_month_day_str = concat('0', next_month_day);
		else
			set next_month_day_str = concat('', next_month_day);
		end if;	
		set next_month_everyday = concat_ws('_', next_month_everyday, next_month_str, next_month_day_str);
		set @create_table_sql = concat('create table ', next_month_everyday,'(`uid` int, `uname` varchar(20), `information` varchar(50))COLLATE=\'utf8_general_ci\'ENGINE = InnoDB');
		prepare create_table_stmt from @create_table_sql;
		execute create_table_stmt;
		deallocate prepare create_table_stmt;
		set next_month_day = next_month_day + 1;
	end while xunhuan;

end $$
delimiter ;

call test('2023-03-22');


SELECT DAY(LAST_DAY(adddate('2023-03-22', interval 1 month)));



select year('2023-03-22');









drop procedure if exists test1;

delimiter $$
create procedure test1()
begin
	declare table_name varchar(20) default 'user_2023_04';
	declare stri varchar(20);
	declare i int default 1;
	xunhuan: while i <= 30 do
		set table_name = 'user_2023_04';
		if i < 10
			then set stri = concat('0', i);
		else set stri = concat('', i);
		end if;
		set table_name = concat_ws('_', table_name, stri);
		
		set @drop_table_sql = concat('drop table ', table_name);
		prepare drop_table_stmt from @drop_table_sql;
		execute drop_table_stmt;
		deallocate prepare drop_table_stmt;
		set i = i + 1;
	end while xunhuan;
	
end $$
delimiter ;
call test1();


# 存储函数
set global log_bin_trust_function_creators=TRUE;
-- 创建存储函数没有参数
drop function if exists noparam;
delimiter $$
create function noparam()
returns int
begin
	declare cnt int default 0;
	select count(*) into cnt from emp;
	return cnt;
end $$
delimiter ;


select noparam();
-- 创建存储函数--有输入参数
-- 传入一个员工的编号，返回员工的名字
drop function if exists myfunc2_emp;
delimiter $$
create function myfunc2_emp(in_empno int)
returns varchar(50)
begin
	declare out_ename varchar(50) default null;
	select ename into out_ename from emp where empno = in_empno;
	return out_ename;
	
end $$
delimiter ;

select myfunc2_emp(1001);








