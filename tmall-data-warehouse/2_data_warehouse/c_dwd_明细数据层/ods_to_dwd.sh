#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=$(date -d "-1 day" +%F)
fi



# todo 1. 交易域-加购-事务事实表 dwd_trade_cart_add_inc (每日)
#    主表：
#        加购表 ods_cart_info_inc
#    相关表：
#        字典表 ods_base_dic_full
dwd_trade_cart_add_sql="
    WITH
        cart AS (
            SELECT
                id,
                user_id,
                sku_id,
                date_format(if(operate_time IS NOT NULL, operate_time, create_time), 'yyyy-MM-dd') AS date_id,
                if(operate_time IS NOT NULL, operate_time, create_time) AS create_time,
                source_id,
                source_type source_type_code,
                sku_num
            FROM ${APP}.ods_cart_info_inc
            WHERE dt='${do_date}'
        ),
        dic AS (
            SELECT
                dic_code,
                dic_name source_type_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='24'
        )
    INSERT OVERWRITE TABLE ${APP}.dwd_trade_cart_add_inc PARTITION(dt='${do_date}')
    SELECT
        id,
        user_id,
        sku_id,
        date_id,
        create_time,
        source_id,
        source_type_code,
        source_type_name,
        sku_num
    FROM cart
             LEFT JOIN dic ON cart.source_type_code=dic.dic_code
    ;
"

#-- todo 2 交易域-下单-事务事实表 dwd_trade_order_detail_inc (每日)
#    主表：
#        订单明细表 ods_order_detail_inc
#    相关表：
#        订单信息表 ods_order_info_inc
#        订单明细活动关联表 ods_order_detail_activity_inc
#        订单明细优惠关联表 ods_order_detail_coupon_inc
#        字典表 ods_base_dic_full
dwd_trade_order_detail_sql="
    WITH
        od AS (
            SELECT
                id,
                order_id,
                sku_id,
                date_format(create_time, 'yyyy-MM-dd') date_id,
                create_time,
                source_id,
                source_type,
                sku_num,
                sku_num * order_price split_original_amount,
                split_total_amount,
                split_activity_amount,
                split_coupon_amount
            FROM ${APP}.ods_order_detail_inc
            WHERE dt = '${do_date}'
        ),
        oi AS (
            SELECT
                id,
                user_id,
                province_id
            FROM ${APP}.ods_order_info_inc
            WHERE dt = '${do_date}'
        ),
        act AS (
            SELECT
                order_detail_id,
                activity_id,
                activity_rule_id
            FROM ${APP}.ods_order_detail_activity_inc
            WHERE dt = '${do_date}'
        ),
        cou AS (
            SELECT
                order_detail_id,
                coupon_id
            FROM ${APP}.ods_order_detail_coupon_inc
            WHERE dt = '${do_date}'
        ),
        dic AS (
            SELECT
                dic_code,
                dic_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='24'
        )
    INSERT OVERWRITE TABLE ${APP}.dwd_trade_order_detail_inc PARTITION (dt='${do_date}')
    SELECT
        od.id,
        order_id,
        user_id,
        sku_id,
        province_id,
        activity_id,
        activity_rule_id,
        coupon_id,
        date_id,
        create_time,
        source_id,
        source_type,
        dic_name,
        sku_num,
        split_original_amount,
        split_activity_amount,
        split_coupon_amount,
        split_total_amount
    FROM od
             LEFT JOIN oi ON od.order_id = oi.id
             LEFT JOIN act ON od.id = act.order_detail_id
             LEFT JOIN cou ON od.id = cou.order_detail_id
             LEFT JOIN dic ON od.source_type=dic.dic_code
    ;
"

