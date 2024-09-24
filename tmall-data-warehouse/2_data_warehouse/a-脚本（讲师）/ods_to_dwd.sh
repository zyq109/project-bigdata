#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=`date -d "-1 day" +%F`
fi


# todo 0. 优化参数
hive_tuning_sql="
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
"

# todo 1.交易域-加购-事务事实表
dwd_trade_cart_add_inc_sql="
WITH
    -- a. 加购物车表
    cart AS (
        SELECT
            id,
            user_id,
            sku_id,
            if(operate_time IS NOT NULL, operate_time, create_time) AS create_time,
            date_format(if(operate_time IS NOT NULL, operate_time, create_time),'yyyy-MM-dd') AS date_id,
            source_id,
            source_type,
            sku_num
        FROM ${APP}.ods_cart_info_inc
        WHERE dt = '${do_date}'
    ),
    -- b. 字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM ${APP}.ods_base_dic_full
        WHERE dt = '${do_date}' AND parent_code='24'
    )
INSERT OVERWRITE TABLE ${APP}.dwd_trade_cart_add_inc PARTITION (dt = '${do_date}')
SELECT
    id,
    user_id,
    sku_id,
    date_id,
    create_time,
    source_id,
    source_type,
    dic.dic_name,
    sku_num
FROM cart
    LEFT JOIN dic ON cart.source_type = dic.dic_code;
"

# todo 2.交易域-下单-事务事实表
dwd_trade_order_detail_inc_sql="
SET hive.stats.autogather=false;
SET hive.vectorized.execution.enabled=false;
SET hive.vectorized.execution.reduce.enabled=false;
SET hive.vectorized.execution.reduce.groupby.enabled=false;
SET hive.exec.dynamic.partition.mode=nonstrict;
WITH
    -- a. 订单明细数据
    detail AS (
        SELECT
            id,
            order_id,
            sku_id,
            create_time,
            source_id,
            source_type,
            sku_num,
            sku_num * order_price AS split_original_amount,
            split_total_amount,
            split_activity_amount,
            split_coupon_amount
        FROM ${APP}.ods_order_detail_inc
        WHERE dt = '${do_date}'
    ),
    -- b. 订单数据
    info AS (
        SELECT
            id,
            user_id,
            province_id
        FROM ${APP}.ods_order_info_inc
        WHERE dt = '${do_date}'
    ),
    -- c. 订单明细活动关联表
    activity AS (
        SELECT
            order_detail_id,
            activity_id,
            activity_rule_id
        FROM ${APP}.ods_order_detail_activity_inc
        WHERE dt = '${do_date}'
    ),
    -- d. 订单明细优惠卷关联表
    coupon AS (
        SELECT
            order_detail_id,
            coupon_id
        FROM ${APP}.ods_order_detail_coupon_inc
        WHERE dt = '${do_date}'
    ),
    -- e. 字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM ${APP}.ods_base_dic_full
        WHERE dt='${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dwd_trade_order_detail_inc PARTITION (dt = '${do_date}')
-- f. 订单明细表关联订单info、活动activity、优惠卷coupon、字段dic
SELECT
    info.id,
    order_id,
    user_id,
    sku_id,
    province_id,
    activity_id,
    activity_rule_id,
    coupon_id,
    date_format(create_time, 'yyyy-MM-dd') AS date_id,
    create_time,
    source_id,
    source_type,
    dic_name,
    sku_num,
    split_original_amount,
    split_activity_amount,
    split_coupon_amount,
    split_total_amount
FROM detail
LEFT JOIN info ON detail.order_id = info.id
LEFT JOIN activity ON detail.id = activity.order_detail_id
LEFT JOIN coupon ON detail.id = coupon.order_detail_id
LEFT JOIN dic ON detail.source_type = dic.dic_code;
"

