

-- a. 浏览首页和商品详情页人数
SELECT
    '2024-09-13' AS dt
     , recent_days
     -- 浏览首页人数
     , SUM(IF(dt >= date_sub('2024-09-13', recent_days - 1) AND page_id = 'home', 1, 0)) AS home_count
     -- 浏览商品详情页人数
     , SUM(IF(dt >= date_sub('2024-09-13', recent_days - 1) AND page_id = 'good_detail', 1, 0)) AS good_detail_count
FROM gmall.dws_traffic_page_visitor_page_view_1d
         LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
WHERE dt >= date_sub('2024-09-13', 29) AND dt <= '2024-09-13'
  AND page_id IS NOT NULL
  AND page_id IN ('home', 'good_detail')
GROUP BY recent_days
;


SELECT split('1,7,30', ',') AS sn;
/*
 ["1","7","30"]
*/

SELECT explode(split('1,7,30', ',')) AS sn;
/*
1
7
30
*/

SELECT
    id, region_name, dt
     , recent_days
FROM gmall.ods_base_region_full
         LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
WHERE dt = '2024-09-11'
;

-- ==================================== 常规写法 ===================================

WITH
   -- todo 第1、最近1日统计
    page_stats_1d AS (
        -- a. 浏览首页和商品详情页人数
        SELECT
            '2024-09-11' AS dt
             , 1 AS recent_days
             -- 浏览首页人数
             , SUM(IF(page_id = 'home', 1, 0)) AS home_count
             -- 浏览商品详情页人数
             , SUM(IF(page_id = 'good_detail', 1, 0)) AS good_detail_count
        FROM gmall.dws_traffic_page_visitor_page_view_1d
        WHERE dt = '2024-09-11'
          AND page_id IS NOT NULL
          AND page_id IN ('home', 'good_detail')
    )
   , cart_stats_1d AS (
    -- b. 加入购物车人数
    SELECT
        '2024-09-11' AS dt
         , 1 AS recent_days
         , count(user_id) AS cart_count
    FROM gmall.dws_trade_user_order_1d
    WHERE dt = '2024-09-11'
)
   , order_stats_1d AS (
    -- c. 下单人数
    SELECT
        '2024-09-11' AS dt
         , 1 AS recent_days
         , count(user_id) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
    WHERE dt = '2024-09-11'
)
   , payment_stats_1d AS (
    -- d. 支付人数
    SELECT
        '2024-09-11' AS dt
         , 1 AS recent_days
         , count(user_id) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
    WHERE dt = '2024-09-11'
)
   , stats_1d AS (
    -- e. 合并人数统计
    SELECT
        ps.dt
         , ps.recent_days
         , ps.home_count
         , ps.good_detail_count
         , cs.cart_count
         , os.order_count
         , pms.payment_count
    FROM page_stats_1d ps
             LEFT JOIN cart_stats_1d cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
             LEFT JOIN order_stats_1d os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
             LEFT JOIN payment_stats_1d pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days
)
   -- todo 第2、最近7日统计
   , page_stats_7d AS (
    -- a. 浏览首页和商品详情页人数
    SELECT
        '2024-09-11' AS dt
         , 7 AS recent_days
         -- 浏览首页人数
         , SUM(IF(page_id = 'home', 1, 0)) AS home_count
         -- 浏览商品详情页人数
         , SUM(IF(page_id = 'good_detail', 1, 0)) AS good_detail_count
    FROM gmall.dws_traffic_page_visitor_page_view_1d
    WHERE dt >= date_sub('2024-09-11', 6) AND dt <= '2024-09-11'
      AND page_id IS NOT NULL
      AND page_id IN ('home', 'good_detail')
)
   , cart_stats_7d AS (
    -- b. 加入购物车人数
    SELECT
        '2024-09-11' AS dt
         , 7 AS recent_days
         , count(user_id) AS cart_count
    FROM gmall.dws_trade_user_order_1d
    WHERE  dt >= date_sub('2024-09-11', 6) AND dt <= '2024-09-11'
)
   , order_stats_7d AS (
    -- c. 下单人数
    SELECT
        '2024-09-11' AS dt
         , 7 AS recent_days
         , count(user_id) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
    WHERE  dt >= date_sub('2024-09-11', 6) AND dt <= '2024-09-11'
)
   , payment_stats_7d AS (
    -- d. 支付人数
    SELECT
        '2024-09-11' AS dt
         , 7 AS recent_days
         , count(user_id) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
    WHERE  dt >= date_sub('2024-09-11', 6) AND dt <= '2024-09-11'
)
   , stats_7d AS (
    -- e. 合并人数统计
    SELECT
        ps.dt
         , ps.recent_days
         , ps.home_count
         , ps.good_detail_count
         , cs.cart_count
         , os.order_count
         , pms.payment_count
    FROM page_stats_7d ps
             LEFT JOIN cart_stats_7d cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
             LEFT JOIN order_stats_7d os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
             LEFT JOIN payment_stats_7d pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days
)
   -- todo 第3、最近30日统计
   , page_stats_30d AS (
    -- a. 浏览首页和商品详情页人数
    SELECT
        '2024-09-11' AS dt
         , 30 AS recent_days
         -- 浏览首页人数
         , SUM(IF(page_id = 'home', 1, 0)) AS home_count
         -- 浏览商品详情页人数
         , SUM(IF(page_id = 'good_detail', 1, 0)) AS good_detail_count
    FROM gmall.dws_traffic_page_visitor_page_view_1d
    WHERE dt >= date_sub('2024-09-11', 29) AND dt <= '2024-09-11'
      AND page_id IS NOT NULL
      AND page_id IN ('home', 'good_detail')
)
   , cart_stats_30d AS (
    -- b. 加入购物车人数
    SELECT
        '2024-09-11' AS dt
         , 30 AS recent_days
         , count(user_id) AS cart_count
    FROM gmall.dws_trade_user_order_1d
    WHERE  dt >= date_sub('2024-09-11', 29) AND dt <= '2024-09-11'
)
   , order_stats_30d AS (
    -- c. 下单人数
    SELECT
        '2024-09-11' AS dt
         , 30 AS recent_days
         , count(user_id) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
    WHERE  dt >= date_sub('2024-09-11', 29) AND dt <= '2024-09-11'
)
   , payment_stats_30d AS (
    -- d. 支付人数
    SELECT
        '2024-09-11' AS dt
         , 30 AS recent_days
         , count(user_id) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
    WHERE  dt >= date_sub('2024-09-11', 29) AND dt <= '2024-09-11'
)
   , stats_30d AS (
    -- e. 合并人数统计
    SELECT
        ps.dt
         , ps.recent_days
         , ps.home_count
         , ps.good_detail_count
         , cs.cart_count
         , os.order_count
         , pms.payment_count
    FROM page_stats_30d ps
             LEFT JOIN cart_stats_30d cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
             LEFT JOIN order_stats_30d os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
             LEFT JOIN payment_stats_30d pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days
)
-- todo 第5、插入保存
INSERT OVERWRITE TABLE gmall.ads_user_action
-- todo 第4、历史统计
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count
FROM gmall.ads_user_action
UNION
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM stats_1d
UNION ALL
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM stats_7d
UNION ALL
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM stats_30d
;


