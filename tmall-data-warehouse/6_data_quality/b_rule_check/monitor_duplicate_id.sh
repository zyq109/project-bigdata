#!/usr/bin/env bash
# -*- coding: utf-8 -*-


# 监控某张表一列的重复值
# 参数解析
while getopts "t:d:c:s:x:l:" arg; do
  case $arg in
  # 要处理的表名
  t)
    TABLE=$OPTARG
    ;;
  # 日期
  d)
    DT=$OPTARG
    ;;
  # 要计算重复值的列名
  c)
    COL=$OPTARG
    ;;
  # 重复值指标下限
  s)
    MIN=$OPTARG
    ;;
  # 重复值指标上限
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
mysql_tbl="monitor_report_duplicate_id"

# 重复值个数
RESULT=$($HIVE_ENGINE -e "set hive.cli.print.header=false;SELECT count(1) FROM (SELECT $COL FROM $HIVE_DB.$TABLE WHERE dt='$DT' GROUP BY $COL HAVING count($COL)>1) t1;")

# 将结果插入MySQL
mysql -h"$mysql_host" -u"$mysql_user" -p"$mysql_passwd" \
  -e"INSERT INTO $mysql_db.$mysql_tbl VALUES('$DT', '$TABLE', '$COL', $RESULT, $MIN, $MAX, $LEVEL)
ON DUPLICATE KEY UPDATE \`value\`=$RESULT, value_min=$MIN, value_max=$MAX, notification_level=$LEVEL;"
