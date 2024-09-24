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

# sku商品信息表
ods_sku_info_sql="
load data inpath '/origin_data/${APP}/sku_info_full/${do_date}' OVERWRITE into table ${APP}.ods_sku_info_full partition(dt='${do_date}');"

# 用户信息表
ods_user_info_sql="
load data inpath '/origin_data/${APP}/user_info_inc/${do_date}' OVERWRITE into table ${APP}.ods_user_info_inc partition(dt='${do_date}');"

# 支付信息表
ods_payment_info_sql="
load data inpath '/origin_data/${APP}/payment_info_inc/${do_date}' OVERWRITE into table ${APP}.ods_payment_info_inc partition(dt='${do_date}');"

# 一级品类表
ods_base_category1_sql="
load data inpath '/origin_data/${APP}/base_category1_full/${do_date}' OVERWRITE into table ${APP}.ods_base_category1_full partition(dt='${do_date}');"

# 二级品类表
ods_base_category2_sql="
load data inpath '/origin_data/${APP}/base_category2_full/${do_date}' OVERWRITE into table ${APP}.ods_base_category2_full partition(dt='${do_date}');"

# 三级品类表
ods_base_category3_sql="
load data inpath '/origin_data/${APP}/base_category3_full/${do_date}' OVERWRITE into table ${APP}.ods_base_category3_full partition(dt='${do_date}'); "

# 品牌表
ods_base_trademark_sql="
load data inpath '/origin_data/${APP}/base_trademark_full/${do_date}' OVERWRITE into table ${APP}.ods_base_trademark_full partition(dt='${do_date}'); "

# 活动信息表
ods_activity_info_sql="
load data inpath '/origin_data/${APP}/activity_info_full/${do_date}' OVERWRITE into table ${APP}.ods_activity_info_full partition(dt='${do_date}'); "

# 加购信息表（全量表）
ods_cart_info_sql="
load data inpath '/origin_data/${APP}/cart_info_full/${do_date}' OVERWRITE into table ${APP}.ods_cart_info_full partition(dt='${do_date}');"

# 加购信息表（增量表）
ods_cart_info_inc_sql="
load data inpath '/origin_data/${APP}/cart_info_inc/${do_date}' OVERWRITE into table ${APP}.ods_cart_info_inc partition(dt='${do_date}'); "

# 评论信息表
ods_comment_info_sql="
load data inpath '/origin_data/${APP}/comment_info_inc/${do_date}' OVERWRITE into table ${APP}.ods_comment_info_inc partition(dt='${do_date}'); "

# 优惠卷信息表
ods_coupon_info_sql="
load data inpath '/origin_data/${APP}/coupon_info_full/${do_date}' OVERWRITE into table ${APP}.ods_coupon_info_full partition(dt='${do_date}'); "

# 优惠卷使用表
ods_coupon_use_sql="
load data inpath '/origin_data/${APP}/coupon_use_inc/${do_date}' OVERWRITE into table ${APP}.ods_coupon_use_inc partition(dt='${do_date}'); "

# 收藏信息表
ods_favor_info_sql="
load data inpath '/origin_data/${APP}/favor_info_inc/${do_date}' OVERWRITE into table ${APP}.ods_favor_info_inc partition(dt='${do_date}'); "

# 退单信息表
ods_order_refund_info_sql="
load data inpath '/origin_data/${APP}/order_refund_info_inc/${do_date}' OVERWRITE into table ${APP}.ods_order_refund_info_inc partition(dt='${do_date}'); "

# 订单状态日志表
ods_order_status_log_sql="
load data inpath '/origin_data/${APP}/order_status_log_inc/${do_date}' OVERWRITE into table ${APP}.ods_order_status_log_inc partition(dt='${do_date}'); "

# spu商品信息表
ods_spu_info_sql="
load data inpath '/origin_data/${APP}/spu_info_full/${do_date}' OVERWRITE into table ${APP}.ods_spu_info_full partition(dt='${do_date}'); "

# 活动规则表
ods_activity_rule_sql="
load data inpath '/origin_data/${APP}/activity_rule_full/${do_date}' OVERWRITE into table ${APP}.ods_activity_rule_full partition(dt='${do_date}');"

# 字典表
ods_base_dic_sql="
load data inpath '/origin_data/${APP}/base_dic_full/${do_date}' OVERWRITE into table ${APP}.ods_base_dic_full partition(dt='${do_date}'); "

# 订单明细关联活动表
ods_order_detail_activity_sql="
load data inpath '/origin_data/${APP}/order_detail_activity_inc/${do_date}' OVERWRITE into table ${APP}.ods_order_detail_activity_inc partition(dt='${do_date}'); "

# 订单明细关联优惠卷表
ods_order_detail_coupon_sql="
load data inpath '/origin_data/${APP}/order_detail_coupon_inc/${do_date}' OVERWRITE into table ${APP}.ods_order_detail_coupon_inc partition(dt='${do_date}'); "

