# 查看SQL执行频率
show SESSION status like 'com_______';
show global status like 'com_______';
show status like'INNODB_rows_%';
# 定位低效率执行SQL - 慢查询日志
-- 查看慢日志配置信息
show variables like '%slow_query_log%';
-- 查看慢日志记录SQL的最低阈值时间
show variables like 'long_query_time%';
select sleep(12);

-- show processlist;
show processlist;


-- show processlist;
show processlist;


# Explain分析执行计划
# 基本使用
-- 1.查询执行计划
explain select * from user where uid = 1;

explain select * from user where uname = '张飞';
# id
-- 1. id相同表示加载表的顺序是从上到下
explain select * from user u, user_role ur, role r where u.uid = ur.uid and ur.rid = r.rid;
-- 2. id不同的id值越大，优先级越高，越先被执行。
explain select * from role where rid = (select rid from user_role where uid = (select uid from user where uname = '张飞'));
-- 3.id有相同有不同
explain select * from role r ,(select * from user_role ur where ur.uid = (select uid from user where uname = '张飞')) t where r.rid = t.rid;

#select_type































