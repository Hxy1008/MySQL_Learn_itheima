create table emp(
    emp_id int primary key auto_increment comment '编号',
    emp_name char(20) not null default '' comment '姓名',
    salary decimal(10,2) not null default 0 comment '工资',
    department char(20) not null default '' comment '部门'
);
 
insert into emp(emp_name,salary,department) 
values('张晶晶',5000,'财务部'),('王飞飞',5800,'财务部'),('赵刚',6200,'财务部'),('刘小贝',5700,'人事部'),('王大鹏',6700,'人事部'),('张小斐',5200,'人事部'),('刘云云',7500,'销售部'),('刘云鹏',7200,'销售部'),
('刘云鹏',7800,'销售部');
# 01. 聚合函数
-- count sum min max avg
-- group_concat()
-- group_concat([distinct] 字段名 [order by 排序字段 asc\desc] [separator '分隔符'])
-- 1. 将所有的员工名字合成一行
select GROUP_CONCAT(emp_name) from emp;
-- 2. 指定分隔符合并
select GROUP_CONCAT(emp_name separator ';') from emp;
-- 3. 指定排序方式和分隔符
select department, GROUP_CONCAT(emp_name order by salary desc separator'。') from emp group by department; 
# 02 数学函数
-- ABS(x)	返回 x 的绝对值
select abs(-10);　　
-- CEIL(x)	返回大于或等于 x 的最小整数
select ceil(2.2);
-- FLOOR(x)	返回小于或等于 x 的最大整数
select floor(2.2);　　
-- GREATEST(expr1, expr2, expr3, ...)	返回列表中的最大值
-- LEAST(expr1, expr2, expr3, ...)	返回列表中的最小值
-- MAX(expression)	返回字段 expression 中的最大值
-- MIN(expression)	返回字段 expression 中的最小值
-- MOD(x,y)	返回 x 除以 y 以后的余数　
-- PI()	返回圆周率(3.141593）　　
-- POW(x,y)	返回 x 的 y 次方　
-- RAND()	返回 0 到 1 的随机数
select rand();　　
-- ROUND(x)	返回离 x 最近的整数（遵循四舍五入）
select round(1.34543543);
select round(1.54543543);
-- ROUND(x,y)	返回指定位数的小数（遵循四舍五入）
select round(1.34543543, 1);
select round(1.35543543, 1);
-- TRUNCATE(x,y)	返回数值 x 保留到小数点后 y 位的值（与 ROUND 最大的区别是不会进行四舍五入）
select TRUNCATE(1.34543543, 1);
select TRUNCATE(1.35543543, 1);

select category_id, round(avg(product.price), 2) from product group by category_id;











