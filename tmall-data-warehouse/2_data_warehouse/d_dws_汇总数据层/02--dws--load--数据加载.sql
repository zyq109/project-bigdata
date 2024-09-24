
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

set hive.stats.column.autogather=false;


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
        WHERE dt <= '2024-09-11'
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
        WHERE dt = '2024-09-11'
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
SELECT * FROM gmall.dws_trade_user_sku_order_1d WHERE dt = '2024-09-11' ;


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
        WHERE dt = '2024-09-12'
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
        WHERE dt = '2024-09-12'
    )
INSERT OVERWRITE TABLE gmall.dws_trade_user_sku_order_1d PARTITION(dt = '2024-09-12')
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
SELECT * FROM gmall.dws_trade_user_sku_order_1d WHERE dt = '2024-09-12' ;


-- =========================================================================
-- todo 1.3 交易域-用户粒度-订单-最近1日-汇总表
-- =========================================================================

-- （1）首日装载
-- 使用 WITH AS 定义临时结果集
insert overwrite table gmall.dws_trade_user_order_1d partition(dt)
select
    user_id,
    count(distinct(order_id)),
    sum(sku_num),
    sum(split_original_amount),
    sum(nvl(split_activity_amount,0)),
    sum(nvl(split_coupon_amount,0)),
    sum(split_total_amount),
    dt
from gmall.dwd_trade_order_detail_inc
group by user_id,dt;

-- （2）每日装载
insert overwrite table gmall.dws_trade_user_order_1d partition(dt='2020-09-12')
select
    user_id,
    count(distinct(order_id)),
    sum(sku_num),
    sum(split_original_amount),
    sum(nvl(split_activity_amount,0)),
    sum(nvl(split_coupon_amount,0)),
    sum(split_total_amount)
from gmall.dwd_trade_order_detail_inc
where dt='2020-09-12'
group by user_id;
-- 查询
SELECT * FROM gmall.dws_trade_user_order_1d WHERE dt = '2024-09-12' ;

-- =========================================================================
-- todo 1.4 交易域-用户粒度-加购-最近1日-汇总表
-- =========================================================================

--（1）首日装载
insert overwrite table gmall.dws_trade_user_order_1d partition(dt)
select
    user_id,
    count(distinct(order_id)),
    sum(sku_num),
    sum(split_original_amount),
    sum(nvl(split_activity_amount,0)),
    sum(nvl(split_coupon_amount,0)),
    sum(split_total_amount),
    dt
from gmall.dwd_trade_order_detail_inc
group by user_id,dt;

-- 查询
SELECT * FROM gmall.dws_trade_user_cart_add_1d WHERE dt = '2024-09-11' ;


-- （2）每日装载
insert overwrite table gmall.dws_trade_user_order_1d partition(dt='2020-09-12')
select
    user_id,
    count(distinct(order_id)),
    sum(sku_num),
    sum(split_original_amount),
    sum(nvl(split_activity_amount,0)),
    sum(nvl(split_coupon_amount,0)),
    sum(split_total_amount)
from gmall.dwd_trade_order_detail_inc
where dt='2020-09-12'
group by user_id;
-- 查询
SELECT * FROM gmall.dws_trade_user_cart_add_1d WHERE dt = '2024-09-12' ;


-- =========================================================================
-- todo 1.5 交易域-用户粒度-支付-最近1日-汇总表
-- =========================================================================

--（1）首日装载
insert overwrite table gmall.dws_trade_user_payment_1d partition(dt)
select
    user_id,
    count(distinct(order_id)),
    sum(sku_num),
    sum(split_payment_amount),
    dt
from gmall.dwd_trade_pay_detail_suc_inc
group by user_id,dt;

-- （2）每日装载
insert overwrite table gmall.dws_trade_user_payment_1d partition(dt='2020-06-15')
select
    user_id,
    count(distinct(order_id)),
    sum(sku_num),
    sum(split_payment_amount)
from gmall.dwd_trade_pay_detail_suc_inc
where dt='2020-06-15'
group by user_id;

-- 查询
SELECT * FROM gmall.dws_trade_user_payment_1d WHERE dt = '2024-09-12' ;
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
        WHERE dt <= '2024-09-11'
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
        WHERE dt = '2024-09-11'
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
SELECT * FROM gmall.dws_trade_province_order_1d WHERE dt = '2024-09-11' ;


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
        WHERE dt = '2024-09-12'
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
        WHERE dt = '2024-09-12'
    )
INSERT OVERWRITE TABLE gmall.dws_trade_province_order_1d PARTITION(dt = '2024-09-12')
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
SELECT * FROM gmall.dws_trade_province_order_1d WHERE dt = '2024-09-12' ;


-- =========================================================================
-- todo 1.8 流量域-会话粒度-页面浏览-最近1日-汇总表
-- =========================================================================
/*
    DWD层事实表：
        dwd_traffic_page_view_inc
*/


