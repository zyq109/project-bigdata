#!/bin/bash

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ] ;then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi


dws_sql="
SET hive.stats.autogather=false;
INSERT OVERWRITE TABLE gmall.dws_traffic_session_page_view_1d PARTITION(dt = '${do_date}')
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
FROM gmall.dwd_traffic_page_view_inc
WHERE dt = '${do_date}'
GROUP BY session_id, mid_id, brand, model, operate_system, version_code, channel;
"

/opt/module/hive/bin/hive -e "${dws_sql}"

#
# chmod u+x log_dwd_to_dws.sh
# log_dwd_to_dws.sh  2024-04-11
#
