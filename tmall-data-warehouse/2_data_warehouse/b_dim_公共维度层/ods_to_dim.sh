#!/bin/bash

APP=gmall

if [ -n "$2" ] ;then
    do_date=$2
else
  echo "请传入日期参数"
  exit
fi

# todo 1 商品维度表 dim_sku_full
#5 商品维度表
#    数据来源于：
#        ods_sku_info_full（全量） 和
#        ods_spu_info_full（全量） 和
#        ods_base_category3_full（全量） 和
#        ods_base_category2_full（全量） 和
#        ods_base_category1_full（全量） 和
#        ods_base_trademark_full（全量） 和
#        ods_sku_attr_value_full（全量） 和
#        ods_sku_sale_attr_value_full（全量） 合并
dim_sku_sql="
    SET hive.exec.dynamic.partition = true;
    SET hive.exec.dynamic.partition.mode = nonstrict;
    SET hive.stats.autogather = false;
    WITH
        sku AS (
            SELECT
                id,
                price,
                sku_name,
                sku_desc,
                weight,
                is_sale,
                spu_id,
                category3_id,
                tm_id,
                create_time
            FROM ${APP}.ods_sku_info_full
            WHERE dt='${do_date}'
        ),
        spu AS (
            SELECT
                id,
                spu_name
            FROM ${APP}.ods_spu_info_full
            WHERE dt='${do_date}'
        ),
        c3 AS (
            SELECT
                id,
                name,
                category2_id
            FROM ${APP}.ods_base_category3_full
            WHERE dt='${do_date}'
        ),
        c2 AS (
            SELECT
                id,
                name,
                category1_id
            FROM ${APP}.ods_base_category2_full
            WHERE dt='${do_date}'
        ),
        c1 AS (
            SELECT
                id,
                name
            FROM ${APP}.ods_base_category1_full
            WHERE dt='${do_date}'
        ),
        tm AS (
            SELECT
                id,
                tm_name
            FROM ${APP}.ods_base_trademark_full
            WHERE dt='${do_date}'
        ),
        attr AS (
            SELECT
                sku_id,
                collect_set(named_struct('attr_id',attr_id,'value_id',value_id,'attr_name',attr_name,'value_name',value_name)) AS attrs
            FROM ${APP}.ods_sku_attr_value_full
            WHERE dt='${do_date}'
            GROUP BY sku_id
        ),
        sale_attr AS (
            SELECT
                sku_id,
                collect_set(named_struct('sale_attr_id',sale_attr_id,'sale_attr_value_id',sale_attr_value_id,'sale_attr_name',sale_attr_name,'sale_attr_value_name',sale_attr_value_name)) AS sale_attrs
            FROM ${APP}.ods_sku_sale_attr_value_full
            WHERE dt='${do_date}'
            GROUP BY sku_id
        )
    INSERT OVERWRITE TABLE ${APP}.dim_sku_full PARTITION(dt='${do_date}')
    SELECT
        sku.id,
        sku.price,
        sku.sku_name,
        sku.sku_desc,
        sku.weight,
        sku.is_sale,
        sku.spu_id,
        spu.spu_name,
        sku.category3_id,
        c3.name,
        c3.category2_id,
        c2.name,
        c2.category1_id,
        c1.name,
        sku.tm_id,
        tm.tm_name,
        attr.attrs,
        sale_attr.sale_attrs,
        sku.create_time
    FROM sku
             LEFT JOIN spu ON sku.spu_id=spu.id
             LEFT JOIN c3 ON sku.category3_id=c3.id
             LEFT JOIN c2 ON c3.category2_id=c2.id
             LEFT JOIN c1 ON c2.category1_id=c1.id
             LEFT JOIN tm ON sku.tm_id=tm.id
             LEFT JOIN attr ON sku.id=attr.sku_id
             LEFT JOIN sale_attr ON sku.id=sale_attr.sku_id
    ;
"

