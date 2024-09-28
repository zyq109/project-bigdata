#!/bin/bash

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ] ;then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi

ads_sql="
SET hive.stats.column.autogather = false ;
INSERT OVERWRITE TABLE gmall.ads_traffic_stats_by_channel
-- d. 获取主题表中历史数据
SELECT * FROM gmall.ads_traffic_stats_by_channel
UNION
-- a. 最近1日统计
SELECT
    '${do_date}' AS dt -- 统计日期
    , 1 AS recent_days -- 最近日数据
    , channel
    , cast(count(distinct mid_id) AS BIGINT) AS uv_count
    , cast(avg(during_time_1d) / 1000 AS BIGINT) AS avg_duration_sec
    , cast(avg(page_count_1d) AS BIGINT) AS avg_page_count
    , cast(count(*) AS BIGINT) AS sv_count
    , CAST(sum(if(page_count_1d = 1, 1, 0)) / count(1) AS DECIMAL(16, 2)) AS bounce_rate
FROM gmall.dws_traffic_session_page_view_1d
WHERE dt = '${do_date}'
GROUP BY channel
UNION ALL
-- b. 最近7日统计
SELECT
    '${do_date}' AS dt -- 统计日期
     , 7 AS recent_days -- 最近日数据
     , channel
     , cast(count(distinct mid_id) AS BIGINT) AS uv_count
     , cast(avg(during_time_1d) / 1000 AS BIGINT) AS avg_duration_sec
     , cast(avg(page_count_1d) AS BIGINT) AS avg_page_count
     , cast(count(*) AS BIGINT) AS sv_count
     , CAST(sum(if(page_count_1d = 1, 1, 0)) / count(1) AS DECIMAL(16, 2)) AS bounce_rate
FROM gmall.dws_traffic_session_page_view_1d
WHERE dt >= date_sub('${do_date}', 6) AND dt <= '${do_date}'
GROUP BY channel
UNION ALL
-- c. 最近30日统计
SELECT
    '${do_date}' AS dt -- 统计日期
     , 30 AS recent_days -- 最近日数据
     , channel
     , cast(count(distinct mid_id) AS BIGINT) AS uv_count
     , cast(avg(during_time_1d) / 1000 AS BIGINT) AS avg_duration_sec
     , cast(avg(page_count_1d) AS BIGINT) AS avg_page_count
     , cast(count(*) AS BIGINT) AS sv_count
     , CAST(sum(if(page_count_1d = 1, 1, 0)) / count(1) AS DECIMAL(16, 2)) AS bounce_rate
FROM gmall.dws_traffic_session_page_view_1d
WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
GROUP BY channel
;
"

/opt/module/hive/bin/hive -e "${ads_sql}"

#
# chmod u+x log_dws_to_ads_v1.sh
# log_dws_to_ads_v1.sh  2024-04-11
#
