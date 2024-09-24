-- todo 数据加载： 5 日期维度表
/*
    数据来源于：
        通常情况下，时间维度表的数据并不是来自于业务系统，而是手动写入，并且由于时间维度表数据的可预见性，
    无须每日导入，一般可一次性导入一年的数据。
*/
--（1）创建临时表
DROP TABLE IF EXISTS gmall.tmp_dim_date_info;
CREATE TABLE gmall.tmp_dim_date_info (
                                         `date_id` STRING COMMENT '日',
                                         `week_id` STRING COMMENT '周ID',
                                         `week_day` STRING COMMENT '周几',
                                         `day` STRING COMMENT '每月的第几天',
                                         `month` STRING COMMENT '第几月',
                                         `quarter` STRING COMMENT '第几季度',
                                         `year` STRING COMMENT '年',
                                         `is_workday` STRING COMMENT '是否是工作日',
                                         `holiday_id` STRING COMMENT '节假日'
) COMMENT '时间维度表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/tmp/tmp_dim_date_info/';

-- （2）将数据文件上传到HFDS上临时表路径/warehouse/gmall/tmp/tmp_dim_date_info
-- hdfs dfs -put date_info_2024.txt /warehouse/gmall/tmp/tmp_dim_date_info/

--（3）执行以下语句将其导入时间维度表
INSERT OVERWRITE TABLE gmall.dim_date
-- SELECT * FROM gmall.dim_date
-- UNION
SELECT date_id,
       week_id,
       week_day,
    day,
    month,
    quarter,
    year,
    is_workday,
    holiday_id
FROM gmall.tmp_dim_date_info;

-- 测试
SELECT * FROM gmall.dim_date ;