-- 每日数据加载
insert overwrite table gmall.dws_traffic_session_page_view_1d partition(dt='2024-09-12')
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
where dt='2024-09-12'
group by session_id,mid_id,brand,model,operate_system,version_code,channel;





-- =========================================================================
-- todo 1.9 流量域-访客页面粒度-页面浏览-最近1日-汇总表
-- =========================================================================
-- 每日数据加载
INSERT OVERWRITE TABLE gmall.dws_traffic_page_visitor_page_view_1d PARTITION (dt = '2024-09-11')
SELECT mid_id
     , brand
     , model
     , operate_system
     , page_id
     , sum(during_time)
     , count(page_id)
FROM gmall.dwd_traffic_page_view_inc
WHERE dt = '2024-09-11'
GROUP BY mid_id, brand, model, operate_system, page_id;
-- 查询
SELECT * FROM gmall.dws_traffic_page_visitor_page_view_1d WHERE dt = '2024-09-11' ;



-- =========================================================================
-- todo 2.1 交易域-用户商品粒度-订单-最近n日汇总表
-- =========================================================================
/*
    汇总表：
        dws_trade_user_sku_order_1d
*/

-- 使用 WITH AS 定义临时结果集
WITH order_data AS (
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
        order_count_1d,
        order_num_1d,
        order_original_amount_1d,
        activity_reduce_amount_1d,
        coupon_reduce_amount_1d,
        order_total_amount_1d,
        dt
    FROM gmall.dws_trade_user_sku_order_1d
    WHERE dt >= date_add('2024-09-12', -29)
)
-- 将处理后的数据插入到 dws_trade_user_sku_order_nd 表的指定分区
INSERT OVERWRITE TABLE gmall.dws_trade_user_sku_order_nd PARTITION(dt = '2024-09-12')
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
    sum(if(dt >= date_add('2024-09-12', -6), order_count_1d, 0)),
    sum(if(dt >= date_add('2024-09-12', -6), order_num_1d, 0)),
    sum(if(dt >= date_add('2024-09-12', -6), order_original_amount_1d, 0)),
    sum(if(dt >= date_add('2024-09-12', -6), activity_reduce_amount_1d, 0)),
    sum(if(dt >= date_add('2024-09-12', -6), coupon_reduce_amount_1d, 0)),
    sum(if(dt >= date_add('2024-09-12', -6), order_total_amount_1d, 0)),
    sum(order_count_1d),
    sum(order_num_1d),
    sum(order_original_amount_1d),
    sum(activity_reduce_amount_1d),
    sum(coupon_reduce_amount_1d),
    sum(order_total_amount_1d)
FROM order_data
GROUP BY user_id, sku_id, sku_name, category1_id, category1_name, category2_id, category2_name, category3_id, category3_name, tm_id, tm_name;

-- 查询
SELECT * FROM gmall.dws_trade_user_sku_order_nd WHERE dt = '2024-09-12' ;

-- =========================================================================
-- todo 2.6 交易域-省份粒度-订单-最近n日-汇总表
-- =========================================================================
insert overwrite table gmall.dws_trade_province_order_nd partition(dt='2024-09-12')
select
    province_id,
    province_name,
    area_code,
    iso_code,
    iso_3166_2,
    sum(if(dt>=date_add('2024-09-12',-6),order_count_1d,0)),
    sum(if(dt>=date_add('2024-09-12',-6),order_original_amount_1d,0)),
    sum(if(dt>=date_add('2024-09-12',-6),activity_reduce_amount_1d,0)),
    sum(if(dt>=date_add('2024-09-12',-6),coupon_reduce_amount_1d,0)),
    sum(if(dt>=date_add('2024-09-12',-6),order_total_amount_1d,0)),
    sum(order_count_1d),
    sum(order_original_amount_1d),
    sum(activity_reduce_amount_1d),
    sum(coupon_reduce_amount_1d),
    sum(order_total_amount_1d)
from gmall.dws_trade_province_order_1d
where dt>=date_add('2024-09-12',-29)
  and dt<='2024-09-12'
group by province_id,province_name,area_code,iso_code,iso_3166_2;


-- 查询
SELECT * FROM gmall.dws_trade_province_order_nd WHERE dt = '2024-09-12' ;



-- =========================================================================
-- todo 3.1 交易域-用户粒度-订单-历史至今-汇总表
-- =========================================================================

