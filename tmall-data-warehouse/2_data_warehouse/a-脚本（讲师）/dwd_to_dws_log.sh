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


# 依据传递参数判断数据加载
case $1 in
"dws_traffic_session_page_view_1d")
    hive -e "${hive_tuning_sql}${dws_traffic_session_page_view_1d_sql}"
;;
"dws_traffic_page_visitor_page_view_1d")
    hive -e "${hive_tuning_sql}${dws_traffic_page_visitor_page_view_1d_sql}"
;;
"all")
    hive -e "${hive_tuning_sql}${dws_traffic_session_page_view_1d_sql}${dws_traffic_page_visitor_page_view_1d_sql}"
;;
esac


#step1. 执行权限
# chmod +x dwd_to_dws_log.sh
#step2. 某天数据，加载到某张表
# sh dwd_to_dws_log.sh dws_traffic_session_page_view_1d 2024-09-11
#step3. 某天数据，加载所有表
# sh dwd_to_dws_log.sh all 2024-09-11
#

