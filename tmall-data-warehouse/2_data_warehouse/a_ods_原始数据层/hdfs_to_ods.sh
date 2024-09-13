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
LOAD DATA INPATH '/origin_data/${APP}/order_info_inc/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_order_info_inc PARTITION(dt='${do_date}');"



# 订单明细表
ods_order_detail_sql="
LOAD DATA INPATH '/origin_data/${APP}/order_detail_inc/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_order_detail_inc PARTITION(dt='${do_date}');"



# 字典表  全量
ods_base_dic_sql="
LOAD DATA INPATH '/origin_data/${APP}/base_dic_full/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_base_dic_full PARTITION(dt='${do_date}'); "


# activity_rule
ods_activity_rule_sql="
LOAD DATA INPATH '/origin_data/${APP}/activity_rule_inc/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_activity_rule_inc PARTITION(dt='${do_date}');"

ods_base_province_sql="
LOAD DATA INPATH '/origin_data/${APP}/base_province_inc/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_base_province_inc PARTITION(dt='${do_date}');"

ods_base_region_sql="
LOAD DATA INPATH '/origin_data/${APP}/base_region_inc/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_base_region_inc PARTITION(dt='${do_date}');"


# order_refund_info  全量
ods_order_refund_info_sql="
LOAD DATA INPATH '/origin_data/${APP}/order_refund_info_full/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_order_refund_info_full PARTITION(dt='${do_date}'); "

# refund_payment  全量
ods_refund_payment_sql="
LOAD DATA INPATH '/origin_data/${APP}/refund_payment_full/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_refund_payment_full PARTITION(dt='${do_date}'); "

# cart_info  全量
ods_cart_info_sql="
LOAD DATA INPATH '/origin_data/${APP}/cart_info_full/${do_date}'
  OVERWRITE INTO TABLE ${APP}.ods_cart_info_full PARTITION(dt='${do_date}'); "

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

        "ods_activity_rule"){
            hive -e "${ods_activity_rule_sql}"
    };;
        "ods_base_province"){
            hive -e "${ods_base_province_sql}"
    };;
        "ods_base_region"){
            hive -e "${ods_base_region_sql}"

    };;
        "ods_order_refund_info"){
            hive -e "${ods_order_refund_info_sql}"
    };;
        "ods_refund_payment"){
            hive -e "${ods_refund_payment_sql}"
    };;
        "ods_cart_info"){
            hive -e "${ods_cart_info_sql}"
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


