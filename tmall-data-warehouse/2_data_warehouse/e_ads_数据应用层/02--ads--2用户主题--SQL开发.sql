

-- =============================================================================
-- todo 2.1 用户变动统计
-- =============================================================================
/*
    统计周期	指标	说明
    最近1日	流失用户数	之前活跃过的用户，最近一段时间未活跃，就称为流失用户。
                        此处要求统计7日前（只包含7日前当天）活跃，但最近7日未活跃的用户总数。
                        todo last_login_date = date_sub('2024-03-24', 7)

    最近1日	回流用户数	之前的活跃用户，一段时间未活跃（流失），今日又活跃了，就称为回流用户。
                        此处要求统计回流用户总数。
                        todo last_login_date = '2024-03-24'
                             AND
                             yesterday_last_login_date < date_sub('2024-03-23', 7)

    `dt`               STRING COMMENT '统计日期',
    `user_churn_count` BIGINT COMMENT '流失用户数',
    `user_back_count`  BIGINT COMMENT '回流用户数'
*/




-- =============================================================================
-- todo 2.2 用户留存率
-- =============================================================================
/*
新增留存率具体是指留存用户数与新增用户数的比值，
    例如2020-06-14新增100个用户，1日之后（2020-06-15）这100人中有80个人活跃了，
        那2020-06-14的1日留存数则为80，2020-06-14的1日留存率则为80%。

新增留存分析：每天新增用户中，有多少用户继续活跃。
			新增用户数  2024-04-02	2024-04-03	2024-04-04	2024-04-05	2024-04-06	2024-04-07	2024-04-08
2024-04-01	  100	   1日$30#30%	2日$20#20%  3日$15#15%	4日$10#10%	5日$9#9%		6日$7#7%		7日$4#4%

2024-04-02	  80					1日$20#25%	2日$10#12.5% 3日$8#10%  3日$4#5%

2024-04-03	  200								1日$20#10%	 2日$10#5%
*/






-- =============================================================================
-- todo 2.3 用户新增活跃统计
-- =============================================================================
/*
    统计周期	        指标	        指标说明
    最近1、7、30日	新增用户数	略

    最近1、7、30日	活跃用户数	略
*/



-- =============================================================================
-- todo 2.4 用户行为漏斗分析
-- =============================================================================
/*
    该需求要求统计一个完整的购物流程各个阶段的人数，具体说明如下：
    统计周期	        指标	            说明
    最近1、7、30日	首页浏览人数	    略
    最近1、7、30日	商品详情页浏览人数	略
    最近1、7、30日	加购人数	        略
    最近1、7、30日	下单人数	        略
    最近1、7、30日	支付人数	        支付成功人数

    `dt`                STRING COMMENT '统计日期',
    `recent_days`       BIGINT COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `home_count`        BIGINT COMMENT '浏览首页人数',
    `good_detail_count` BIGINT COMMENT '浏览商品详情页人数',
    `cart_count`        BIGINT COMMENT '加入购物车人数',
    `order_count`       BIGINT COMMENT '下单人数',
    `payment_count`     BIGINT COMMENT '支付人数'
*/
/*
    事实表：
        dwd_traffic_page_view_inc
        dwd_trade_cart_add_inc
        dwd_trade_order_detail_inc
        dwd_trade_pay_detail_suc_inc
    由于DWS层，对上述事实表，按照用户粒度汇总，直接获取数据，进一步分析
 */

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



-- =============================================================================
-- todo 2.5 最近7日内连续3日下单用户数
-- =============================================================================
/*
    `dt`                            STRING COMMENT '统计日期',
    `recent_days`                   BIGINT COMMENT '最近天数,7:最近7天',
    `order_continuously_user_count` BIGINT COMMENT '连续3日下单用户数
*/
/*
    连续问题：
        连续登录、连续下单、连续打卡、连续签到类似
    todo 思路
        连续日期 - 序号（按照用户分组，日期排序） = 日期差值 ， 此时连续几天，差值相同

    step1. 去重
    step2. 序号
    step3. 差值
    step4. 分组、计数
    step5. 过滤、去重
*/
WITH
    tmp1 AS (
        -- step1. 去重
        SELECT
            user_id, date_id
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt >= date_sub('2024-09-18', 6) AND dt <= '2024-09-18'
        GROUP BY user_id, date_id
    )
    , tmp2 AS (
        -- step2. 序号
        SELECT
            user_id
             , date_id
             , row_number() over (PARTITION BY user_id ORDER BY date_id) AS rk
        FROM tmp1
    )
    , tmp3 AS (
        -- step3. 差值
        SELECT
            user_id, date_id, rk
             , date_sub(date_id, rk) AS date_diff
        FROM tmp2
    )
    , tmp4 AS (
        -- step4. 分组、计数
        SELECT
            user_id
             , date_diff
             , count(*) AS days
             , collect_list(date_id) AS date_list
        FROM tmp3
        GROUP BY user_id, date_diff
    )
-- 保存数据
INSERT OVERWRITE TABLE gmall.ads_order_continuously_user_count
-- 历史统计
SELECT dt, recent_days, order_continuously_user_count FROM gmall.ads_order_continuously_user_count
UNION
-- step5. 过滤、去重
SELECT
    '2024-09-18' AS dt
    , 7 AS recent_days
    , count(DISTINCT user_id) AS order_continously_user_count
FROM tmp4
WHERE days >= 3
;





















WITH
-- step1. 去重：同一天下单多次，或一个订单多个商品
    order_data AS (
        SELECT
            user_id, date_id
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt >= date_sub('2024-09-18', 6) AND dt <= '2024-09-18'
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
INSERT OVERWRITE TABLE gmall.ads_order_continuously_user_count
SELECT dt, recent_days, order_continuously_user_count FROM gmall.ads_order_continuously_user_count
UNION
-- step5. 去重：考虑多次连续下单，比如1,2,3、5,6,7
SELECT
    '2024-09-18' AS dt
     , 7 AS recent_days
     , count(DISTINCT user_id) AS order_continuously_user_count
FROM continue_data
WHERE continue_days >= 3
;

