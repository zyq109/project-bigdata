
-- todo ADS层统计主题指标
/*
    主题1：
        各品牌商品交易统计：订单数、商品销量、商品销售额
    主题2：
        各品类商品交易统计：订单数、商品销量、商品销售额
    |
    可视化展示：Top10 热销品牌或品类（三级品类）
*/
-- todo 主题1：各品牌商品交易统计：订单数、商品销量、商品销售额
WITH
-- a. 获取下单明细数据
    order_data AS (
        SELECT
            sku_id
            -- 订单数
            , count(id) AS order_count
            -- 商品销量
            , sum(sku_num) AS sku_num_sum
            --  商品销售额
            , sum(split_total_amount) As total_amount_sum
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt = '2024-09-11'
        GROUP BY sku_id
    )
-- b. 获取商品维度数据
    , sku_data AS (
        SELECT
            id, tm_id, tm_name
        FROM gmall.dim_sku_full
        WHERE dt = '2024-09-11'
    )
-- c. 关联维度
    , join_data AS (
        SELECT
            t1.sku_id, t1.order_count, t1.sku_num_sum, t1.total_amount_sum
             , t2.tm_id, t2.tm_name
        FROM order_data t1
                 LEFT JOIN sku_data t2 ON t1.sku_id = t2.id
    )
-- d. 按照品牌分组统计
SELECT
    tm_id, tm_name
     -- 订单数
         , sum(order_count) AS order_count
     -- 商品销量
         , sum(sku_num_sum) AS sku_num_sum
     --  商品销售额
         , sum(total_amount_sum) As total_amount_sum
FROM join_data
GROUP BY tm_id, tm_name
;

-- todo 主题2：各品类商品交易统计：订单数、商品销量、商品销售额
WITH
-- a. 获取下单明细数据
    order_data AS (
        SELECT
            sku_id
             -- 订单数
             , count(id) AS order_count
             -- 商品销量
             , sum(sku_num) AS sku_num_sum
             --  商品销售额
             , sum(split_total_amount) As total_amount_sum
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt = '2024-09-11'
        GROUP BY sku_id
    )
-- b. 获取商品维度数据
   , sku_data AS (
    SELECT
        id, category3_id, category3_name
    FROM gmall.dim_sku_full
    WHERE dt = '2024-09-11'
)
-- c. 关联维度
   , join_data AS (
    SELECT
        t1.sku_id, t1.order_count, t1.sku_num_sum, t1.total_amount_sum
         , t2.category3_id, t2.category3_name
    FROM order_data t1
             LEFT JOIN sku_data t2 ON t1.sku_id = t2.id
)
-- d. 按照品类分组统计
SELECT
    category3_id, category3_name
     -- 订单数
     , sum(order_count) AS order_count
     -- 商品销量
     , sum(sku_num_sum) AS sku_num_sum
     --  商品销售额
     , sum(total_amount_sum) As total_amount_sum
FROM join_data
GROUP BY category3_id, category3_name
;


-- ============================================================================

-- ============================================================================

-- todo：DWS层，商品粒度，下单明细数据，最近1日数据汇总
DROP TABLE IF EXISTS gmall.tmp_dws_sku_order_1d ;
CREATE TABLE gmall.tmp_dws_sku_order_1d   -- CTAS 方式创建表
AS
WITH
-- a. 获取下单明细数据
    order_data AS (
        SELECT
            sku_id
            -- 订单数
            , count(id) AS order_count
            -- 商品销量
            , sum(sku_num) AS sku_num_sum
            --  商品销售额
            , sum(split_total_amount) As total_amount_sum
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt = '2024-09-11'
        GROUP BY sku_id
    )
-- b. 获取商品维度数据
    , sku_data AS (
        SELECT
            id, spu_id, spu_name, tm_id, tm_name
            , category1_id, category1_name
            , category2_id, category2_name
            , category3_id, category3_name
        FROM gmall.dim_sku_full
        WHERE dt = '2024-09-11'
    )
SELECT
    t1.sku_id, t1.order_count, t1.sku_num_sum, t1.total_amount_sum
     , t2.spu_id, t2.spu_name, t2.tm_id, t2.tm_name
     , t2.category1_id, t2.category1_name, t2.category2_id
     , t2.category2_name, t2.category3_id, t2.category3_name
FROM order_data t1
         LEFT JOIN sku_data t2 ON t1.sku_id = t2.id
;


-- todo 主题1：各品牌商品交易统计：订单数、商品销量、商品销售额
DROP TABLE IF EXISTS gmall.tmp_ads_order_stats_by_tm ;
CREATE TABLE gmall.tmp_ads_order_stats_by_tm   -- CTAS 方式创建表
AS
SELECT
    '2024-09-11' AS report_dt
    , '1' AS recent_days
    , tm_id, tm_name
     -- 订单数
     , sum(order_count) AS order_count
     -- 商品销量
     , sum(sku_num_sum) AS sku_num_sum
     --  商品销售额
     , sum(total_amount_sum) As total_amount_sum
FROM gmall.tmp_dws_sku_order_1d
GROUP BY tm_id, tm_name
;

-- todo 主题2：各品类商品交易统计：订单数、商品销量、商品销售额
DROP TABLE IF EXISTS gmall.tmp_ads_order_stats_by_category3 ;
CREATE TABLE gmall.tmp_ads_order_stats_by_category3   -- CTAS 方式创建表
AS
SELECT
    '2024-09-11' AS report_dt
     , '1' AS recent_days
     , category3_id, category3_name
     -- 订单数
     , sum(order_count) AS order_count
     -- 商品销量
     , sum(sku_num_sum) AS sku_num_sum
     --  商品销售额
     , sum(total_amount_sum) As total_amount_sum
FROM gmall.tmp_dws_sku_order_1d
GROUP BY category3_id, category3_name
;