# todo 3.交易域-支付成功-事务事实表
dwd_trade_pay_detail_suc_inc_sql="
WITH
    -- a. 订单明细表
    detail AS (
        SELECT
            id,
            order_id,
            sku_id,
            source_id,
            source_type,
            sku_num,
            sku_num * order_price AS split_original_amount,
            split_total_amount,
            split_activity_amount,
            split_coupon_amount
        FROM ${APP}.ods_order_detail_inc
        WHERE dt ='${do_date}' OR dt = date_sub('${do_date}', 1)
    ),
    -- b. 支付表
    payment AS (
        SELECT
            user_id,
            order_id,
            payment_type,
            callback_time
        FROM ${APP}.ods_payment_info_inc
        WHERE dt = '${do_date}' AND payment_status = '1602'
          AND date_format(callback_time, 'yyyy-MM-dd') = '${do_date}'
    ),
    -- c. 订单表
    info AS (
        SELECT
            id,
            province_id
        FROM ${APP}.ods_order_info_inc
        WHERE dt = '${do_date}' OR dt = date_sub('${do_date}', 1)
    ),
    -- d. 订单明细活动关联表
    activity AS (
        SELECT
            order_detail_id,
            activity_id,
            activity_rule_id
        FROM ${APP}.ods_order_detail_activity_inc
        WHERE dt = '${do_date}' OR dt = date_sub('${do_date}', 1)
    ),
    -- e. 订单明细优惠卷关联表
    coupon AS (
        SELECT
            order_detail_id,
            coupon_id
        FROM ${APP}.ods_order_detail_coupon_inc
        WHERE dt = '${do_date}' OR dt = date_sub('${do_date}', 1)
    ),
    -- d. 支付类型字典表数据
    pay_dic AS (
        SELECT
            dic_code,
            dic_name
        FROM ${APP}.ods_base_dic_full
        WHERE dt = '${do_date}' and parent_code='11'
    ),
    -- e. 订单来源字典表数据
    src_dic AS (
        SELECT
            dic_code,
            dic_name
        FROM ${APP}.ods_base_dic_full
        WHERE dt='${do_date}' AND parent_code='24'
    )
INSERT OVERWRITE TABLE ${APP}.dwd_trade_pay_detail_suc_inc PARTITION (dt = '${do_date}')
-- f. 各个表关联
SELECT
    detail.id,
    detail.order_id,
    user_id,
    sku_id,
    province_id,
    activity_id,
    activity_rule_id,
    coupon_id,
    payment_type AS payment_type_code,
    pay_dic.dic_name AS payment_type_name,
    date_format(callback_time,'yyyy-MM-dd') AS date_id,
    callback_time,
    source_id,
    source_type AS source_type_code,
    src_dic.dic_name AS source_type_name,
    sku_num,
    split_original_amount,
    split_activity_amount,
    split_coupon_amount,
    split_total_amount
FROM detail
     JOIN payment ON detail.order_id = payment.order_id
     LEFT JOIN info ON detail.order_id = info.id
     LEFT JOIN activity ON detail.id = activity.order_detail_id
     LEFT JOIN coupon ON detail.id = coupon.order_detail_id
     LEFT JOIN pay_dic ON payment.payment_type = pay_dic.dic_code
     LEFT JOIN src_dic ON detail.source_type = src_dic.dic_code;
"

# todo 4.交易域-购物车-周期快照事实表
dwd_trade_cart_full_sql="
INSERT OVERWRITE TABLE ${APP}.dwd_trade_cart_full PARTITION(dt = '${do_date}')
SELECT
    id,
    user_id,
    sku_id,
    sku_name,
    sku_num
FROM ${APP}.ods_cart_info_full
WHERE dt = '${do_date}' and is_ordered = '0';
"

# todo 5.工具域-优惠券领取-事务事实表
dwd_tool_coupon_get_inc_sql="
SET hive.stats.autogather=false;
INSERT OVERWRITE TABLE ${APP}.dwd_tool_coupon_get_inc PARTITION(dt = '${do_date}')
SELECT
    id,
    coupon_id,
    user_id,
    date_format(get_time, 'yyyy-MM-dd') AS date_id,
    get_time