# 退款表
ods_refund_payment_sql="
load data inpath '/origin_data/${APP}/refund_payment_inc/${do_date}' OVERWRITE into table ${APP}.ods_refund_payment_inc partition(dt='${do_date}'); "

# sku商品属性表
ods_sku_attr_value_sql="
load data inpath '/origin_data/${APP}/sku_attr_value_full/${do_date}' OVERWRITE into table ${APP}.ods_sku_attr_value_full partition(dt='${do_date}'); "

# sku商品销售属性表
ods_sku_sale_attr_value_sql="
load data inpath '/origin_data/${APP}/sku_sale_attr_value_full/${do_date}' OVERWRITE into table ${APP}.ods_sku_sale_attr_value_full partition(dt='${do_date}'); "

# 省份表
ods_base_province_sql="
load data inpath '/origin_data/${APP}/base_province_full/${do_date}' OVERWRITE into table ${APP}.ods_base_province_full partition(dt='${do_date}');"

# 区域表
ods_base_region_sql="
load data inpath '/origin_data/${APP}/base_region_full/${do_date}' OVERWRITE into table ${APP}.ods_base_region_full partition(dt='${do_date}');"


case $1 in
    "ods_order_info"){
        hive -e "${ods_order_info_sql}"
    };;
    "ods_order_detail"){
        hive -e "${ods_order_detail_sql}"
    };;
    "ods_sku_info"){
        hive -e "${ods_sku_info_sql}"
    };;
    "ods_user_info"){
        hive -e "${ods_user_info_sql}"
    };;
    "ods_payment_info"){
        hive -e "${ods_payment_info_sql}"
    };;
    "ods_base_category1"){
        hive -e "${ods_base_category1_sql}"
    };;
    "ods_base_category2"){
        hive -e "${ods_base_category2_sql}"
    };;
    "ods_base_category3"){
        hive -e "${ods_base_category3_sql}"
    };;
    "ods_base_trademark"){
        hive -e "${ods_base_trademark_sql}"
    };;
    "ods_activity_info"){
        hive -e "${ods_activity_info_sql}"
    };;
    "ods_cart_info"){
        hive -e "${ods_cart_info_sql}"
    };;
    "ods_cart_info_inc"){
        hive -e "${ods_cart_info_inc_sql}"
    };;
    "ods_comment_info"){
        hive -e "${ods_comment_info_sql}"
    };;
    "ods_coupon_info"){
        hive -e "${ods_coupon_info_sql}"
    };;
    "ods_coupon_use"){
        hive -e "${ods_coupon_use_sql}"
    };;
    "ods_favor_info"){
        hive -e "${ods_favor_info_sql}"
    };;
    "ods_order_refund_info"){
        hive -e "${ods_order_refund_info_sql}"
    };;
    "ods_order_status_log"){
        hive -e "${ods_order_status_log_sql}"
    };;
    "ods_spu_info"){
        hive -e "${ods_spu_info_sql}"
    };;
    "ods_activity_rule"){
        hive -e "${ods_activity_rule_sql}"
    };;
    "ods_base_dic"){
        hive -e "${ods_base_dic_sql}"
    };;
    "ods_order_detail_activity"){
        hive -e "${ods_order_detail_activity_sql}"
    };;
    "ods_order_detail_coupon"){
        hive -e "${ods_order_detail_coupon_sql}"
    };;
    "ods_refund_payment"){
        hive -e "${ods_refund_payment_sql}"
    };;
    "ods_sku_attr_value"){
        hive -e "${ods_sku_attr_value_sql}"
    };;
    "ods_sku_sale_attr_value"){
        hive -e "${ods_sku_sale_attr_value_sql}"
    };;
    "ods_base_province"){
        hive -e "${ods_base_province_sql}"
    };;
    "ods_base_region"){
        hive -e "${ods_base_region_sql}"
    };;
    "all"){
        /opt/module/hive/bin/beeline -n bwie -u jdbc:hive2://node101:10000 -e "${ods_order_info_sql}${ods_order_detail_sql}${ods_sku_info_sql}${ods_user_info_sql}${ods_payment_info_sql}${ods_base_category1_sql}${ods_base_category2_sql}${ods_base_category3_sql}${ods_base_trademark_sql}${ods_activity_info_sql}${ods_cart_info_sql}${ods_cart_info_inc_sql}${ods_comment_info_sql}${ods_coupon_info_sql}${ods_coupon_use_sql}${ods_favor_info_sql}${ods_order_refund_info_sql}${ods_order_status_log_sql}${ods_spu_info_sql}${ods_activity_rule_sql}${ods_base_dic_sql}${ods_order_detail_activity_sql}${ods_order_detail_coupon_sql}${ods_refund_payment_sql}${ods_sku_attr_value_sql}${ods_sku_sale_attr_value_sql}${ods_base_province_sql}${ods_base_region_sql}"
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


