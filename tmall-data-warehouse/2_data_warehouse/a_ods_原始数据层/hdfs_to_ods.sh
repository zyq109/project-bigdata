#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=`date -d "-1 day" +%F`
fi


# ===========================================================================================
#                                 定义变量：各个表数据加载语句
# ===========================================================================================

# 订单信息表
ods_order_info_sql="
load data inpath '/origin_data/${APP}/order_info_inc/${do_date}' OVERWRITE into table ${APP}.ods_order_info_inc partition(dt='${do_date}');"

# 订单明细表
ods_order_detail_sql="
load data inpath '/origin_data/${APP}/order_detail_inc/${do_date}' OVERWRITE into table ${APP}.ods_order_detail_inc partition(dt='${do_date}');"

# 字典表
ods_base_dic_sql="
load data inpath '/origin_data/${APP}/base_dic_full/${do_date}' OVERWRITE into table ${APP}.ods_base_dic_full partition(dt='${do_date}'); "


case $1 in
    "ods_order_info"){
        hive -e "${ods_order_info_sql}"
    };;
    "ods_order_detail"){
        hive -e "${ods_order_detail_sql}"
    };;
    "ods_base_dic"){
        hive -e "${ods_base_dic_sql}"
    };;
    "all"){
        hive -e "${ods_order_info_sql}${ods_order_detail_sql}${ods_base_dic_sql}"
    };;
esac

#step1. 执行权限
# chmod +x hdfs_to_ods.sh
#step2. 前一天数据，加载到某张表
# hdfs_to_ods.sh ods_order_detail
#step3. 某天数据，加载到某张表
# hdfs_to_ods.sh ods_order_detail 2024-01-06
#step4. 某天数据，加载所有表
# hdfs_to_ods.sh all 2024-01-06
#


