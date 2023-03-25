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

































