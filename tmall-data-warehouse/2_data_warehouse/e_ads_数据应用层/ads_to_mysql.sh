#!/bin/bash

APP=gmall_report
CMD=/opt/module/sqoop/bin/sqoop

declare -A table_update_keys
table_update_keys=(
    ["ads_traffic_stats_by_channel"]="dt, recent_days, channel"
    ["ads_page_path"]="dt, recent_days, source, target"
    ["ads_user_change"]="dt"
    ["ads_user_retention"]="dt, create_date, retention_day"
    ["ads_user_stats"]="dt, recent_days"
    ["ads_user_action"]="dt, recent_days"
    ["ads_order_continuously_user_count"]="dt, recent_days"
    ["ads_repeat_purchase_by_tm"]="dt, recent_days, tm_id"
    ["ads_order_stats_by_tm"]="dt, recent_days, tm_id"
    ["ads_order_stats_by_cate"]="dt, recent_days, category1_id, category2_id, category3_id"
    ["ads_sku_cart_num_top3_by_cate"]="dt, sku_id, category1_id, category2_id, category3_id"
    ["ads_sku_favor_count_top3_by_tm"]="dt, tm_id, sku_id"
    ["ads_trade_stats"]="dt, recent_days"
    ["ads_order_by_province"]="dt, recent_days, province_id"
    ["ads_coupon_stats"]="dt, coupon_id"
)

export_data(){
    table_name=$1
    update_key=${table_update_keys[$table_name]}
    ${CMD} export \
           --connect "jdbc:mysql://node101:3306/${APP}?useUnicode=true&characterEncoding=utf-8" \
           --username root \
           --password 123456 \
           --table "$table_name" \
           --export-dir /warehouse/gmall/ads/"$table_name" \
           --input-fields-terminated-by "\t" \
           --update-mode allowinsert \
           --update-key "$update_key" \
           --num-mappers 1 \
           --null-string '\\N' \
           --null-non-string '\\N'
}

# 创建函数来处理每个表的导出
function export_table() {
    table_name=$1
    export_data "$table_name"
}

case $1 in
    "ads_traffic_stats_by_channel")
        export_table "ads_traffic_stats_by_channel"
    ;;
    "ads_page_path")
        export_table "ads_page_path"
    ;;
    "ads_user_change")
        export_table "ads_user_change"
    ;;
    "ads_user_retention")
        export_table "ads_user_retention"
    ;;
    "ads_user_stats")
        export_table "ads_user_stats"
    ;;
    "ads_user_action")
        export_table "ads_user_action"
    ;;
    "ads_order_continuously_user_count")
        export_table "ads_order_continuously_user_count"
    ;;
    "ads_repeat_purchase_by_tm")
        export_table "ads_repeat_purchase_by_tm"
    ;;
    "ads_order_stats_by_tm")
        export_table "ads_order_stats_by_tm"
    ;;
    "ads_order_stats_by_cate")
        export_table "ads_order_stats_by_cate"
    ;;
    "ads_sku_cart_num_top3_by_cate")
        export_table "ads_sku_cart_num_top3_by_cate"
    ;;
    "ads_sku_favor_count_top3_by_tm")
        export_table "ads_sku_favor_count_top3_by_tm"
    ;;
    "ads_trade_stats")
        export_table "ads_trade_stats"
    ;;
    "ads_order_by_province")
        export_table "ads_order_by_province"
    ;;
    "ads_coupon_stats")
        export_table "ads_coupon_stats"
    ;;
    "all")
        export_table "ads_traffic_stats_by_channel"
        export_table "ads_page_path"
        export_table "ads_user_change"
        export_table "ads_user_retention"
        export_table "ads_user_stats"
        export_table "ads_user_action"
        export_table "ads_order_continuously_user_count"
        export_table "ads_repeat_purchase_by_tm"
        export_table "ads_order_stats_by_tm"
        export_table "ads_order_stats_by_cate"
        export_table "ads_sku_cart_num_top3_by_cate"
        export_table "ads_sku_favor_count_top3_by_tm"
        export_table "ads_trade_stats"
        export_table "ads_order_by_province"
        export_table "ads_coupon_stats"
    ;;
esac