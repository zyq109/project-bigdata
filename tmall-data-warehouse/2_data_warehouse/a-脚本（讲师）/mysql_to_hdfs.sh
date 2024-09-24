#!/bin/bash

# 定义变量
APP=gmall
# 定义变量，表示命令
CMD=/opt/module/sqoop/bin/sqoop

# 获取同步数据日期参数值
if [ -n "$2" ] ;then
  do_date=$2
else
  do_date=`date -d '-1 day' +%F`
fi

# 定义函数，类似方法，不需要显示指定参数个数类型：第1个参数为表名称，第2个参数为SQL语句
import_data(){
  ${CMD} import \
  --connect jdbc:mysql://node101:3306/${APP} \
  --username root \
  --password 123456 \
  --target-dir /origin_data/${APP}/$1/${do_date} \
  --delete-target-dir \
  --query "$2 and \$CONDITIONS" \
  --num-mappers 1 \
  --fields-terminated-by '\t' \
  --compress \
  --compression-codec gzip \
  --null-string '\\N' \
  --null-non-string '\\N'
}

# todo：1. 活动信息表：activity_info（每日，全量）
import_activity_info(){
  import_data activity_info_full "SELECT
                                id,
                                activity_name,
                                activity_type,
                                activity_desc,
                                start_time,
                                end_time,
                                create_time
                            FROM activity_info
                            WHERE 1 = 1"
}

# todo：2. 活动信息表：activity_rule（每日，全量）
import_activity_rule(){
  import_data activity_rule_full "SELECT
                            id,
                            activity_id,
                            activity_type,
                            condition_amount,
                            condition_num,
                            benefit_amount,
                            benefit_discount,
                            benefit_level
                        FROM activity_rule
                        WHERE 1 = 1"
}

# todo：3. 一级品类表：base_category1（每日，全量）
import_base_category1(){
  import_data base_category1_full "SELECT
                                  id,
                                  name
                              FROM base_category1
                              WHERE 1 = 1"
}

# todo：4. 二级品类表：base_category2（每日，全量）
import_base_category2(){
  import_data base_category2_full "SELECT
                                id,
                                name,
                                category1_id
                              FROM base_category2
                              WHERE 1 = 1"
}

# todo：5. 三级品类表：base_category3（每日，全量）
import_base_category3(){
  import_data base_category3_full "SELECT
                                  id,
                                  name,
                                  category2_id
                              FROM base_category3
                              WHERE 1 = 1"
}

# todo：6. 编码字典表：base_dic（每日，全量）
import_base_dic(){
  import_data base_dic_full "SELECT
                          dic_code,
                          dic_name,
                          parent_code,
                          create_time,
                          operate_time
                        FROM base_dic
                        WHERE 1 = 1"
}

# todo：7. 省份表：base_province（每日，全量）
import_base_province(){
  import_data base_province_full "SELECT
                            id,
                            name,
                            region_id,
                            area_code,
                            iso_code,
                            iso_3166_2
                        FROM base_province
                        WHERE 1 = 1"
}

# todo：8. 地区表：base_region（每日，全量）
import_base_region(){
  import_data base_region_full "SELECT
                              id,
                              region_name
                          FROM base_region
                          WHERE 1 = 1"
}

# todo：9. 品牌表：base_trademark（每日，全量）
import_base_trademark(){
  import_data base_trademark_full "SELECT
                                  id,
                                  tm_name,
                                  logo_url
                              FROM base_trademark
                              WHERE 1 = 1"
}

# todo：10. 购物车表：cart_info（每日，全量）
import_cart_info(){
  import_data cart_info_full "SELECT
                            id,
                            user_id,
                            sku_id,
                            cart_price,
                            sku_num,
                            img_url,
                            sku_name,
                            is_checked,
                            create_time,
                            operate_time,
                            is_ordered,
                            order_time,
                            source_type,
                            source_id
                        FROM cart_info
                        WHERE 1 = 1"
}

# todo：11. 优惠卷信息表：coupon_info（每日，全量）
import_coupon_info(){
  import_data coupon_info_full "SELECT
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
                              expire_time,
                              range_desc
                          FROM coupon_info
                          WHERE 1 = 1"
}

# todo：12. 商品平台属性表：sku_attr_value（每日，全量）
import_sku_attr_value(){
  import_data sku_attr_value_full "SELECT
                                id,
                                attr_id,
                                value_id,
                                sku_id,
                                attr_name,
                                value_name
                            FROM sku_attr_value
                            WHERE 1 = 1"
}

# todo：13. 商品销售属性表：sku_sale_attr_value（每日，全量）
import_sku_sale_attr_value(){
  import_data sku_sale_attr_value_full "SELECT
                                      id,
                                      sku_id,
                                      spu_id,
                                      sale_attr_value_id,
                                      sale_attr_id,
                                      sale_attr_name,
                                      sale_attr_value_name
                                  FROM sku_sale_attr_value
                                  WHERE 1 = 1"
}

