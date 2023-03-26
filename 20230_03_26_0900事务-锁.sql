/*
MySQL的事务操作主要有以下三种：
1、开启事务：Start Transaction

任何一条DML语句(insert、update、delete)执行，标志事务的开启
命令：BEGIN 或 START TRANSACTION

2、提交事务：Commit Transaction
成功的结束，将所有的DML语句操作历史记录和底层硬盘数据来一次同步
命令：COMMIT

3、回滚事务：Rollback Transaction
失败的结束，将所有的DML语句操作历史记录全部清空
命令：ROLLBACK 
*/
# 关闭MySQL事务的自动提交
set autocommit = 0;
set autocommit = 1;
select @@session.autocommit;
create table account(
	id int primary key,
	name varchar(20),
	money double
);
insert into account values(1, 'zhangsan', 1000);
insert into account values(2, 'lisi', 1000);
-- 模拟转账
-- 开启事务
begin; # 或者start transaction

-- id为1的账户转账给id为2的账户update account set money = money - 200 where id = 1;
update account set money = money + 200 where id = 2;
-- 提交事务
commit;
-- 回滚事务
rollback;


select * from account;


set autocommit = 0;


-- 查看隔离级别 
show variables like '%isolation%'; 

-- 设置隔离级别
/*
set session transaction isolation level 级别字符串
级别字符串：read uncommitted、read committed、repeatable read、serializable
*/
-- 设置read uncommitted
set session transaction isolation level read uncommitted;
 
-- 设置read committed
set session transaction isolation level read committed;
 
-- 设置repeatable read
set session transaction isolation level repeatable read;
 
-- 设置serializable
set session transaction isolation level serializable;


# 锁机制
-- MyISAM表锁
加读锁 ： lock table table_name read; 

加写锁 ： lock table table_name write；


create table `tb_book` (
  `id` int(11) auto_increment,
  `name` varchar(50) default null,
  `publish_time` date default null,
  `status` char(1) default null,
  primary key (`id`)
) engine=myisam default charset=utf8;
 
insert into tb_book (id, name, publish_time, status) values(null,'java编程思想','2088-08-01','1');
insert into tb_book (id, name, publish_time, status) values(null,'solr编程思想','2088-08-08','0');


create table `tb_user` (
  `id` int(11) auto_increment,
  `name` varchar(50) default null,
  primary key (`id`)
) engine=myisam default charset=utf8 ;
--InnoDB 行锁
共享锁（S）：SELECT * FROM table_name WHERE ... LOCK IN SHARE MODE 
排他锁（X) ：SELECT * FROM table_name WHERE ... FOR UPDATE


drop table if exists test_innodb_lock;
create table test_innodb_lock(
    id int(11),
    name varchar(16),
    sex varchar(1)
)engine = innodb ;
 
insert into test_innodb_lock values(1,'100','1');
insert into test_innodb_lock values(3,'3','1');
insert into test_innodb_lock values(4,'400','0');
insert into test_innodb_lock values(5,'500','1');
insert into test_innodb_lock values(6,'600','0');
insert into test_innodb_lock values(7,'700','0');
insert into test_innodb_lock values(8,'800','1');
insert into test_innodb_lock values(9,'900','1');
insert into test_innodb_lock values(1,'200','0');
 
create index idx_test_innodb_lock_id on test_innodb_lock(id);
create index idx_test_innodb_lock_name on test_innodb_lock(name);
 































