#!/bin/bash

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ] ;then
   do_date=$1
else
   do_date=`date -d "-1 day" +%F`
fi

echo "================== 加载日志数据日期为 ${do_date} =================="
# 加载数据SQL语句
load_sql="
LOAD DATA INPATH '/origin_data/gmall/log/${do_date}' OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='${do_date}');"
# 执行SQL语句
/opt/module/hive/bin/hive -e "${load_sql}"


#
# chmod u+x log_hdfs_to_ods.sh
# log_hdfs_to_ods.sh 2024-04-11
#

