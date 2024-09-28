#!/bin/bash

# 脚本参数说明：
#   第1个参数$1，表示日期，同步某一天数据，从ODS层提取加载到DWD层

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ] ;then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi

# DWD层页面page日志加载语句
dwd_sql="
SET hive.stats.autogather=false;
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
            if(page.last_page_id IS NULL, ts, NULL) AS session_start_point
        FROM gmall.ods_log_inc
        WHERE dt = '${do_date}' AND page IS NOT NULL
    ),
    -- b. 省份信息表
    province AS (
        SELECT
            id AS province_id,
            area_code
        FROM gmall.ods_base_province_full
        WHERE dt = '${do_date}'
    )
INSERT OVERWRITE TABLE gmall.dwd_traffic_page_view_inc PARTITION (dt='${do_date}')
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
LEFT JOIN province ON log.area_code = province.area_code
;
SET hive.cbo.enable=true;
"

/opt/module/hive/bin/hive -e "${dwd_sql}"

#
# chmod u+x log_ods_to_dwd.sh
# log_ods_to_dwd.sh  2024-04-11
#
