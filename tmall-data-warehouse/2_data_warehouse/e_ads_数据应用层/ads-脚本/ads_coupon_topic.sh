#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=`date -d "-1 day" +%F`
fi


# todo 5.1 优惠券使用统计
ads_coupon_stats_sql="
WITH
   -- step1. 聚合统计
    stats AS (
        SELECT '${do_date}'            AS dt
             , coupon_id
             , count(id)               AS used_count
             , count(DISTINCT user_id) AS used_user_count
        FROM ${APP}.dwd_tool_coupon_pay_inc
        WHERE dt = '${do_date}'
        GROUP BY coupon_id
    )
   -- step2. 优惠卷维度表
   , coupon AS (
        SELECT id, coupon_name
        FROM ${APP}.dim_coupon_full
        WHERE dt = '${do_date}'
    )
-- step5. 插入覆盖
INSERT OVERWRITE TABLE ${APP}.ads_coupon_stats
-- step4. 历史统计
SELECT * FROM ${APP}.ads_coupon_stats
UNION
-- step3. 关联维度
SELECT stats.dt
     , stats.coupon_id
     , coupon.coupon_name
     , stats.used_count
     , stats.used_user_count
FROM stats
         LEFT JOIN coupon ON stats.coupon_id = coupon.id
;
"


case $1 in
    "ads_coupon_stats"){
        hive -e "${ads_coupon_stats_sql}"
    };;
    "all"){
        hive -e "${ads_coupon_stats_sql}"
    };;
esac


#
#step1. 执行权限
# chmod u+x ads_coupon_topic.sh
#step2. 前一天数据，加载到某张表
# ads_coupon_topic.sh ads_trade_stats
#step3. 某天数据，加载到某张表
# ads_coupon_topic.sh ads_trade_stats ${do_date}
#step4. 某天数据，加载所有表
# ads_coupon_topic.sh all ${do_date}
#

