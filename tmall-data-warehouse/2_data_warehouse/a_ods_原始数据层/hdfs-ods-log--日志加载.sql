LOAD DATA INPATH '/origin_data/gmall/log/2024-09-11'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-11');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-12'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-12');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-13'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-13');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-14'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-14');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-15'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-15');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-16'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-16');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-17'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-17');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-18'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-18');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-19'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-19');

LOAD DATA INPATH '/origin_data/gmall/log/2024-09-20'
    OVERWRITE INTO TABLE gmall.ods_log_inc PARTITION(dt='2024-09-20');



SHOW PARTITIONS gmall.ods_log_inc