FROM ${APP}.ods_coupon_use_inc
WHERE dt = '${do_date}' AND date_format(get_time, 'yyyy-MM-dd') = '${do_date}';
"

# todo 6. 工具域-优惠券使用(下单)-事务事实表
dwd_tool_coupon_order_inc_sql="
INSERT OVERWRITE TABLE ${APP}.dwd_tool_coupon_order_inc PARTITION(dt = '${do_date}')
SELECT
    id,
    coupon_id,
    user_id,
    order_id,
    date_format(using_time, 'yyyy-MM-dd') AS date_id,
    using_time
FROM ${APP}.ods_coupon_use_inc
WHERE dt = '${do_date}' AND date_format(using_time, 'yyyy-MM-dd') = '${do_date}' ;
"

# todo 7.工具域-优惠券使用(支付)-事务事实表
dwd_tool_coupon_pay_inc_sql="
INSERT OVERWRITE TABLE ${APP}.dwd_tool_coupon_pay_inc PARTITION(dt = '${do_date}')
SELECT
    id,
    coupon_id,
    user_id,
    order_id,
    date_format(used_time, 'yyyy-MM-dd') AS date_id,
    used_time
FROM ${APP}.ods_coupon_use_inc
WHERE dt = '${do_date}' AND date_format(used_time, 'yyyy-MM-dd') = '${do_date}' ;
"

# todo 8.互动域-收藏商品-事务事实表
dwd_interaction_favor_add_inc_sql="
INSERT OVERWRITE TABLE ${APP}.dwd_interaction_favor_add_inc PARTITION(dt = '${do_date}')
SELECT
    id,
    user_id,
    sku_id,
    date_format(create_time, 'yyyy-MM-dd') AS date_id,
    create_time
FROM ${APP}.ods_favor_info_inc
WHERE dt = '${do_date}' AND date_format(create_time, 'yyyy-MM-dd') = '${do_date}';

"

# todo 9.互动域-评价-事务事实表
dwd_interaction_comment_inc_sql="
WITH
    -- a. 评论数据
    comment AS (
        SELECT
            id,
            user_id,
            sku_id,
            order_id,
            create_time,
            appraise
        FROM ${APP}.ods_comment_info_inc
        WHERE dt = '${do_date}'
    ),
    -- b. 好评字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM ${APP}.ods_base_dic_full
        WHERE dt = '${do_date}' AND parent_code = '12'
    )
INSERT OVERWRITE TABLE ${APP}.dwd_interaction_comment_inc PARTITION(dt = '${do_date}')
SELECT
    id,
    user_id,
    sku_id,
    order_id,
    date_format(create_time,'yyyy-MM-dd') AS date_id,
    create_time,
    appraise,
    dic_name
FROM comment
    LEFT JOIN dic ON comment.appraise = dic.dic_code;
"

