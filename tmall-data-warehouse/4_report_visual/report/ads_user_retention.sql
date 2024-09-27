/*
Navicat MySQL Data Transfer

Source Server         : node101-mysql
Source Server Version : 50729
Source Host           : node101:3306
Source Database       : gmall_report

Target Server Type    : MYSQL
Target Server Version : 50729
File Encoding         : 65001

Date: 2024-04-15 13:15:50
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for ads_user_retention
-- ----------------------------
DROP TABLE IF EXISTS `ads_user_retention`;
CREATE TABLE `ads_user_retention` (
  `dt` date NOT NULL COMMENT '统计日期',
  `create_date` varchar(16) NOT NULL COMMENT '用户新增日期',
  `retention_day` int(20) NOT NULL COMMENT '截至当前日期留存天数',
  `retention_count` bigint(20) DEFAULT NULL COMMENT '留存用户数量',
  `new_user_count` bigint(20) DEFAULT NULL COMMENT '新增用户数量',
  `retention_rate` decimal(16,2) DEFAULT NULL COMMENT '留存率',
  PRIMARY KEY (`dt`,`create_date`,`retention_day`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='留存率';

-- ----------------------------
-- Records of ads_user_retention
-- ----------------------------
INSERT INTO `ads_user_retention` VALUES ('2024-09-12', '2024-09-11', '1', '7', '642', '1.09');
INSERT INTO `ads_user_retention` VALUES ('2024-09-13', '2024-09-11', '2', '6', '642', '0.93');
INSERT INTO `ads_user_retention` VALUES ('2024-09-13', '2024-09-12', '1', '12', '691', '1.74');
INSERT INTO `ads_user_retention` VALUES ('2024-09-14', '2024-09-11', '3', '5', '642', '0.78');
INSERT INTO `ads_user_retention` VALUES ('2024-09-14', '2024-09-12', '2', '12', '691', '1.74');
INSERT INTO `ads_user_retention` VALUES ('2024-09-14', '2024-09-13', '1', '10', '647', '1.55');
INSERT INTO `ads_user_retention` VALUES ('2024-09-15', '2024-09-11', '4', '3', '642', '0.47');
INSERT INTO `ads_user_retention` VALUES ('2024-09-15', '2024-09-12', '3', '9', '691', '1.30');
INSERT INTO `ads_user_retention` VALUES ('2024-09-15', '2024-09-13', '2', '8', '647', '1.24');
INSERT INTO `ads_user_retention` VALUES ('2024-09-15', '2024-09-14', '1', '16', '629', '2.49');
INSERT INTO `ads_user_retention` VALUES ('2024-09-16', '2024-09-11', '5', '4', '642', '0.62');
INSERT INTO `ads_user_retention` VALUES ('2024-09-16', '2024-09-12', '4', '8', '691', '1.24');
INSERT INTO `ads_user_retention` VALUES ('2024-09-16', '2024-09-13', '3', '9', '647', '1.39');
INSERT INTO `ads_user_retention` VALUES ('2024-09-16', '2024-09-14', '2', '11', '629', '1.75');
INSERT INTO `ads_user_retention` VALUES ('2024-09-16', '2024-09-15', '1', '3', '247', '1.21');
INSERT INTO `ads_user_retention` VALUES ('2024-09-17', '2024-09-11', '6', '5', '642', '0.78');
INSERT INTO `ads_user_retention` VALUES ('2024-09-17', '2024-09-12', '5', '8', '691', '1.16');
INSERT INTO `ads_user_retention` VALUES ('2024-09-17', '2024-09-13', '4', '9', '647', '1.39');
INSERT INTO `ads_user_retention` VALUES ('2024-09-17', '2024-09-14', '3', '10', '629', '1.59');
INSERT INTO `ads_user_retention` VALUES ('2024-09-17', '2024-09-15', '2', '3', '247', '1.21');
INSERT INTO `ads_user_retention` VALUES ('2024-09-17', '2024-09-16', '1', '6', '241', '2.49');
INSERT INTO `ads_user_retention` VALUES ('2024-09-18', '2024-09-11', '7', '3', '642', '0.47');
INSERT INTO `ads_user_retention` VALUES ('2024-09-18', '2024-09-12', '6', '6', '691', '0.87');
INSERT INTO `ads_user_retention` VALUES ('2024-09-18', '2024-09-13', '5', '9', '647', '1.39');
INSERT INTO `ads_user_retention` VALUES ('2024-09-18', '2024-09-14', '4', '10', '629', '1.59');
INSERT INTO `ads_user_retention` VALUES ('2024-09-18', '2024-09-15', '3', '5', '247', '2.02');
INSERT INTO `ads_user_retention` VALUES ('2024-09-18', '2024-09-16', '2', '4', '241', '1.66');
INSERT INTO `ads_user_retention` VALUES ('2024-09-18', '2024-09-17', '1', '6', '562', '1.07');
