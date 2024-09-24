

-- =============================================================================
-- todo 5.1 优惠券使用统计
-- =============================================================================
/*
    统计周期	统计粒度	指标	    说明
    最近1日	优惠券	使用次数	支付才算使用
    最近1日	优惠券	使用人数	支付才算使用

    `dt`              STRING COMMENT '统计日期',
    `coupon_id`       STRING COMMENT '优惠券ID',
    `coupon_name`     STRING COMMENT '优惠券名称',
    `used_count`      BIGINT COMMENT '使用次数',
    `used_user_count` BIGINT COMMENT '使用人数'
*/

WITH
   -- step1. 聚合统计
    stats AS (
        SELECT '2024-09-11'            AS dt
             , coupon_id
             , count(id)               AS `used_count`
             , count(DISTINCT user_id) AS `used_user_count`
        FROM gmall.dwd_tool_coupon_pay_inc
        WHERE dt = '2024-09-11'
        GROUP BY coupon_id
    )
   -- step2. 优惠卷维度表
   , coupon AS (
        SELECT id, coupon_name
        FROM gmall.dim_coupon_full
        WHERE dt = '2024-09-11'
    )
-- step5. 插入覆盖
INSERT OVERWRITE TABLE gmall.ads_coupon_stats
-- step4. 历史统计
SELECT * FROM gmall.ads_coupon_stats
UNION
-- step3. 关联维度
SELECT stats.`dt`
     , stats.`coupon_id`
     , coupon.`coupon_name`
     , stats.`used_count`
     , stats.`used_user_count`
FROM stats
         LEFT JOIN coupon ON stats.coupon_id = coupon.id
;



