#!/bin/bash

# 定义变量方便修改
APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ] ;then
   do_date=$1
else
   do_date=`date -d "-1 day" +%F`
fi

echo ================== 日志日期为 $do_date ==================
sql="
LOAD DATA INPATH '/origin_data/${APP}/log/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_log_inc PARTITION(dt='${do_date}');
"

hive -e "$sql"


