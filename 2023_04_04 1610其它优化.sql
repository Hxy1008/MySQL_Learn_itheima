# 1.大批量插入数据
create table `tb_user` (
  `id` int(11) not null auto_increment,
  `username` varchar(45) not null,
  `password` varchar(96) not null,
  `name` varchar(45) not null,
  `birthday` datetime default null,
  `sex` char(1) default null,
  `email` varchar(45) default null,
  `phone` varchar(45) default null,
  `qq` varchar(32) default null,
  `status` varchar(32) not null comment '用户状态',
  `create_time` datetime not null,
  `update_time` datetime default null,
  primary key (`id`),
  unique key `unique_user_username` (`username`)
);
drop table tb_user;
truncate table tb_user;
# 主键有序插入
-- 主键有序
load data local infile 'D:\\BaiduNetdiskDownload\\sql_code\\sql1.log' into table tb_user fields terminated by ',' lines terminated by '\n';
-- 主键无序
load data local infile 'D:\\BaiduNetdiskDownload\\sql_code\\sql2.log' into table tb_user fields terminated by ',' lines terminated by '\n';
主键无序的时间明显更长

show global variables like '%local_infile%';
set global local_infile = 'ON';

# 关闭唯一性校验
show VARIABLES like '%unique_checks%';
set unique_checks = 0;
load data local infile 'D:\\BaiduNetdiskDownload\\sql_code\\sql1.log' into table tb_user fields terminated by ',' lines terminated by '\n';


set unique_checks = 1; # 操作完记得打开

# 2.insert 语句优化
-- 尽量使用少的insert语句
-- 在事务中进行insert语句
-- 数据有序插入


# 3.order by 语句优化
CREATE TABLE `emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `age` int(3) NOT NULL,
  `salary` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
);
 
insert into `emp` (`id`, `name`, `age`, `salary`) values('1','Tom','25','2300');
insert into `emp` (`id`, `name`, `age`, `salary`) values('2','Jerry','30','3500');
insert into `emp` (`id`, `name`, `age`, `salary`) values('3','Luci','25','2800');
insert into `emp` (`id`, `name`, `age`, `salary`) values('4','Jay','36','3500');
insert into `emp` (`id`, `name`, `age`, `salary`) values('5','Tom2','21','2200');
insert into `emp` (`id`, `name`, `age`, `salary`) values('6','Jerry2','31','3300');
insert into `emp` (`id`, `name`, `age`, `salary`) values('7','Luci2','26','2700');
insert into `emp` (`id`, `name`, `age`, `salary`) values('8','Jay2','33','3500');
insert into `emp` (`id`, `name`, `age`, `salary`) values('9','Tom3','23','2400');
insert into `emp` (`id`, `name`, `age`, `salary`) values('10','Jerry3','32','3100');
insert into `emp` (`id`, `name`, `age`, `salary`) values('11','Luci3','26','2900');
insert into `emp` (`id`, `name`, `age`, `salary`) values('12','Jay3','37','4500');
 
create index idx_emp_age_salary on emp(age,salary);

-- filesort 排序
explain select * from emp order by age;
-- using index排序
explain select id from emp order by age;
explain select id,age,salary from emp order by age,salary;  -- Using index
-- 既有filesort 也有 index
explain select id,age from emp order by age asc, salary desc;
虽然有一个组合索引，但是当排序方式不同是 age使用了组合索引，根据复合最左原则，salary使用不了组合索引了
我是这样想的，老师没讲
explain select id, age from emp order by age desc, salary desc;  -- Backward index scan; Using index

explain select id, age from emp order by salary, age; -- Using index; Using filesort
order by 后边的多个排序字段，尽量和组合索引字段顺序相同

































