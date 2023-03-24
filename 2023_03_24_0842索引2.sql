create table student1(
	sid int primary key,
	card_id varchar(20),
	name varchar(20),
	gender varchar(20),
	age int,
	birth date,
	phone_num varchar(20),
	score double,
);
# 单列索引-普通索引-查看操作
-- 查看数据库所有索引
select * from mysql.`innodb_index_stats` a where a.`database_name` = '数据库名';
select * from mysql.`innodb_index_stats` a where a.`database_name` = 'mydby_6';
-- 查看表中的索引
select * from mysql.`innodb_index_stats` a where a.`database_name` = 'mydby_6' and a.table_name like '%student%';
show index from student;

# 单列索引-普通索引-删除操作
drop index <索引名> on <表名>;
drop index index_age on student;
alter table <表名> drop index <索引名>;
alter table student drop index index_gender;

#单列索引-唯一索引
create table student1(
	sid int primary key,
	card_id varchar(20),
	name varchar(20),
	gender varchar(20),
	age int,
	birth date,
	phone_num varchar(20),
	score double,
	unique index_card_id(card_id)
);
create unique index index_phone_num on student1(phone_num);
drop index index_phone_num on student1;
alter table student1 add [unique] index index_phone_num(phone_num);
alter table student1 drop index index_phone_num;
# 组合索引
create table student2(
	sid int primary key,
	card_id varchar(20),
	name varchar(20),
	gender varchar(20),
	age int,
	birth date,
	phone_num varchar(20),
	score double
);
-- 创建
-- 创建普通索引
create index index_name on table_name(column1(length), column2(length));
create index index_phone_name on student2(phone_num, `name`);
-- 创建唯一索引
create unique index index_name on table_name(column1(length), column2(length));
create unique index index_phone_name_1 on student2(phone_num, `name`);
drop index index_phone_name on student2;



-- 复合最左原则
select * from student where name = '张三'; 
select * from student where phone_num = '15100046637'; 
select * from student where phone_num = '15100046637' and name = '张三'; 
select * from student where name = '张三' and phone_num = '15100046637'; 
/* 
  三条sql只有 2 、 3、4能使用的到索引idx_phone_name,因为条件里面必须包含索引前面的字段  才能够进行匹配。
  而3和4相比where条件的顺序不一样，为什么4可以用到索引呢？是因为mysql本身就有一层sql优化，他会根据sql来识别出来该用哪个索引，我们可以理解为3和4在mysql眼中是等价的。 

*/
# 全文索引 fulltext

show variables like '%ft%';
-- 创建表的时候添加全文索引
create table t_article (
     id int primary key auto_increment ,
     title varchar(255) ,
     content varchar(1000) ,
     writing_date date, 
		 fulltext (content) -- 创建全文检索
);

insert into t_article values(null,"Yesterday Once More","When I was young I listen to the radio",'2021-10-01');
insert into t_article values(null,"Right Here Waiting","Oceans apart, day after day,and I slowly go insane",'2021-10-02'); 
insert into t_article values(null,"My Heart Will Go On","every night in my dreams,i see you, i feel you",'2021-10-03');
insert into t_article values(null,"Everything I Do","eLook into my eyes,You will see what you mean to me",'2021-10-04');
insert into t_article values(null,"Called To Say I Love You","say love you no new year's day, to celebrate",'2021-10-05');
insert into t_article values(null,"Nothing's Gonna Change My Love For You","if i had to live my life without you near me",'2021-10-06');
insert into t_article values(null,"Everybody","We're gonna bring the flavor show U how.",'2021-10-07');
drop index index_content on t_article;
-- 修改表结构
alter table t_article add fulltext index index_content(content);
-- 直接添加
create fulltext index index_content on t_article(content);

# 使用全文索引
select * from <表名> where match(col1, col2,...) against(expr[search_modiffier]);

select * from t_article where match(content) against('yo'); -- 没有结果 单词数需要大于等于3 
select * from t_article where match(content) against('you'); -- 有结果
#空间索引
create table shop_info (
  id  int  primary key auto_increment comment 'id',
  shop_name varchar(64) not null comment '门店名称',
  geom_point geometry not null comment '经纬度',
  spatial key geom_index(geom_point)
);


# 验证索引的好处
use itcast_shop;
-- 创建临时表
create temporary table tmp_goods_cat
as
select t3.catid as cat_id_l3,
			 t3.catname as cat_name_l3,
			 t2.catid as cat_id_l2,
			 t2.catname as cat_name_l2,
			 t1.catid as cat_id_l1,
			 t1.catname as cat_name_l1
from itcast_shop.itheima_goods_cats t3,
		 itcast_shop.itheima_goods_cats t2,
		 itcast_shop.itheima_goods_cats t1
where t3.parentid = t2.catid
  and t2.parentid = t1.catid
	and t3.cat_level = 3;
select * from tmp_goods_cat;

-- 统计分析不同一级商品分类对应的总金额、总笔数
select
	'2019-09-05',
	t1.cat_name_l1 as goods_cat_l1,
	sum(t3.payprice * t3.goodsnum) as total_money,
	count(distinct t3.orderid) as total_cnt
from 
  tmp_goods_cat t1
left join itheima_goods t2
  on t1.cat_id_l3 = t2.goodscatid
left join itheima_order_goods t3
  on t2.goodsid = t3.goodsid
where 
  substring(t3.createtime, 1, 10) = '2019-09-05'
group by
  t1.cat_name_l1;






-- 创建索引
create unique index idx_goods_cat3 on tmp_goods_cat(cat_id_l3);
create index idx_itheima_goodscatid on itheima_goods(goodscatid);
create unique index idx_itheima_goods on itheima_goods(goodsid);
create index idx_itheima_order_goods on itheima_order_goods(goodsid);

drop index idx_itheima_order_goods on itheima_order_goods;



show engines;

