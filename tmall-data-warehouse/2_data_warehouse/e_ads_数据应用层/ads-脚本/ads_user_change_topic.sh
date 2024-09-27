#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=`date -d "-1 day" +%F`
fi

#todo 1.用户变动统计
ads_user_change_sql="
-- 不开启自动收集表统计信息
SET hive.stats.autogather=false;
-- 开启MapJoin优化
SET hive.auto.convert.join = true;
SET hive.mapjoin.smalltable.filesize = 25000000 ;
-- 开启关联优化器
SET hive.optimize.correlation = true;
-- 开启SkewJoin优化
SET hive.optimize.skewjoin = true;
SET hive.optimize.skewjoin.compiletime = true;
SET hive.optimize.union.remove = true;
WITH churn_data AS
         (SELECT '${do_date}' AS dt,
                 count(*)     AS user_churn_count
          FROM ${APP}.dws_user_user_login_td
          WHERE dt = '${do_date}'
            AND login_date_last = date_add('${do_date}', -7)),
     back_data AS
         (SELECT '${do_date}' AS dt,
                 count(*)     AS user_back_count
          FROM (SELECT t1.user_id,
                       t1.login_date_last
                FROM (SELECT user_id,
                             login_date_last
                      FROM ${APP}.dws_user_user_login_td
                      WHERE dt = '${do_date}') t1
                         JOIN
                     (SELECT user_id,
                             login_date_last AS login_date_previous
                      FROM ${APP}.dws_user_user_login_td
                      WHERE dt = date_add('${do_date}', -1)) t2 ON t1.user_id = t2.user_id
                WHERE datediff(login_date_last, login_date_previous) >= 8) t)
INSERT
OVERWRITE
TABLE
${APP}.ads_user_change
SELECT *
FROM ${APP}.ads_user_change
UNION
SELECT churn.dt,
       user_churn_count,
       user_back_count
FROM churn_data churn
         JOIN back_data back ON churn.dt = back.dt;
"

#todo 2.2 用户留存率

ads_user_retention_sql="
-- 不开启自动收集表统计信息
SET hive.stats.autogather=false;
-- 开启MapJoin优化
SET hive.auto.convert.join = true;
SET hive.mapjoin.smalltable.filesize = 25000000 ;
-- 开启关联优化器
SET hive.optimize.correlation = true;
-- 开启SkewJoin优化
SET hive.optimize.skewjoin = true;
SET hive.optimize.skewjoin.compiletime = true;
SET hive.optimize.union.remove = true;
WITH tmp_data AS
         (SELECT '${do_date}'                                                                           AS dt,
                 login_date_first                                                                       AS create_date,
                 datediff('${do_date}', login_date_first)                                               AS retention_day,
                 sum(if(login_date_last = '${do_date}', 1, 0))                                          AS retention_count,
                 count(*)                                                                               AS new_user_count,
                 cast(sum(if(login_date_last = '${do_date}', 1, 0)) / count(*) * 100 AS DECIMAL(16, 2)) AS retention_rate
     FROM (SELECT user_id,
                date_id AS login_date_first
         FROM ${APP}.dwd_user_register_inc
         WHERE dt >= date_add('${do_date}', -7)
           AND dt <= '${do_date}') t1
JOIN
(SELECT user_id,
        login_date_last
 FROM ${APP}.dws_user_user_login_td
 WHERE dt = '${do_date}') t2 ON t1.user_id = t2.user_id
          GROUP BY login_date_first)
INSERT
OVERWRITE
TABLE
${APP}.ads_user_retention
SELECT *
FROM ${APP}.ads_user_retention
UNION
SELECT *
FROM tmp_data;
"


