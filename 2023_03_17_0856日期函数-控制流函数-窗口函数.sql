# 04. 日期函数
-- UNIX_TIMESTAMP()	返回从1970-01-01 00:00:00到当前毫秒值
select UNIX_TIMESTAMP();
-- UNIX_TIMESTAMP(DATE_STRING)	将制定日期转为毫秒值时间戳
-- FROM_UNIXTIME(BIGINT UNIXTIME[, STRING FORMAT])	将毫秒值时间戳转为指定格式日期
select FROM_UNIXTIME(1679014892, '%Y-%m-%d %H:%i:%s');
-- CURDATE()	返回当前日期
-- CURRENT_DATE()	返回当前日期
select CURDATE();
-- CURRENT_TIME	返回当前时间
-- CURTIME()	返回当前时间
select CURTIME(); 
-- CURRENT_TIMESTAMP()	返回当前日期和时间
select CURRENT_TIMESTAMP();
-- DATE()	从日期或日期时间表达式中提取日期值
select date('2022-12-22 12:56:36');
-- DATEDIFF(d1,d2)	计算日期 d1->d2 之间相隔的天数
-- TIMEDIFF(time1, time2)	计算时间差值
select TIMEDIFF('11', '09:14:15');
-- DATE_FORMAT(d,f)	按表达式 f的要求显示日期 d
select date_format(2020.1.1 1:1:1, '%Y-%m-%d %H:%m:%s %r');
-- STR_TO_DATE(string, format_mask)	将字符串转变为日期
-- DATE_SUB/SUBDATE(date,INTERVAL expr type)	函数从日期减去指定的时间间隔。
select date_sub('2021-12-30', interval 2 hour);
-- DATE_ADD/ADDDATE(date, interval expr type) 日期向后跳转
-- EXTRACT(type FROM d)	从日期 d 中获取指定的值，type 指定返回的值。
-- LAST_DAY(d)	返回给给定日期的那一月份的最后一天
select last_day(current_date());
-- MAKEDATE(year, day-of-year)	基于给定参数年份 year 和所在年中的天数序号 day-of-year 返回一个日期
select makedate(2023, 100);
-- MONTHNAME(d)	返回日期当中的月份名称，如 November
-- DAYNAME(d)	返回日期 d 是星期几，如 Monday,Tuesday
-- DAYOFMONTH(d)	计算日期 d 是本月的第几天
-- DAYOFWEEK(d)	日期 d 今天是星期几，1 星期日，2 星期一，以此类推
-- DAYOFYEAR(d)	计算日期 d 是本年的第几天
-- WEEK(d)	计算日期 d 是本年的第几个星期，范围是 0 到 53
-- WEEKDAY(d)	日期 d 是星期几，0 表示星期一，1 表示星期二
-- WEEKOFYEAR(d)	计算日期 d 是本年的第几个星期，范围是 0 到 53
-- YEARWEEK(date, mode)	返回年份及第几周（0到53），mode 中 0 表示周天，1表示周一，以此类推
-- NOW()	返回当前日期和时间
# 05. 控制流函数
/*
IF 逻辑判断语句

IF(expr,v1,v2)	如果表达式 expr 成立，返回结果 v1；否则，返回结果 v2。	
	SELECT IF(1 > 0,'正确','错误')    ->正确
IFNULL(v1,v2)	如果 v1 的值不为 NULL，则返回 v1，否则返回 v2。	
	SELECT IFNULL(null,'Hello Word') ->Hello Word
ISNULL(expression)	判断表达式是否为 NULL	
	SELECT ISNULL(NULL);  ->1
NULLIF(expr1, expr2)	比较两个字符串，如果字符串 expr1 与 expr2 相等 返回 NULL，否则返回 expr1	
	SELECT NULLIF(25, 25); ->
*/

-- case_when 语句
/* CASE expression
		WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    WHEN conditionN THEN resultN
    ELSE result
   END
CASE 表示函数开始，END 表示函数结束。如果 condition1 成立，则返回 result1, 如果 condition2 成立，则返回 result2，当全部不成立则返回 result，而当有一个成立之后，后面的就不执行了。
*/
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
select *, case payType
	when 1 then '微信支付'
	when 2 then '支付宝支付'
	when 3 then '银行卡支付'
	else '其它'
