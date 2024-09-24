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


# 依据传递参数判断数据加载
case $1 in
"dwd_traffic_page_view_inc")
    hive -e "${hive_tuning_sql}${dwd_traffic_page_view_inc_sql}"
;;
"all")
    hive -e "${hive_tuning_sql}${dwd_traffic_page_view_inc_sql}"
;;
esac