# 2.3 用户新增活跃统计
ads_user_action_sql="
WITH
    page_stats AS (
        -- a. 浏览首页和商品详情页人数
        SELECT
            '${do_date}' AS dt
             , recent_days
             -- 浏览首页人数
             , SUM(IF(dt >= date_sub('${do_date}', recent_days - 1) AND page_id = 'home', 1, 0)) AS home_count
             -- 浏览商品详情页人数
             , SUM(IF(dt >= date_sub('${do_date}', recent_days - 1) AND page_id = 'good_detail', 1, 0)) AS good_detail_count
        FROM gmall.dws_traffic_page_visitor_page_view_1d
                 LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
        WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
          AND page_id IS NOT NULL
          AND page_id IN ('home', 'good_detail')
        GROUP BY recent_days
    )
   , cart_stats AS (
        -- b. 加入购物车人数
        SELECT
            '${do_date}' AS dt
             , recent_days
             , count(DISTINCT IF(dt >= date_sub('${do_date}', recent_days - 1), user_id, NULL)) AS cart_count
        FROM gmall.dws_trade_user_order_1d
                 LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
        WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
        GROUP BY recent_days
    )
   , order_stats AS (
        -- c. 下单人数
        SELECT
            '${do_date}' AS dt
             , recent_days
             , count(DISTINCT IF(dt >= date_sub('${do_date}', recent_days - 1), user_id, NULL)) AS order_count
        FROM gmall.dws_trade_user_cart_add_1d
                 LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
        WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
        GROUP BY recent_days
    )
   , payment_stats AS (
        -- d. 支付人数
        SELECT
            '${do_date}' AS dt
             , recent_days
             , count(DISTINCT IF(dt >= date_sub('${do_date}', recent_days - 1), user_id, NULL)) AS payment_count
        FROM gmall.dws_trade_user_payment_1d
                 LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
        WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
        GROUP BY recent_days
    )
-- todo 第5、插入保存
INSERT OVERWRITE TABLE gmall.ads_user_action
-- todo 第4、历史统计
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count
FROM gmall.ads_user_action
UNION
-- e. 合并人数统计
SELECT
    ps.dt
     , ps.recent_days
     , ps.home_count
     , ps.good_detail_count
     , cs.cart_count
     , os.order_count
     , pms.payment_count
FROM page_stats ps
         LEFT JOIN cart_stats cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
         LEFT JOIN order_stats os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
         LEFT JOIN payment_stats pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days
;
"


#todo 2.5 最近7日内连续3日下单用户数
ads_order_continuously_user_count_sql="
WITH
-- step1. 去重：同一天下单多次，或一个订单多个商品
    order_data AS (
        SELECT
            user_id, date_id
        FROM ${APP}.dwd_trade_order_detail_inc
        WHERE dt >= date_sub('${do_date}', 6) AND dt <= '${do_date}'
        GROUP BY user_id, date_id
    )
-- step2. 序号：每条数据加上编号，按照用户id分组，下单日期排序
   , rank_data AS (
    SELECT
        user_id, date_id
         , row_number() over (PARTITION BY user_id ORDER BY date_id) AS rnk
    FROM order_data
)
-- step3. 差值：计算下单日期与序号差值
   , diff_data AS (
    SELECT
        user_id, date_id, rnk
         , date_sub(date_id, rnk) AS date_diff
    FROM rank_data
)
-- step4. 分组：用户和日期差值、计数、过滤：大于等于3
   , continue_data AS (
    SELECT
        user_id, date_diff
         , collect_list(date_id) AS date_list
         , count(user_id) AS continue_days
    FROM diff_data
    GROUP BY user_id, date_diff
)
INSERT OVERWRITE TABLE ${APP}.ads_order_continuously_user_count
SELECT dt, recent_days, order_continuously_user_count FROM ${APP}.ads_order_continuously_user_count
UNION
-- step5. 去重：考虑多次连续下单，比如1,2,3、5,6,7
SELECT
    '${do_date}' AS dt
     , 7 AS recent_days
     , count(DISTINCT user_id) AS order_continuously_user_count
FROM continue_data
WHERE continue_days >= 3
;
"


case $1 in
  "ads_user_change"){
        hive -e "${ads_user_change_sql}"
    };;
"ads_user_retention"){
          hive -e "${ads_user_retention_sql}"
      };;
"ads_user_stats"){
          hive -e "${ads_user_stats_sql}"
      };;
"ads_user_action"){
              hive -e "${ads_user_action_sql}"
          };;
"ads_order_continuously_user_count"){
              hive -e "${ads_order_continuously_user_count_sql}"
         };;

    "all"){
        hive -e "${ads_user_change_sql}${ads_user_retention_sql}
        ${ads_user_stats_sql}${ads_order_continuously_user_count_sql}
        ${ads_user_action_sql}
        "
    };;
esac