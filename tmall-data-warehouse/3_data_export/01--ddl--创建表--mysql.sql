
-- todo 为方便报表应用使用数据，需将ads各指标的统计结果导出到MySQL数据库中。

-- 1 创建数据库
DROP DATABASE IF EXISTS gmall_report;
CREATE DATABASE IF NOT EXISTS gmall_report DEFAULT CHARSET utf8 COLLATE utf8_general_ci;


-- 2 创建表
-- ====================================================================
-- todo 1 流量主题
-- ====================================================================
-- 1.1 各渠道流量统计
DROP TABLE IF EXISTS `gmall_report`.`ads_traffic_stats_by_channel`;
CREATE TABLE `gmall_report`.`ads_traffic_stats_by_channel`
(
    `dt`               DATE           NOT NULL COMMENT '统计日期',
    `recent_days`      BIGINT(20)     NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `channel`          VARCHAR(16)    NOT NULL COMMENT '渠道',
    `uv_count`         BIGINT(20)     NULL DEFAULT NULL COMMENT '访客人数',
    `avg_duration_sec` BIGINT(20)     NULL DEFAULT NULL COMMENT '会话平均停留时长，单位为秒',
    `avg_page_count`   BIGINT(20)     NULL DEFAULT NULL COMMENT '会话平均浏览页面数',
    `sv_count`         BIGINT(20)     NULL DEFAULT NULL COMMENT '会话数',
    `bounce_rate`      DECIMAL(16, 2) NULL DEFAULT NULL COMMENT '跳出率',
    PRIMARY KEY (`dt`, `recent_days`, `channel`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '各渠道流量统计'
  ROW_FORMAT = DYNAMIC;

-- 1.2 用户路径分析
DROP TABLE IF EXISTS `gmall_report`.`ads_page_path`;
CREATE TABLE `gmall_report`.`ads_page_path`
(
    `dt`          date        NOT NULL COMMENT '统计日期',
    `recent_days` bigint(20)  NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `source`      varchar(64) NOT NULL COMMENT '跳转起始页面ID',
    `target`      varchar(64) NOT NULL COMMENT '跳转终到页面ID',
    `path_count`  bigint(20)  NULL DEFAULT NULL COMMENT '跳转次数',
    PRIMARY KEY (`dt`, `recent_days`, `source`, `target`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '页面浏览路径分析'
  ROW_FORMAT = DYNAMIC;


-- ====================================================================
-- todo 2 用户主题
-- ====================================================================
-- 2.1 用户变动统计
DROP TABLE IF EXISTS `gmall_report`.`ads_user_change`;
CREATE TABLE `gmall_report`.`ads_user_change`
(
    `dt`               VARCHAR(16) NOT NULL COMMENT '统计日期',
    `user_churn_count` VARCHAR(16) NULL DEFAULT NULL COMMENT '流失用户数',
    `user_back_count`  VARCHAR(16) NULL DEFAULT NULL COMMENT '回流用户数',
    PRIMARY KEY (`dt`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '用户变动统计'
  ROW_FORMAT = DYNAMIC;


-- 2.2 用户留存率
DROP TABLE IF EXISTS `gmall_report`.`ads_user_retention`;
CREATE TABLE `gmall_report`.`ads_user_retention`
(
    `dt`              DATE           NOT NULL COMMENT '统计日期',
    `create_date`     VARCHAR(16)    NOT NULL COMMENT '用户新增日期',
    `retention_day`   INT(20)        NOT NULL COMMENT '截至当前日期留存天数',
    `retention_count` BIGINT(20)     NULL DEFAULT NULL COMMENT '留存用户数量',
    `new_user_count`  BIGINT(20)     NULL DEFAULT NULL COMMENT '新增用户数量',
    `retention_rate`  DECIMAL(16, 2) NULL DEFAULT NULL COMMENT '留存率',
    PRIMARY KEY (`dt`, `create_date`, `retention_day`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '留存率'
  ROW_FORMAT = DYNAMIC;


-- 2.3 用户新增活跃统计
DROP TABLE IF EXISTS `gmall_report`.`ads_user_stats`;
CREATE TABLE `gmall_report`.`ads_user_stats`
(
    `dt`                DATE       NOT NULL COMMENT '统计日期',
    `recent_days`       BIGINT(20) NOT NULL COMMENT '最近n日,1:最近1日,7:最近7日,30:最近30日',
    `new_user_count`    BIGINT(20) NULL DEFAULT NULL COMMENT '新增用户数',
    `active_user_count` BIGINT(20) NULL DEFAULT NULL COMMENT '活跃用户数',
    PRIMARY KEY (`dt`, `recent_days`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '用户新增活跃统计'
  ROW_FORMAT = DYNAMIC;


-- 2.4 用户行为漏斗分析
DROP TABLE IF EXISTS `gmall_report`.`ads_user_action`;
CREATE TABLE `gmall_report`.`ads_user_action`
(
    `dt`                DATE       NOT NULL COMMENT '统计日期',
    `recent_days`       BIGINT(20) NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `home_count`        BIGINT(20) NULL DEFAULT NULL COMMENT '浏览首页人数',
    `good_detail_count` BIGINT(20) NULL DEFAULT NULL COMMENT '浏览商品详情页人数',
    `cart_count`        BIGINT(20) NULL DEFAULT NULL COMMENT '加入购物车人数',
    `order_count`       BIGINT(20) NULL DEFAULT NULL COMMENT '下单人数',
    `payment_count`     BIGINT(20) NULL DEFAULT NULL COMMENT '支付人数',
    PRIMARY KEY (`dt`, `recent_days`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '漏斗分析'
  ROW_FORMAT = DYNAMIC;

-- 2.5 最近7日内连续3日下单用户数
DROP TABLE IF EXISTS `gmall_report`.`ads_order_continuously_user_count`;
CREATE TABLE `gmall_report`.`ads_order_continuously_user_count`
(
    `dt`                            DATE       NOT NULL COMMENT '统计日期',
    `recent_days`                   BIGINT(20) NOT NULL COMMENT '最近天数,7:最近7天',
    `order_continuously_user_count` BIGINT(20) NULL DEFAULT NULL COMMENT '连续3日下单用户数',
    PRIMARY KEY (`dt`, `recent_days`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '最近7日内连续3日下单用户数统计'
  ROW_FORMAT = DYNAMIC;

-- ====================================================================
-- todo 3 商品主题
-- ====================================================================
-- 3.1 最近7/30日各品牌复购率
DROP TABLE IF EXISTS `gmall_report`.`ads_repeat_purchase_by_tm`;
CREATE TABLE `gmall_report`.`ads_repeat_purchase_by_tm`
(
    `dt`                DATE           NOT NULL COMMENT '统计日期',
    `recent_days`       BIGINT(20)     NOT NULL COMMENT '最近天数,7:最近7天,30:最近30天',
    `tm_id`             VARCHAR(16)    NOT NULL COMMENT '品牌ID',
    `tm_name`           VARCHAR(32)    NULL DEFAULT NULL COMMENT '品牌名称',
    `order_repeat_rate` DECIMAL(16, 2) NULL DEFAULT NULL COMMENT '复购率',
    PRIMARY KEY (`dt`, `recent_days`, `tm_id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '各品牌复购率统计'
  ROW_FORMAT = DYNAMIC;

-- 3.2 各品牌商品交易统计
DROP TABLE IF EXISTS `gmall_report`.`ads_order_stats_by_tm`;
CREATE TABLE `gmall_report`.`ads_order_stats_by_tm`
(
    `dt`                      DATE        NOT NULL COMMENT '统计日期',
    `recent_days`             BIGINT(20)  NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `tm_id`                   VARCHAR(16) NOT NULL COMMENT '品牌ID',
    `tm_name`                 VARCHAR(32) NULL DEFAULT NULL COMMENT '品牌名称',
    `order_count`             BIGINT(20)  NULL DEFAULT NULL COMMENT '订单数',
    `order_user_count`        BIGINT(20)  NULL DEFAULT NULL COMMENT '订单人数',
    PRIMARY KEY (`dt`, `recent_days`, `tm_id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '各品牌商品交易统计'
  ROW_FORMAT = dynamic;

-- 3.3 各品类商品交易统计
DROP TABLE IF EXISTS `gmall_report`.`ads_order_stats_by_cate`;
CREATE TABLE `gmall_report`.`ads_order_stats_by_cate`
(
    `dt`                      date        NOT NULL COMMENT '统计日期',
    `recent_days`             bigint(20)  NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `category1_id`            varchar(16) NOT NULL COMMENT '一级分类id',
    `category1_name`          varchar(64) NULL DEFAULT NULL COMMENT '一级分类名称',
    `category2_id`            varchar(16) NOT NULL COMMENT '二级分类id',
    `category2_name`          varchar(64) NULL DEFAULT NULL COMMENT '二级分类名称',
    `category3_id`            varchar(16) NOT NULL COMMENT '三级分类id',
    `category3_name`          varchar(64) NULL DEFAULT NULL COMMENT '三级分类名称',
    `order_count`             bigint(20)  NULL DEFAULT NULL COMMENT '订单数',
    `order_user_count`        bigint(20)  NULL DEFAULT NULL COMMENT '订单人数',
    PRIMARY KEY (`dt`, `recent_days`, `category1_id`, `category2_id`, `category3_id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '各分类商品交易统计'
  ROW_FORMAT = DYNAMIC;

-- 3.4 各品类商品购物车存量top3
DROP TABLE IF EXISTS `gmall_report`.`ads_sku_cart_num_top3_by_cate`;
CREATE TABLE `gmall_report`.`ads_sku_cart_num_top3_by_cate`
(
    `dt`             DATE         NOT NULL COMMENT '统计日期',
    `category1_id`   VARCHAR(16)  NOT NULL COMMENT '一级分类ID',
    `category1_name` VARCHAR(64)  NULL DEFAULT NULL COMMENT '一级分类名称',
    `category2_id`   VARCHAR(16)  NOT NULL COMMENT '二级分类ID',
    `category2_name` VARCHAR(64)  NULL DEFAULT NULL COMMENT '二级分类名称',
    `category3_id`   VARCHAR(16)  NOT NULL COMMENT '三级分类ID',
    `category3_name` VARCHAR(64)  NULL DEFAULT NULL COMMENT '三级分类名称',
    `sku_id`         VARCHAR(16)  NOT NULL COMMENT '商品id',
    `sku_name`       VARCHAR(128) NULL DEFAULT NULL COMMENT '商品名称',
    `cart_num`       BIGINT(20)   NULL DEFAULT NULL COMMENT '购物车中商品数量',
    `rk`             BIGINT(20)   NULL DEFAULT NULL COMMENT '排名',
    PRIMARY KEY (`dt`, `sku_id`, `category1_id`, `category2_id`, `category3_id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '各分类商品购物车存量TopN'
  ROW_FORMAT = DYNAMIC;

-- 3.5 各品牌商品收藏次数Top3
DROP TABLE IF EXISTS `gmall_report`.`ads_sku_favor_count_top3_by_tm`;
CREATE TABLE `gmall_report`.`ads_sku_favor_count_top3_by_tm`
(
    `dt`          date         NOT NULL COMMENT '统计日期',
    `tm_id`       varchar(20)  NOT NULL COMMENT '品牌ID',
    `tm_name`     varchar(128) NULL DEFAULT NULL COMMENT '品牌名称',
    `sku_id`      varchar(20)  NOT NULL COMMENT 'SKU_ID',
    `sku_name`    varchar(128) NULL DEFAULT NULL COMMENT 'SKU名称',
    `favor_count` bigint(20)   NULL DEFAULT NULL COMMENT '被收藏次数',
    `rk`          bigint(20)   NULL DEFAULT NULL COMMENT '排名',
    PRIMARY KEY (`dt`, `tm_id`, `sku_id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '各品牌商品收藏次数TopN'
  ROW_FORMAT = Dynamic;


-- ====================================================================
-- todo 4 交易主题
-- ====================================================================
-- 4.1 交易综合统计
DROP TABLE IF EXISTS `gmall_report`.`ads_trade_stats`;
CREATE TABLE `gmall_report`.`ads_trade_stats`
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


-- 4.2 各省份订单统计
DROP TABLE IF EXISTS `gmall_report`.`ads_order_by_province`;
CREATE TABLE `gmall_report`.`ads_order_by_province`
(
    `dt`                 DATE           NOT NULL COMMENT '统计日期',
    `recent_days`        BIGINT(20)     NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `province_id`        VARCHAR(16)    NOT NULL COMMENT '省份ID',
    `province_name`      VARCHAR(16)    NULL DEFAULT NULL COMMENT '省份名称',
    `area_code`          VARCHAR(16)    NULL DEFAULT NULL COMMENT '地区编码',
    `iso_code`           VARCHAR(16)    NULL DEFAULT NULL COMMENT '国际标准地区编码',
    `iso_code_3166_2`    VARCHAR(16)    NULL DEFAULT NULL COMMENT '国际标准地区编码',
    `order_count`        BIGINT(20)     NULL DEFAULT NULL COMMENT '订单数',
    `order_total_amount` DECIMAL(16, 2) NULL DEFAULT NULL COMMENT '订单金额',
    PRIMARY KEY (`dt`, `recent_days`, `province_id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT = '各地区订单统计'
  ROW_FORMAT = dynamic;


-- ====================================================================
-- todo 5 优惠卷主题
-- ====================================================================
-- 5.1 优惠券使用统计
DROP TABLE IF EXISTS `gmall_report`.`ads_coupon_stats`;
CREATE TABLE `gmall_report`.`ads_coupon_stats`
(
    `dt`              DATE         NOT NULL COMMENT '统计日期',
    `coupon_id`       VARCHAR(20)  NOT NULL COMMENT '优惠券ID',
    `coupon_name`     VARCHAR(128) NOT NULL COMMENT '优惠券名称',
    `used_count`      BIGINT(20)   NULL DEFAULT NULL COMMENT '使用次数',
    `used_user_count` BIGINT(20)   NULL DEFAULT NULL COMMENT '使用人数',
    PRIMARY KEY (`dt`, `coupon_id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci COMMENT '优惠券使用统计'
  ROW_FORMAT = DYNAMIC;
