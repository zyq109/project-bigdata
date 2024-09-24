
-- 创建表
DROP TABLE IF EXISTS `gmall_report`.`tmp_trade_stats`;
CREATE TABLE `gmall_report`.`tmp_trade_stats`
(
    `dt`                      DATE           NOT NULL COMMENT '统计日期',
    `recent_days`             BIGINT(255)    NOT NULL COMMENT '最近天数,1:最近1日',
    `order_total_amount`      DECIMAL(16, 2) NULL DEFAULT NULL COMMENT '订单总额,GMV',
    `order_count`             BIGINT(20)     NULL DEFAULT NULL COMMENT '订单数',
    `order_user_count`        BIGINT(20)     NULL DEFAULT NULL COMMENT '下单人数',
    PRIMARY KEY (`dt`, `recent_days`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '交易统计'
  ROW_FORMAT = DYNAMIC;

-- 插入数据
INSERT INTO gmall_report.tmp_trade_stats
(dt, recent_days, order_total_amount, order_count, order_user_count)
VALUES
('2024-06-11', 1, 999.99, 99, 88),
('2024-06-12', 1, 1999.99, 199, 188),
('2024-06-13', 1, 2999.99, 299, 288),
('2024-06-14', 1, 3999.99, 399, 388),
('2024-06-15', 1, 4999.99, 499, 488),
('2024-06-16', 1, 5999.99, 599, 588),
('2024-06-17', 1, 6999.99, 699, 688)
;


-- 更新数据
UPDATE gmall_report.tmp_trade_stats
SET order_total_amount = 9999.99, order_count = 800, order_user_count = 1000
WHERE dt = '2024-06-17' AND recent_days = 1
;

/*
    针对MySQL数据库表：如果主键存在，更新字段值；否则，主键不存在，直接插入。
        方式1：replace 语句
        方式2：ON DUPLICATE KEY UPDATE 语句
*/

-- todo： replace 替换，指定所有字段的值
REPLACE INTO gmall_report.tmp_trade_stats
    (dt, recent_days, order_total_amount, order_count, order_user_count)
VALUES
    ('2024-06-17', 1, 90999.99, 1099, 999)
;


-- todo：ON DUPLICATE KEY UPDATE 更新数据，指定要更新字段
INSERT INTO gmall_report.tmp_trade_stats
(dt, recent_days, order_count, order_user_count)
VALUES
('2024-06-17', 1, 6, 5)
    ON DUPLICATE KEY UPDATE order_count = VALUES(order_count), order_user_count = VALUES(order_user_count)
;