# todo 2 优惠券维度表 dim_coupon_full
#    数据来源于：
#        ods_coupon_info_full（全量） 和
#        ods_base_dic_full（全量） 合并
dim_coupon_sql="
    SET hive.exec.dynamic.partition = true;
    SET hive.exec.dynamic.partition.mode = nonstrict;
    SET hive.stats.autogather = false;
    WITH
        ci AS (
            SELECT
                id,
                coupon_name,
                coupon_type,
                condition_amount,
                condition_num,
                activity_id,
                benefit_amount,
                benefit_discount,
                create_time,
                range_type,
                limit_num,
                taken_count,
                start_time,
                end_time,
                operate_time,
                expire_time
            FROM ${APP}.ods_coupon_info_full
            WHERE dt='${do_date}'
        ),
        coupon_dic AS (
            SELECT
                dic_code,
                dic_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='32'
        ),
        range_dic AS (
            SELECT
                dic_code,
                dic_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='33'
        )
    INSERT OVERWRITE TABLE ${APP}.dim_coupon_full PARTITION(dt='${do_date}')
    SELECT
        id,
        coupon_name,
        coupon_type,
        coupon_dic.dic_name,
        condition_amount,
        condition_num,
        activity_id,
        benefit_amount,
        benefit_discount,
        CASE coupon_type
            WHEN '3201' THEN concat('满',condition_amount,'元减',benefit_amount,'元')
            WHEN '3202' THEN concat('满',condition_num,'件打',10*(1-benefit_discount),'折')
            WHEN '3203' THEN concat('减',benefit_amount,'元')
            END benefit_rule,
        create_time,
        range_type,
        range_dic.dic_name,
        limit_num,
        taken_count,
        start_time,
        end_time,
        operate_time,
        expire_time
    FROM ci 
        LEFT JOIN coupon_dic ON ci.coupon_type=coupon_dic.dic_code
        LEFT JOIN range_dic ON ci.range_type=range_dic.dic_code
    ;
"

# todo 3 活动维度表 dim_activity_full
#    数据来源于：
#        ods_activity_rule_full（全量） 和
#        ods_activity_info_full（全量） 和
#        ods_base_dic_full（全量） 合并
dim_activity_sql="
    SET hive.exec.dynamic.partition = true;
    SET hive.exec.dynamic.partition.mode = nonstrict;
    SET hive.stats.autogather = false;
    WITH
        rule AS (
            SELECT
                id,
                activity_id,
                activity_type,
                condition_amount,
                condition_num,
                benefit_amount,
                benefit_discount,
                benefit_level
            FROM ${APP}.ods_activity_rule_full
            WHERE dt='${do_date}'
        ),
        info AS (
            SELECT
                id,
                activity_name,
                activity_type,
                activity_desc,
                start_time,
                end_time,
                create_time
            FROM ${APP}.ods_activity_info_full
            WHERE dt='${do_date}'
        ),
        dic AS (
            SELECT
                dic_code,
                dic_name
            FROM ${APP}.ods_base_dic_full
            WHERE dt='${do_date}'
              AND parent_code='31'
        )
    INSERT OVERWRITE TABLE ${APP}.dim_activity_full PARTITION(dt='${do_date}')
    SELECT
        rule.id,
        info.id,
        activity_name,
        rule.activity_type,
        dic.dic_name,
        activity_desc,
        start_time,
        end_time,
        create_time,
        condition_amount,
        condition_num,
        benefit_amount,
        benefit_discount,
        CASE rule.activity_type
            WHEN '3101' THEN concat('满',condition_amount,'元减',benefit_amount,'元')
            WHEN '3102' THEN concat('满',condition_num,'件打',10*(1-benefit_discount),'折')
            WHEN '3103' THEN concat('打',10*(1-benefit_discount),'折')
            END benefit_rule,
        benefit_level
    FROM rule 
        LEFT JOIN info ON rule.activity_id=info.id
        LEFT JOIN dic ON rule.activity_type=dic.dic_code
    ;
"


