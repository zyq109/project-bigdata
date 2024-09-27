#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ] ;then
    do_date=$2
else
    do_date=`date -d "-1 day" +%F`
fi

#todo 1.1 各渠道-流量统计
ads_traffic_stats_by_channel_sql="
-- step5. 插入保存
INSERT OVERWRITE TABLE ${APP}.ads_traffic_stats_by_channel
-- step4. 历史统计
SELECT dt, recent_days, channel, uv_count, avg_duration_sec, avg_page_count, sv_count, bounce_rate
FROM ${APP}.ads_traffic_stats_by_channel
UNION
-- step1. 最近1日统计
SELECT
    '${do_date}' AS dt
     , 1 AS recent_days
     , channel
     , count(DISTINCT (mid_id)) AS uv_count
     , round(avg(during_time_1d / 1000), 2) AS avg_duration_sec
     , ceil(avg(page_count_1d)) AS avg_page_count
     , count(session_id) AS sv_count
     -- 跳出数：某个会话中pv=1，此会话为跳出会话
     --, sum(if(page_count_1d = 1, 1, 0)) AS bounce_count
     -- 跳出率 = 跳出数 / 会话数
	 --page_count_1d = 应该等于1 因为没有1的数据采用54来代替
     ,round(sum(if(page_count_1d = 1, 1, 0)) / count(session_id), 4) AS bounce_rate
FROM ${APP}.dws_traffic_session_page_view_1d
WHERE dt = '${do_date}'
GROUP BY channel
UNION ALL
-- step2. 最近7日统计
SELECT
    '${do_date}' AS dt
     , 7 AS recent_days
     , channel
     , count(DISTINCT (mid_id)) AS uv_count
     , round(avg(during_time_1d / 1000), 2) AS avg_duration_sec
     , ceil(avg(page_count_1d)) AS avg_page_count
     , count(session_id) AS sv_count
     -- 跳出数：某个会话中pv=1，此会话为跳出会话
     --, sum(if(page_count_1d = 1, 1, 0)) AS bounce_count
     -- 跳出率 = 跳出数 / 会话数
     ,round(sum(if(page_count_1d = 1, 1, 0)) / count(session_id), 4) AS bounce_rate
FROM ${APP}.dws_traffic_session_page_view_1d
WHERE dt >= date_sub('${do_date}', 6) AND dt <= '${do_date}'
GROUP BY channel
UNION ALL
-- step3. 最近30日统计
SELECT
    '${do_date}' AS dt
     , 30 AS recent_days
     , channel
     , count(DISTINCT (mid_id)) AS uv_count
     , round(avg(during_time_1d / 1000), 2) AS avg_duration_sec
     , ceil(avg(page_count_1d)) AS avg_page_count
     , count(session_id) AS sv_count
     -- 跳出率 = 跳出数 / 会话数
     ,round(sum(if(page_count_1d = 1, 1, 0)) / count(session_id), 4) AS bounce_rate
FROM ${APP}.dws_traffic_session_page_view_1d
WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
GROUP BY channel;
"

#-- todo 1.2 路径分析
ads_page_path_sql="
WITH
   -- todo 第1、最近1日统计
    tmp_1d1 AS (
        -- step1. 会话中数据加序号和页面ID
        SELECT
            session_id, view_time, last_page_id
             , page_id
             -- 使用lead开窗函数，向下获取下一个访问页面编号
             , lead(page_id, 1) over (PARTITION BY session_id ORDER BY view_time) AS next_page_id
             -- 加序号，某个Session会话访问页面编号
             , row_number() over (PARTITION BY session_id ORDER BY view_time) AS rk
        FROM ${APP}.dwd_traffic_page_view_inc
        WHERE dt = '${do_date}'
    )
   , tmp_1d2 AS (
        -- step2. 拼接字符串，确定访问路径顺序
        SELECT
            concat('step-', rk, ':', page_id) AS source_page
             , concat('step-', rk + 1, ':', next_page_id) AS target_page
        FROM tmp_1d1
    )
   , stats_1d AS (
        -- step3. 分组聚合
        SELECT
            source_page, target_page, count(*) AS path_count
        FROM tmp_1d2
        GROUP BY source_page, target_page
    )
   -- todo 第2、最近7日统计
   , tmp_7d1 AS (
        -- step1. 会话中数据加序号和页面ID
        SELECT
            session_id, view_time, last_page_id
           , page_id
            -- 使用lead开窗函数，向下获取下一个访问页面编号
           , lead(page_id, 1) over (PARTITION BY session_id ORDER BY view_time) AS next_page_id
            -- 加序号，某个Session会话访问页面编号
           , row_number() over (PARTITION BY session_id ORDER BY view_time) AS rk
        FROM ${APP}.dwd_traffic_page_view_inc
        WHERE dt >= date_sub('${do_date}', 6) AND dt <= '${do_date}'
    )
   , tmp_7d2 AS (
        -- step2. 拼接字符串，确定访问路径顺序
        SELECT
            concat('step-', rk, ':', page_id) AS source_page
           , concat('step-', rk + 1, ':', next_page_id) AS target_page
        FROM tmp_7d1
    )
   , stats_7d AS (
        -- step3. 分组聚合
        SELECT
        source_page, target_page, count(*) AS path_count
        FROM tmp_7d2
        GROUP BY source_page, target_page
    )
   -- todo 第3、最近30日统计
   , tmp_30d1 AS (
        -- step1. 会话中数据加序号和页面ID
        SELECT
            session_id, view_time, last_page_id
             , page_id
             -- 使用lead开窗函数，向下获取下一个访问页面编号
             , lead(page_id, 1) over (PARTITION BY session_id ORDER BY view_time) AS next_page_id
             -- 加序号，某个Session会话访问页面编号
             , row_number() over (PARTITION BY session_id ORDER BY view_time) AS rk
        FROM ${APP}.dwd_traffic_page_view_inc
        WHERE dt >= date_sub('${do_date}', 29) AND dt <= '${do_date}'
    )
   , tmp_30d2 AS (
        -- step2. 拼接字符串，确定访问路径顺序
        SELECT
            concat('step-', rk, ':', page_id) AS source_page
             , concat('step-', rk + 1, ':', next_page_id) AS target_page
        FROM tmp_30d1
    )
   , stats_30d AS (
        -- step3. 分组聚合
        SELECT
            source_page, target_page, count(*) AS path_count
        FROM tmp_30d2
        GROUP BY source_page, target_page
    )
-- todo 第6、保存数据
INSERT OVERWRITE TABLE ${APP}.ads_page_path
-- todo 第5、历史统计
SELECT dt, recent_days, source, target, path_count FROM ${APP}.ads_page_path
UNION
-- todo 第4、合并最近1日、7日、30日统计
SELECT '${do_date}' AS dt, 1 AS recent_days, source_page, target_page, path_count FROM stats_1d
UNION ALL
SELECT '${do_date}' AS dt, 7 AS recent_days, source_page, target_page, path_count FROM stats_7d
UNION ALL
SELECT '${do_date}' AS dt, 30 AS recent_days, source_page, target_page, path_count FROM stats_30d
;"


case $1 in
  "ads_traffic_stats_by_channel_sql"){
        hive -e "${ads_traffic_stats_by_channel_sql}"
    };;
"ads_page_path_sql"){
          hive -e "${ads_page_path_sql}"
      };;

    "all"){
        hive -e "${ads_traffic_stats_by_channel_sql}${ads_page_path_sql}"
    };;
esac