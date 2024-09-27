#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=`date -d "-1 day" +%F`
fi


# todo 4.1 交易综合统计：ads_trade_stats
ads_trade_stats_sql="
-- c. 插入表，采用覆盖
INSERT OVERWRITE TABLE ${APP}.ads_trade_stats
-- b. 历史统计
SELECT * FROM ${APP}.ads_trade_stats
UNION
-- a. 聚合统计
SELECT
    '${do_date}' AS dt
    , 1 AS recent_days
    , SUM(split_total_amount) AS order_total_amount
    , COUNT(DISTINCT order_id) AS order_count
    , COUNT(DISTINCT user_id) AS order_user_count
FROM ${APP}.dwd_trade_order_detail_inc
WHERE dt = '${do_date}'
;
"


# todo 4.2 各省份交易统计
ads_order_by_province_sql="
WITH
   -- step1. 最近1日统计，从DWS汇总表
   stats_1d AS (
        SELECT '${do_date}'               AS dt
             , 1                          AS recent_days
             , province_id
             , province_name
             , area_code
             , iso_code
             , iso_3166_2                 AS iso_code_3166_2
             , sum(order_count_1d)        AS order_count
             , sum(order_total_amount_1d) AS order_total_amount
        FROM ${APP}.dws_trade_province_order_1d
        WHERE dt = '${do_date}'
        GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2
    )
   -- step2. 最近7日统计，从DWS汇总表
   , stats_7d AS (
      SELECT '${do_date}'               AS dt
           , 7                          AS recent_days
           , province_id
           , province_name
           , area_code
           , iso_code
           , iso_3166_2                 AS iso_code_3166_2
           , sum(order_count_7d)        AS order_count
           , sum(order_total_amount_7d) AS order_total_amount
      FROM ${APP}.dws_trade_province_order_nd
      WHERE dt = '${do_date}'
      GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2
  )
   -- step3. 最近30日统计，从DWS汇总表
   , stats_30d AS (
    SELECT '${do_date}'                AS dt
         , 30                          AS recent_days
         , province_id
         , province_name
         , area_code
         , iso_code
         , iso_3166_2                  AS iso_code_3166_2
         , sum(order_count_30d)        AS order_count
         , sum(order_total_amount_30d) AS order_total_amount
    FROM ${APP}.dws_trade_province_order_nd
    WHERE dt = '${do_date}'
    GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2
)
-- c. 插入表，采用覆盖
INSERT OVERWRITE TABLE ${APP}.ads_order_by_province
-- b. 历史统计
SELECT * FROM ${APP}.ads_order_by_province
UNION
-- a. 合并聚合统计
SELECT * FROM stats_1d
UNION ALL
SELECT * FROM stats_7d
UNION ALL
SELECT * FROM stats_30d
;
"


case $1 in
    "ads_trade_stats"){
        hive -e "${ads_trade_stats_sql}"
    };;
    "ads_order_by_province"){
        hive -e "${ads_order_by_province_sql}"
    };;
    "all"){
        hive -e "${ads_trade_stats_sql}${ads_order_by_province_sql}"
    };;
esac

#step1. 执行权限
# chmod u+x ads_trade_topic.sh
#step2. 前一天数据，加载到某张表
# ads_trade_topic.sh ads_trade_stats
#step3. 某天数据，加载到某张表
# ads_trade_topic.sh ads_trade_stats 2024-09-11
#step4. 某天数据，加载所有表
# ads_trade_topic.sh all 2024-09-11
#
