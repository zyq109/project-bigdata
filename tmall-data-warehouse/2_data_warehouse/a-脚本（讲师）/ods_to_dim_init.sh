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
-- 开启动态分区
SET hive.exec.dynamic.partition=true;
-- 非严格模式：允许所有分区都是动态的
SET hive.exec.dynamic.partition.mode=nonstrict;
-- 开启MapJoin优化
SET hive.auto.convert.join = true;
SET hive.mapjoin.smalltable.filesize = 25000000 ;
-- 开启关联优化器
SET hive.optimize.correlation = true;
-- 开启SkewJoin优化
SET hive.optimize.skewjoin = true;
SET hive.optimize.skewjoin.compiletime = true;
SET hive.optimize.union.remove = true;
"

# todo 1. 商品维度表
dim_sku_full_sql="
WITH
    -- a. SKU商品信息表
    sku AS
        (
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
            WHERE dt = '${do_date}'
        ),
    -- b. SPU商品信息表
    spu AS
        (
            SELECT
                id,
                spu_name
            FROM ${APP}.ods_spu_info_full
            WHERE dt = '${do_date}'
        ),
    -- c. 三级品类表
    c3 AS
        (
            SELECT
                id,
                name,
                category2_id
            FROM ${APP}.ods_base_category3_full
            WHERE dt = '${do_date}'
        ),
    -- c. 二级品类表
    c2 AS
        (
            SELECT
                id,
                name,
                category1_id
            FROM ${APP}.ods_base_category2_full
            WHERE dt = '${do_date}'
        ),
    -- d. 一级品类表
    c1 AS
        (
            SELECT
                id,
                name
            FROM ${APP}.ods_base_category1_full
            WHERE dt='${do_date}'
        ),
    -- e. 品牌表
    tm AS
        (
            SELECT
                id,
                tm_name
            FROM ${APP}.ods_base_trademark_full
            WHERE dt='${do_date}'
        ),
    -- f. sku商品平台属性表
    attr AS
        (
            SELECT
                sku_id,
                collect_set(
                    named_struct('attr_id',attr_id,'value_id',value_id,'attr_name',attr_name,'value_name',value_name)
                ) AS attrs
            FROM ${APP}.ods_sku_attr_value_full
            WHERE dt='${do_date}'
            GROUP BY sku_id
        ),
    -- g. sku商品销售平台属性表
    sale_attr AS
        (
            SELECT
                sku_id,
                collect_set(
                    named_struct('sale_attr_id',sale_attr_id,'sale_attr_value_id',sale_attr_value_id,
                        'sale_attr_name',sale_attr_name,'sale_attr_value_name',sale_attr_value_name)
                ) AS sale_attrs
            FROM ${APP}.ods_sku_sale_attr_value_full
            WHERE dt='${do_date}'
            GROUP BY sku_id
        )
INSERT OVERWRITE TABLE ${APP}.dim_sku_full PARTITION(dt = '${do_date}')
-- h. 以sku商品为主表，left join关联其他表
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
LEFT JOIN spu ON sku.spu_id = spu.id
LEFT JOIN c3 ON sku.category3_id = c3.id
LEFT JOIN c2 ON c3.category2_id = c2.id
LEFT JOIN c1 ON c2.category1_id = c1.id
LEFT JOIN tm ON sku.tm_id = tm.id
LEFT JOIN attr ON sku.id = attr.sku_id
LEFT JOIN sale_attr ON sku.id = sale_attr.sku_id;
"

# todo 2. 优惠券维度表
dim_coupon_full_sql="
WITH
    -- a. 优惠卷信息表
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
    -- b. 购物券类型字典数据
    coupon_dic AS (
        SELECT
            dic_code,
            dic_name
        FROM ${APP}.ods_base_dic_full
        WHERE dt = '${do_date}' AND parent_code = '32'
    ),
    -- c. 优惠券范围字典数据
    range_dic AS (
        SELECT
            dic_code,
            dic_name
        FROM ${APP}.ods_base_dic_full
        WHERE dt = '${do_date}' AND parent_code = '33'
    )
