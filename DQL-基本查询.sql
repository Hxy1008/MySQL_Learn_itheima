use mydb2;
-- 创建商品表
create table product(
	pid int primary key auto_increment comment '商品编号',
	pname varchar(20) not null comment '商品名称',
	price double comment '商品价格',
	category_id varchar(20) comment '商品所属分类'
);
-- 添加数据
insert into product values(null,'海尔洗衣机',5000,'c001');
insert into product values(null,'美的冰箱',3000,'c001');
insert into product values(null,'格力空调',5000,'c001');
insert into product values(null,'九阳电饭煲',200,'c001');

insert into product values(null,'啄木鸟衬衣',300,'c002');
insert into product values(null,'恒源祥西裤',800,'c002');
insert into product values(null,'花花公子夹克',440,'c002');
insert into product values(null,'劲霸休闲裤',266,'c002');
insert into product values(null,'海澜之家卫衣',180,'c002');
insert into product values(null,'杰克琼斯运动裤',430,'c002');

insert into product values(null,'兰蔻面霜',300,'c003');
insert into product values(null,'雅诗兰黛精华水',200,'c003');
insert into product values(null,'香奈儿香水',350,'c003');
insert into product values(null,'SK-II神仙水',350,'c003');
insert into product values(null,'资生堂粉底液',180,'c003');
 
insert into product values(null,'老北京方便面',56,'c004');
insert into product values(null,'良品铺子海带丝',17,'c004');
insert into product values(null,'三只松鼠坚果',88,null);
# 简单查询
-- 1.查询所有的商品
select * from product;--查询所有列，可以全部列出来，也可以用*代替
-- 2.查询商品名和价格
select pid, price from product;
-- 3.别名查询 as [可省略]
-- 别表名
select * from product as p;
-- 别列名
select pname as'商品名', price as'价格' from product;
-- 4.去掉重复值
select price from product; -- 这样子写的时候显示的价格有很多重复的
select DISTINCT price from product; -- 这样写 重复的价格就没了
-- 5.查询结果是表达式
select pname, price + 10 from product; -- 可以把一个列当作参数进行运算
select pname, price + 10 as new_price from product;
-- 算术运算符查询
select 6 + - * / % 2; -- 没啥意义
  -- 将每件商品的价格加10显示
select price + 10 as new_price from product;
  -- 将每件商品的价格上调10%
select price * 1.1 as new_price from product;
update product set price = price-10;
-- 条件查询（比较运算符、逻辑运算符）
-- 查询商品名称为 海尔洗衣机 的所有信息
select * from product where pname = '海尔洗衣机';
-- 查询价格为800的商品
select * from product where price = 800; 
-- 查询价格不是800的商品
select * from product where price != 800; 
select * from product where price <> 800; 
select * from product where not(price = 800); 
-- 查询价格大于60的所有商品
select * from product where price > 60; 
select * from product where not(price <= 60);
-- 查询价格在200到1000 之间的商品
select * from product where (price >= 200) and (price <=1000);
select * from product where price BETWEEN 200 AND 1000;
-- 查询商品价格是200或800的商品
select * from product where price = 200 or price = 800;
select * from product where price in(200,800);
select * from product where price = 200 || price = 800;
-- 查询含有 裤 字的所有商品
select * from product where pname like '%裤%';
-- 查询以 海 字开头的商品                         -- %匹配多个任意字符
select * from product where pname like '海%';
-- 查询第二个字为 蔻 的商品                       -- _匹配单个任意字符
select * from product where pname like '_蔻%';
-- 查询category_id 为空的商品
-- 不能用category_id = null 因为在MySQL中null不与任何值相等
-- 用is null和is not null
SELECT * FROM product WHERE category_id in('c001',null); -- 用这种方法也查不出null的
select * from product where max(price);
# 排序查询
-- 按照价格降序排列
select * from product order by price desc;
-- 按照价格降序并按照分类降序
select * from product order by price desc, category_id asc;
-- 显示商品的价格（去重），并降序排列
select distinct price from product order by price desc;
# 聚合查询
	--查询商品总条数
select count(pid) as '总条数' from product;
	--查询价格大于两百的商品总条数
select count(price) from product where price > 200;
	-- 查询分类为'c001'的所有商品的总和
select sum(price) from product where category_id = 'c001';
-- 查询商品最大价格
select max(price) from product;
-- 查询分类为'c002'的商品的平均值
select avg(price) from product where category_id = 'c002';
# 分组查询
-- 统计各个分类商品的个数
select category_id, count(*) from product group by category_id;
-- 运行逻辑，将category_id 相同的分成一组，分别统计每组的个数
# 分页查询
-- 1. 查询prouduct表的前五条
select * from product limit 5;
-- 2. 从第四天开始显示，显示5条
select * from product limit 3,5; -- 第一条数据是0
# insert into select 语句
create table table2(
	category_id varchar(20),
	num int
);
insert into table2(category_id, num) select category_id, count(*) from product group by category_id order by count(*) ;

drop table table2;





