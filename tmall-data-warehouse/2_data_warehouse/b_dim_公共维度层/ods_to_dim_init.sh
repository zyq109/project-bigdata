#!/bin/bash

APP=gmall

if [ -n "$2" ] ;then
    do_date=$2
else
  echo "请传入日期参数"
  exit
fi

# todo 用户维度表 (首日)
dim_user_sql="
    SET hive.exec.dynamic.partition = true;
    SET hive.exec.dynamic.partition.mode = nonstrict;
    SET hive.stats.autogather = false;
    INSERT OVERWRITE TABLE ${APP}.dim_user_zip PARTITION (dt)
    SELECT
        id, login_name, nick_name
         , md5(name) AS name, md5(phone_num) AS phone_num, md5(email) AS email
         , user_level, birthday, gender, create_time, operate_time
         , '${do_date}' AS start_date
         , '9999-12-31' AS end_date
         , '9999-12-31' AS dt
    FROM ${APP}.ods_user_info_inc
    WHERE dt = '${do_date}'
    ;
"

case $1 in
  "dim_activity"){
    hive -e "${dim_user_sql}"
  };;
  "all"){
    hive -e "${dim_user_sql}"
  };;
esac