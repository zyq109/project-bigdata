#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=`date -d "-1 day" +%F`
fi

# todo 3.1 最近7/30日各品牌复购率
ads_repeat_purchase_by_tm_sql="
WITH
    -- todo 第1、最近7日统计
    tm_7d AS (
        -- step1. 计算每个品牌中每个用户的购买次数
        SELECT
            tm_id, tm_name, user_id
             , sum(order_count_7d) AS order_count
        FROM ${APP}.dws_trade_user_sku_order_nd
        WHERE dt = '${do_date}'
        GROUP BY tm_id, tm_name, user_id
    )
    , stats_7d AS (
        -- step2. 计算复购率
        SELECT
            '${do_date}' AS dt
             , 7 AS recent_days
             , tm_id, tm_name
             -- 计算购买人数
             , count(user_id) AS user_count
             -- 计算复购人数：购买次数大于1的人数
             , sum(if(order_count > 1, 1, 0)) AS repeat_user_count
             -- 计算复购率 = 复购人数 / 购买人数
             , round(sum(if(order_count > 1, 1, 0)) / count(user_id), 4) AS order_repeat_rate
        FROM tm_7d
        GROUP BY tm_id, tm_name
    )
    -- todo 第2、最近30日统计
    ,tm_30d AS (
        -- step1. 计算每个品牌中每个用户的购买次数
        SELECT
            tm_id, tm_name, user_id
             , sum(order_count_30d) AS order_count
        FROM ${APP}.dws_trade_user_sku_order_nd
        WHERE dt = '${do_date}'
        GROUP BY tm_id, tm_name, user_id
    )
   , stats_30d AS (
        -- step2. 计算复购率
        SELECT
            '${do_date}' AS dt
             , 30 AS recent_days
             , tm_id, tm_name
             -- 计算购买人数
             , count(user_id) AS user_count
             -- 计算复购人数：购买次数大于1的人数
             , sum(if(order_count > 1, 1, 0)) AS repeat_user_count
             -- 计算复购率 = 复购人数 / 购买人数
             , round(sum(if(order_count > 1, 1, 0)) / count(user_id), 4) AS order_repeat_rate
        FROM tm_30d
        GROUP BY tm_id, tm_name
    )
-- todo 第4、保存数据
INSERT OVERWRITE TABLE ${APP}.ads_repeat_purchase_by_tm
-- todo 第3、历史统计
SELECT dt, recent_days, tm_id, tm_name, order_repeat_rate FROM ${APP}.ads_repeat_purchase_by_tm
UNION
SELECT dt, recent_days, tm_id, tm_name, order_repeat_rate FROM stats_7d
UNION ALL
SELECT dt, recent_days, tm_id, tm_name, order_repeat_rate FROM stats_30d
;
"



#todo 3.2 各品牌商品下单统计
ads_order_stats_by_tm_sql="
WITH
    stats_1d AS (
        -- step1. 最近1日统计
        SELECT
            '${do_date}' AS dt
             , 1 AS recent_days
             , tm_id
             , tm_name
             , sum(order_count_1d) AS order_count
             , count(DISTINCT user_id) AS order_user_count
        FROM ${APP}.dws_trade_user_sku_order_1d
        WHERE dt = '${do_date}'
        GROUP BY tm_id, tm_name
    )
   , stats_7d AS (
    -- step2, 最近7日统计
    SELECT
        '${do_date}' AS dt
         , 7 AS recent_days
         , tm_id
         , tm_name
         , sum(order_count_7d) AS order_count
         , count(DISTINCT user_id) AS order_user_count
    FROM ${APP}.dws_trade_user_sku_order_nd
    WHERE dt = '${do_date}'
    GROUP BY tm_id, tm_name
)
   , stats_30d AS (
    -- step3, 最近30日统计
    SELECT
        '${do_date}' AS dt
         , 30 AS recent_days
         , tm_id
         , tm_name
         , sum(order_count_30d) AS order_count
         , count(DISTINCT user_id) AS order_user_count
    FROM ${APP}.dws_trade_user_sku_order_nd
    WHERE dt = '${do_date}'
    GROUP BY tm_id, tm_name
)
-- step6. 插入保存
INSERT OVERWRITE TABLE ${APP}.ads_order_stats_by_tm
-- step5. 历史统计
SELECT * FROM ${APP}.ads_order_stats_by_tm
UNION
-- step4. 合并数据
SELECT * FROM stats_1d
UNION ALL
SELECT * FROM stats_7d
UNION ALL
SELECT * FROM stats_30d
;"

