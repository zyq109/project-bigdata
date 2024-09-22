
-- todo 首日数据加载，开启动态分区
-- 开启动态分区
SET hive.exec.dynamic.partition=true;
-- 非严格模式：允许所有分区都是动态的
SET hive.exec.dynamic.partition.mode=nonstrict;
-- todo 事实表数据按照粒度汇总处理，产生小文件进行合并
-- 在Map-only的任务结束时合并小文件
SET hive.merge.mapfiles = true ;
-- 在Map-Reduce的任务结束时合并小文件
SET hive.merge.mapredfiles = true ;


-- =========================================================================
-- todo 1.1 交易域-用户商品粒度-订单-最近1日-汇总表
-- =========================================================================
/*
    DWD层事实表：
        dwd_trade_order_detail_inc
    DIM层维表表：
        dim_sku_full
*/
--（1）首日装载
WITH
    -- a. 分组聚合
    detail AS (
        SELECT
            dt,
            user_id,
            sku_id,
            count(*) AS order_count_1d,
            sum(sku_num) AS order_num_1d,
            sum(split_original_amount) AS order_original_amount_1d,
            sum(nvl(split_activity_amount,0.0)) AS activity_reduce_amount_1d,
            sum(nvl(split_coupon_amount,0.0)) AS coupon_reduce_amount_1d,
            sum(split_total_amount) AS order_total_amount_1d
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt <= '2024-09-13'
        GROUP BY dt, user_id, sku_id
    ),
    -- b. 商品维度数据
    sku AS (
        SELECT
            id,
            sku_name,
            category1_id,
            category1_name,
            category2_id,
            category2_name,
            category3_id,
            category3_name,
            tm_id,
            tm_name
        FROM gmall.dim_sku_full
        WHERE dt = '2024-09-13'
    )
INSERT OVERWRITE TABLE gmall.dws_trade_user_sku_order_1d PARTITION(dt)
SELECT
    user_id,
    id,
    sku_name,
    category1_id,
    category1_name,
    category2_id,
    category2_name,
    category3_id,
    category3_name,
    tm_id,
    tm_name,
    order_count_1d,
    order_num_1d,
    order_original_amount_1d,
    activity_reduce_amount_1d,
    coupon_reduce_amount_1d,
    order_total_amount_1d,
    dt -- 分区字段值
FROM detail
    LEFT JOIN sku ON detail.sku_id=sku.id;

-- 查询
SHOW PARTITIONS gmall.dws_trade_user_sku_order_1d ;
SELECT * FROM gmall.dws_trade_user_sku_order_1d WHERE dt = '2024-09-13' ;


-- （2）每日装载
WITH
    detail AS (
        SELECT
            user_id,
            sku_id,
            count(*) AS order_count_1d,
            sum(sku_num) AS order_num_1d,
            sum(split_original_amount) AS order_original_amount_1d,
            sum(nvl(split_activity_amount,0.0)) AS activity_reduce_amount_1d,
            sum(nvl(split_coupon_amount,0.0)) AS coupon_reduce_amount_1d,
            sum(split_total_amount) AS order_total_amount_1d
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt = '2024-09-14'
        GROUP BY user_id, sku_id
    ),
    -- b. 商品维度数据
    sku AS (
        SELECT
            id,
            sku_name,
            category1_id,
            category1_name,
            category2_id,
            category2_name,
            category3_id,
            category3_name,
            tm_id,
            tm_name
        FROM gmall.dim_sku_full
        WHERE dt = '2024-09-14'
    )
INSERT OVERWRITE TABLE gmall.dws_trade_user_sku_order_1d PARTITION(dt = '2024-09-14')
SELECT
    user_id,
    id,
    sku_name,
    category1_id,
    category1_name,
    category2_id,
    category2_name,
    category3_id,
    category3_name,
    tm_id,
    tm_name,
    order_count_1d,
    order_num_1d,
    order_original_amount_1d,
    activity_reduce_amount_1d,
    coupon_reduce_amount_1d,
    order_total_amount_1d
FROM detail
         LEFT JOIN sku ON detail.sku_id=sku.id;

-- 查询
SELECT * FROM gmall.dws_trade_user_sku_order_1d WHERE dt = '2024-09-14' ;


