#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期
if [ -n "$2" ] ;then
    do_date=$2
else
  echo "请传入日期参数"
  exit
fi

# todo 0. 优化参数
hive_tuning_sql="
-- 不开启自动收集表统计信息
SET hive.stats.autogather=false;
-- 设置map端输出进行合并，默认为true
SET hive.merge.mapfiles = true;
-- 设置reduce端输出进行合并，默认为false
SET hive.merge.mapredfiles = true;
-- 开启Map阶段聚合
SET hive.map.aggr = true;
-- 启用负载均衡处理
SET hive.groupby.skewindata = true;
"

# todo 1.交易域-用户商品粒度-订单-最近1日-汇总表
dws_trade_user_sku_order_1d_sql="
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
        FROM ${APP}.dwd_trade_order_detail_inc
        WHERE dt = '${do_date}'
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
        FROM ${APP}.dim_sku_full
        WHERE dt = '${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dws_trade_user_sku_order_1d PARTITION(dt = '${do_date}')
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
"

# todo 2.交易域-用户粒度-订单-最近1日-汇总表
dws_trade_user_order_1d_sql="
INSERT OVERWRITE TABLE ${APP}.dws_trade_user_order_1d PARTITION(dt = '${do_date}')
SELECT
    user_id,
    count(distinct(order_id)) AS order_count_1d,
    sum(sku_num) AS order_num_1d,
    sum(split_original_amount) AS order_original_amount_1d,
    sum(nvl(split_activity_amount,0)) AS activity_reduce_amount_1d,
    sum(nvl(split_coupon_amount,0)) AS coupon_reduce_amount_1d,
    sum(split_total_amount) AS order_total_amount_1d
FROM ${APP}.dwd_trade_order_detail_inc
WHERE dt = '${do_date}'
GROUP BY user_id;
"

# todo 3.交易域-用户粒度-加购-最近1日-汇总表
dws_trade_user_cart_add_1d_sql="
INSERT OVERWRITE TABLE ${APP}.dws_trade_user_cart_add_1d PARTITION(dt = '${do_date}')
SELECT
    user_id,
    count(*) AS cart_add_count_1d,
    sum(sku_num) AS cart_add_num_1d
FROM ${APP}.dwd_trade_cart_add_inc
WHERE dt = '${do_date}'
GROUP BY user_id;
"

# todo 4.交易域-用户粒度-支付-最近1日-汇总表
dws_trade_user_payment_1d_sql="
SET hive.stats.autogather=false;
INSERT OVERWRITE TABLE ${APP}.dws_trade_user_payment_1d PARTITION(dt = '${do_date}')
SELECT
    user_id,
    count(DISTINCT(order_id)) AS payment_count_1d,
    sum(sku_num) AS payment_num_1d,
    sum(split_payment_amount) AS payment_amount_1d
FROM ${APP}.dwd_trade_pay_detail_suc_inc
WHERE dt = '${do_date}'
GROUP BY user_id;
"

# todo 5.交易域-省份粒度-订单-最近1日-汇总表
dws_trade_province_order_1d_sql="
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
        FROM ${APP}.dwd_trade_order_detail_inc
        WHERE dt = '${do_date}'
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
        FROM ${APP}.dim_province_full
        WHERE dt = '${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dws_trade_province_order_1d PARTITION(dt = '${do_date}')
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
"

# todo 6.流量域-会话粒度-页面浏览-最近1日-汇总表
dws_traffic_session_page_view_1d_sql="
SET hive.stats.autogather=false;
INSERT OVERWRITE TABLE ${APP}.dws_traffic_session_page_view_1d PARTITION(dt = '${do_date}')
SELECT
    session_id,
    mid_id,
    brand,
    model,
    operate_system,
    version_code,
    channel,
    sum(during_time) AS during_time_1d,
    count(*) AS page_count_1d
FROM ${APP}.dwd_traffic_page_view_inc
WHERE dt = '${do_date}'
GROUP BY session_id, mid_id,brand,model,operate_system,version_code,channel;
"

# todo 7.流量域-访客页面粒度-页面浏览-最近1日-汇总表
dws_traffic_page_visitor_page_view_1d_sql="
SET hive.stats.autogather=false;
INSERT OVERWRITE TABLE ${APP}.dws_traffic_page_visitor_page_view_1d PARTITION(dt = '${do_date}' )
SELECT
    mid_id,
    brand,
    model,
    operate_system,
    page_id,
    sum(during_time) AS during_time_1d,
    count(*) AS view_count_1d
