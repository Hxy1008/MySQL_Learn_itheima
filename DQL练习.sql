use mydb1_itheima_learn;
create table student(
	id int,
	name varchar(20),
	gender varchar(20),
	chinese int,
	english int,
	math int
);

insert into student values(1, '张明', '男', 89, 78, 90);
insert into student values(2, '李进', '男', 67, 53, 95);
insert into student values(3, '王五', '女', 87, 78, 77);
insert into student values(4, '李一', '女', 88, 98, 92);
insert into student values(5, '李财', '男', 82, 84, 67);
insert into student values(6, '张宝', '男', 55, 85, 45);
insert into student values(7, '黄蓉', '女', 75, 65, 30);
insert into student values(7, '黄蓉', '女', 75, 65, 30);

-- 查询表中所有学生的信息
select * from student;
-- 查询表中所有学生的姓名和对应的英语成绩
select name, english from student;
-- 过滤表中的重复数据
select distinct * from student;
-- 统计每个学生的总分
select distinct name, (chinese+english+math) as '总分' from student;
-- 在所有学生总分上加10分特长分
select distinct name, chinese+english+math+10 as '总分' from student;
-- 查询英语成绩大于90的同学
select distinct name from student where english > 90;
-- 查询总分大于200分的所有同学
select id, name, gender, chinese, english, math, chinese+english+math as '总分' from student where chinese+english+math > 200;
-- 查询英语分数在80-90之间的同学
select name from student where english between 80 and 90;
-- 查询英语分数不在80-90之间的同学
select name from student where english not between 80 and 90;
select name from student where not (english between 80 and 90);
-- 查询数学分数为89,90,91的同学
select * from student where math in(89,90,91);
-- 查询所有姓李的学生的英语成绩
select name, english from student where name like '李%';
-- 查询数学分80且语文80分的同学
select * from student where math = 80 and chinese = 80;
-- 对数学成绩降序然后输出
select * from student order by math desc;
-- 对总分排序后输出，然后再按从高到低的顺序输出
select * from student order by (math+chinese+english) desc;
-- 对姓李的学生成绩排序输出
select * from student where name like '李%' order by (math+chinese+english) desc;
-- 查询男生和女生分别有多少人，并将人数降序排序输出
select distinct gender, count(*) as '人数' from student group by gender order by '人数' desc;




