# todo：14. 商品表sku：sku_info（每日，全量）
import_sku_info(){
  import_data sku_info_full "SELECT
                            id,
                            spu_id,
                            price,
                            sku_name,
                            sku_desc,
                            weight,
                            tm_id,
                            category3_id,
                            sku_default_img,
                            is_sale,
                            create_time
                        FROM sku_info
                        WHERE 1 = 1"
}

# todo：15. SPU表：spu_info（每日，全量）
import_spu_info(){
  import_data spu_info_full "SELECT
                            id,
                            spu_name,
                            description,
                            category3_id,
                            tm_id
                        FROM spu_info
                        WHERE 1 = 1"
}


# todo：1. 评论表：comment_info（增量，每一次）
import_comment_info(){
  import_data comment_info_inc "SELECT
    id,
    user_id,
    nick_name,
    head_img,
    sku_id,
    spu_id,
    order_id,
    appraise,
    comment_txt,
    create_time,
    operate_time
FROM comment_info
WHERE (date_format(create_time, '%Y-%m-%d') = '${do_date}'
           OR date_format(operate_time, '%Y-%m-%d') = '${do_date}')"
}

# todo：2. 优惠卷领用表：coupon_use（增量，每一次）
import_coupon_use(){
  import_data coupon_use_inc "SELECT
    id,
    coupon_id,
    user_id,
    order_id,
    coupon_status,
    create_time,
    get_time,
    using_time,
    used_time,
    expire_time
FROM coupon_use
WHERE ( date_format(get_time, '%Y-%m-%d') = '${do_date}'
        OR date_format(using_time, '%Y-%m-%d') = '${do_date}'
        OR date_format(used_time, '%Y-%m-%d') = '${do_date}'
        OR date_format(expire_time, '%Y-%m-%d') = '${do_date}'
      )"
}

# todo：3. 收藏表：favor_info（增量，每一次）
import_favor_info(){
  import_data favor_info_inc "SELECT
    id,
    user_id,
    sku_id,
    spu_id,
    is_cancel,
    create_time,
    cancel_time
FROM favor_info
WHERE (date_format(create_time, '%Y-%m-%d') = '${do_date}'
        OR date_format(cancel_time, '%Y-%m-%d') = '${do_date}'
      )"
}

# todo：4. 订单明细表：order_detail（增量，每一次）
import_order_detail(){
  import_data order_detail_inc "SELECT
    id,
    order_id,
    sku_id,
    sku_name,
    img_url,
    order_price,
    sku_num,
    create_time,
    source_type,
    source_id,
    split_total_amount,
    split_activity_amount,
    split_coupon_amount
FROM order_detail
WHERE date_format(create_time, '%Y-%m-%d') = '${do_date}'"
}

# todo：5. 订单明细活动关联表：order_detail_activity（增量，每一次）
import_order_detail_activity(){
  import_data order_detail_activity_inc "SELECT
    id,
    order_id,
    order_detail_id,
    activity_id,
    activity_rule_id,
    sku_id,
    create_time
FROM order_detail_activity
WHERE date_format(create_time, '%Y-%m-%d') = '${do_date}'"
}

# todo：6. 订单明细优惠卷关联表：order_detail_coupon（增量，每一次）
import_order_detail_coupon(){
  import_data order_detail_coupon_inc "SELECT
    id,
    order_id,
    order_detail_id,
    coupon_id,
    coupon_use_id,
    sku_id,
    create_time
FROM order_detail_coupon
WHERE date_format(create_time, '%Y-%m-%d') = '${do_date}'"
}

# todo：7. 订单表：order_info（增量，每一次）
import_order_info(){
  import_data order_info_inc "SELECT
    id,
    consignee,
    consignee_tel,
    total_amount,
    order_status,
    user_id,
    payment_way,
    delivery_address,
    order_comment,
    out_trade_no,
    trade_body,
    create_time,
    operate_time,
    expire_time,
    process_status,
    tracking_no,
    parent_order_id,
    img_url,
    province_id,
    activity_reduce_amount,
    coupon_reduce_amount,
    original_total_amount,
    feight_fee,
    feight_fee_reduce,
    refundable_time
FROM order_info
WHERE (date_format(create_time, '%Y-%m-%d') = '${do_date}'
           OR date_format(operate_time, '%Y-%m-%d') = '${do_date}')"
}

# todo：8. 订单状态日志表：order_status_log（增量，每一次）
import_order_status_log(){
  import_data order_status_log_inc "SELECT
    id,
    order_id,
    order_status,
    operate_time
FROM order_status_log
WHERE date_format(operate_time, '%Y-%m-%d') = '${do_date}'"
}