-- ==================================== 最近1日统计 ====================================
WITH
    page_stats_1d AS (
        -- a. 浏览首页和商品详情页人数
        SELECT
            '2024-09-11' AS dt
             , 1 AS recent_days
             -- 浏览首页人数
             , SUM(IF(page_id = 'home', 1, 0)) AS home_count
             -- 浏览商品详情页人数
             , SUM(IF(page_id = 'good_detail', 1, 0)) AS good_detail_count
        FROM gmall.dws_traffic_page_visitor_page_view_1d
        WHERE dt = '2024-09-11'
          AND page_id IS NOT NULL
          AND page_id IN ('home', 'good_detail')
    )
   , cart_stats_1d AS (
    -- b. 加入购物车人数
    SELECT
        '2024-09-11' AS dt
         , 1 AS recent_days
         , count(user_id) AS cart_count
    FROM gmall.dws_trade_user_order_1d
    WHERE dt = '2024-09-11'
)
   , order_stats_1d AS (
    -- c. 下单人数
    SELECT
        '2024-09-11' AS dt
         , 1 AS recent_days
         , count(user_id) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
    WHERE dt = '2024-09-11'
)
   , payment_stats_1d AS (
    -- d. 支付人数
    SELECT
        '2024-09-11' AS dt
         , 1 AS recent_days
         , count(user_id) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
    WHERE dt = '2024-09-11'
)
-- e. 合并人数统计
SELECT
    ps.dt
     , ps.recent_days
     , ps.home_count
     , ps.good_detail_count
     , cs.cart_count
     , os.order_count
     , pms.payment_count
FROM page_stats_1d ps
         LEFT JOIN cart_stats_1d cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
         LEFT JOIN order_stats_1d os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
         LEFT JOIN payment_stats_1d pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days
;
