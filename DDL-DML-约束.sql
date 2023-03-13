# 展示所以数据库
show databases;

# 创建一个新的数据库
create DATABASE if not EXISTS mydb1_itheima_learn CHARSET = utf8;
-- 使用mydb1_itheima_learn
use mydb1_itheima_learn;

# 练习删除数据库
create database if not exists test charset = utf8;
drop database if exists test;

# 对表结构的相关操作
-- 创建表
create table if not exists stu1(
	stID int comment '学生的ID',
	name varchar(20) COMMENT '学生姓名',
	address VARCHAR(20) COMMENT '学生地址'
);
-- 对表结构的其它操作
-- 查看当前所有数据库的表名称
create table if not exists test1(
	stID int comment '学生的ID',
	name varchar(20) COMMENT '学生姓名',
	address VARCHAR(20) COMMENT '学生地址'
);
create table if not exists test2(
	stID int comment '学生的ID',
	name varchar(20) COMMENT '学生姓名',
	address VARCHAR(20) COMMENT '学生地址'
);
show tables; --  查看当前所有数据库的表名称
-- 查看指定某个表的创建语句
show create table stu1;
-- 删除表
drop table test1;
drop table test2;
-- 查看表结构
desc stu1;
-- 修改表添加列
alter table stu1 add phone_numeber varchar(20);
-- 修改列名和类型
alter table stu1 change stID ST123 varchar(10);
alter table stu1 change ST123 stID int;
-- 删除列
alter table stu1 drop phone_numeber;
-- 修改表名
rename table stu1 to student1;
rename table student1 to stu1;

# MySQL数据库基本操作 DML
-- 插入 insert
-- 删除 delete
-- 更行 update
-- 1.数据插入
create table stu2(
	stID int comment '学生id',
	name VARCHAR(20) comment '学生姓名',
	address VARCHAR(20) comment '学生地址'
);
insert into stu2(stID) values(1001); -- 使用insert into<表名>(字段名) values(); 可以指定某一个列进行添加
insert into stu2(stID, name, address) values(1002, '张三', '北京');
insert into stu2(name, stID, address) values('李四', 1003, '北京');-- 使用insert into<表名>(字段名) values();  字段名可以不按表中的顺序，有点类似于关键字传参
insert into stu2 values(1004, '王五', '深圳');
insert into stu2 values(1005, '赵六'); -- 使用insert into<表名> values(); 的方法必须按位置传，且所有地方不能为空，除非在约束里面加
-- 插入多行数据
insert into stu2 values(1005, 'X1', '河南'),(1006, 'X2', '河北'),(1007, 'X3', '天津');
-- 2.数据修改
-- update 表名 set 字段名1 = 值, 字段名2 = 值, ···, 字段名N = 值;
update stu2 set address = '重庆' -- 改了所有的address
-- update 表名 set 字段名1 = 值, 字段名2 = 值, ···, 字段名N = 值 where 条件;
update stu2 set address = '上海' where stID = 1001;-- 将stID为1001的学生的地址改为上海
-- 3.数据删除
-- delete from 表名 [where 条件];
delete from stu2 where stID = 1004; -- 删除了stu2表中stID=1004的那一行的数据，不加where 就删除全部
-- truncate table 表名/ truncate 表名
truncate table stu1;
# MySQL 约束-主键约束
-- 主键约束-单列主键
-- 在创建表定义字段时直接指定主键
use mydb1_itheima_learn;
create table stu3(
	stid int primary key,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
);
-- 在创建表定义字段后指定主键-[constraint 约束名] primary key (字段名) 
drop table stu3;
create table stu3(
	stid int,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11),
	constraint PK1 primary key (stid)
);
-- 在创建表后指定主键
drop table stu3;
create table stu3(
	stid int,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
);
alter table stu3 modify stid int primary key;
-- 另一种创建表以后指定主键的方法
drop table stu3;
create table stu3(
	stid int,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
);
alter table stu3 change stid stid int primary key;
-- 主键约束-多列主键
-- 定义表时在定义字段后加上[CONSTRAINT <约束名>]primary key(字段名1, 字段名2····)
-- alter table 表名 add [constraint <约束名>] primary key(字段名1, 字段名2····)
drop table stu3;
create table stu3(
	stid int,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(20)
);
alter table stu3 add constraint PK1 PRIMARY KEY(stid, name);
-- 删除主键约束
-- alter table 表名 drop primary key;
alter table stu3 drop primary key;
-- 一些测试
insert into stu3(stid, name) values(1001, '张三')
insert into stu3(stid, name) values(1001, '李四')
insert into stu3(stid, name) values(1002, NULL)
# MySQL 约束-自增长约束
-- 定义字段时 字段名 类型(长度) auto_increment;
/* 
默认从1开始
必须于主键联用
一个表中只能有一个字段使用auto_increment约束
auto_increment约束的字段必须为 NOT NULL
字段必须为整型
*/
drop table stu4;
create table stu4(
	stid int primary key auto_increment,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
);
insert into stu4 values(NULL, '张三', '北京', '17814781456'); -- 就算自动增长了，也得用NULL来占位
insert into stu4(name) values('李四');
-- 指定自增长字段的初始值
-- 1.创建表时指定
create table stu4(
	stid int primary key auto_increment,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
)auto_increment = 100; -- 在这里写着相当于表的设置，第一行为设置的默认值100
insert into stu4 values(NULL, '张三', '北京', '17814781456');
-- 2.创建表后设置
-- alter table 表名 auto_increment = DEFAULT
create table stu4(
	stid int primary key auto_increment,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
);
alter table stu4 auto_increment = 100;
-- delete 删除数据后自动增长从断点开始
-- truncate 删除数据后自动增长从默认起始值开始
-- 设定自增长步长-set session auto_increment_increment = 数值;会将整个会话的步长全设置为某数值
set session auto_increment_increment=1;
# MySQL约束-非空约束(NOT NULL)
-- 1.创建表时指定   <字段名><类型> not null;
create table stu5(
	stid int,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
);
insert into stu5 values(1001, '张三', '北京', '17814671345');
-- 2.创建完表后指定  alter table 表名 modify 字段名 类型(长度) not NULL;
alter table stu5 modify stid int not NULL;
-- 删除非空约束 alter table 表名 modify 字段名 类型(长度);
alter table stu5 modify stid int;
# MySQL约束-唯一约束(UNIQUE)
-- 在MySQL中，NULL不和任何值相同，包括NULL自己
-- 1.在创建表时指定 字段名 类型(长度) unique;
create table stu5(
	stid int UNIQUE,
	name varchar(20),
	address VARCHAR(20),
	phone_numeber varchar(11)
);
insert into stu5 values(1001, '张三', '北京', '17814671345');
insert into stu5 values(NULL, '李四', '上海', '17814781345');
insert into stu5 values(NULL, '王五', '深圳', '17814781790');
-- 2.在创建完表后指定
-- alter table 表名 modify 字段名 类型(长度) unique; 只能指定一个且不能修改约束名
-- alter table 表名 add constraint 约束名 unique(字段名); 可同时指定多个字段
  /* 
	以下述为例子，如果unique(stid, name)这样使用，则会把stid和name这两个字段名当成一个整体，只要他俩有一个不同
	就能存入数据，如果分别unique(stid);unique(name);则会让他俩不成为一个整体，必须两个字段都不同才能存入数据*/