-- =========================================================================
-- todo 1.3 交易域-用户粒度-订单-最近1日-汇总表
-- =========================================================================

-- （1）首日装载

-- （2）每日装载


-- =========================================================================
-- todo 1.4 交易域-用户粒度-加购-最近1日-汇总表
-- =========================================================================

--（1）首日装载

-- （2）每日装载


-- =========================================================================
-- todo 1.5 交易域-用户粒度-支付-最近1日-汇总表
-- =========================================================================

--（1）首日装载


-- （2）每日装载


-- =========================================================================
-- todo 1.6 交易域-省份粒度-订单-最近1日-汇总表
-- =========================================================================
/*
    DWD层事实表：
        dwd_trade_order_detail_inc
    DIM层维度表：
        dim_province_full
*/
-- （1）首日装载
WITH
    -- a. 下单事实表数据
    detail AS (
        SELECT
            province_id,
            -- 订单明细数据与订单数据关系：N 对 1
            count(distinct(order_id)) AS order_count_1d,
            sum(split_original_amount) AS order_original_amount_1d,
            sum(nvl(split_activity_amount,0)) AS activity_reduce_amount_1d,
            sum(nvl(split_coupon_amount,0)) AS coupon_reduce_amount_1d,
            sum(split_total_amount) AS order_total_amount_1d,
            dt
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt <= '2024-09-13'
        GROUP BY province_id, dt
    ),
    -- b. 地区维度表数据
    province AS (
        SELECT
            id,
            province_name,
            area_code,
            iso_code,
            iso_3166_2
        FROM gmall.dim_province_full
        WHERE dt = '2024-09-13'
    )
INSERT OVERWRITE TABLE gmall.dws_trade_province_order_1d PARTITION(dt)
SELECT
    province_id,
    province_name,
    area_code,
    iso_code,
    iso_3166_2,
    order_count_1d,
    order_original_amount_1d,
    activity_reduce_amount_1d,
    coupon_reduce_amount_1d,
    order_total_amount_1d,
    dt
FROM detail
LEFT JOIN province ON detail.province_id = province.id;

-- 查询
SHOW PARTITIONS gmall.dws_trade_province_order_1d ;
SELECT * FROM gmall.dws_trade_province_order_1d WHERE dt = '2024-09-13' ;


-- （2）每日装载
WITH
    -- a. 下单事实表数据
    detail AS (
        SELECT
            province_id,
            -- 订单明细数据与订单数据关系：N 对 1
            count(distinct(order_id)) AS order_count_1d,
            sum(split_original_amount) AS order_original_amount_1d,
            sum(nvl(split_activity_amount,0)) AS activity_reduce_amount_1d,
            sum(nvl(split_coupon_amount,0)) AS coupon_reduce_amount_1d,
            sum(split_total_amount) AS order_total_amount_1d
        FROM gmall.dwd_trade_order_detail_inc
        WHERE dt = '2024-09-14'
        GROUP BY province_id
    ),
    -- b. 地区维度表数据
    province AS (
        SELECT
            id,
            province_name,
            area_code,
            iso_code,
            iso_3166_2
        FROM gmall.dim_province_full
        WHERE dt = '2024-09-14'
    )
INSERT OVERWRITE TABLE gmall.dws_trade_province_order_1d PARTITION(dt = '2024-09-14')
SELECT
    province_id,
    province_name,
    area_code,
    iso_code,
    iso_3166_2,
    order_count_1d,
    order_original_amount_1d,
    activity_reduce_amount_1d,
    coupon_reduce_amount_1d,
    order_total_amount_1d
FROM detail
    LEFT JOIN province ON detail.province_id = province.id;

-- 查询
SELECT * FROM gmall.dws_trade_province_order_1d WHERE dt = '2024-09-14' ;


-- =========================================================================
-- todo 1.8 流量域-会话粒度-页面浏览-最近1日-汇总表
-- =========================================================================
/*
    DWD层事实表：
        dwd_traffic_page_view_inc
*/

-- 首日数据加载
insert overwrite table gmall.dws_traffic_session_page_view_1d partition(dt='2024-09-13')
select
    session_id,
    mid_id,
    brand,
    model,
    operate_system,
    version_code,
    channel,
    sum(during_time),
    count(*)