END AS'支付方式' from orders;
-- 方式2
select *, case
	when payType = 1 then '微信支付'
	when payType = 2 then '支付宝支付'
	when payType = 3 then '银行卡支付'
	else '其它'
END AS'支付方式' from orders;


# 06.窗口函数
-- 序号函数
-- ROW_NUMBER()|RANK()|DENSE_RANK()
-- row_number()|rank()|dense_rank() over(
-- 	partition by···
-- 	order by···
-- )
use mydb1_itheima_learn;
create table employee(
	dname varchar(20) comment'部门名',
	eid varchar(20),
	ename varchar(20),
	hiredate date comment'入职日期',
	salary double comment'薪资'
);
insert into employee values('研发部','1001','刘备','2021-11-01',3000);
insert into employee values('研发部','1002','关羽','2021-11-02',5000);
insert into employee values('研发部','1003','张飞','2021-11-03',7000);
insert into employee values('研发部','1004','赵云','2021-11-04',7000);
insert into employee values('研发部','1005','马超','2021-11-05',4000);
insert into employee values('研发部','1006','黄忠','2021-11-06',4000);
 
insert into employee values('销售部','1007','曹操','2021-11-01',2000);
insert into employee values('销售部','1008','许褚','2021-11-02',3000);
insert into employee values('销售部','1009','典韦','2021-11-03',5000);
insert into employee values('销售部','1010','张辽','2021-11-04',6000);
insert into employee values('销售部','1011','徐晃','2021-11-05',9000);
insert into employee values('销售部','1012','曹洪','2021-11-06',6000);

-- 对每个部门的员工按照薪资降序排序，并给出排名
select
	*,
	row_number() over(PARTITION by dname order by salary desc) as '每个部门的内部排名1',
	rank() over(PARTITION by dname order by salary desc) as '每个部门的内部排名2',
	dense_rank() over(PARTITION by dname order by salary desc) as '每个部门的内部排名3'
from
	employee;
-- 求每个部门薪资排在前三名的员工信息 利用子查询
select
*
from
(
select
	*,
	rank() over(PARTITION by dname order by salary desc) as rn
from
	employee
) as t
where t.rn <= 3;
-- 对所有员工进行全局排序
select
	*,
	row_number() over(order by salary desc) as '内部排名'
from
	employee;
# 开窗聚合函数
select 
	dname,
	ename,
	hiredate,
	salary,
	sum(salary) over(partition by dname order by hiredate) as pv1
from employee;

select 
	dname,
	ename,
	hiredate,
	salary,
	sum(salary) over(partition by dname) as pv1
from employee;
# 分布函数
#CUME_DIST()/PERCENT_RANK()
# CUME_DIST() 分组内小于等于当前rank值的行数/分组内总行数
select
	dname,
	ename,
	salary,
	cume_dist() over(order by salary) as rn1,
	cume_dist() over(partition by dname order by salary) as rn2
from employee;
# 前后函数
# LAG(expr, n, DEFAULT)/LEAD(expr, n, DEFAULT)
# 其它函数
#NTH_VALUE(expr,N)
# NTILE(N)













show databases;
create database if not exists mydb charset = UTF8;
drop database mydb;
alter database mydb character set utf8;
create table if not exists 表名();
tinyint     char
smallint    varchar
int         TINYBLOB
mediumint   tinytext
bigint      blob
float       text
double      MEDIUMBLOB   LONGBLOB
decimal     MEDIUMTEXT   longtext
date
time
year
datetime
timestamp

show tables;
show create table 表名;
drop table 表名;
desc  表名;
alter table employee add pname int;
alter table employee change pname pn varchar(20);
alter table employee drop pn;
rename table emp to employee;
alter table 表名 set 字段名 = 值,字段名 = 值;
alter table 表名 set 字段名 = 值 where 条件
delete from 表名 where
truncate table 表名
create table test(
	eid int primary key auto_increment,
	name varchar(20) default  '1000',
	panme varchar(20)
);
alter table test add constraint pk1 primary key(eid, pid);
alter table test drop auto_increment;
alter table test modify eid int;
insert into test values(null, DEFAULT, '1001');

insert into test values(null, DEFAULT);
alter table test modify panme varchar(20) not null;
alter table test modify panme varchar(20);
alter table test drop index panme;
alter table test change column name bname varchar(20);














