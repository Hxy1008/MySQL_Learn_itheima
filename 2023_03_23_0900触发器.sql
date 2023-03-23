# 触发器
# 创建触发器
# 只有一条执行语句
-- create trigger 触发器名 before|after 触发事件
-- on 表名 for each row 
-- 执行语句;

-- 有多条执行语句
-- create trigger 触发器名 before|after  触发事件 
-- on 表名 for each row
-- begin
--      执行语句列表
-- end;
-- 用户表
create table user(
    uid int primary key ,
    username varchar(50) not null,
    password varchar(50) not null
);
-- 用户信息操作日志表
create table user_logs(
    id int primary key auto_increment,
    time timestamp,
    log_text varchar(255)
);

-- 当user表添加一行数据，则自动在user_logs表添加日志记录
drop trigger if exists user_insert;
create trigger user_insert after insert
on `user` for each row
insert into user_logs values(null, now(), '有新用户添加');

insert into `user` values(1, '张三', '123456');


-- 当user表被修改时，自动在user_logs表添加日志记录
drop trigger if exists user_insert;
delimiter $$
create trigger user_update after update
on `user` for each row
begin
	insert into user_logs values(null, now(), '有用户进行修改操作');
end $$
delimiter ;

update `user` set username = '李四' where uid = 1;



#NEW和OLD
-- insert
drop trigger if exists user_insert;
delimiter $$
create trigger user_insert after insert
on `user` for each row
begin
	insert into user_logs values(null, now(), concat('有新用户进行插入 ','uid:',new.uid,' username:',new.username,' password',new.`password`));
end $$
delimiter ;
insert into `user` values(1, '李四', '123456');