# todo 10. 流量域-页面浏览-事务事实表
dwd_traffic_page_view_inc_sql="
SET hive.cbo.enable=false;
WITH
    -- a. app 日志数据
    log AS (
        SELECT
            common.ar AS area_code,
            common.ba AS brand,
            common.ch AS channel,
            common.is_new AS is_new,
            common.md AS model,
            common.mid AS mid_id,
            common.os AS operate_system,
            common.uid AS user_id,
            common.vc AS version_code,
            page.during_time,
            page.item AS page_item,
            page.item_type AS page_item_type,
            page.last_page_id,
            page.page_id,
            page.source_type,
            ts,
            -- 找到每个会话起点：当且仅当页面浏览数据中last_page_id为null时，表示会话第一次访问页面浏览数据，获取时间戳作为会话开始起点
            if(page.last_page_id is null, ts, null) session_start_point
        from ${APP}.ods_log_inc
        where dt = '${do_date}' and page is not null
    ),
    -- b. 省份信息表
    province AS (
        select
            id AS province_id,
            area_code
        from ${APP}.ods_base_province_full
        where dt = '${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dwd_traffic_page_view_inc PARTITION (dt='${do_date}')
SELECT
    province_id,
    brand,
    channel,
    is_new,
    model,
    mid_id,
    operate_system,
    user_id,
    version_code,
    page_item,
    page_item_type,
    last_page_id,
    page_id,
    source_type,
    date_format(from_utc_timestamp(ts,'GMT+8'), 'yyyy-MM-dd') AS date_id,
    date_format(from_utc_timestamp(ts,'GMT+8'),' yyyy-MM-dd HH:mm:ss') AS view_time,
    -- 拼接字段，形成会话标识符session_id：每个设备ID + 每个会话开始时间点
    concat(mid_id, '-', last_value(session_start_point, TRUE) OVER (PARTITION BY mid_id ORDER BY ts)) AS session_id,
    during_time
FROM log
         LEFT JOIN province ON log.area_code = province.area_code;
SET hive.cbo.enable=true;
"

# todo 11. 用户域-用户注册-事务事实表
dwd_user_register_inc_sql="
WITH
    -- a. 用户数据
    user_data AS  (
        SELECT
            id AS user_id,
            create_time
        FROM ${APP}.ods_user_info_inc
        WHERE dt = '${do_date}' AND date_format(create_time, 'yyyy-MM-dd') = '${do_date}'
    ),
    -- b. 日志数据
    log AS (
        SELECT
            common.ar area_code,
            common.ba brand,
            common.ch channel,
            common.md model,
            common.mid mid_id,
            common.os operate_system,
            common.uid user_id,
            common.vc version_code
        FROM ${APP}.ods_log_inc
        WHERE dt = '${do_date}' AND page.page_id = 'register'
          AND common.uid IS NOT NULL
    ),
    -- c. 地区维度表
    province AS (
        SELECT
            id AS province_id,
            area_code
        FROM ${APP}.ods_base_province_full
        WHERE dt = '${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dwd_user_register_inc PARTITION(dt='${do_date}')
SELECT
    user_data.user_id,
    date_format(create_time,'yyyy-MM-dd') AS date_id,
    create_time,
    channel,
    province_id,
    version_code,
    mid_id,
    brand,
    model,
    operate_system
FROM user_data
LEFT JOIN log ON user_data.user_id = log.user_id
LEFT JOIN province ON log.area_code = province.area_code;
"

# todo 12. 用户域-用户登录-事务事实表
dwd_user_login_inc_sql="
WITH
    -- a. 原始日志数据
    log_data AS (
        SELECT
            common.uid user_id,
            common.ch channel,
            common.ar area_code,
            common.vc version_code,
            common.mid mid_id,
            common.ba brand,
            common.md model,
            common.os operate_system,
            ts,
            if(page.last_page_id IS NULL, ts, NULL) AS session_start_point
        FROM ${APP}.ods_log_inc
        WHERE dt = '${do_date}' AND page IS NOT NULL
    ),
    -- b. 会话日志数据
    session_log AS (
        SELECT
            user_id,
            channel,
            area_code,
            version_code,
            mid_id,
            brand,
            model,
            operate_system,
            ts,
            -- 每个会话标识session_id = mid_id  + session_start_point
            concat(
                    mid_id,
                    '-',
                    last_value(session_start_point, true) OVER (PARTITION BY mid_id ORDER BY ts)
            ) AS session_id
        FROM log_data
    ),
    -- c. 每行数据加上编号
    rk_data AS   (
        SELECT
            user_id,
            channel,
            area_code,
            version_code,
            mid_id,
            brand,
            model,
            operate_system,
            ts,
            row_number() OVER (PARTITION BY session_id ORDER BY ts) AS rn
        FROM session_log
        WHERE user_id IS NOT NULL
    ),
    -- d. 获取每个会话第1条数据
    first_data AS (
        SELECT
            user_id,
            channel,
            area_code,
            version_code,
            mid_id,
            brand,
            model,
            operate_system,
            ts
        FROM rk_data
        WHERE rn = 1
    ),
    -- d. 省份数据
    province AS (
        SELECT
            id province_id,
            area_code
        FROM ${APP}.ods_base_province_full
        WHERE dt='${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dwd_user_login_inc PARTITION(dt='${do_date}')
SELECT
    user_id,
    date_format(from_utc_timestamp(ts,'GMT+8'), 'yyyy-MM-dd') AS date_id,
    date_format(from_utc_timestamp(ts,'GMT+8'), 'yyyy-MM-dd HH:mm:ss') AS login_time,
    channel,
    province_id,
    version_code,
    mid_id,
    brand,
    model,
    operate_system
FROM first_data
         LEFT JOIN province ON first_data.area_code = province.area_code;
"


# 依据传递参数判断数据加载
case $1 in
"dwd_trade_cart_add_inc")
    hive -e "${hive_tuning_sql}${dwd_trade_cart_add_inc_sql}"
;;
"dwd_trade_order_detail_inc")
    hive -e "${dwd_trade_order_detail_inc_sql}"
;;
"dwd_trade_pay_detail_suc_inc")
    hive -e "${hive_tuning_sql}${dwd_trade_pay_detail_suc_inc_sql}"
