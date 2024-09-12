#!/bin/bash

# 定义变量
APP=gmall
# 定义变量，表示命令
CMD=/opt/module/sqoop/bin/sqoop

# 获取同步数据日期参数值
if [ -n "$2" ] ;then
  do_date=$2
else
  echo "请传入日期参数"
  exit
fi

# 定义函数，类似方法，不需要显示指定参数个数类型：第1个参数为表名称，第2个参数为SQL语句
import_data(){
  ${CMD} import \
  --connect jdbc:mysql://node101:3306/${APP} \
  --username root \
  --password 123456 \
  --target-dir /origin_data/${APP}/$1/${do_date} \
  --delete-target-dir \
  --query "$2 AND \$CONDITIONS" \
  --num-mappers 1 \
  --fields-terminated-by '\t' \
  --compress \
  --compression-codec gzip \
  --null-string '\\N' \
  --null-non-string '\\N'
}

#  ======================================== 针对每个表，调用定义函数，同步数据 ========================================
# todo 首日同步表：base_dic
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

# todo 首日同步表：order_detail
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
                          WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}

# todo 首日同步表：order_info
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
                        WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}
---------------------------------------------------------------


# todo 首日同步表：payment_info
import_payment_info(){
  import_data payment_info "SELECT
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
                          WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}
# todo 首日同步表：order_refund_info
import_order_refund_info(){
  import_data order_refund_info "SELECT
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
                          WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}
# todo 首日同步表：refund_payment
import_refund_payment(){
  import_data refund_payment "SELECT
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
                          WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}

import_comment_info(){
  import_data comment_info "SELECT
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
                           WHERE date_format(create_time, '%Y-%m-%d') <= '$do_date' and \$CONDITIONS"
}

import_coupon_use(){
  import_data coupon_use "SELECT
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
                         WHERE date_format(create_time, '%Y-%m-%d') <= '$do_date' and \$CONDITIONS"
}



# todo 1.首日同步表：favor_info 收藏表
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
                          WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}



# todo 首日同步表：user_info
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
                        WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}


# 条件判断，依据执行脚本传递第1个参数值，确定同步导入哪个表数据，或同步导入所有表数据
case $1 in
  "base_dic")
    import_base_dic
;;
  "order_detail")
    import_order_detail
;;
  "order_info")
    import_order_info
;;
;;
  "order_detail_coupon")
    import_order_detail_coupon
;;
  "order_status_log")
    import_order_status_log
;;
  "cart_info")
    import_cart_info
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
  "comment_info")
    import_comment_info
;;
  "coupon_use")
    import_coupon_use
;;
  "favor_info")
    import_favor_info
;;
  "user_info")
    import_user_info
;;
  "all")
    import_base_dic
    import_order_detail
    import_order_info
    import_order_detail_coupon
    import_order_status_log
    import_cart_info
    import_payment_info
    import_order_refund_info
    import_refund_payment
    import_comment_info
    import_coupon_use
    import_favor_info
    import_user_info
;;
esac

#
# chmod u+x mysql_to_hdfs_init.sh
# sh mysql_to_hdfs_init.sh base_dic 2024-03-25
#         $0                  $1        $2
#
# 同步所有表
# sh mysql_to_hdfs_init.sh all 2024-03-31
# 同步某一张表
# sh mysql_to_hdfs_init.sh order_detail 2024-03-31
#


