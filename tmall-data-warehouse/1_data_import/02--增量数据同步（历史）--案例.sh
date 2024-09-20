


#数据库连接发生异常
#因为我们使用的id 不是主键，且不保证有序，
# 所以sqoop利用游标查询数据库时返回数据可能会出现
#重复搬运，数据丢失


#sqoop从sqlserver导数据配置时候--split-by 的字段必须为长整型顺序唯一字段。
#涉及的表结构没有很好符合该规范。
#从而使得连接异常时恢复链接后继续搬运数据出现重复。

# ======================================================================
#                   todo：1. 订单明细表：order_detail（增量，历史）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_detail_inc/2024-06-18 \
--delete-target-dir \
--query "SELECT
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
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'



# ======================================================================
#                   todo：2. 订单表：order_info（增量，首日）
# hdfs dfs -cat /origin_data/gmall/order_detail_inc/2024-06-18/part* |zcat
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_info_inc/2024-06-18 \
--delete-target-dir \
--query "SELECT
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
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'










# ======================================================================
#                   todo：1. 订单明细表：payment_info（增量，历史）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/payment_info/2024-06-18 \
--delete-target-dir \
--query "SELECT
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
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'





# ======================================================================
#                   todo：. ：order_refund_info（增量，历史）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_refund_info/2024-06-18 \
--delete-target-dir \
--query "SELECT
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
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'




# ======================================================================
#                   todo：. ：refund_payment（增量，历史）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/refund_payment/2024-06-18 \
--delete-target-dir \
--query "SELECT
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
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'





