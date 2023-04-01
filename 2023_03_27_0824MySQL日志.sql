# 错误日志
show variables like 'log_error%';


# 二进制日志
show variables like 'log_Bin%';

show variables like 'binlog_format';

show binlog events;

show master STATUS;

show binlog events in 'DESKTOP-CSEC6PS-bin.000006';

# 查询日志
show variables like 'general_log%';
set global general_log = 1;
select * from account;

# 慢查询日志
show variables like 'slow_query_log%';