FROM ${APP}.dwd_traffic_page_view_inc
WHERE dt = '${do_date}'
GROUP BY mid_id,brand,model,operate_system,page_id;
"

# todo 1.交易域-用户商品粒度-订单-最近n日汇总表
dws_trade_user_sku_order_nd_sql="
INSERT OVERWRITE TABLE ${APP}.dws_trade_user_sku_order_nd PARTITION(dt = '${do_date}')
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
    -- 最近7日数据统计
    sum(if(dt >= date_sub('${do_date}', 6), order_count_1d, 0)) AS order_count_7d,
    sum(if(dt >= date_sub('${do_date}', 6), order_num_1d, 0)) AS order_num_7d,
    sum(if(dt >= date_sub('${do_date}', 6), order_original_amount_1d, 0)) AS order_original_amount_7d,
    sum(if(dt >= date_sub('${do_date}', 6), activity_reduce_amount_1d, 0)) AS activity_reduce_amount_7d,
    sum(if(dt >= date_sub('${do_date}', 6), coupon_reduce_amount_1d, 0)) AS coupon_reduce_amount_7d,
    sum(if(dt >= date_sub('${do_date}', 6), order_total_amount_1d, 0)) AS order_total_amount_7d,
    -- 最近30日数据统计
    sum(order_count_1d) AS order_count_30d,
    sum(order_num_1d) AS order_num_30d,
    sum(order_original_amount_1d) AS order_original_amount_30d,
    sum(activity_reduce_amount_1d) AS activity_reduce_amount_30d,
    sum(coupon_reduce_amount_1d) AS coupon_reduce_amount_30d,
    sum(order_total_amount_1d) AS order_total_amount_30d
FROM ${APP}.dws_trade_user_sku_order_1d
WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
GROUP BY user_id, sku_id, sku_name, category1_id, category1_name,
         category2_id, category2_name, category3_id, category3_name,
         tm_id, tm_name;
"

# todo 2.交易域-省份粒度-订单-最近n日-汇总表
dws_trade_province_order_nd_sql="
INSERT OVERWRITE TABLE ${APP}.dws_trade_province_order_nd PARTITION(dt = '${do_date}')
SELECT
    province_id,
    province_name,
    area_code,
    iso_code,
    iso_3166_2,
    -- 最近7日数据统计
    sum(if(dt>=date_add('${do_date}', -6), order_count_1d, 0)) AS order_count_7d,
    sum(if(dt>=date_add('${do_date}', -6), order_original_amount_1d, 0)) AS order_original_amount_7d,
    sum(if(dt>=date_add('${do_date}', -6), activity_reduce_amount_1d, 0)) AS activity_reduce_amount_7d,
    sum(if(dt>=date_add('${do_date}', -6), coupon_reduce_amount_1d, 0)) AS coupon_reduce_amount_7d,
    sum(if(dt>=date_add('${do_date}', -6), order_total_amount_1d, 0)) AS order_total_amount_7d,
    -- 最近30日数据统计
    sum(order_count_1d) AS order_count_30d,
    sum(order_original_amount_1d) AS order_original_amount_30d,
    sum(activity_reduce_amount_1d) AS activity_reduce_amount_30d,
    sum(coupon_reduce_amount_1d) AS coupon_reduce_amount_30d,
    sum(order_total_amount_1d) AS order_total_amount_30d
FROM ${APP}.dws_trade_province_order_1d
WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2;
"


# todo 1.交易域-用户粒度-订单-历史至今汇总表
dws_trade_user_order_td_sql="
WITH
    -- a. 前一天统计【历史至今汇总数据】
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
        FROM ${APP}.dws_trade_user_order_td
        WHERE dt = date_sub('${do_date}', 1)
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
        FROM ${APP}.dws_trade_user_order_1d
        WHERE dt = '${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dws_trade_user_order_td partition(dt = '${do_date}')
