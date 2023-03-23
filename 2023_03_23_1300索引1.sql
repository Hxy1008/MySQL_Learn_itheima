# 单列索引- 普通索引
# 创建操作
create table student(
	sid int primary key,
	card_id varchar(20),
	name varchar(20),
	gender varchar(20),
	age int,
	birth date,
	phone_num varchar(20),
	score double,
	index index_name(name)
);

create index index_gender on student(gender);
alter table student add index index_age(age);