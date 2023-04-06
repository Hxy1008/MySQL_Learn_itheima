# 子查询优化
explain select * from user where uid in (select uid from user_role);
explain select * from user u, user_role ur where u.uid = ur.uid;

# limit优化

show variables like 'local_infile';
set global local_infile=1;
load data local infile 'D:\\BaiduNetdiskDownload\\sql_code\\sql1.log' into table `tb_user` fields TERMINATED by ',' lines TERMINATED by '\n';

1.在索引上完成排序分页操作，最后根据主键关联回原表查询所需要的其它内容
select * from tb_user limit 900000,10; -- 2.908s


select id from tb_user order by id limit 900000, 10; 
select * from tb_user a, (select id from tb_user order by id limit 900000, 10) b where a.id = b.id;
-- 1.357s

2. 该方案适用于主键自增的表，可以把limit查询转换成某个位置的查询
select * from tb_user where id > 900000 limit 10;  -- 0.108s