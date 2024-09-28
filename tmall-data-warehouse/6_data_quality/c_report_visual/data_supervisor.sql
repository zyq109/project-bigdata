/*
SQLyog Ultimate v8.32 
MySQL - 5.7.29-log : Database - data_supervisor
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE /*!32312 IF NOT EXISTS*/`data_supervisor` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `data_supervisor`;

/*Table structure for table `monitor_report_day_on_day_volume` */

DROP TABLE IF EXISTS `monitor_report_day_on_day_volume`;

CREATE TABLE `monitor_report_day_on_day_volume` (
  `dt` date NOT NULL COMMENT '日期',
  `tbl` varchar(50) NOT NULL COMMENT '表名',
  `value` double DEFAULT NULL COMMENT '环比增长百分比',
  `value_min` double DEFAULT NULL COMMENT '增长上限',
  `value_max` double DEFAULT NULL COMMENT '增长上限',
  `notification_level` int(11) DEFAULT NULL COMMENT '警告级别',
  PRIMARY KEY (`dt`,`tbl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='环比增长指标表';

/*Data for the table `monitor_report_day_on_day_volume` */

insert  into `monitor_report_day_on_day_volume`(`dt`,`tbl`,`value`,`value_min`,`value_max`,`notification_level`) values ('2024-09-16','ods_order_info',10000,-10,10,1),('2024-09-17','ods_order_info',20,-10,10,1),('2024-09-18','ods_order_info',15,-10,10,1),('2024-09-19','ods_order_info',8.5,-10,10,1),('2024-09-20','ods_order_info',12.2,-10,10,1),('2024-09-21','ods_order_info',-4.5,-10,10,1),('2024-09-22','ods_order_info',7.8,-10,10,1),('2024-09-23','ods_order_info',12.8,-10,10,1);

/*Table structure for table `monitor_report_duplicate_id` */

DROP TABLE IF EXISTS `monitor_report_duplicate_id`;

CREATE TABLE `monitor_report_duplicate_id` (
  `dt` date NOT NULL COMMENT '日期',
  `tbl` varchar(50) NOT NULL COMMENT '表名',
  `col` varchar(50) NOT NULL COMMENT '列名',
  `value` int(11) DEFAULT NULL COMMENT '重复值个数',
  `value_min` int(11) DEFAULT NULL COMMENT '下限',
  `value_max` int(11) DEFAULT NULL COMMENT '上限',
  `notification_level` int(11) DEFAULT NULL COMMENT '警告级别',
  PRIMARY KEY (`dt`,`tbl`,`col`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='重复值指标表';

/*Data for the table `monitor_report_duplicate_id` */

insert  into `monitor_report_duplicate_id`(`dt`,`tbl`,`col`,`value`,`value_min`,`value_max`,`notification_level`) values ('2024-09-16','dim_user_info','id',0,0,5,0),('2024-09-16','dwd_order_info','id',1,0,5,0),('2024-09-17','dim_user_info','id',0,0,5,0),('2024-09-17','dwd_order_info','id',2,0,5,0),('2024-09-18','dim_user_info','id',0,0,5,0),('2024-09-18','dwd_order_info','id',0,0,5,0),('2024-09-19','dim_user_info','id',0,0,5,0),('2024-09-19','dwd_order_info','id',1,0,5,0),('2024-09-20','dim_user_info','id',1,0,5,0),('2024-09-20','dwd_order_info','id',0,0,5,0),('2024-09-21','dim_user_info','id',0,0,5,0),('2024-09-21','dwd_order_info','id',1,0,5,0),('2024-09-22','dim_user_info','id',0,0,5,0),('2024-09-22','dwd_order_info','id',2,0,5,0),('2024-09-23','dim_user_info','id',1,0,5,0),('2024-09-23','dwd_order_info','id',0,0,5,0);

/*Table structure for table `monitor_report_null_id` */

DROP TABLE IF EXISTS `monitor_report_null_id`;

CREATE TABLE `monitor_report_null_id` (
  `dt` date NOT NULL COMMENT '日期',
  `tbl` varchar(50) NOT NULL COMMENT '表名',
  `col` varchar(50) NOT NULL COMMENT '列名',
  `value` int(11) DEFAULT NULL COMMENT '空ID个数',
  `value_min` int(11) DEFAULT NULL COMMENT '下限',
  `value_max` int(11) DEFAULT NULL COMMENT '上限',
  `notification_level` int(11) DEFAULT NULL COMMENT '警告级别',
  PRIMARY KEY (`dt`,`tbl`,`col`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='空值指标表';

/*Data for the table `monitor_report_null_id` */

insert  into `monitor_report_null_id`(`dt`,`tbl`,`col`,`value`,`value_min`,`value_max`,`notification_level`) values ('2024-09-16','dim_user_info','id',0,0,10,0),('2024-09-16','dwd_order_info','id',1,0,10,0),('2024-09-17','dim_user_info','id',0,0,10,0),('2024-09-17','dwd_order_info','id',0,0,10,0),('2024-09-18','dim_user_info','id',1,0,10,0),('2024-09-18','dwd_order_info','id',2,0,10,0),('2024-09-19','dim_user_info','id',0,0,10,0),('2024-09-19','dwd_order_info','id',0,0,10,0),('2024-09-20','dim_user_info','id',1,0,10,0),('2024-09-20','dwd_order_info','id',1,0,10,0),('2024-09-21','dim_user_info','id',0,0,10,0),('2024-09-21','dwd_order_info','id',4,0,10,0),('2024-09-22','dim_user_info','id',0,0,10,0),('2024-09-22','dwd_order_info','id',2,0,10,0),('2024-09-23','dim_user_info','id',1,0,10,0),('2024-09-23','dwd_order_info','id',0,0,10,0);

/*Table structure for table `monitor_report_range_value` */

DROP TABLE IF EXISTS `monitor_report_range_value`;

CREATE TABLE `monitor_report_range_value` (
  `dt` date NOT NULL COMMENT '日期',
  `tbl` varchar(50) NOT NULL COMMENT '表名',
  `col` varchar(50) NOT NULL COMMENT '列名',
  `value` int(11) DEFAULT NULL COMMENT '超出预定值域个数',
  `range_min` int(11) DEFAULT NULL COMMENT '值域下限',
  `range_max` int(11) DEFAULT NULL COMMENT '值域上限',
  `value_min` int(11) DEFAULT NULL COMMENT '下限',
  `value_max` int(11) DEFAULT NULL COMMENT '上限',
  `notification_level` int(11) DEFAULT NULL COMMENT '警告级别',
  PRIMARY KEY (`dt`,`tbl`,`col`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='值域指标表';

/*Data for the table `monitor_report_range_value` */

insert  into `monitor_report_range_value`(`dt`,`tbl`,`col`,`value`,`range_min`,`range_max`,`value_min`,`value_max`,`notification_level`) values ('2024-09-16','ods_order_info','final_amount',5,0,100000,0,100,1),('2024-09-17','ods_order_info','final_amount',12,0,100000,0,100,1),('2024-09-18','ods_order_info','final_amount',0,0,100000,0,100,1),('2024-09-19','ods_order_info','final_amount',23,0,100000,0,100,1),('2024-09-20','ods_order_info','final_amount',0,0,100000,0,100,1),('2024-09-21','ods_order_info','final_amount',5,0,100000,0,100,1),('2024-09-22','ods_order_info','final_amount',8,0,100000,0,100,1),('2024-09-23','ods_order_info','final_amount',16,0,100000,0,100,1);

/*Table structure for table `monitor_report_week_on_week_volume` */

DROP TABLE IF EXISTS `monitor_report_week_on_week_volume`;

CREATE TABLE `monitor_report_week_on_week_volume` (
  `dt` date NOT NULL COMMENT '日期',
  `tbl` varchar(50) NOT NULL COMMENT '表名',
  `value` double DEFAULT NULL COMMENT '同比增长百分比',
  `value_min` double DEFAULT NULL COMMENT '增长上限',
  `value_max` double DEFAULT NULL COMMENT '增长上限',
  `notification_level` int(11) DEFAULT NULL COMMENT '警告级别',
  PRIMARY KEY (`dt`,`tbl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='同比增长指标表';

/*Data for the table `monitor_report_week_on_week_volume` */

insert  into `monitor_report_week_on_week_volume`(`dt`,`tbl`,`value`,`value_min`,`value_max`,`notification_level`) values ('2024-09-16','ods_order_info',10000,-10,50,1),('2024-09-17','ods_order_info',8.34,-10,50,1),('2024-09-18','ods_order_info',4.35,-10,50,1),('2024-09-19','ods_order_info',-12.29,-10,50,1),('2024-09-20','ods_order_info',15.98,-10,50,1),('2024-09-21','ods_order_info',-3.47,-10,50,1),('2024-09-22','ods_order_info',5.9,-10,50,1),('2024-09-23','ods_order_info',-2.26,-10,50,1);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