#-- todo 3. 交易域-支付成功-事务事实表 dwd_trade_pay_detail_suc_inc (每日)
dwd_trade_pay_detail_suc_sql="
    WITH
        od AS (
            SELECT
                id,
                order_id,
                sku_id,
                source_id,
                source_type,
                sku_num,
                sku_num * order_price split_original_amount,
                split_total_amount,
                split_activity_amount,
                split_coupon_amount
            FROM ${APP}.ods_order_detail_inc
            WHERE (dt = '${do_date}' or dt = date_add('${do_date}',-1))
        ),
        pi AS (
            SELECT
                user_id,
                order_id,
                payment_type,
                callback_time
            FROM ${APP}.ods_payment_info_inc
            WHERE dt='${do_date}'
              AND payment_status='1602'
        ),
        oi AS (
            SELECT
                id,
                province_id
            FROM ${APP}.ods_order_info_inc
            WHERE (dt = '${do_date}' or dt = date_add('${do_date}',-1))
        ),
        act AS (
            SELECT
                order_detail_id,
                activity_id,
                activity_rule_id
            FROM ${APP}.ods_order_detail_activity_inc
            WHERE (dt = '${do_date}' or dt = date_add('${do_date}',-1))
        ),
        cou AS (
            SELECT
                order_detail_id,
                coupon_id
            FROM ${APP}.ods_order_detail_coupon_inc
            WHERE (dt = '${do_date}' or dt = date_add('${do_date}',-1))
        ),
        pay_dic AS (
            SELECT
                dic_code,
                dic_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='11'
        ),
        src_dic AS (
            SELECT
                dic_code,
                dic_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='24'
        )
    INSERT OVERWRITE TABLE ${APP}.dwd_trade_pay_detail_suc_inc PARTITION (dt='${do_date}')
    SELECT
        od.id,
        od.order_id,
        pi.user_id,
        sku_id,
        province_id,
        activity_id,
        activity_rule_id,
        coupon_id,
        pi.payment_type,
        pay_dic.dic_name,
        date_format(pi.callback_time,'yyyy-MM-dd') date_id,
        pi.callback_time,
        source_id,
        source_type,
        src_dic.dic_name,
        sku_num,
        split_original_amount,
        split_activity_amount,
        split_coupon_amount,
        split_total_amount
    FROM od
             JOIN pi ON od.order_id=pi.order_id
             LEFT JOIN oi ON od.order_id = oi.id
             LEFT JOIN act ON od.id = act.order_detail_id
             LEFT JOIN cou ON od.id = cou.order_detail_id
             LEFT JOIN pay_dic ON pi.payment_type=pay_dic.dic_code
             LEFT JOIN src_dic ON od.source_type=src_dic.dic_code
    ;
"

#-- todo  4 交易域-购物车-周期快照事实表 dwd_trade_cart_full (每日)
dwd_trade_cart_sql="
    INSERT OVERWRITE TABLE ${APP}.dwd_trade_cart_full PARTITION(dt='${do_date}')
    SELECT
        id,
        user_id,
        sku_id,
        sku_name,
        sku_num
    FROM ${APP}.ods_cart_info_inc
    WHERE dt='${do_date}'
      AND is_ordered='0'
    ;
"

#-- todo 5 工具域-优惠券领取-事务事实表 dwd_tool_coupon_get_inc (每日)
dwd_tool_coupon_get_sql="
    INSERT OVERWRITE TABLE ${APP}.dwd_tool_coupon_get_inc PARTITION (dt='${do_date}')
    SELECT
        id,
        coupon_id,
        user_id,
        date_format(get_time,'yyyy-MM-dd') date_id,
        get_time
    FROM ${APP}.ods_coupon_use_inc
    WHERE dt='${do_date}'
    ;
"

#-- todo 6 工具域-优惠券使用(下单)-事务事实表 dwd_tool_coupon_order_inc (每日)
dwd_tool_coupon_order_sql="
    INSERT OVERWRITE TABLE ${APP}.dwd_tool_coupon_order_inc PARTITION(dt='${do_date}')
    SELECT
        id,
        coupon_id,
        user_id,
        order_id,
        date_format(using_time,'yyyy-MM-dd') date_id,
        using_time
    FROM ${APP}.ods_coupon_use_inc
    WHERE dt='${do_date}'
    ;
"

#-- todo 7 工具域-优惠券使用(支付)-事务事实表 dwd_tool_coupon_pay_inc (每日)
dwd_tool_coupon_pay_sql="
    INSERT OVERWRITE TABLE ${APP}.dwd_tool_coupon_pay_inc PARTITION(dt='${do_date}')
    SELECT
        id,
        coupon_id,
        user_id,
        order_id,
        date_format(used_time,'yyyy-MM-dd') date_id,
        used_time
    FROM ${APP}.ods_coupon_use_inc
    WHERE dt='${do_date}'
    ;
"

#-- todo 8 互动域-收藏商品-事务事实表 dwd_interaction_favor_add_inc (每日)
dwd_interaction_favor_add_sql="
    INSERT OVERWRITE TABLE ${APP}.dwd_interaction_favor_add_inc PARTITION(dt='${do_date}')
    SELECT
        id,
        user_id,
        sku_id,
        date_format(create_time,'yyyy-MM-dd') date_id,
        create_time
    FROM ${APP}.ods_favor_info_inc
    WHERE dt='${do_date}'
    ;
"


#-- todo 9 互动域-评价-事务事实表 dwd_interaction_comment_inc (每日)
dwd_interaction_comment_sql="
    WITH
        ci AS (
            SELECT
                id,
                user_id,
                sku_id,
                order_id,
                create_time,
                appraise
            FROM ${APP}.ods_comment_info_inc
            WHERE dt='${do_date}'
        ),
        dic AS (
            SELECT
                dic_code,
                dic_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='12'
        )
    INSERT OVERWRITE TABLE ${APP}.dwd_interaction_comment_inc PARTITION(dt='${do_date}')
    SELECT
        id,
        user_id,
        sku_id,
        order_id,
        date_format(create_time,'yyyy-MM-dd') date_id,
        create_time,
        appraise,
        dic_name
    FROM ci
             LEFT JOIN dic ON ci.appraise=dic.dic_code
    ;
