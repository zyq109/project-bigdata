#!/bin/bash

/opt/module/sqoop/bin/sqoop export \
--connect "jdbc:mysql://node101:3306/gmall_report?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password 123456 \
--table ads_traffic_stats_by_channel \
--num-mappers 1 \
--export-dir /warehouse/gmall/ads/ads_traffic_stats_by_channel \
--input-fields-terminated-by "\t" \
--update-mode allowinsert \
--update-key "dt,recent_days,channel" \
--input-null-string '\\N'    \
--input-null-non-string '\\N'

#
# chmod u+x log_ads_to_mysql.sh
# log_ads_to_mysql.sh
#
