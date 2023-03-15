# 子查询
# 查询年龄最大的员工信息，显示信息包含员工号、员工名字，员工年龄
-- 1. 查询最大年龄
select max(age) from emp3
-- 2. 让每一个员工的年龄和最大年龄进行比较，相等则满足条件
select * from emp3 where age = 85;
-- 最终表达式
select * from emp3 where age = (select max(age) from emp3); -- 查询出的单行单列的数据可以当作一个值来使用
# 查询研发部和销售部的员工信息，包含员工号、员工名字
-- 内关联查询
select * from dept3 as a join emp3 as b on a.deptno = b.dept_id and (name = '研发部' or name = '销售部');
-- 子查询
-- 1.先查询研发部和销售部的部门号
select deptno from dept3 where name in('研发部', '销售部');
-- 2.查询哪个员工的部门号是1001或者1002
select dept_id, ename from emp3 where dept_id in('1001', '1002');
-- 最终结果
select dept_id, ename from emp3 where dept_id in(select deptno from dept3 where name in('研发部', '销售部')); -- 多行单列，可以当作多个值来使用
-- 查询研发部20岁-40岁的员工信息，包括员工号、员工名字、部门名字
-- 内关联查询
select dept3.deptno, emp3.ename, dept3.`name` from dept3 inner join emp3 on dept3.deptno = emp3.dept_id and (emp3.age between 20 and 40) and dept3.name = '研发部';
-- 子查询
-- 1. 在部门表中查询研发部信息
select * from dept3 where name = '研发部'; -- 一行多列
-- 2. 在员工表中查询20-40岁的员工信息
select * from emp3 where age between 20 and 40;-- 多行多列
-- 3. 以上两个查询的结果进行关联查询
select a.name, b.ename, b.dept_id from (select * from dept3 where name = '研发部') as a inner join (select * from emp3 where age between 20 and 40) as b on a.deptno = b.dept_id;
# ALL关键字
# 查询年龄大于1003部门所有年龄的员工的信息
select * from emp3 where age > all(select age from emp3 where dept_id = '1003');
# 查询不属于任何部门的员工信息
select * from emp3 where dept_id != all(select deptno from dept3);
# ANY 和 SOME 关键字
# 查询年龄大于1003部门任意一个员工年龄的员工信息
select * from emp3 where age > any(select age from emp3 where dept_id = '1003');
# IN 关键字
# 查询研发部和销售部的员工信息，包含员工号、员工名字
select eid, ename from emp3 where dept_id in (select deptno from dept3 where name in('研发部', '销售部'));
# EXISTS 关键字
# 查询公司是否有大于60岁的员工，有则输出
select * from emp3 a where exists(select * from emp3 where a.age > 60);
/*
IN执行原理：

​   IN在查询的时候，首先查询子查询的表，然后将内表和外表做一个笛卡尔积，然后按照条件进行筛选。

EXISTS执行顺序：
​  1、首先执行一次外部查询，并缓存结果集，如 SELECT * FROM A
​  2、遍历外部查询结果集的每一行记录R，代入子查询中作为条件进行查询，如 SELECT 1 FROM B WHERE B.id = A.id
​  3、如果子查询有返回结果，则EXISTS子句返回TRUE，这一行R可作为外部查询的结果行，否则不能作为结果

IN与EXISTS的区别：
   1、如果查询的两个表大小相当，那么用in和exists差别不大。
   2、如果两个表中一个较小，一个是大表，则子查询表大的用exists，子查询表小的用in。
   3、not in和not exists:如果查询语句使用了not in，那么内外表都进行全表扫描，没有用到索引;而not extsts的子查询依然能用到表上的索引。所以无论那个表大，用not exists都比not in要快。



一种通俗的可以理解为：将外查询表的每一行，代入内查询作为检验，如果内查询返回的结果取非空值，则EXISTS子句返回TRUE，这一行行可作为外查询的结果行，否则不能作为结果。
 
分析器会先看语句的第一个词，当它发现第一个词是SELECT关键字的时候，它会跳到FROM关键字，然后通过FROM关键字找到表名并把表装入内存。接着是找WHERE关键字，如果找不到则返回到SELECT找字段解析，如果找到WHERE，则分析其中的条件，完成后再回到SELECT分析字段。最后形成一张我们要的虚表。
　　WHERE关键字后面的是条件表达式。条件表达式计算完成后，会有一个返回值，即非0或0，非0即为真(true)，0即为假(false)。同理WHERE后面的条件也有一个返回值，真或假，来确定接下来执不执行SELECT。
*/
# 查询有所属部门的员工信息
select * from emp3 a where exists(select * from dept3 b where a.dept_id = b.deptno);

























