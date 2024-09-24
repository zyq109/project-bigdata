
-- =============================================================================
-- todo 3.1 最近7/30日各品牌复购率
-- =============================================================================
/*
    统计周期	    统计粒度	指标	    说明
    最近7、30日	品牌	    复购率	重复购买人数占购买人数比例

    `dt`                STRING COMMENT '统计日期',
    `recent_days`       BIGINT COMMENT '最近天数,7:最近7天,30:最近30天',
    `tm_id`             STRING COMMENT '品牌ID',
    `tm_name`           STRING COMMENT '品牌名称',
    `order_repeat_rate` DECIMAL(16, 2) COMMENT '复购率'
*/

WITH
    -- todo 第1、最近7日统计
    tm_7d AS (
        -- step1. 计算每个品牌中每个用户的购买次数
        SELECT
            tm_id, tm_name, user_id
             , sum(order_count_7d) AS order_count
        FROM gmall.dws_trade_user_sku_order_nd
        WHERE dt = '2024-09-11'
        GROUP BY tm_id, tm_name, user_id
    )
    , stats_7d AS (
        -- step2. 计算复购率
        SELECT
            '2024-09-11' AS dt
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
        FROM gmall.dws_trade_user_sku_order_nd
        WHERE dt = '2024-09-11'
        GROUP BY tm_id, tm_name, user_id
    )
   , stats_30d AS (
        -- step2. 计算复购率
        SELECT
            '2024-09-11' AS dt
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
INSERT OVERWRITE TABLE gmall.ads_repeat_purchase_by_tm
-- todo 第3、历史统计
SELECT dt, recent_days, tm_id, tm_name, order_repeat_rate FROM gmall.ads_repeat_purchase_by_tm
UNION
SELECT dt, recent_days, tm_id, tm_name, order_repeat_rate FROM stats_7d
UNION ALL
SELECT dt, recent_days, tm_id, tm_name, order_repeat_rate FROM stats_30d
;


-- =============================================== 最近7日统计 ===============================================
WITH
    tm_7d AS (
        -- step1. 计算每个品牌中每个用户的购买次数
        SELECT
            tm_id, tm_name, user_id
             , sum(order_count_7d) AS order_count
        FROM gmall.dws_trade_user_sku_order_nd
        WHERE dt = '2024-09-11'
        GROUP BY tm_id, tm_name, user_id
    )
    -- step2. 计算复购率
    SELECT
        '2024-09-11' AS dt
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
;


-- =============================================================================
-- todo 3.2 各品牌商品下单统计
-- =============================================================================
/*
    统计周期	        统计粒度	指标	    说明
    最近1、7、30日	品牌	    订单数	略
    最近1、7、30日	品牌	    订单人数	略

    `dt`                      STRING COMMENT '统计日期',
    , `recent_days`             BIGINT COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    , `tm_id`                   STRING COMMENT '品牌ID',
    , `tm_name`                 STRING COMMENT '品牌名称',
    , `order_count`             BIGINT COMMENT '下单数',
    , `order_user_count`        BIGINT COMMENT '下单人数'
*/
/*
    事实表：
        dwd_trade_order_detail_inc
    维度表：
        dim_sku_full
*/
WITH
    stats_1d AS (
        -- step1. 最近1日统计
        SELECT
            '2024-09-18' AS `dt`
             , 1 AS `recent_days`
             , `tm_id`
             , `tm_name`
             , sum(order_count_1d) AS `order_count`
             , count(DISTINCT user_id) AS `order_user_count`
        FROM gmall.dws_trade_user_sku_order_1d
        WHERE dt = '2024-09-18'
        GROUP BY tm_id, tm_name
    )
    , stats_7d AS (
        -- step2, 最近7日统计
        SELECT
            '2024-09-18' AS `dt`
             , 7 AS `recent_days`
             , `tm_id`
             , `tm_name`
             , sum(order_count_7d) AS `order_count`
             , count(DISTINCT user_id) AS `order_user_count`
        FROM gmall.dws_trade_user_sku_order_nd
        WHERE dt = '2024-09-18'
        GROUP BY tm_id, tm_name
    )
   , stats_30d AS (
        -- step3, 最近30日统计
        SELECT
            '2024-09-18' AS `dt`
             , 30 AS `recent_days`
             , `tm_id`
             , `tm_name`
             , sum(order_count_30d) AS `order_count`
             , count(DISTINCT user_id) AS `order_user_count`
        FROM gmall.dws_trade_user_sku_order_nd
        WHERE dt = '2024-09-18'
        GROUP BY tm_id, tm_name
    )
-- step6. 插入保存
INSERT OVERWRITE TABLE gmall.ads_order_stats_by_tm
-- step5. 历史统计
SELECT * FROM gmall.ads_order_stats_by_tm
UNION
-- step4. 合并数据
SELECT * FROM stats_1d
UNION ALL
SELECT * FROM stats_7d
UNION ALL
SELECT * FROM stats_30d
;


-- =============================================================================
-- todo 3.3 各品类商品下单统计
-- =============================================================================
/*
    统计周期	        统计粒度	指标	    说明
    最近1、7、30日	品类	    下单数	略
    最近1、7、30日	品类	    下单人数	略

    `dt`                      STRING COMMENT '统计日期',
    , `recent_days`             BIGINT COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    , `category1_id`            STRING COMMENT '一级品类ID',
    , `category1_name`          STRING COMMENT '一级品类名称',
    , `category2_id`            STRING COMMENT '二级品类ID',
    , `category2_name`          STRING COMMENT '二级品类名称',
    , `category3_id`            STRING COMMENT '三级品类ID',
    , `category3_name`          STRING COMMENT '三级品类名称',
    , `order_count`             BIGINT COMMENT '下单数',
    , `order_user_count`        BIGINT COMMENT '下单人数'
*/

WITH
   -- step1. 最近1日统计
    stats_1d AS (
        SELECT '2024-09-18'            AS `dt`
             , 1                       AS `recent_days`
             , `category1_id`
             , `category1_name`
             , `category2_id`
             , `category2_name`
             , `category3_id`
             , `category3_name`
             , sum(order_count_1d)     AS `order_count`
             , count(DISTINCT user_id) AS `order_user_count`
        FROM gmall.dws_trade_user_sku_order_1d
        WHERE dt = '2024-09-18'
        GROUP BY category1_id, category1_name,
                 category2_id, category2_name,
                 category3_id, category3_name
    )
   -- step2, 最近7日统计
   , stats_7d AS (
    SELECT '2024-09-18'            AS `dt`
         , 7                       AS `recent_days`
         , `category1_id`
         , `category1_name`
         , `category2_id`
         , `category2_name`
         , `category3_id`
         , `category3_name`
         , sum(order_count_7d)     AS `order_count`
         , count(DISTINCT user_id) AS `order_user_count`
    FROM gmall.dws_trade_user_sku_order_nd
    WHERE dt = '2024-09-18'
    GROUP BY category1_id, category1_name,
             category2_id, category2_name,
             category3_id, category3_name
)
   -- step3, 最近30日统计
   , stats_30d AS (
    SELECT '2024-09-18'            AS `dt`
         , 30                      AS `recent_days`
         , `category1_id`
         , `category1_name`
         , `category2_id`
         , `category2_name`
         , `category3_id`
         , `category3_name`
         , sum(order_count_30d)    AS `order_count`
         , count(DISTINCT user_id) AS `order_user_count`
    FROM gmall.dws_trade_user_sku_order_nd
    WHERE dt = '2024-09-18'
    GROUP BY category1_id, category1_name,
             category2_id, category2_name,
             category3_id, category3_name
)
-- step6. 插入保存
INSERT OVERWRITE TABLE gmall.ads_order_stats_by_cate
-- step5. 历史统计
SELECT * FROM gmall.ads_order_stats_by_cate
UNION
-- step4. 合并数据
SELECT * FROM stats_1d
UNION ALL
SELECT * FROM stats_7d
UNION ALL
SELECT * FROM stats_30d
;


-- =============================================================================
-- todo 3.4 各品类商品-购物车存量Top3
-- =============================================================================
/*
    `dt`             STRING COMMENT '统计日期',
    `category1_id`   STRING COMMENT '一级品类ID',
    `category1_name` STRING COMMENT '一级品类名称',
    `category2_id`   STRING COMMENT '二级品类ID',
    `category2_name` STRING COMMENT '二级品类名称',
    `category3_id`   STRING COMMENT '三级品类ID',
    `category3_name` STRING COMMENT '三级品类名称',
    `sku_id`         STRING COMMENT 'SKU_ID',
    `sku_name`       STRING COMMENT 'SKU名称',
    `cart_num`       BIGINT COMMENT '购物车中商品数量',
    `rk`             BIGINT COMMENT '排名'
*/
/*
    事实表：
        dwd_trade_cart_full
    维度表：
        dim_sku_full
*/
WITH
    -- step1. 商品聚合统计
    stats AS (
        SELECT
            '2024-09-11' AS dt
            , sku_id
             , sku_name
             , sum(sku_num) AS cart_num
        FROM gmall.dwd_trade_cart_full
        WHERE dt = '2024-09-11'
        GROUP BY sku_id, sku_name
    )
    -- step2. 维度表数据
    , sku AS (
        SELECT
            id
             , category3_id, category3_name
             , category2_id, category2_name
             , category1_id, category1_name
        FROM gmall.dim_sku_full
        WHERE dt = '2024-09-11'
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
INSERT OVERWRITE TABLE gmall.ads_sku_cart_num_top3_by_cate
-- step5. 历史统计
SELECT * FROM gmall.ads_sku_cart_num_top3_by_cate
UNION
-- step4. 获取Top3
SELECT
    dt, category1_id, category1_name, category2_id, category2_name, category3_id, category3_name
     , sku_id, sku_name, cart_num, rk
FROM join_data
WHERE rk <= 3
;


-- ==========================================================================
-- todo 3.5 各品牌商品-收藏次数Top3
-- =============================================================================
/*
    `dt`          STRING COMMENT '统计日期',
    `tm_id`       STRING COMMENT '品牌ID',
    `tm_name`     STRING COMMENT '品牌名称',
    `sku_id`      STRING COMMENT 'SKU_ID',
    `sku_name`    STRING COMMENT 'SKU名称',
    `favor_count` BIGINT COMMENT '被收藏次数',
    `rk`          BIGINT COMMENT '排名'
*/
WITH
    -- step1. 商品聚合统计
    stats AS (
        SELECT
            '2024-09-11' AS dt
             , sku_id
             , count(id) AS favor_count
        FROM gmall.dwd_interaction_favor_add_inc
        WHERE dt = '2024-09-11'
        GROUP BY sku_id
    )
    -- step2. 维度数据
    , sku AS (
        SELECT
            id, sku_name, tm_id, tm_name
        FROM gmall.dim_sku_full
        WHERE dt = '2024-09-11'
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
INSERT OVERWRITE TABLE gmall.ads_sku_favor_count_top3_by_tm
-- step5. 历史统计
SELECT * FROM gmall.ads_sku_favor_count_top3_by_tm
UNION
-- step4. 获取TopKey
SELECT
    dt, tm_id, tm_name, sku_id, sku_name, favor_count, rk
FROM join_data
WHERE rk <= 3
;