from gmall.dwd_traffic_page_view_inc
where dt='2024-09-13'
group by session_id,mid_id,brand,model,operate_system,version_code,channel;

-- 每日数据加载
insert overwrite table gmall.dws_traffic_session_page_view_1d partition(dt='2024-09-14')
select
    session_id,
    mid_id,
    brand,
    model,
    operate_system,
    version_code,
    channel,
    sum(during_time),
    count(*)
from gmall.dwd_traffic_page_view_inc
where dt='2024-09-14'
group by session_id,mid_id,brand,model,operate_system,version_code,channel;



-- =========================================================================
-- todo 1.9 流量域-访客页面粒度-页面浏览-最近1日-汇总表
-- =========================================================================
-- 每日数据加载
INSERT OVERWRITE TABLE gmall.dws_traffic_page_visitor_page_view_1d PARTITION (dt = '2024-09-14')
SELECT mid_id
     , brand
     , model
     , operate_system
     , page_id
     , sum(during_time)
     , count(page_id)
FROM gmall.dwd_traffic_page_view_inc
WHERE dt = '2024-09-14'
GROUP BY mid_id, brand, model, operate_system, page_id;


-- =========================================================================
-- todo 2.1 交易域-用户商品粒度-订单-最近n日汇总表
-- =========================================================================
/*
    汇总表：
        dws_trade_user_sku_order_1d
*/
INSERT OVERWRITE TABLE gmall.dws_trade_user_sku_order_nd PARTITION(dt = '2024-09-13')
SELECT
    user_id,
    sku_id,
    sku_name,
    category1_id,
    category1_name,
    category2_id,
    category2_name,
    category3_id,
    category3_name,
    tm_id,
    tm_name,
    -- 最近7日汇总数据
    sum(if(dt >= date_sub('2024-09-13', 6), order_count_1d, 0)) AS order_count_7d,
    sum(if(dt >= date_sub('2024-09-13', 6), order_num_1d, 0)) AS order_num_7d,
    sum(if(dt >= date_sub('2024-09-13', 6), order_original_amount_1d, 0)) AS order_original_amount_7d,
    sum(if(dt >= date_sub('2024-09-13', 6), activity_reduce_amount_1d, 0)) AS activity_reduce_amount_7d,
    sum(if(dt >= date_sub('2024-09-13', 6), coupon_reduce_amount_1d, 0)) AS coupon_reduce_amount_7d,
    sum(if(dt >= date_sub('2024-09-13', 6), order_total_amount_1d, 0)) AS order_total_amount_7d,
    -- 最近30日汇总数据
    sum(order_count_1d) AS order_count_30d,
    sum(order_num_1d) AS order_num_30d,
    sum(order_original_amount_1d) AS order_original_amount_30d,
    sum(activity_reduce_amount_1d) AS activity_reduce_amount_30d,
    sum(coupon_reduce_amount_1d) AS coupon_reduce_amount_30d,
    sum(order_total_amount_1d) AS order_total_amount_30d
FROM gmall.dws_trade_user_sku_order_1d
-- step1. 获取最近30日数据
WHERE dt >= date_sub('2024-09-13', 29) AND dt <= '2024-09-13'
GROUP BY user_id, sku_id, sku_name, category1_id, category1_name,
         category2_id, category2_name, category3_id, category3_name,
         tm_id, tm_name;

-- 查询
SHOW PARTITIONS gmall.dws_trade_user_sku_order_nd ;
SELECT * FROM gmall.dws_trade_user_sku_order_nd WHERE dt = '2024-04-18' ;


-- =========================================================================
-- todo 2.6 交易域-省份粒度-订单-最近n日-汇总表
-- =========================================================================


-- =========================================================================
-- todo 3.1 交易域-用户粒度-订单-历史至今汇总表
-- =========================================================================
/*
    汇总表：
        dws_trade_province_order_1d
*/
-- （1）首日装载
INSERT OVERWRITE TABLE gmall.dws_trade_user_order_td partition(dt = '2024-09-13')
SELECT
    user_id,
    min(dt) AS login_date_first,
    max(dt) AS login_date_last,
    sum(order_count_1d) AS order_count,
    sum(order_num_1d) AS order_num,
    sum(order_original_amount_1d) AS original_amount,
    sum(activity_reduce_amount_1d) AS activity_reduce_amount,
    sum(coupon_reduce_amount_1d) AS coupon_reduce_amount,
    sum(order_total_amount_1d) AS total_amount