SELECT
    nvl(old.user_id, new.user_id) AS user_id,
    if(new.user_id IS NOT NULL AND old.user_id IS NULL, '2024-04-19', old.order_date_first) AS order_date_first,
    if(new.user_id IS NOT NULL, '2024-04-19', old.order_date_last) AS order_date_last,
    nvl(old.order_count_td, 0) + nvl(new.order_count_1d, 0) AS order_count_td,
    nvl(old.order_num_td, 0) + nvl(new.order_num_1d, 0) AS order_num_td,
    nvl(old.original_amount_td, 0) + nvl(new.order_original_amount_1d, 0) AS original_amount_td,
    nvl(old.activity_reduce_amount_td, 0) + nvl(new.activity_reduce_amount_1d, 0) AS activity_reduce_amount_td,
    nvl(old.coupon_reduce_amount_td, 0) + nvl(new.coupon_reduce_amount_1d, 0) AS coupon_reduce_amount_td,
    nvl(old.total_amount_td, 0) + nvl(new.order_total_amount_1d, 0) AS total_amount_td
FROM old
FULL OUTER JOIN new ON old.user_id = new.user_id;
"

# todo 2.用户域-用户粒度-登录-历史至今-汇总表
dws_user_user_login_td_sql="
WITH
    old AS (
        SELECT
            user_id,
            login_date_last,
            login_count_td
        FROM ${APP}.dws_user_user_login_td
        WHERE dt = date_sub('${do_date}', 1)
    ),
    new AS (
        SELECT
            user_id,
            count(*) AS login_count_1d
        FROM ${APP}.dwd_user_login_inc
        WHERE dt = '${do_date}'
        GROUP BY user_id
    )
INSERT OVERWRITE TABLE ${APP}.dws_user_user_login_td PARTITION(dt = '${do_date}')
SELECT
    nvl(old.user_id, new.user_id) AS user_id,
    if(new.user_id is null, old.login_date_last, '2024-04-19') AS login_date_last,
    nvl(old.login_count_td, 0) + nvl(new.login_count_1d, 0) AS login_count_td
FROM old
FULL OUTER JOIN new ON old.user_id = new.user_id;
"

# 依据传递参数判断数据加载
case $1 in
"dws_trade_user_sku_order_1d")
    hive -e "${hive_tuning_sql}${dws_trade_user_sku_order_1d_sql}"
;;
"dws_trade_user_order_1d")
    hive -e "${hive_tuning_sql}${dws_trade_user_order_1d_sql}"
;;
"dws_trade_user_cart_add_1d")
    hive -e "${hive_tuning_sql}${dws_trade_user_cart_add_1d_sql}"
;;
"dws_trade_user_payment_1d")
    hive -e "${hive_tuning_sql}${dws_trade_user_payment_1d_sql}"
;;
"dws_trade_province_order_1d")
    hive -e "${hive_tuning_sql}${dws_trade_province_order_1d_sql}"
;;
"dws_traffic_session_page_view_1d")
    hive -e "${hive_tuning_sql}${dws_traffic_session_page_view_1d_sql}"
;;
"dws_traffic_page_visitor_page_view_1d")
    hive -e "${hive_tuning_sql}${dws_traffic_page_visitor_page_view_1d_sql}"
;;
"dws_trade_user_sku_order_nd")
    hive -e "${dws_trade_user_sku_order_nd_sql}"
;;
"dws_trade_province_order_nd")
    hive -e "${dws_trade_province_order_nd_sql}"
;;
"dws_trade_user_order_td")
    hive -e "${dws_trade_user_order_td_sql}"
;;
"dws_user_user_login_td")
    hive -e "${dws_user_user_login_td_sql}"
;;
"all")
    hive -e "${hive_tuning_sql}${dws_trade_user_sku_order_1d_sql}${dws_trade_user_order_1d_sql}${dws_trade_user_cart_add_1d_sql}${dws_trade_user_payment_1d_sql}${dws_trade_province_order_1d_sql}${dws_trade_user_sku_order_nd_sql}${dws_trade_province_order_nd_sql}${dws_trade_user_order_td_sql}${dws_user_user_login_td_sql}"
    # hive -e "${hive_tuning_sql}${dws_traffic_session_page_view_1d_sql}${dws_traffic_page_visitor_page_view_1d_sql}"

;;
esac


#step1. 执行权限
# chmod +x dwd_to_dws.sh
#step2. 某天数据，加载到某张表
# sh dwd_to_dws.sh dws_traffic_session_page_view_1d 2024-04-18
#step3. 某天数据，加载所有表
# sh dwd_to_dws.sh all 2024-04-18
#

