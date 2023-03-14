# 正则表达式
use mydb1_itheima_learn;
create table product(
	pid int primary key auto_increment comment '商品编号',
	pname varchar(20) not null comment '商品名称',
	price double comment '商品价格',
	category_id varchar(20) comment '商品所属分类'
);

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
-- ^ 在字符串开始处进行匹配
select 'abc' regexp '^a'; -- 判断'abc'是否以a开头
select 'bca' regexp '^a';
select * from product where pname regexp '^海';
-- $ 在字符串末尾开始匹配
select 'abc' regexp 'a$'; -- 判断'abc'是否以a结尾
select 'abc' regexp 'c$';
select * from product where pname regexp '水$';
-- .匹配除\n外任意单个字符
select 'abc' regexp 'a.'; -- 判断a后有无任意字符
select 'abc' regexp 'b.'; -- 判断b后有无任意字符
select 'abc' regexp '.c'; -- 判断c前有无任意字符
select 'abc' regexp 'c.'; -- 判断c后有无任意字符
-- [...] 匹配括号内任意字符
select 'abc' regexp '[xyz]'; -- 判断'abc'中有无出现[x,y,z]中任意一个
select 'abc' regexp '[xaz]';
-- [^...] 注意^符只有在[]内才表示取反，在别的地方都是表示从开始处匹配
select 'a' regexp '[^xyz]';-- 判断'a'中是否不出现[x,y,z]中任意一个 
select 'a' regexp '[^axz]';
select 'a' regexp '[^a]';   -- 返回结果是0，因为出现了a
select 'abc' regexp '[^a]'; -- 返回结果是1，因为是字符串'abc'所以意思好像是'abc'和'a'不是一个字符串
-- a* 匹配0个或多个a，包括空字符串。可以作为占位符使用，没有指定字符都可以匹配到数据
select 'stab' regexp '.ta*b'; -- 1
select 'staxb' regexp '.ta*b'; -- 0
select 'stb' regexp '.ta*b'; -- 1
select 'stxb' regexp '.ta*b'; -- 0
select ''  regexp 'a*'; -- 1
-- a+ 匹配1个或多个a，但是不包括空字符
select 'stab' regexp '.ta+b';
select 'staaab' regexp '.ta+b';
select 'stb' regexp '.ta+b';
select ''  regexp 'a+'; -- 0
-- a? 匹配0个或者1个a
select 'stab' regexp '.ta?b';
select 'stb' regexp '.ta?b';
select 'staaab' regexp '.ta?b'; -- 0
-- a1|a2 匹配a1或者a2
select 'abc' regexp '^a|xyz';
select 'abc' regexp 'c$|xyz';
-- a{m} 匹配m个a
select 'auuuuc' regexp 'au{4}c';
select 'auuuuc' regexp 'au{3}c';
-- a{m,} 匹配m个或者更多a
select 'auuuuc' regexp 'au{3,}c';
-- a{m,n} 匹配m到n个a
select 'auuuuc' regexp 'au{3,5}c';
select 'auuuuc' regexp 'au{5,10}c';




















