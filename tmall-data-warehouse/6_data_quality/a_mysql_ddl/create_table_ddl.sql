
-- ====================================================================
--          MySQL主要用于存储数据质量监控的结果值，需要提前建库建表
-- ====================================================================

-- todo （1）创建data_supervisor库
DROP DATABASE IF EXISTS data_supervisor;
CREATE DATABASE data_supervisor;


-- todo （2）创建--空值指标表，monitor_report_null_id
DROP TABLE IF EXISTS data_supervisor.monitor_report_null_id ;
CREATE TABLE IF NOT EXISTS data_supervisor.monitor_report_null_id
(
    `dt`                 date        NOT NULL COMMENT '日期',
    `tbl`                varchar(50) NOT NULL COMMENT '表名',
    `col`                varchar(50) NOT NULL COMMENT '列名',
    `value`              int DEFAULT NULL COMMENT '空ID个数',
    `value_min`          int DEFAULT NULL COMMENT '下限',
    `value_max`          int DEFAULT NULL COMMENT '上限',
    `notification_level` int DEFAULT NULL COMMENT '警告级别',
    PRIMARY KEY (`dt`, `tbl`, `col`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
    COMMENT '空值指标表';


-- todo （3）创建--重复值指标表，monitor_report_duplicate_id
DROP TABLE IF EXISTS data_supervisor.monitor_report_duplicate_id ;
CREATE TABLE IF NOT EXISTS data_supervisor.monitor_report_duplicate_id
(
    `dt`                 date        NOT NULL COMMENT '日期',
    `tbl`                varchar(50) NOT NULL COMMENT '表名',
    `col`                varchar(50) NOT NULL COMMENT '列名',
    `value`              int DEFAULT NULL COMMENT '重复值个数',
    `value_min`          int DEFAULT NULL COMMENT '下限',
    `value_max`          int DEFAULT NULL COMMENT '上限',
    `notification_level` int DEFAULT NULL COMMENT '警告级别',
    PRIMARY KEY (`dt`, `tbl`, `col`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
    COMMENT '重复值指标表';


-- todo（4）创建--值域指标表，monitor_report_range_value
DROP TABLE IF EXISTS data_supervisor.monitor_report_range_value ;
CREATE TABLE IF NOT EXISTS data_supervisor.monitor_report_range_value
(
    `dt`                 date        NOT NULL COMMENT '日期',
    `tbl`                varchar(50) NOT NULL COMMENT '表名',
    `col`                varchar(50) NOT NULL COMMENT '列名',
    `value`              int DEFAULT NULL COMMENT '超出预定值域个数',
    `range_min`          int DEFAULT NULL COMMENT '值域下限',
    `range_max`          int DEFAULT NULL COMMENT '值域上限',
    `value_min`          int DEFAULT NULL COMMENT '下限',
    `value_max`          int DEFAULT NULL COMMENT '上限',
    `notification_level` int DEFAULT NULL COMMENT '警告级别',
    PRIMARY KEY (`dt`, `tbl`, `col`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
    COMMENT '值域指标表';


-- todo （5）创建--环比增长指标表，monitor_report_day_on_day_volume
DROP TABLE IF EXISTS data_supervisor.monitor_report_day_on_day_volume ;
CREATE TABLE IF NOT EXISTS data_supervisor.monitor_report_day_on_day_volume
(
    `dt`                 date        NOT NULL COMMENT '日期',
    `tbl`                varchar(50) NOT NULL COMMENT '表名',
    `value`              double DEFAULT NULL COMMENT '环比增长百分比',
    `value_min`          double DEFAULT NULL COMMENT '增长上限',
    `value_max`          double DEFAULT NULL COMMENT '增长上限',
    `notification_level` int    DEFAULT NULL COMMENT '警告级别',
    PRIMARY KEY (`dt`, `tbl`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
    COMMENT '环比增长指标表';


-- todo （6）创建--同比增长指标表，monitor_report_week_on_week_volume
DROP TABLE IF EXISTS data_supervisor.monitor_report_week_on_week_volume ;
CREATE TABLE IF NOT EXISTS data_supervisor.monitor_report_week_on_week_volume
(
    `dt`                 date        NOT NULL COMMENT '日期',
    `tbl`                varchar(50) NOT NULL COMMENT '表名',
    `value`              double DEFAULT NULL COMMENT '同比增长百分比',
    `value_min`          double DEFAULT NULL COMMENT '增长上限',
    `value_max`          double DEFAULT NULL COMMENT '增长上限',
    `notification_level` int    DEFAULT NULL COMMENT '警告级别',
    PRIMARY KEY (`dt`, `tbl`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
    COMMENT '同比增长指标表';


