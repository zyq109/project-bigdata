
-- 创建数据库
CREATE DATABASE IF NOT EXISTS gmall ;
-- 使用数据库
USE gmall;


-- todo 1. 编码字典表：base_dic（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/base_dic_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_dic_full PARTITION (dt = '2024-06-18');

-- 显示分区数目
SHOW PARTITIONS gmall.ods_base_dic_full ;
-- 查询分区表数据，where过滤日期，limit限制条目数
SELECT * FROM gmall.ods_base_dic_full WHERE dt = '2024-06-18' LIMIT 10 ;

-- todo 2. 品牌表：base_trademark（每日，全量）

-- todo 3. 三级分类表：base_category3（每日，全量）

-- todo 4. 二级分类表：base_category2（每日，全量）

-- todo 5. 一级分类表：base_category1（每日，全量）

-- todo 6. 库存单元表（商品信息表）：sku_info（每日，全量）

-- todo 7. 商品表：spu_info（每日，全量）

-- todo 8. 活动表：activity_info（每日，全量）

-- todo 9. 优惠规则：activity_rule（每日，全量）

-- todo 10. 购物车表：cart_info（每日，全量）

-- todo 11.  优惠券表：coupon_info（每日，全量）

-- todo 12. sku平台属性值关联表：sku_attr_value（每日，全量）

-- todo 13. sku销售属性值：sku_sale_attr_value（每日，全量）

-- todo 14. 省份表：base_province（每日，全量）

-- todo 15. 区域表：base_region（每日，全量）


-- ==========================================================================
-- ==========================================================================

-- todo: 1.订单详情表：order_detail（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_detail_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_detail_inc PARTITION (dt = '2024-06-18');
-- 显示分区数目
SHOW PARTITIONS gmall.ods_order_detail_inc ;
-- 查询分区表数据，where过滤日期，limit限制条目数
SELECT * FROM gmall.ods_order_detail_inc WHERE dt = '2024-06-18' LIMIT 10 ;

-- todo 2.退单表：order_refund_info（每日，增量）
order_refund_info
-- todo 3.订单状态日志表：order_status_log（每日，增量）

-- todo 4.订单明细活动关联表：order_detail_activity（每日，增量）

-- todo 5.订单明细购物券表：order_detail_coupon（每日，增量）

-- todo 6.商品评论表：comment_info（每日，增量）

-- todo 7. 商品收藏表：favor_info（每日，增量）

-- todo 8.订单表：order_info（每日，增量）

-- todo 9.优惠券领用表：coupon_use（每日，增量）

-- todo 10.用户表：user_info（每日，增量）

-- todo 11.支付信息表：payment_info（每日，增量）

-- todo 12.退款信息表：refund_payment（每日，增量）

-- todo 13. 购物车表：cart_info（每日，增量）


