/*
Navicat MySQL Data Transfer

Source Server         : node101-mysql
Source Server Version : 50729
Source Host           : node101:3306
Source Database       : gmall_report

Target Server Type    : MYSQL
Target Server Version : 50729
File Encoding         : 65001

Date: 2024-04-15 13:20:14
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for ads_user_action
-- ----------------------------
DROP TABLE IF EXISTS `ads_user_action`;
CREATE TABLE `ads_user_action` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
  `home_count` bigint(20) DEFAULT NULL COMMENT '浏览首页人数',
  `good_detail_count` bigint(20) DEFAULT NULL COMMENT '浏览商品详情页人数',
  `cart_count` bigint(20) DEFAULT NULL COMMENT '加入购物车人数',
  `order_count` bigint(20) DEFAULT NULL COMMENT '下单人数',
  `payment_count` bigint(20) DEFAULT NULL COMMENT '支付人数',
  PRIMARY KEY (`dt`,`recent_days`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='漏斗分析';

-- ----------------------------
-- Records of ads_user_action
-- ----------------------------
INSERT INTO `ads_user_action` VALUES ('2024-09-18', '1', '2800', '1800', '600', '350', '300');
