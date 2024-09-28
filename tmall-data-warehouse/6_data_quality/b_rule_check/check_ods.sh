#!/usr/bin/env bash


DT=$1
[ "$DT" ] || DT=$(date -d '-1 day' +%F)

# ====================================== ODS层：ods_order_info_inc 规则检查 ======================================
#检查表 ods_order_info_inc 数据量日环比增长
#参数： -t 表名
#      -d 日期
#      -s 环比增长下限
#      -x 环比增长上限
#      -l 告警级别
bash monitor_day_on_day_volume.sh -t ods_order_info_inc -d "$DT" -s -10 -x 10 -l 1

#检查表 ods_order_info_inc 数据量周同比增长
#参数： -t 表名
#      -d 日期
#      -s 同比增长下限
#      -x 同比增长上限
#      -l 告警级别
bash monitor_week_on_week_volume.sh -t ods_order_info_inc -d "$DT" -s -10 -x 50 -l 1

#检查表 ods_order_info_inc 订单异常值
#参数： -t 表名
#      -d 日期
#      -s 指标下限
#      -x 指标上限
#      -l 告警级别
#      -a 值域下限
#      -b 值域上限
bash monitor_range_value.sh -t ods_order_info_inc -d "$DT" -c original_total_amount -a 0 -b 100000 -s 0 -x 100 -l 1


# ====================================== ODS层：ods_order_detail_inc 规则检查 ======================================