--（1）首日装载
-- 使用WITH AS定义临时结果集
WITH order_data AS (
    SELECT
        user_id,
        order_count_1d,
        order_num_1d,
        order_original_amount_1d,
        activity_reduce_amount_1d,
        coupon_reduce_amount_1d,
        order_total_amount_1d
    FROM gmall.dws_trade_user_order_1d
)
-- 将处理后的数据插入到dws_trade_user_order_td表的指定分区
INSERT OVERWRITE TABLE gmall.dws_trade_user_order_td PARTITION(dt = '2024-09-11')
SELECT
    user_id,
    min(dt) login_date_first,
    max(dt) login_date_last,
    sum(order_count_1d) order_count,
    sum(order_num_1d) order_num,
    sum(order_original_amount_1d) original_amount,
    sum(activity_reduce_amount_1d) activity_reduce_amount,
    sum(coupon_reduce_amount_1d) coupon_reduce_amount,
    sum(order_total_amount_1d) total_amount
FROM (
         SELECT
             user_id,
             '2024-09-11' dt,
             order_count_1d,
             order_num_1d,
             order_original_amount_1d,
             activity_reduce_amount_1d,
             coupon_reduce_amount_1d,
             order_total_amount_1d
         FROM order_data
     ) t
GROUP BY user_id;

-- 查询
SELECT * FROM gmall.dws_trade_user_order_td WHERE dt = '2024-09-11' ;


-- （2）每日装载
-- 使用WITH AS定义临时结果集
WITH old_data AS (
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
    WHERE dt = date_add('2024-09-12', -1)
),
     new_data AS (
         SELECT
             user_id,
             order_count_1d,
             order_num_1d,
             order_original_amount_1d,
             activity_reduce_amount_1d,
             coupon_reduce_amount_1d,
             order_total_amount_1d
         FROM gmall.dws_trade_user_order_1d
         WHERE dt = '2024-09-12'
     )
-- 将处理后的数据插入到dws_trade_user_order_td表的指定分区
INSERT OVERWRITE TABLE gmall.dws_trade_user_order_td PARTITION(dt = '2024-09-12')
SELECT
    nvl(old.user_id, new.user_id),
    if(new.user_id is not null and old.user_id is null, '2024-09-12', old.order_date_first),
    if(new.user_id is not null, '2024-09-12', old.order_date_last),
    nvl(old.order_count_td, 0) + nvl(new.order_count_1d, 0),
    nvl(old.order_num_td, 0) + nvl(new.order_num_1d, 0),
    nvl(old.original_amount_td, 0) + nvl(new.order_original_amount_1d, 0),
    nvl(old.activity_reduce_amount_td, 0) + nvl(new.activity_reduce_amount_1d, 0),
    nvl(old.coupon_reduce_amount_td, 0) + nvl(new.coupon_reduce_amount_1d, 0),
    nvl(old.total_amount_td, 0) + nvl(new.order_total_amount_1d, 0)
FROM old_data old
         FULL OUTER JOIN new_data new ON old.user_id = new.user_id;

-- 查询
SELECT * FROM gmall.dws_trade_user_order_td WHERE dt = '2024-09-12' ;

-- =========================================================================
-- todo 3.3 用户域-用户粒度-登录-历史至今-汇总表
-- =========================================================================
-- 首日装载
-- 使用WITH AS定义临时结果集
WITH user_data AS (
    SELECT
        id,
        create_time
    FROM gmall.dim_user_zip
    WHERE dt = '9999-12-31'
),
     login_data AS (
         SELECT
             user_id,
             max(dt) login_date_last,
             count(*) login_count_td
         FROM gmall.dwd_user_login_inc
         GROUP BY user_id
     )
-- 将处理后的数据插入到dws_user_user_login_td表的指定分区
INSERT OVERWRITE TABLE gmall.dws_user_user_login_td PARTITION(dt = '2024-09-11')
SELECT
    u.id,
    nvl(login_date_last, date_format(u.create_time, 'yyyy - MM - dd')),
    nvl(login_count_td, 1)
FROM user_data u
         LEFT JOIN login_data l ON u.id = l.user_id;

-- 查询
SELECT * FROM gmall.dws_user_user_login_td WHERE dt = '2024-09-11' ;


-- 每日装载
-- 使用 WITH AS 定义临时结果集
WITH old_data AS (
    SELECT
        user_id,
        login_date_last,
        login_count_td
    FROM gmall.dws_user_user_login_td
    WHERE dt = date_add('2024-09-12', -1)
),
     new_data AS (
         SELECT
             user_id,
             count(*) login_count_1d
         FROM gmall.dwd_user_login_inc
         WHERE dt = '2024-09-12'
         GROUP BY user_id
     )
-- 将处理后的数据插入到 dws_user_user_login_td 表的指定分区
INSERT OVERWRITE TABLE gmall.dws_user_user_login_td PARTITION(dt = '2024-09-12')
SELECT
    nvl(old.user_id, new.user_id),
    if(new.user_id is null, old.login_date_last, '2024-09-12'),
    nvl(old.login_count_td, 0) + nvl(new.login_count_1d, 0)
FROM old_data old
         FULL OUTER JOIN new_data new ON old.user_id = new.user_id;

SELECT * FROM gmall.dws_user_user_login_td WHERE dt = '2024-09-12' ;