;;
"dwd_trade_cart_full")
    hive -e "${hive_tuning_sql}${dwd_trade_cart_full_sql}"
;;
"dwd_tool_coupon_get_inc")
    hive -e "${hive_tuning_sql}${dwd_tool_coupon_get_inc_sql}"
;;
"dwd_tool_coupon_order_inc")
    hive -e "${hive_tuning_sql}${dwd_tool_coupon_order_inc_sql}"
;;
"dwd_tool_coupon_pay_inc")
    hive -e "${hive_tuning_sql}${dwd_tool_coupon_pay_inc_sql}"
;;
"dwd_interaction_favor_add_inc")
    hive -e "${hive_tuning_sql}${dwd_interaction_favor_add_inc_sql}"
;;
"dwd_interaction_comment_inc")
    hive -e "${hive_tuning_sql}${dwd_interaction_comment_inc_sql}"
;;
"dwd_traffic_page_view_inc")
    hive -e "${hive_tuning_sql}${dwd_traffic_page_view_inc_sql}"
;;
"dwd_user_register_inc")
    hive -e "${hive_tuning_sql}${dwd_user_register_inc_sql}"
;;
"dwd_user_login_inc")
    hive -e "${hive_tuning_sql}${dwd_user_login_inc_sql}"
;;
"all")
    hive -e "${dwd_trade_order_detail_inc_sql}"
    hive -e "${hive_tuning_sql}${dwd_trade_cart_add_inc_sql}${dwd_trade_order_detail_inc_sql}${dwd_trade_pay_detail_suc_inc_sql}${dwd_trade_cart_full_sql}${dwd_tool_coupon_get_inc_sql}${dwd_tool_coupon_order_inc_sql}${dwd_tool_coupon_pay_inc_sql}${dwd_user_register_inc_sql}${dwd_user_login_inc_sql}${dwd_interaction_favor_add_inc_sql}${dwd_interaction_comment_inc_sql}"
    #hive -e "${hive_tuning_sql}${dwd_traffic_page_view_inc_sql}"
esac

#
#step1. 执行权限
# chmod +x ods_to_dwd.sh
#step2. 某天数据，加载到某张表
# sh ods_to_dwd.sh dwd_trade_order_detail_inc 2024-04-19
#step3. 某天数据，加载所有表
# sh ods_to_dwd.sh all 2024-04-19
#