create table stu5(
	stid int,
	name int,
	address VARCHAR(20),
	phone_numeber varchar(11)
);
alter table stu5 add unique(stid);
alter table stu5 add unique(name);
insert into stu5 values(1001, 1002, '深圳', '17814781790');
insert into stu5 values(1001, 1003, '深圳', '17814781790');
-- 删除唯一约束
-- alter table 表名 drop index <唯一约束名>; -- 若不指定唯一约束名，则约束名为字段名
alter table stu5 drop index stid; -- 若不指定唯一约束名，则约束名为字段名
-- 不能通过 alter table modify 字段名 类型(长度); 的方式删除唯一约束
# MySQL约束-默认约束(DEFAULT)
-- 1.创建表时指定 字段名 类型(长度) default 默认值;
CREATE TABLE stu6(
	id int,
	name varchar(20),
	address varchar(20) default '北京'
);
insert into stu6 values(1001, '张三', null); -- 插入数据时 使用default占位，不能空着
insert into stu6(id, name) values(1001, '张三');-- 这样插入数据时不用管
-- 2.创建完列表后指定 alter table 表名 modify 字段名 类型(长度) default 默认值;
-- 删除默认约束
-- alter table 表名 change column 字段名 类型(长度) default null;
-- alter table 表名 modify 字段名 类型(长度) default null;


# MySQL约束-零填充约束(ZEROFILL)
-- zerofill 默认为int(10) 长度变了,且好像只能给整数用，可以去csdn查查
-- 字段名 类型(长度) zerofill;
-- alter table 表名 modify 字段名 类型(长度) zerofill;


-- 删除零填充约束
-- alter table 表名 modify 字段名 类型(长度);