# todo：9. 支付表：payment_info（增量，每一次）
import_payment_info(){
  import_data payment_info_inc "SELECT
    id,
    out_trade_no,
    order_id,
    user_id,
    payment_type,
    trade_no,
    total_amount,
    subject,
    payment_status,
    create_time,
    callback_time,
    callback_content
FROM payment_info
WHERE (date_format(create_time, '%Y-%m-%d') = '${do_date}'
        OR date_format(callback_time, '%Y-%m-%d') = '${do_date}'
      )"
}

# todo 10. 退单表：order_refund_info（增量，每一次）
import_order_refund_info(){
  import_data order_refund_info_inc "SELECT
    id,
    user_id,
    order_id,
    sku_id,
    refund_type,
    refund_num,
    refund_amount,
    refund_reason_type,
    refund_reason_txt,
    refund_status,
    create_time
FROM order_refund_info
WHERE date_format(create_time, '%Y-%m-%d') = '${do_date}'"
}

# todo：11. 退款表：refund_payment（增量，每一次）
import_refund_payment(){
  import_data refund_payment_inc "SELECT
    id,
    out_trade_no,
    order_id,
    sku_id,
    payment_type,
    trade_no,
    total_amount,
    subject,
    refund_status,
    create_time,
    callback_time,
    callback_content
FROM refund_payment
WHERE (date_format(create_time, '%Y-%m-%d') = '${do_date}'
        OR date_format(callback_time, '%Y-%m-%d') = '${do_date}')"
}

# todo 12. 用户表：user_info（增量，每一次）
import_user_info(){
  import_data user_info_inc "SELECT
    id,
    login_name,
    nick_name,
    passwd,
    name,
    phone_num,
    email,
    head_img,
    user_level,
    birthday,
    gender,
    create_time,
    operate_time,
    status
FROM user_info
WHERE (date_format(create_time, '%Y-%m-%d') = '${do_date}'
        OR date_format(operate_time, '%Y-%m-%d') = '${do_date}'
      )"
}

# todo 13. 加购物车表：cart_info（增量，每一次）
import_cart_info_inc(){
  import_data cart_info_inc "SELECT id,
                                   user_id,
                                   sku_id,
                                   cart_price,
                                   sku_num,
                                   img_url,
                                   sku_name,
                                   is_checked,
                                   create_time,
                                   operate_time,
                                   is_ordered,
                                   order_time,
                                   source_type,
                                   source_id
                            FROM cart_info
                            WHERE date_format(create_time, '%Y-%m-%d') = '${do_date}'"
}


# 条件判断，依据执行脚本传递第1个参数值，确定同步导入哪个表数据，或同步导入所有表数据
case $1 in
  "activity_info")
    import_activity_info
;;
  "activity_rule")
    import_activity_rule
;;
  "base_category1")
    import_base_category1
;;
  "base_category2")
    import_base_category2
;;
  "base_category3")
    import_base_category3
;;
  "base_dic")
    import_base_dic
;;
  "base_province")
    import_base_province
;;
  "base_region")
    import_base_region
;;
  "base_trademark")
    import_base_trademark
;;
  "cart_info")
    import_cart_info
;;
  "coupon_info")
    import_coupon_info
;;
  "sku_attr_value")
    import_sku_attr_value
;;
  "sku_sale_attr_value")
    import_sku_sale_attr_value
;;
  "sku_info")
    import_sku_info
;;
  "spu_info")
    import_spu_info
;;
  "comment_info")
    import_comment_info
;;
  "coupon_use")
    import_coupon_use
;;
  "favor_info")
    import_favor_info
;;
  "order_detail")
    import_order_detail
;;
  "order_detail_activity")
    import_order_detail_activity
;;
  "order_detail_coupon")
    import_order_detail_coupon
;;
  "order_info")
    import_order_info
;;
  "order_status_log")
    import_order_status_log
;;
  "payment_info")
    import_payment_info
;;
  "order_refund_info")
    import_order_refund_info
;;
  "refund_payment")
    import_refund_payment
;;
  "user_info")
    import_user_info
;;
  "cart_info_inc")
    import_cart_info_inc
;;
  "all")
    import_activity_info
    import_activity_rule
    import_base_category1
    import_base_category2
    import_base_category3
    import_base_dic
    import_base_province
    import_base_region
    import_base_trademark
    import_cart_info
    import_coupon_info
    import_sku_attr_value
    import_sku_sale_attr_value
    import_sku_info
    import_spu_info
    import_comment_info
    import_coupon_use
    import_favor_info
    import_order_detail
    import_order_detail_activity
    import_order_detail_coupon
    import_order_info
    import_order_status_log
    import_payment_info
    import_order_refund_info
    import_refund_payment
    import_user_info
    import_cart_info_inc
;;
esac


#
# chmod u+x mysql_to_hdfs.sh
# sh mysql_to_hdfs.sh base_dic ${do_date}
#         $0              $1        $2
#
# 同步所有表
# sh mysql_to_hdfs.sh all 2024-04-18
# 同步某一张表
# sh mysql_to_hdfs.sh order_detail 2024-04-18
#