INSERT OVERWRITE TABLE ${APP}.dim_coupon_full PARTITION(dt = '${do_date}')
-- d. 优惠卷信息表，关联字段表，并且转换类型值
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
    -- 优惠类型
    case coupon_type
        WHEN '3201' THEN concat('满', condition_amount, '元减', benefit_amount, '元')
        WHEN '3202' THEN concat('满', condition_num, '件打', 10 * (1 - benefit_discount), '折')
        WHEN '3203' THEN concat('减', benefit_amount, '元')
    end AS benefit_rule,
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
LEFT JOIN coupon_dic ON ci.coupon_type = coupon_dic.dic_code
LEFT JOIN range_dic ON ci.range_type = range_dic.dic_code;
"

# todo 3. 活动维度表
dim_activity_full_sql="
WITH
     -- a. 活动规则表
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
     -- b. 活动信息表
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
         WHERE dt = '${do_date}'
     ),
     -- c. 活动类型字典数据
     dic AS (
         SELECT
             dic_code,
             dic_name
         FROM ${APP}.ods_base_dic_full
         WHERE dt = '${do_date}' AND parent_code = '31'
     )
INSERT OVERWRITE TABLE ${APP}.dim_activity_full PARTITION(dt = '${do_date}')
-- d. 活动规则 关联 活动信息 和 字段属性数据
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
    case rule.activity_type
        WHEN '3101' THEN concat('满',condition_amount,'元减',benefit_amount,'元')
        WHEN '3102' THEN concat('满',condition_num,'件打',10*(1-benefit_discount),'折')
        WHEN '3103' THEN concat('打',10*(1-benefit_discount),'折')
    end AS benefit_rule,
    benefit_level
FROM rule
LEFT JOIN info ON rule.activity_id = info.id
LEFT JOIN dic ON rule.activity_type = dic.dic_code;
"

# todo 4. 地区维度表
dim_province_full_sql="
WITH
    -- a. 省份数据
    province AS (
        SELECT
            id,
            name,
            region_id,
            area_code,
            iso_code,
            iso_3166_2
        FROM ${APP}.ods_base_province_full
        WHERE dt = '${do_date}'
    ),
    -- b. 地区数据
    region AS (
        SELECT
            id,
            region_name
        FROM ${APP}.ods_base_region_full
        WHERE dt = '${do_date}'
    )
INSERT OVERWRITE TABLE ${APP}.dim_province_full PARTITION(dt = '${do_date}')
-- c. 省份数据关联地区数据，按照region_id关联
SELECT
    province.id,
    province.name,
    province.area_code,
    province.iso_code,
    province.iso_3166_2,
    region_id,
    region_name
FROM province
LEFT JOIN region ON province.region_id = region.id;
"

# todo 6. 用户维度表
dim_user_zip_sql="
INSERT OVERWRITE TABLE ${APP}.dim_user_zip PARTITION (dt = '9999-12-31')
SELECT
    id,
    login_name,
    nick_name,
    md5(name) AS name,
    md5(phone_num) AS phone_num,
    md5(email),
    user_level,
    birthday,
    gender,
    create_time,
    operate_time,
    '${do_date}' AS start_date,
    '9999-12-31' AS end_date
FROM ${APP}.ods_user_info_inc
WHERE dt = '${do_date}';
"

# 依据传递参数判断数据加载
case $1 in
"dim_user_zip")
    hive -e "${hive_tuning_sql}${dim_user_zip_sql}"
;;
"dim_sku_full")
    hive -e "${hive_tuning_sql}${dim_sku_full_sql}"
;;
"dim_province_full")
    hive -e "${hive_tuning_sql}${dim_province_full_sql}"
;;
"dim_coupon_full")
    hive -e "${hive_tuning_sql}${dim_coupon_full_sql}"
;;
"dim_activity_full")
    hive -e "${hive_tuning_sql}${dim_activity_full_sql}"
;;
"all")
    hive -e "${hive_tuning_sql}${dim_user_zip_sql}${dim_sku_full_sql}${dim_province_full_sql}${dim_coupon_full_sql}${dim_activity_full_sql}"
;;
esac


#step1. 执行权限
# chmod +x ods_to_dim_init.sh
#step2. 某天数据，加载到某张表
# sh ods_to_dim_init.sh dim_sku_full_sql 2024-04-18
#step3. 某天数据，加载所有表
# sh ods_to_dim_init.sh all 2024-04-18
#

