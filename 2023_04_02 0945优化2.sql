#select_type
# SIMPLE 没有子查询和UNION
explain select * from user;
explain select * from user join user_role on `user`.uid = user_role.uid;
# PRIMARY 主查询，也就是子查询中的最外层查询
explain select * from role where rid = (select rid from user_role where uid = (select uid from user where uname = '张飞'));
# SUBQUERY 在Select和Where中包含的子查询
explain select * from role where rid = (select rid from user_role where uid = (select uid from user where uname = '张飞'));
# DERIVED 在From中包含的子查询,被标记为衍生表
explain select * from (select * from user limit 2) as a;
# UNION 
# UNION RESULT
explain
select * from user where uid = 1
UNION
select * from user where uid = 3;

# type
# NULL 不访问任何表，任何索引，直接返回结果
explain select now();
# SYSTEM 访问的是系统表，数据较少，不需要磁盘IO 在5.7以上就直接显示ALL
explain select * from mysql.tables_priv;
# const 
explain select * from user where uid = 2;
# eq_ref 对前表的每一行，后表只有一行被扫描 左表有主键列，且左表的每一行与右表的每一行匹配
create table if not exists user2(
	id int,
	name varchar(20)
);
create table if not exists user2_ex(
	id int,
	age int
);

insert into user2 values(2, '李四'),(3, '王五');
insert into user2_ex values(1, 20),(2, 21),(3, 22);
explain select * from user2 a, user2_ex b where a.id = b.id;
--  给user2表添加主键索引
alter table user2 add PRIMARY KEY(id);
explain select * from user2 a, user2_ex b where a.id = b.id;
-- 给user2_ex添加重复数据后
explain select * from user2 a, user2_ex b where a.id = b.id;

# ref
alter table user2 drop PRIMARY KEY;
-- 给user2添加普通索引
alter table user2 add index index_simple(id);
explain select * from user2 a, user2_ex b where a.id = b.id;
-- 给user2_ex添加重复数据后
explain select * from user2 a, user2_ex b where a.id = b.id;

# range 范围查询
主要是where后面有范围
# index 扫描索引列的全部数据
explain select id from user2; -- index
explain select * from user2; -- ALL
# ALL 扫描全表

#table
#rows
#possible_keys
#key
#key_len
#Extra
explain select * from user order by uname;
explain select uname, count(*) from user GROUP BY uname;
explain select uid, count(*) from user GROUP BY uid;


# show profile语句
-- 查看当前MySQL是否支持profile
select @@have_profiling;
-- 如果不支持，则需要设置打开
set profiling = 1;

show databases;
use mydby_7;
show tables;
select * from user where uid < 2;
select count(*) from user_role;
show profiles;

show profile for query 238;
show profile cpu for query 265;
show profile all for query 284;
show profile Block_ops_in for query 284;

# trace优化器
show variables like '%OPTIMIZe%';
show variables like 'optimizer_trace';
select @@session.optimizer_trace;
select * from user where uid < 2;
set optimizer_trace = 'enabled = on',end_markers_in_json = on;












