

-- =============================================================================
-- todo 4.1 交易综合统计：ads_trade_stats
-- =============================================================================
/*
    统计周期	指标	    说明
    最近1日	订单总额	订单最终金额
    最近1日	订单数	略
    最近1日	订单人数	略

    `dt`                      STRING COMMENT '统计日期',
    `recent_days`             BIGINT COMMENT '最近天数,1:最近1日',
    `order_total_amount`      DECIMAL(16, 2) COMMENT '订单总额,GMV',
    `order_count`             BIGINT COMMENT '订单数',
    `order_user_count`        BIGINT COMMENT '下单人数',
*/
/*
    事实表：dwd_trade_order_detail_inc
*/
-- c. 插入表，采用覆盖
INSERT OVERWRITE TABLE gmall.ads_trade_stats
-- b. 历史统计
SELECT * FROM gmall.ads_trade_stats
UNION
-- a. 聚合统计
SELECT
    '2024-09-11' AS dt
    , 1 AS recent_days
    , SUM(split_total_amount) AS `order_total_amount`
    , COUNT(DISTINCT order_id) AS `order_count`
    , COUNT(DISTINCT user_id) AS `order_user_count`
FROM gmall.dwd_trade_order_detail_inc
WHERE dt = '2024-09-11'
;


-- todo 直接使用DWS层汇总表
-- c. 插入表，采用覆盖
INSERT OVERWRITE TABLE gmall.ads_trade_stats
-- b. 历史统计
SELECT * FROM gmall.ads_trade_stats
UNION
-- a. 聚合统计
SELECT
    '2024-09-13' AS dt
     , 1 AS recent_days
     , SUM(order_total_amount_1d) AS `order_total_amount`
     , SUM(order_count_1d) AS `order_count`
     , COUNT(user_id) AS `order_user_count`
FROM gmall.dws_trade_user_order_1d
WHERE dt = '2024-09-13'
;


-- =============================================================================
-- todo 4.2 各省份交易统计
-- =============================================================================
/*
    统计周期	        统计粒度	指标	    说明
    最近1、7、30日	省份	    订单数	略
    最近1、7、30日	省份	    订单金额	略

    `dt`                 STRING COMMENT '统计日期',
    `recent_days`        BIGINT COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `province_id`        STRING COMMENT '省份ID',
    `province_name`      STRING COMMENT '省份名称',
    `area_code`          STRING COMMENT '地区编码',
    `iso_code`           STRING COMMENT '国际标准地区编码',
    `iso_code_3166_2`    STRING COMMENT '国际标准地区编码',
    `order_count`        BIGINT COMMENT '订单数',
    `order_total_amount` DECIMAL(16, 2) COMMENT '订单金额'
*/
WITH
   -- step1. 最近1日统计，从DWS汇总表
   stats_1d AS (
        SELECT '2024-09-18'               AS `dt`
             , 1                          AS `recent_days`
             , `province_id`
             , `province_name`
             , `area_code`
             , `iso_code`
             , iso_3166_2                 AS `iso_code_3166_2`
             , sum(order_count_1d)        AS `order_count`
             , sum(order_total_amount_1d) AS `order_total_amount`
        FROM gmall.dws_trade_province_order_1d
        WHERE dt = '2024-09-18'
        GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2
    )
   -- step2. 最近7日统计，从DWS汇总表
   , stats_7d AS (
    SELECT '2024-09-18'               AS `dt`
         , 7                          AS `recent_days`
         , `province_id`
         , `province_name`
         , `area_code`
         , `iso_code`
         , iso_3166_2                 AS `iso_code_3166_2`
         , sum(order_count_7d)        AS `order_count`
         , sum(order_total_amount_7d) AS `order_total_amount`
    FROM gmall.dws_trade_province_order_nd
    WHERE dt = '2024-09-18'
    GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2
)
   -- step3. 最近30日统计，从DWS汇总表
   , stats_30d AS (
    SELECT '2024-09-18'                AS `dt`
         , 30                          AS `recent_days`
         , `province_id`
         , `province_name`
         , `area_code`
         , `iso_code`
         , iso_3166_2                  AS `iso_code_3166_2`
         , sum(order_count_30d)        AS `order_count`
         , sum(order_total_amount_30d) AS `order_total_amount`
    FROM gmall.dws_trade_province_order_nd
    WHERE dt = '2024-09-18'
    GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2
)
-- c. 插入表，采用覆盖
INSERT OVERWRITE TABLE gmall.ads_order_by_province
-- b. 历史统计
SELECT * FROM gmall.ads_order_by_province
UNION
-- a. 合并聚合统计
SELECT * FROM stats_1d
UNION ALL
SELECT * FROM stats_7d
UNION ALL
SELECT * FROM stats_30d
;


