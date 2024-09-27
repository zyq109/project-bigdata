
-- =============================================================================
-- todo 1.1 各渠道流量统计：ads_traffic_stats_by_channel
-- =============================================================================
/*
统计周期	    统计粒度	指标	            说明                      解释
最近1/7/30日	渠道	    访客数	        统计访问人数                UV，有多少用户
最近1/7/30日	渠道	    会话平均停留时长	统计每个会话平均停留时长      计算每个会话时长，再求平均值
最近1/7/30日	渠道	    会话平均浏览页面数	统计每个会话平均浏览页面数    计算每个会话PV（流量页面个数），再求平均值
最近1/7/30日	渠道	    会话总数	        统计会话总数                计算会话个数
最近1/7/30日	渠道	    跳出率	        只有一个页面的会话的比例      跳出数：每个会话只有一个页面，计数为1；跳出率 = 跳出数 / 会话数
*/
/*
    `dt`               STRING COMMENT '统计日期',
    , `recent_days`      BIGINT COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    , `channel`          STRING COMMENT '渠道',
    , `uv_count`         BIGINT COMMENT '访客人数',
    , `avg_duration_sec` BIGINT COMMENT '会话平均停留时长，单位为秒',
    , `avg_page_count`   BIGINT COMMENT '会话平均浏览页面数',
    , `sv_count`         BIGINT COMMENT '会话数',
    , `bounce_rate`      DECIMAL(16, 2) COMMENT '跳出率'
*/
-- step5. 插入保存
INSERT OVERWRITE TABLE gmall.ads_traffic_stats_by_channel
-- step4. 历史统计
SELECT
    dt, recent_days, channel, uv_count, avg_duration_sec, avg_page_count, sv_count, bounce_rate
FROM gmall.ads_traffic_stats_by_channel
UNION
-- step1. 最近1日统计
SELECT
    '2024-09-13' AS dt
     , 1 AS recent_days
     , channel
     , count(DISTINCT (mid_id)) AS uv_count
     , round(avg(during_time_1d / 1000), 2) AS avg_duration_sec
     , ceil(avg(page_count_1d)) AS avg_page_count
     , count(session_id) AS sv_count
     -- 跳出数：某个会话中pv=1，此会话为跳出会话
     --, sum(if(page_count_1d = 1, 1, 0)) AS bounce_count
     -- 跳出率 = 跳出数 / 会话数
     ,round(sum(if(page_count_1d = 1, 1, 0)) / count(session_id), 4) AS bounce_rate
FROM gmall.dws_traffic_session_page_view_1d
WHERE dt = '2024-09-13'
GROUP BY channel
UNION ALL
-- step2. 最近7日统计
SELECT
    '2024-09-13' AS dt
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
FROM gmall.dws_traffic_session_page_view_1d
WHERE dt >= date_sub('2024-09-13', 6) AND dt <= '2024-09-13'
GROUP BY channel
UNION ALL
-- step3. 最近30日统计
SELECT
    '2024-09-13' AS dt
     , 30 AS recent_days
     , channel
     , count(DISTINCT (mid_id)) AS uv_count
     , round(avg(during_time_1d / 1000), 2) AS avg_duration_sec
     , ceil(avg(page_count_1d)) AS avg_page_count
     , count(session_id) AS sv_count
     -- 跳出率 = 跳出数 / 会话数
     ,round(sum(if(page_count_1d = 1, 1, 0)) / count(session_id), 4) AS bounce_rate
FROM gmall.dws_traffic_session_page_view_1d
WHERE dt >= date_sub('2024-09-13', 29) AND dt <= '2024-09-13'
GROUP BY channel
;


-- =============================================================================
-- todo 1.2 路径分析
-- =============================================================================
/*
    桑基图需要我们提供每种页面跳转的次数，每个跳转由source/target表示，source指跳转起始页面，target表示跳转终到页面。
        `source`      STRING COMMENT '跳转起始页面ID',
        `target`      STRING COMMENT '跳转终到页面ID',
        `path_count`  BIGINT COMMENT '跳转次数'
*/

WITH
   -- todo 第1、最近1日统计
   -- step1. 会话中数据加序号和页面ID
    tmp_1d1 AS (
        SELECT
            session_id, view_time, last_page_id
             , page_id
             -- 使用lead开窗函数，向下获取下一个访问页面编号
             , lead(page_id, 1) over (PARTITION BY session_id ORDER BY view_time) AS next_page_id
             -- 加序号，某个Session会话访问页面编号
             , row_number() over (PARTITION BY session_id ORDER BY view_time) AS rk
        FROM gmall.dwd_traffic_page_view_inc
        WHERE dt = '2024-09-11'
    )
   -- step2. 拼接字符串，确定访问路径顺序
   , tmp_1d2 AS (
        SELECT
            concat('step-', rk, ':', page_id) AS source_page
             , concat('step-', rk + 1, ':', next_page_id) AS target_page
        FROM tmp_1d1
    )
   -- step3. 分组聚合
   , stats_1d AS (
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
        FROM gmall.dwd_traffic_page_view_inc
        WHERE dt >= date_sub('2024-09-11', 6) AND dt <= '2024-09-11'
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
        FROM gmall.dwd_traffic_page_view_inc
        WHERE dt >= date_sub('2024-09-11', 29) AND dt <= '2024-09-11'
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
INSERT OVERWRITE TABLE gmall.ads_page_path
-- todo 第5、历史统计
SELECT dt, recent_days, source, target, path_count FROM gmall.ads_page_path
UNION
-- todo 第4、合并最近1日、7日、30日统计
SELECT '2024-09-11' AS dt, 1 AS recent_days, source_page, target_page, path_count FROM stats_1d
UNION ALL
SELECT '2024-09-11' AS dt, 7 AS recent_days, source_page, target_page, path_count FROM stats_7d
UNION ALL
SELECT '2024-09-11' AS dt, 30 AS recent_days, source_page, target_page, path_count FROM stats_30d
;



-- ================================= 最近1日统计 =================================
WITH
    tmp_1d1 AS (
        -- step1. 会话中数据加序号和页面ID
        SELECT
            session_id, view_time, last_page_id
             , page_id
             -- 使用lead开窗函数，向下获取下一个访问页面编号
             , lead(page_id, 1) over (PARTITION BY session_id ORDER BY view_time) AS next_page_id
             -- 加序号，某个Session会话访问页面编号
             , row_number() over (PARTITION BY session_id ORDER BY view_time) AS rk
        FROM gmall.dwd_traffic_page_view_inc
        WHERE dt = '2024-09-11'
    )
    , tmp_1d2 AS (
        -- step2. 拼接字符串，确定访问路径顺序
        SELECT
            concat('step-', rk, ':', page_id) AS source_page
             , concat('step-', rk + 1, ':', next_page_id) AS target_page
        FROM tmp_1d1
    )
    -- step3. 分组聚合
    SELECT
        source_page, target_page, count(*) AS path_count
    FROM tmp_1d2
    GROUP BY source_page, target_page
;