# todo 4 地区维度表 dim_province_full
#    数据来源于：
#        ods_base_province_full（全量） 和
#        ods_base_region_full（全量） 合并
#省份数据关联地区数据，按照region_id关联
dim_province_sql="
    SET hive.exec.dynamic.partition = true;
    SET hive.exec.dynamic.partition.mode = nonstrict;
    SET hive.stats.autogather = false;
    WITH
        province AS (
            SELECT
                id,
                name,
                region_id,
                area_code,
                iso_code,
                iso_3166_2
            FROM ${APP}.ods_base_province_full
            WHERE dt='${do_date}'
        ),
        region AS (
            SELECT
                id,
                region_name
            FROM ${APP}.ods_base_region_full
            WHERE dt='${do_date}'
        )
    INSERT OVERWRITE TABLE ${APP}.dim_province_full PARTITION(dt='${do_date}')
    SELECT
        province.id,
        province.name,
        province.area_code,
        province.iso_code,
        province.iso_3166_2,
        region_id,
        region_name
    FROM province
        LEFT JOIN region ON province.region_id=region.id
    ;
"

# todo 5 日期维度表 dim_date
dim_date="
    INSERT OVERWRITE TABLE gmall.dim_date
    SELECT
        date_id
        , week_id
        , week_day
        , day
        , month
        , quarter
        , year
        , is_workday
        , holiday_id
    FROM gmall.tmp_dim_date_info
    ;
"

# todo 6 用户维度表 dim_user_zip (每日)
#    数据来源于：
#        ods_user_info_inc（增量）和
#        dim_user_zip
dim_user_sql="
    SET hive.exec.dynamic.partition = true;
    SET hive.exec.dynamic.partition.mode = nonstrict;
    SET hive.stats.autogather = false;
    WITH
        old_data AS (
            SELECT
                id, login_name, nick_name, name, phone_num, email, user_level, birthday, gender, create_time, operate_time
                 , start_date, end_date
                 , dt
            FROM ${APP}.dim_user_zip
            WHERE dt = '9999-12-31'
        )
       , new_data AS (
        SELECT
            id, login_name, nick_name, md5(name) AS name, md5(phone_num) AS phone_num, md5(email) AS email
             , user_level, birthday, gender, create_time, operate_time
             , '${do_date}' AS start_date
             , '9999-12-31' AS end_date
             , '9999-12-31' AS dt
        FROM ${APP}.ods_user_info_inc
        WHERE dt = '${do_date}'
    )
       , unin_data AS (
        SELECT * FROM old_data
        UNION
        SELECT * FROM new_data
    )
       , rank_data AS (
        SELECT
            id, login_name, nick_name, name, phone_num, email, user_level, birthday, gender, create_time, operate_time
             , row_number() OVER (PARTITION BY id ORDER BY start_date DESC) AS rk
             , start_date, end_date
             , dt
        FROM unin_data
    )
    INSERT OVERWRITE TABLE ${APP}.dim_user_zip PARTITION (dt)
    SELECT
        id, login_name, nick_name, name, phone_num, email, user_level, birthday, gender, create_time, operate_time
         , start_date
         , if(rk = 1, end_date, date_sub('${do_date}', 1)) AS end_date
         , if(rk = 1, end_date, date_sub('${do_date}', 1)) AS dt
    FROM rank_data
    ;
"

case $1 in
  "dim_activity"){
    hive -e "${dim_activity_sql}"
  };;
  "dim_coupon"){
    hive -e "${dim_coupon_sql}"
  };;
  "dim_province"){
    hive -e "${dim_province_sql}"
  };;
  "dim_sku"){
    hive -e "${dim_sku_sql}"
  };;
  "dim_date"){
      hive -e "${dim_date}"
  };;
  "dim_user"){
    hive -e "${dim_user_sql}"
  };;
  "all"){
    hive -e "
    ${dim_activity_sql};
    ${dim_coupon_sql};
    ${dim_province_sql};
    ${dim_sku_sql};
    ${dim_date}
    ${dim_user_sql};
    "
  };;
esac