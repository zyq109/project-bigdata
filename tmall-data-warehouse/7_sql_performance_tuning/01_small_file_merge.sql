
/*
1. 小文件产生的原因
    1). 数据源本身就包含大量的小文件，例如api,kafka消息管道等；
    2). 动态分区插入数据的时候，会产生大量的小文件，从而导致map数量剧增；
    3). reduce 数量越多，小文件也越多，小文件数量=ReduceTask数量*分区数；
    4). hive中的小文件是向 hive 表中导入数据时产生；
*/


/*
2.小文件的危害
    todo 小文件通常是指文件大小要比HDFS块大小（一般是128M）还要小很多的文件。
*/
-- 1). 如果小文件过多会占用大量内存，会直接影响NameNode性能；HDFS读写小文件也会更加耗时
-- 2). 从 Hive 角度看，一个小文件会开启一个 MapTask，一个 MapTask开一个 JVM 去执行,会浪费大量的资源，严重影响性能。


/*
3. 小文件的解决方案
    todo 小文件的解决思路主要有两个方向：1.小文件的预防；2.已存在的小文件合并
*/

-- 3.1 小文件的预防
/*
    通过调整参数进行合并，在 hive 中执行 insert overwrite  tableA select xx  from tableB 之前设置如下合并参数，即可自动合并小文件。
*/
-- todo 设置map端输出时和reduce端输出时的合并参数
--设置map端输出进行合并，默认为true
set hive.merge.mapfiles = true;
--设置reduce端输出进行合并，默认为false
set hive.merge.mapredfiles = true;
--设置合并文件的大小
set hive.merge.size.per.task = 256*1000*1000;   -- 256M
--当输出文件的平均大小小于该值时，启动一个独立的MapReduce任务进行文件merge
set hive.merge.smallfiles.avgsize=16000000;   -- 16M



-- 3.2 已存在的小文件合并
/*
对集群上已存在的小文件进行定时或实时的合并操作，定时操作可在访问低峰期操作，如凌晨2点。
*/

/*
todo 3.2.1 方式一：insert overwrite (推荐)
 */

-- todo （1）创建备份表（创建备份表时需和原表的表结构一致）
DROP TABLE IF EXISTS gmall.tmp_ods_log_inc ;
CREATE TABLE IF NOT EXISTS gmall.tmp_ods_log_inc
    LIKE gmall.ods_log_inc
    LOCATION '/warehouse/gmall/tmp/tmp_ods_log_inc';


-- DESC gmall.tmp_ods_log_inc ;

-- todo （2）设置合并文件相关参数，并使用insert overwrite 语句读取原表，再插入备份表
/*
insert overwrite：会重写数据，先进行删除后插入（不用担心如果overwrite失败，数据没了，这里面是有事务保障的）;
distribute by分区：能控制数据从map端发往到哪个reduceTask中，
    distribute by的分区规则：分区字段的hashcode值对reduce 个数取模后， 余数相同的数据会分发到同一个reduceTask中。
rand()函数：生成0-1的随机小数，控制最终输出多少个文件。
*/
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE gmall.tmp_ods_log_inc PARTITION(dt)
SELECT * FROM gmall.ods_log_inc WHERE dt = '2024-09-12';



-- 检验原表和备份表数据量是否一致
SET hive.compute.query.using.stats=false ;
SET hive.fetch.task.conversion=none;
SELECT count(*) AS c1 FROM gmall.ods_log_inc WHERE dt = '2024-09-12';   -- 17992
SELECT count(*) AS c2 FROM gmall.tmp_ods_log_inc WHERE dt = '2024-09-12';  -- 17992

-- todo （3）确认表数据一致后，将临时表数据查询插入到原表，采用覆盖方式
-- hive的查询结果输出是否进行压缩
set hive.exec.compress.output=true;
-- MapReduce Job的结果输出是否使用压缩
set mapreduce.output.fileoutputformat.compress=true;
-- 设置压缩方式是snappy
set mapreduce.output.fileoutputformat.compress.codec = org.apache.hadoop.io.compress.GzipCodec;

INSERT OVERWRITE TABLE gmall.ods_log_inc PARTITION(dt)
SELECT * FROM gmall.tmp_ods_log_inc WHERE dt = '2024-09-12';


/*
todo 3.2.1 方式二：hadoop getmerge (推荐)
 */
-- 对于txt格式的文件可以使用hadoop getmerge命令来合并小文件。
-- 使用 getmerge 命令先合并数据到本地，再通过put命令回传数据到hdfs。

/*
-- 将hdfs上分区为pdate=20220815，文件路径为 /user/hive/warehouse/xxxx.db/xxxx/pdate=20220815/*
-- 下载到linux 本地进行合并文件，本地路径为：/home/hadoop/pdate/20220815
hdfs dfs -getmerge  /user/hive/warehouse/xxxx.db/xxxx/pdate=20220815/*  /home/hadoop/pdate/20220815;

-- 将hdfs源分区数据删除
hdfs dfs -rm  /user/hive/warehouse/xxxx.db/xxxx/pdate=20220815/*

-- 在hdfs上新建分区
hdfs dfs -mkdir -p /user/hive/warehouse/xxxx.db/xxxx/pdate=20220815

-- 将本地合并后的文件回传到hdfs上
hdfs dfs -put  /home/hadoop/pdate/20220815  /user/hive/warehouse/xxxx.db/xxxx/pdate=20220815/*
*/