#todo 3.3 各品类商品下单统计
ads_order_stats_by_cate_sql="
WITH
   -- step1. 最近1日统计
    stats_1d AS (
        SELECT '${do_date}'            AS dt
             , 1                       AS recent_days
             , category1_id
             , category1_name
             , category2_id
             , category2_name
             , category3_id
             , category3_name
             , sum(order_count_1d)     AS order_count
             , count(DISTINCT user_id) AS order_user_count
        FROM ${APP}.dws_trade_user_sku_order_1d
        WHERE dt = '${do_date}'
        GROUP BY category1_id, category1_name,
                 category2_id, category2_name,
                 category3_id, category3_name
    )
   -- step2, 最近7日统计
   , stats_7d AS (
    SELECT '${do_date}'            AS dt
         , 7                       AS recent_days
         , category1_id
         , category1_name
         , category2_id
         , category2_name
         , category3_id
         , category3_name
         , sum(order_count_7d)     AS order_count
         , count(DISTINCT user_id) AS order_user_count
    FROM ${APP}.dws_trade_user_sku_order_nd
    WHERE dt = '${do_date}'
    GROUP BY category1_id, category1_name,
             category2_id, category2_name,
             category3_id, category3_name
)
   -- step3, 最近30日统计
   , stats_30d AS (
    SELECT '${do_date}'            AS dt
         , 30                      AS recent_days
         , category1_id
         , category1_name
         , category2_id
         , category2_name
         , category3_id
         , category3_name
         , sum(order_count_30d)    AS order_count
         , count(DISTINCT user_id) AS order_user_count
    FROM ${APP}.dws_trade_user_sku_order_nd
    WHERE dt = '${do_date}'
    GROUP BY category1_id, category1_name,
             category2_id, category2_name,
             category3_id, category3_name
)
-- step6. 插入保存
INSERT OVERWRITE TABLE ${APP}.ads_order_stats_by_cate
-- step5. 历史统计
SELECT * FROM ${APP}.ads_order_stats_by_cate
UNION
-- step4. 合并数据
SELECT * FROM stats_1d
UNION ALL
SELECT * FROM stats_7d
UNION ALL
SELECT * FROM stats_30d
;"

#3.4 各分类商品购物车存量Top3

ads_sku_cart_num_top3_by_cate_sql="
WITH
   -- step1. 商品聚合统计
    stats AS (
        SELECT
            '${do_date}' AS dt
             , sku_id
             , sku_name
             , sum(sku_num) AS cart_num
        FROM ${APP}.dwd_trade_cart_full
        WHERE dt = '${do_date}'
        GROUP BY sku_id, sku_name
    )
   -- step2. 维度表数据
   , sku AS (
    SELECT
        id
         , category3_id, category3_name
         , category2_id, category2_name
         , category1_id, category1_name
    FROM ${APP}.dim_sku_full
    WHERE dt = '${do_date}'
)
   -- step3. 关联维度
   , join_data AS (
    SELECT
        dt
         , category1_id, category1_name
         , category2_id, category2_name
         , category3_id, category3_name
         , sku_id
         , sku_name
         , cart_num
         , row_number() OVER (
        PARTITION BY category1_id, category1_name , category2_id, category2_name, category3_id, category3_name
        ORDER BY cart_num DESC
        ) AS rk
    FROM stats
             LEFT JOIN sku ON stats.sku_id = sku.id
)
-- step6. 保存数据
INSERT OVERWRITE TABLE ${APP}.ads_sku_cart_num_top3_by_cate
-- step5. 历史统计
SELECT * FROM ${APP}.ads_sku_cart_num_top3_by_cate
UNION
-- step4. 获取Top3
SELECT
    dt, category1_id, category1_name, category2_id, category2_name, category3_id, category3_name
     , sku_id, sku_name, cart_num, rk
FROM join_data
WHERE rk <= 3
;"

#3.5 各品牌商品收藏次数Top3

ads_sku_favor_count_top3_by_tm_sql="
WITH
   -- step1. 商品聚合统计
    stats AS (
        SELECT
            '${do_date}' AS dt
             , sku_id
             , count(id) AS favor_count
        FROM ${APP}.dwd_interaction_favor_add_inc
        WHERE dt = '${do_date}'
        GROUP BY sku_id
    )
   -- step2. 维度数据
   , sku AS (
    SELECT
        id, sku_name, tm_id, tm_name
    FROM ${APP}.dim_sku_full
    WHERE dt = '${do_date}'
)
   -- step3. 关联维度
   , join_data AS (
    SELECT
        dt
         , tm_id, tm_name
         , sku_id, sku_name
         , favor_count
         , row_number() over (
        PARTITION BY tm_id, tm_name ORDER BY favor_count DESC
        ) AS rk
    FROM stats
             LEFT JOIN sku ON stats.sku_id = sku.id
)
-- step6. 保存数据
INSERT OVERWRITE TABLE ${APP}.ads_sku_favor_count_top3_by_tm
-- step5. 历史统计
SELECT * FROM ${APP}.ads_sku_favor_count_top3_by_tm
UNION
-- step4. 获取TopKey
SELECT
    dt, tm_id, tm_name, sku_id, sku_name, favor_count, rk
FROM join_data
WHERE rk <= 3
;

"

case $1 in
"ads_order_stats_by_tm"){
        hive -e "${ads_order_stats_by_tm_sql}"
    };;
"ads_order_stats_by_cate"){
          hive -e "${ads_order_stats_by_cate_sql}"
      };;
"ads_sku_cart_num_top3_by_cate"){
              hive -e "${ads_sku_cart_num_top3_by_cate_sql}"
          };;
"ads_repeat_purchase_by_tm"){
              hive -e "${ads_repeat_purchase_by_tm_sql}"
          };;
"ads_sku_favor_count_top3_by_tm"){
              hive -e "${ads_sku_favor_count_top3_by_tm_sql}"
          };;
"all"){
        hive -e "${ads_order_stats_by_tm_sql}${ads_order_stats_by_cate_sql}
        ${ads_sku_cart_num_top3_by_cate_sql}${ads_repeat_purchase_by_tm_sql}${ads_sku_favor_count_top3_by_tm_sql}"
    };;
esac


#
#step1. 执行权限
# chmod u+x ads_coupon_topic.sh
#step2. 前一天数据，加载到某张表
# ads_coupon_topic.sh ads_trade_stats
#step3. 某天数据，加载到某张表
# ads_coupon_topic.sh ads_trade_stats ${${do_date}}
#step4. 某天数据，加载所有表
# ads_coupon_topic.sh all ${${do_date}}
#