FROM gmall.dws_trade_user_order_1d
WHERE dt <= '2024-09-13'
GROUP BY user_id;

-- 查询
SHOW PARTITIONS gmall.dws_trade_user_order_td ;
SELECT * FROM gmall.dws_trade_user_order_td WHERE dt = '2024-09-14' ;

-- （2）每日装载
WITH
    -- a. 前一天统计【历史之间汇总数据】
    old AS (
        SELECT
            user_id,
            order_date_first,
            order_date_last,
            order_count_td,
            order_num_td,
            original_amount_td,
            activity_reduce_amount_td,
            coupon_reduce_amount_td,
            total_amount_td
        FROM gmall.dws_trade_user_order_td
        WHERE dt = date_sub('2024-09-14', 1)
    ),
    -- b. 当天统计【最近1日汇总数据】
    new AS (
        SELECT
            user_id,
            order_count_1d,
            order_num_1d,
            order_original_amount_1d,
            activity_reduce_amount_1d,
            coupon_reduce_amount_1d,
            order_total_amount_1d
        FROM gmall.dws_trade_user_order_1d
        WHERE dt = '2024-09-14'
    )
INSERT OVERWRITE TABLE gmall.dws_trade_user_order_td partition(dt = '2024-04-14')
SELECT
    nvl(old.user_id, new.user_id) AS user_id,
    if(new.user_id IS NOT NULL AND old.user_id IS NULL, '2024-09-14', old.order_date_first) AS order_date_first,
    if(new.user_id IS NOT NULL, '2024-09-14', old.order_date_last) AS order_date_last,
    nvl(old.order_count_td, 0) + nvl(new.order_count_1d, 0) AS order_count_td,
    nvl(old.order_num_td, 0) + nvl(new.order_num_1d, 0) AS order_num_td,
    nvl(old.original_amount_td, 0) + nvl(new.order_original_amount_1d, 0) AS original_amount_td,
    nvl(old.activity_reduce_amount_td, 0) + nvl(new.activity_reduce_amount_1d, 0) AS activity_reduce_amount_td,
    nvl(old.coupon_reduce_amount_td, 0) + nvl(new.coupon_reduce_amount_1d, 0) AS coupon_reduce_amount_td,
    nvl(old.total_amount_td, 0) + nvl(new.order_total_amount_1d, 0) AS total_amount_td
FROM old
FULL OUTER JOIN new ON old.user_id = new.user_id;

-- 查询
SELECT * FROM gmall.dws_trade_user_order_td WHERE dt = '2024-09-14' ;


-- =========================================================================
-- todo 3.3 用户域-用户粒度-登录-历史至今-汇总表
-- =========================================================================


--（1）首日装载
INSERT OVERWRITE TABLE dws_user_user_login_td PARTITION (dt = '2024-09-13')
SELECT u.id,
       nvl(login_date_last, date_format(create_time, 'yyyy-MM-dd')),
       nvl(login_count_td, 1)
FROM (SELECT id,
             create_time
      FROM dim_user_zip
      WHERE dt = '2024-09-13') u
         LEFT JOIN
     (SELECT user_id,
             max(dt)  login_date_last,
             count(*) login_count_td
      FROM dwd_user_login_inc
      GROUP BY user_id) l
     ON u.id = l.user_id;

SHOW PARTITIONS gmall.dws_user_user_login_td;
SELECT *
FROM gmall.dws_user_user_login_td
;
-- （2）每日装载

insert overwrite table dws_user_user_login_td partition (dt = '2020-09-14')
select nvl(old.user_id, new.user_id),
       if(new.user_id is null, old.login_date_last, '2024-09-14'),
       nvl(old.login_count_td, 0) + nvl(new.login_count_1d, 0)
from (select user_id,
             login_date_last,
             login_count_td
      from dws_user_user_login_td
      where dt = date_add('2020-09-14', -1)) old
         full outer join
     (select user_id,
             count(*) login_count_1d
      from dwd_user_login_inc
      where dt = '2020-09-14'
      group by user_id) new
     on old.user_id = new.user_id;



