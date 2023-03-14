use mydb1_itheima_learn;
# 创建外键约束
# 1. [constraint<外键名>]foreign key 字段名1[,字段名2···,]references <主表名>主键列1[,主键列2,···]
# 创建部门表-主表
create table if not exists dept(
	deptno varchar(20) primary key comment '部门号',
	name varchar(20) comment '部门名称'
);
# 创建员工表-子表
create table if not exists emp(
	eid varchar(20) primary key comment'员工编号',
	ename varchar(20) comment'员工名字',
	age int comment'员工年龄',
	dept_id varchar(20) comment'员工所属部门',
	constraint emp_fk foreign key(dept_id) references dept(deptno)
);
# 2.修改表结构添加外键
# alter table <表名> add constraint <外键名> foreign key(列名) references 主表名 (列名);
alter table emp add constraint emp_fk foreign key(dept_id) references dept(deptno);
# 验证外键约束的作用
-- 1、添加主表数据
-- 注意必须先给主表添加数据
insert into dept values('1001','研发部');
insert into dept values('1002','销售部');
insert into dept values('1003','财务部');
insert into dept values('1004','人事部');

-- 2、添加从表数据
-- 注意给从表添加数据时，外键列的值不能随便写，必须依赖主表的主键列
insert into emp values('1','乔峰',20, '1001');
insert into emp values('2','段誉',21, '1001');
insert into emp values('3','虚竹',23, '1001');
insert into emp values('4','阿紫',18, '1002');
insert into emp values('5','扫地僧',35, '1002');
insert into emp values('6','李秋水',33, '1003');
insert into emp values('7','鸠摩智',50, '1003'); 
insert into emp values('8','天山童姥',60, '1005');  -- 不可以
# 删除数据
# 主表的数据被从表依赖时不能删除，否则可以删除
delete from dept where deptno = '1001';
delete from dept where deptno = '1004';
# 从表的数据可以随意删除
delete from emp where eid = '7'
# 删除外键约束
alter table emp drop foreign key emp_fk;
# 多对多关系
# 创建学生表
create table if not exists stu(
	sid int primary key auto_increment,
	name varchar(20),
	age int,
	gender varchar(20)
);
# 创建课程表
create table if not exists course(
	cid int primary key auto_increment,
	cname varchar(20)
);
# 创建中间表
create table if not exists score(
	sid int,
	cid int,
	score double
);
# 建立两次外键约束
alter table score add constraint sid_fk foreign key(sid) references stu(sid); 
alter table score add constraint cid_fk foreign key(cid) references course(cid); 
# 给学生表添加数据
INSERT INTO stu values(1, '小龙女', 18, '女'),(null, '阿紫', 18, '女'),(null, '周芷若', 18, '女');
# 给课程表添加数据
insert into course values(1, '语文'),(2, '数学'),(3, '英语');
# 给成绩表添加数据
insert into score values(1, 1, 78),(1, 2, 88),(2, 1, 79),(2, 3, 90),(3, 2, 89),(3, 3, 67);
insert into score values(4, 1); -- 不可以
# 多表联合查询
-- 创建部门表
create table if not exists dept3(
  deptno varchar(20) primary key ,  -- 部门号
  name varchar(20) -- 部门名字
);
 
-- 创建员工表
create table if not exists emp3(
  eid varchar(20) primary key, -- 员工编号
  ename varchar(20), -- 员工名字
  age int,  -- 员工年龄
  dept_id varchar(20)  -- 员工所属部门
);
-- 给dept3表添加数据
insert into dept3 values('1001','研发部');
insert into dept3 values('1002','销售部');
insert into dept3 values('1003','财务部');
insert into dept3 values('1004','人事部');
-- 给emp表添加数据
insert into emp3 values('1','乔峰',20, '1001');
insert into emp3 values('2','段誉',21, '1001');
insert into emp3 values('3','虚竹',23, '1001');
insert into emp3 values('4','阿紫',18, '1001');
insert into emp3 values('5','扫地僧',85, '1002');
insert into emp3 values('6','李秋水',33, '1002');
insert into emp3 values('7','鸠摩智',50, '1002'); 
insert into emp3 values('8','天山童姥',60, '1003');
insert into emp3 values('9','慕容博',58, '1003');
insert into emp3 values('10','丁春秋',71, '1005');
# 交叉连接查询
# select * from 表1,表2,表3;
select * from dept3, emp3;
# 内连接查询
# select * from A, B where 条件;
# select * from A inner join B on 条件;
# 查询所有部门的所属员工
select emp3.ename from dept3 inner join emp3 on dept3.deptno = emp3.dept_id;
# 查询研发部和销售部的所属员工
select * from emp3 inner join dept3 on emp3.dept_id = dept3.deptno and dept3.name in('研发部', '销售部');
# 查询每个部门的员工数并升序排序
select emp3.dept_id, name, count(*) as'员工数' from dept3 inner join emp3 on dept3.deptno = emp3.dept_id group by emp3.dept_id order by '员工数' asc;
# 查询人数大于3的部门，并按照人数降序排序
select name, count(1) as total_cnt from dept3 inner join emp3 on dept3.deptno = emp3.dept_id group by emp3.dept_id having total_cnt >= 3 order by total_cnt desc;
# 外连接查询
# 左外连接 select * from A left outer join B on 条件;
# 右外连接 select * from A right outer join B on 条件;
# 满外连接 select * from A full outer join B on 条件; 一般使用union关键字
-- 有多张表时
-- select * from A left join B on 条件1
--                 left join C on 条件2
--                 left join D on 条件3
# 查询哪个部门有员工，哪个部门没有员工
select name, ename from dept3 left outer join emp3 on dept3.deptno = emp3.dept_id;
# 查询哪个员工没有对应的部门
select name, ename from dept3 right outer join emp3 on dept3.deptno = emp3.dept_id;
# 满外连接 显示左外连接和右外连接的并集
select name, ename from dept3 full outer join emp3 on dept3.deptno = emp3.dept_id; -- 不可以
select * from dept3 left outer join emp3 on dept3.deptno = emp3.dept_id
union
select * from dept3 right outer join emp3 on dept3.deptno = emp3.dept_id;
select * from dept3 left outer join emp3 on dept3.deptno = emp3.dept_id
union all
select * from dept3 right outer join emp3 on dept3.deptno = emp3.dept_id;
-- union 将上下的查询结果拼接并去重
-- union all 不去重



