"

#-- todo 18 用户域-用户注册-事务事实表 dwd_user_register_inc (每日)
dwd_user_register_sql="
    WITH
        ui AS (
            SELECT
                id user_id,
                create_time
            FROM ${APP}.ods_user_info_inc
            WHERE dt='${do_date}'
        ),
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
            WHERE dt='${do_date}'
              AND page.page_id='register'
              AND common.uid is not null
        ),
        bp AS (
            SELECT
                id province_id,
                area_code
            FROM ${APP}.ods_base_province_full
            WHERE dt='${do_date}'
        )
    INSERT OVERWRITE TABLE ${APP}.dwd_user_register_inc PARTITION(dt='${do_date}')
    SELECT
        ui.user_id,
        date_format(create_time,'yyyy-MM-dd') date_id,
        create_time,
        channel,
        province_id,
        version_code,
        mid_id,
        brand,
        model,
        operate_system
    FROM ui
             LEFT JOIN log ON ui.user_id=log.user_id
             LEFT JOIN bp ON log.area_code=bp.area_code
    ;
"

#-- todo 19 用户域-用户登录-事务事实表 dwd_user_login_inc (每日)
dwd_user_login_sql="
    WITH
    -- 最内层子查询
    t1 AS (
        SELECT
            common.uid AS user_id,
            common.ch AS channel,
            common.ar AS area_code,
            common.vc AS version_code,
            common.mid AS mid_id,
            common.ba AS brand,
            common.md AS model,
            common.os AS operate_system,
            ts,
            IF(page.last_page_id IS NULL, ts, NULL) AS session_start_point
        FROM ${APP}.ods_log_inc
        WHERE dt = '${do_date}'
          AND page IS NOT NULL
    ),
    -- 第二层子查询
    t2 AS (
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
            CONCAT(mid_id, '-', LAST_VALUE(session_start_point, TRUE) OVER (PARTITION BY mid_id ORDER BY ts)) AS session_id
        FROM t1
    ),
    -- 第三层子查询
    t3 AS (
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
            ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY ts) AS rn
        FROM t2
        WHERE user_id IS NOT NULL
    ),
    -- 第四层子查询
    t4 AS (
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
        FROM t3
        WHERE rn = 1
    ),
    -- 省份信息子查询
    bp AS (
        SELECT
            id AS province_id,
            area_code
        FROM ${APP}.ods_base_province_full
        WHERE dt = '${do_date}'
    )
    INSERT OVERWRITE TABLE ${APP}.dwd_user_login_inc PARTITION(dt='${do_date}')
    SELECT
        user_id,
        DATE_FORMAT(FROM_UTC_TIMESTAMP(ts, 'GMT+8'), 'yyyy-MM-dd') AS date_id,
        DATE_FORMAT(FROM_UTC_TIMESTAMP(ts, 'GMT+8'), 'yyyy-MM-dd HH:mm:ss') AS login_time,
        channel,
        bp.province_id,
        version_code,
        mid_id,
        brand,
        model,
        operate_system
    FROM t4
             LEFT JOIN bp ON t4.area_code = bp.area_code
    ;
"

case $1 in
      "trade_cart_add"){
        hive -e "${dwd_trade_cart_add_sql}"
    };;
      "trade_order_detail"){
        hive -e "${dwd_trade_order_detail_sql}"
    };;
      "trade_pay_detail_suc"){
        hive -e "${dwd_trade_pay_detail_suc_sql}"
    };;
      "trade_cart"){
        hive -e "${dwd_trade_cart_sql}"
    };;
      "tool_coupon_get"){
        hive -e "${dwd_tool_coupon_get_sql}"
    };;
      "tool_coupon_order"){
        hive -e "${dwd_tool_coupon_order_sql}"
    };;
      "tool_coupon_pay"){
        hive -e "${dwd_tool_coupon_pay_sql}"
    };;
      "interaction_favor_add"){
        hive -e "${dwd_interaction_favor_add_sql}"
    };;
      "interaction_comment"){
        hive -e "${dwd_interaction_comment_sql}"
    };;
      "user_register"){
        hive -e "${dwd_user_register_sql}"
    };;
      "user_login"){
        hive -e "${dwd_user_login_sql}"
    };;
      "all"){
        hive -e "
        ${dwd_trade_cart_add_sql};
        ${dwd_trade_order_detail_sql};
        ${dwd_trade_pay_detail_suc_sql};
        ${dwd_trade_cart_sql};
        ${dwd_tool_coupon_get_sql};
        ${dwd_tool_coupon_order_sql};
        ${dwd_tool_coupon_pay_sql};
        ${dwd_interaction_favor_add_sql};
        ${dwd_interaction_comment_sql};
        ${dwd_user_register_sql};
        ${dwd_user_login_sql};
        "
    };;
esac