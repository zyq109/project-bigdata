#!/usr/bin/env bash
# -*- coding: utf-8 -*-


# 计算一张表单日数据量环比增长值
# 参数解析
while getopts "t:d:s:x:l:" arg; do
  case $arg in
  # 要处理的表名
  t)
    TABLE=$OPTARG
    ;;
  # 日期
  d)
    DT=$OPTARG
    ;;
  # 环比增长指标下限
  s)
    MIN=$OPTARG
    ;;
  # 环比增长指标上限
  x)
    MAX=$OPTARG
    ;;
  # 告警级别
  l)
    LEVEL=$OPTARG
    ;;
  ?)
    echo "unkonw argument"
    exit 1
    ;;
  esac
done

#如果dt和level没有设置，那么默认值dt是昨天 告警级别是0
[ "$DT" ] || DT=$(date -d '-1 day' +%F)
[ "$LEVEL" ] || LEVEL=0

# 数仓DB名称
HIVE_DB=gmall

# 查询引擎
HIVE_ENGINE=hive

# MySQL相关配置
mysql_user="root"
mysql_passwd="123456"
mysql_host="node101"
mysql_db="data_supervisor"
mysql_tbl="monitor_report_day_on_day_volume"

# 昨日数据量
YESTERDAY=$($HIVE_ENGINE -e "set hive.cli.print.header=false; SELECT count(1) FROM $HIVE_DB.$TABLE WHERE dt=date_sub('$DT',1);")

# 今日数据量
TODAY=$($HIVE_ENGINE -e "set hive.cli.print.header=false;SELECT count(1) FROM $HIVE_DB.$TABLE WHERE dt='$DT';")

# 计算环比增长值
if [ "$YESTERDAY" -ne 0 ]; then
  # 命令：awk "BEGIN{print (10 - 5)/5 * 100}"  --> 计算结果  100
  RESULT=$(awk "BEGIN{print ($TODAY-$YESTERDAY)/$YESTERDAY*100}")
else
  RESULT=10000
fi

# 将结果写入MySQL表格
mysql -h"$mysql_host" -u"$mysql_user" -p"$mysql_passwd" \
  -e"INSERT INTO $mysql_db.$mysql_tbl VALUES('$DT', '$TABLE', $RESULT, $MIN, $MAX, $LEVEL)
ON DUPLICATE KEY UPDATE \`value\`=$RESULT, value_min=$MIN, value_max=$MAX, notification_level=$LEVEL;"

