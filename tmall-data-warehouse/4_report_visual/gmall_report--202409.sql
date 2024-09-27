/*
Navicat MySQL Data Transfer

Source Server         : node101-mysql
Source Server Version : 50729
Source Host           : node101:3306
Source Database       : gmall_report

Target Server Type    : MYSQL
Target Server Version : 50729
File Encoding         : 65001

Date: 2024-09-29 14:20:57
*/

SET FOREIGN_KEY_CHECKS=0;

USE gmall_report ;
-- ----------------------------
-- Table structure for ads_coupon_stats
-- ----------------------------
DROP TABLE IF EXISTS `ads_coupon_stats`;
CREATE TABLE `ads_coupon_stats` (
  `dt` date NOT NULL COMMENT '统计日期',
  `coupon_id` varchar(20) NOT NULL COMMENT '优惠券ID',
  `coupon_name` varchar(128) NOT NULL COMMENT '优惠券名称',
  `used_count` bigint(20) DEFAULT NULL COMMENT '使用次数',
  `used_user_count` bigint(20) DEFAULT NULL COMMENT '使用人数',
  PRIMARY KEY (`dt`,`coupon_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='优惠券使用统计';

-- ----------------------------
-- Records of ads_coupon_stats
-- ----------------------------
INSERT INTO `ads_coupon_stats` VALUES ('2024-09-18', '1', '口红品类券', '45', '35');
INSERT INTO `ads_coupon_stats` VALUES ('2024-09-18', '2', '洋河酒品类卷', '154', '143');
INSERT INTO `ads_coupon_stats` VALUES ('2024-09-18', '3', '娃哈哈饮料品类卷', '244', '210');
INSERT INTO `ads_coupon_stats` VALUES ('2024-09-18', '4', '茅台酒品类卷', '88', '80');

-- ----------------------------
-- Table structure for ads_order_by_province
-- ----------------------------
DROP TABLE IF EXISTS `ads_order_by_province`;
CREATE TABLE `ads_order_by_province` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
  `province_id` varchar(16) NOT NULL COMMENT '省份ID',
  `province_name` varchar(16) DEFAULT NULL COMMENT '省份名称',
  `area_code` varchar(16) DEFAULT NULL COMMENT '地区编码',
  `iso_code` varchar(16) DEFAULT NULL COMMENT '国际标准地区编码',
  `iso_code_3166_2` varchar(16) DEFAULT NULL COMMENT '国际标准地区编码',
  `order_count` bigint(20) DEFAULT NULL COMMENT '订单数',
  `order_total_amount` decimal(16,2) DEFAULT NULL COMMENT '订单金额',
  PRIMARY KEY (`dt`,`recent_days`,`province_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='各地区订单统计';

-- ----------------------------
-- Records of ads_order_by_province
-- ----------------------------
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '1', '北京', '110000', 'CN-11', 'CN-BJ', '881', '95354.96');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '10', '福建', '350000', 'CN-35', 'CN-FJ', '242', '23378.18');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '11', '江西', '360000', 'CN-36', 'CN-JX', '823', '18132.28');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '12', '山东', '370000', 'CN-37', 'CN-SD', '948', '86241.01');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '13', '重庆', '500000', 'CN-50', 'CN-CQ', '144', '87735.31');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '14', '台湾', '710000', 'CN-71', 'CN-TW', '1062', '57107.64');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '15', '黑龙江', '230000', 'CN-23', 'CN-HL', '829', '31121.37');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '16', '吉林', '220000', 'CN-22', 'CN-JL', '87', '35451.39');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '17', '辽宁', '210000', 'CN-21', 'CN-LN', '268', '96317.95');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '18', '陕西', '610000', 'CN-61', 'CN-SN', '501', '85732.84');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '19', '甘肃', '620000', 'CN-62', 'CN-GS', '1037', '8896.57');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '2', '天津', '120000', 'CN-12', 'CN-TJ', '428', '89221.65');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '20', '青海', '630000', 'CN-63', 'CN-QH', '942', '84530.29');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '21', '宁夏', '640000', 'CN-64', 'CN-NX', '714', '45258.56');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '22', '新疆', '650000', 'CN-65', 'CN-XJ', '438', '59453.36');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '23', '河南', '410000', 'CN-41', 'CN-HA', '666', '36819.42');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '24', '湖北', '420000', 'CN-42', 'CN-HB', '977', '29871.13');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '25', '湖南', '430000', 'CN-43', 'CN-HN', '32', '63094.85');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '26', '广东', '440000', 'CN-44', 'CN-GD', '254', '85511.44');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '27', '广西', '450000', 'CN-45', 'CN-GX', '64', '87915.94');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '28', '海南', '460000', 'CN-46', 'CN-HI', '433', '93513.96');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '29', '香港', '810000', 'CN-91', 'CN-HK', '496', '57142.98');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '3', '山西', '140000', 'CN-14', 'CN-SX', '640', '42522.90');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '30', '澳门', '820000', 'CN-92', 'CN-MO', '823', '54340.29');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '31', '四川', '510000', 'CN-51', 'CN-SC', '85', '12079.88');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '32', '贵州', '520000', 'CN-52', 'CN-GZ', '786', '90773.79');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '33', '云南', '530000', 'CN-53', 'CN-YN', '519', '43261.71');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '34', '西藏', '540000', 'CN-54', 'CN-XZ', '732', '97662.95');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '4', '内蒙古', '150000', 'CN-15', 'CN-NM', '375', '75625.51');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '5', '河北', '130000', 'CN-13', 'CN-HE', '603', '74362.86');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '6', '上海', '310000', 'CN-31', 'CN-SH', '823', '51595.64');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '7', '江苏', '320000', 'CN-32', 'CN-JS', '83', '9420.12');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '8', '浙江', '330000', 'CN-33', 'CN-ZJ', '1023', '93949.25');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '1', '9', '安徽', '340000', 'CN-34', 'CN-AH', '475', '102675.49');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '1', '北京', '110000', 'CN-11', 'CN-BJ', '4353', '345974.86');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '10', '福建', '350000', 'CN-35', 'CN-FJ', '5682', '52044.30');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '11', '江西', '360000', 'CN-36', 'CN-JX', '1405', '150264.13');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '12', '山东', '370000', 'CN-37', 'CN-SD', '6102', '380247.55');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '13', '重庆', '500000', 'CN-50', 'CN-CQ', '1697', '546587.59');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '14', '台湾', '710000', 'CN-71', 'CN-TW', '3689', '50252.11');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '15', '黑龙江', '230000', 'CN-23', 'CN-HL', '1978', '384682.73');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '16', '吉林', '220000', 'CN-22', 'CN-JL', '2214', '61740.17');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '17', '辽宁', '210000', 'CN-21', 'CN-LN', '1921', '540898.09');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '18', '陕西', '610000', 'CN-61', 'CN-SN', '2231', '651241.95');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '19', '甘肃', '620000', 'CN-62', 'CN-GS', '163', '526860.57');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '2', '天津', '120000', 'CN-12', 'CN-TJ', '3382', '403070.46');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '20', '青海', '630000', 'CN-63', 'CN-QH', '1246', '542140.19');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '21', '宁夏', '640000', 'CN-64', 'CN-NX', '327', '96190.69');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '22', '新疆', '650000', 'CN-65', 'CN-XJ', '1980', '100484.09');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '23', '河南', '410000', 'CN-41', 'CN-HA', '5194', '610508.18');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '24', '湖北', '420000', 'CN-42', 'CN-HB', '4962', '79826.68');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '25', '湖南', '430000', 'CN-43', 'CN-HN', '4082', '308062.96');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '26', '广东', '440000', 'CN-44', 'CN-GD', '4047', '502900.10');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '27', '广西', '450000', 'CN-45', 'CN-GX', '4902', '581880.50');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '28', '海南', '460000', 'CN-46', 'CN-HI', '5096', '611671.31');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '29', '香港', '810000', 'CN-91', 'CN-HK', '4517', '433992.34');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '3', '山西', '140000', 'CN-14', 'CN-SX', '2556', '613821.55');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '30', '澳门', '820000', 'CN-92', 'CN-MO', '4528', '260835.78');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '31', '四川', '510000', 'CN-51', 'CN-SC', '1388', '467003.64');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '32', '贵州', '520000', 'CN-52', 'CN-GZ', '3931', '124047.40');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '33', '云南', '530000', 'CN-53', 'CN-YN', '494', '394769.08');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '34', '西藏', '540000', 'CN-54', 'CN-XZ', '3902', '470230.48');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '4', '内蒙古', '150000', 'CN-15', 'CN-NM', '444', '292084.03');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '5', '河北', '130000', 'CN-13', 'CN-HE', '4272', '466080.42');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '6', '上海', '310000', 'CN-31', 'CN-SH', '2986', '584177.18');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '7', '江苏', '320000', 'CN-32', 'CN-JS', '3947', '95209.47');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '8', '浙江', '330000', 'CN-33', 'CN-ZJ', '1021', '580689.54');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '7', '9', '安徽', '340000', 'CN-34', 'CN-AH', '1831', '500391.79');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '1', '北京', '110000', 'CN-11', 'CN-BJ', '6375', '1301846.47');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '10', '福建', '350000', 'CN-35', 'CN-FJ', '9859', '479076.69');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '11', '江西', '360000', 'CN-36', 'CN-JX', '6002', '2062532.19');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '12', '山东', '370000', 'CN-37', 'CN-SD', '2665', '261474.70');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '13', '重庆', '500000', 'CN-50', 'CN-CQ', '13253', '2190028.92');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '14', '台湾', '710000', 'CN-71', 'CN-TW', '19955', '738659.36');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '15', '黑龙江', '230000', 'CN-23', 'CN-HL', '15885', '717153.90');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '16', '吉林', '220000', 'CN-22', 'CN-JL', '9207', '2268202.94');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '17', '辽宁', '210000', 'CN-21', 'CN-LN', '19375', '322639.60');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '18', '陕西', '610000', 'CN-61', 'CN-SN', '19716', '388763.72');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '19', '甘肃', '620000', 'CN-62', 'CN-GS', '9491', '1150228.39');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '2', '天津', '120000', 'CN-12', 'CN-TJ', '4283', '1360240.53');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '20', '青海', '630000', 'CN-63', 'CN-QH', '16624', '2034564.17');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '21', '宁夏', '640000', 'CN-64', 'CN-NX', '11882', '2179419.30');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '22', '新疆', '650000', 'CN-65', 'CN-XJ', '9418', '1822185.03');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '23', '河南', '410000', 'CN-41', 'CN-HA', '184', '974571.62');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '24', '湖北', '420000', 'CN-42', 'CN-HB', '12691', '524391.69');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '25', '湖南', '430000', 'CN-43', 'CN-HN', '10231', '265656.49');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '26', '广东', '440000', 'CN-44', 'CN-GD', '8589', '314139.88');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '27', '广西', '450000', 'CN-45', 'CN-GX', '8327', '607540.98');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '28', '海南', '460000', 'CN-46', 'CN-HI', '5166', '2178317.44');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '29', '香港', '810000', 'CN-91', 'CN-HK', '21031', '1301421.44');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '3', '山西', '140000', 'CN-14', 'CN-SX', '17683', '1381955.84');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '30', '澳门', '820000', 'CN-92', 'CN-MO', '1858', '381379.04');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '31', '四川', '510000', 'CN-51', 'CN-SC', '4438', '484085.09');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '32', '贵州', '520000', 'CN-52', 'CN-GZ', '19229', '1409874.34');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '33', '云南', '530000', 'CN-53', 'CN-YN', '18868', '1502340.63');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '34', '西藏', '540000', 'CN-54', 'CN-XZ', '14383', '2505373.62');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '4', '内蒙古', '150000', 'CN-15', 'CN-NM', '13945', '980413.99');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '5', '河北', '130000', 'CN-13', 'CN-HE', '3185', '904690.31');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '6', '上海', '310000', 'CN-31', 'CN-SH', '19662', '992803.82');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '7', '江苏', '320000', 'CN-32', 'CN-JS', '13151', '306743.09');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '8', '浙江', '330000', 'CN-33', 'CN-ZJ', '14547', '469937.10');
INSERT INTO `ads_order_by_province` VALUES ('2024-09-18', '30', '9', '安徽', '340000', 'CN-34', 'CN-AH', '5317', '792630.22');

-- ----------------------------
-- Table structure for ads_order_continuously_user_count
-- ----------------------------
DROP TABLE IF EXISTS `ads_order_continuously_user_count`;
CREATE TABLE `ads_order_continuously_user_count` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,7:最近7天',
  `order_continuously_user_count` bigint(20) DEFAULT NULL COMMENT '连续3日下单用户数',
  PRIMARY KEY (`dt`,`recent_days`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='最近7日内连续3日下单用户数统计';

-- ----------------------------
-- Records of ads_order_continuously_user_count
-- ----------------------------
INSERT INTO `ads_order_continuously_user_count` VALUES ('2024-09-18', '7', '34');
INSERT INTO `ads_order_continuously_user_count` VALUES ('2024-09-19', '7', '24');
INSERT INTO `ads_order_continuously_user_count` VALUES ('2024-09-20', '7', '45');
INSERT INTO `ads_order_continuously_user_count` VALUES ('2024-09-21', '7', '39');
INSERT INTO `ads_order_continuously_user_count` VALUES ('2024-09-22', '7', '76');
INSERT INTO `ads_order_continuously_user_count` VALUES ('2024-09-23', '7', '84');
INSERT INTO `ads_order_continuously_user_count` VALUES ('2024-09-24', '7', '52');

-- ----------------------------
-- Table structure for ads_order_stats_by_cate
-- ----------------------------
DROP TABLE IF EXISTS `ads_order_stats_by_cate`;
CREATE TABLE `ads_order_stats_by_cate` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
  `category1_id` varchar(16) NOT NULL COMMENT '一级分类id',
  `category1_name` varchar(64) DEFAULT NULL COMMENT '一级分类名称',
  `category2_id` varchar(16) NOT NULL COMMENT '二级分类id',
  `category2_name` varchar(64) DEFAULT NULL COMMENT '二级分类名称',
  `category3_id` varchar(16) NOT NULL COMMENT '三级分类id',
  `category3_name` varchar(64) DEFAULT NULL COMMENT '三级分类名称',
  `order_count` bigint(20) DEFAULT NULL COMMENT '订单数',
  `order_user_count` bigint(20) DEFAULT NULL COMMENT '订单人数',
  PRIMARY KEY (`dt`,`recent_days`,`category1_id`,`category2_id`,`category3_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='各分类商品交易统计';

-- ----------------------------
-- Records of ads_order_stats_by_cate
-- ----------------------------
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '1', '14', '食品饮料、保健食品', '82', '粮油调味', '803', '米面杂粮', '453', '213');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '1', '2', '手机', '13', '手机通讯', '61', '手机', '324', '180');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '1', '3', '家用电器', '16', '大 家 电', '86', '平板电视', '35', '26');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '1', '8', '个护化妆', '54', '香水彩妆', '473', '香水', '21', '20');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '1', '8', '个护化妆', '54', '香水彩妆', '477', '唇部', '28', '25');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '7', '14', '食品饮料、保健食品', '82', '粮油调味', '803', '米面杂粮', '453', '213');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '7', '2', '手机', '13', '手机通讯', '61', '手机', '324', '180');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '7', '3', '家用电器', '16', '大 家 电', '86', '平板电视', '35', '26');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '7', '8', '个护化妆', '54', '香水彩妆', '473', '香水', '21', '20');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '7', '8', '个护化妆', '54', '香水彩妆', '477', '唇部', '28', '25');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '30', '14', '食品饮料、保健食品', '82', '粮油调味', '803', '米面杂粮', '453', '213');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '30', '2', '手机', '13', '手机通讯', '61', '手机', '324', '180');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '30', '3', '家用电器', '16', '大 家 电', '86', '平板电视', '35', '26');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '30', '8', '个护化妆', '54', '香水彩妆', '473', '香水', '21', '20');
INSERT INTO `ads_order_stats_by_cate` VALUES ('2024-09-18', '30', '8', '个护化妆', '54', '香水彩妆', '477', '唇部', '28', '25');

-- ----------------------------
-- Table structure for ads_order_stats_by_tm
-- ----------------------------
DROP TABLE IF EXISTS `ads_order_stats_by_tm`;
CREATE TABLE `ads_order_stats_by_tm` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
  `tm_id` varchar(16) NOT NULL COMMENT '品牌ID',
  `tm_name` varchar(32) DEFAULT NULL COMMENT '品牌名称',
  `order_count` bigint(20) DEFAULT NULL COMMENT '订单数',
  `order_user_count` bigint(20) DEFAULT NULL COMMENT '订单人数',
  PRIMARY KEY (`dt`,`recent_days`,`tm_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='各品牌商品交易统计';

-- ----------------------------
-- Records of ads_order_stats_by_tm
-- ----------------------------
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '1', '三星', '54', '53');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '11', '香奈儿', '24', '22');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '2', '苹果', '56', '51');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '3', '华为', '88', '76');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '4', 'TCL', '21', '19');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '6', '长粒香', '231', '180');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '7', '金沙河', '131', '100');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '1', '9', 'CAREMiLLE', '34', '25');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '1', '三星', '54', '53');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '11', '香奈儿', '24', '22');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '2', '苹果', '56', '51');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '3', '华为', '88', '76');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '4', 'TCL', '21', '19');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '6', '长粒香', '231', '180');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '7', '金沙河', '131', '100');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '7', '9', 'CAREMiLLE', '34', '25');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '1', '三星', '54', '53');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '11', '香奈儿', '24', '22');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '2', '苹果', '56', '51');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '3', '华为', '88', '76');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '4', 'TCL', '21', '19');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '6', '长粒香', '231', '180');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '7', '金沙河', '131', '100');
INSERT INTO `ads_order_stats_by_tm` VALUES ('2024-09-18', '30', '9', 'CAREMiLLE', '34', '25');

-- ----------------------------
-- Table structure for ads_page_path
-- ----------------------------
DROP TABLE IF EXISTS `ads_page_path`;
CREATE TABLE `ads_page_path` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
  `source` varchar(64) NOT NULL COMMENT '跳转起始页面ID',
  `target` varchar(64) NOT NULL COMMENT '跳转终到页面ID',
  `path_count` bigint(20) DEFAULT NULL COMMENT '跳转次数',
  PRIMARY KEY (`dt`,`recent_days`,`source`,`target`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='页面浏览路径分析';

-- ----------------------------
-- Records of ads_page_path
-- ----------------------------
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-1:home', 'step-2:good_detail', '513');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-1:home', 'step-2:good_list', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-1:home', 'step-2:mine', '526');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-1:home', 'step-2:search', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-2:good_list', 'step-3:good_detail', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-2:mine', 'step-3:orders_unpaid', '526');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-2:search', 'step-3:good_list', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-3:good_detail', 'step-4:cart', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-3:good_list', 'step-4:good_detail', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-3:orders_unpaid', 'step-4:good_detail', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-3:orders_unpaid', 'step-4:trade', '257');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-4:cart', 'step-5:trade', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-4:good_detail', 'step-5:good_spec', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-4:good_detail', 'step-5:login', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-4:trade', 'step-5:payment', '257');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-5:good_spec', 'step-6:comment', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-5:login', 'step-6:good_detail', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-5:login', 'step-6:register', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-5:trade', 'step-6:payment', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-6:comment', 'step-7:home', '123');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-6:comment', 'step-7:trade', '146');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-6:good_detail', 'step-7:cart', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-6:register', 'step-7:good_detail', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-7:cart', 'step-8:trade', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-7:good_detail', 'step-8:cart', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-7:trade', 'step-8:payment', '146');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-8:cart', 'step-9:trade', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-8:trade', 'step-9:payment', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '1', 'step-9:trade', 'step-10:payment', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-1:home', 'step-2:good_detail', '513');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-1:home', 'step-2:good_list', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-1:home', 'step-2:mine', '526');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-1:home', 'step-2:search', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-2:good_list', 'step-3:good_detail', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-2:mine', 'step-3:orders_unpaid', '526');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-2:search', 'step-3:good_list', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-3:good_detail', 'step-4:cart', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-3:good_list', 'step-4:good_detail', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-3:orders_unpaid', 'step-4:good_detail', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-3:orders_unpaid', 'step-4:trade', '257');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-4:cart', 'step-5:trade', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-4:good_detail', 'step-5:good_spec', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-4:good_detail', 'step-5:login', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-4:trade', 'step-5:payment', '257');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-5:good_spec', 'step-6:comment', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-5:login', 'step-6:good_detail', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-5:login', 'step-6:register', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-5:trade', 'step-6:payment', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-6:comment', 'step-7:home', '123');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-6:comment', 'step-7:trade', '146');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-6:good_detail', 'step-7:cart', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-6:register', 'step-7:good_detail', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-7:cart', 'step-8:trade', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-7:good_detail', 'step-8:cart', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-7:trade', 'step-8:payment', '146');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-8:cart', 'step-9:trade', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-8:trade', 'step-9:payment', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '7', 'step-9:trade', 'step-10:payment', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-1:home', 'step-2:good_detail', '513');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-1:home', 'step-2:good_list', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-1:home', 'step-2:mine', '526');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-1:home', 'step-2:search', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-2:good_list', 'step-3:good_detail', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-2:mine', 'step-3:orders_unpaid', '526');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-2:search', 'step-3:good_list', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-3:good_detail', 'step-4:cart', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-3:good_list', 'step-4:good_detail', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-3:orders_unpaid', 'step-4:good_detail', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-3:orders_unpaid', 'step-4:trade', '257');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-4:cart', 'step-5:trade', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-4:good_detail', 'step-5:good_spec', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-4:good_detail', 'step-5:login', '1360');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-4:trade', 'step-5:payment', '257');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-5:good_spec', 'step-6:comment', '269');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-5:login', 'step-6:good_detail', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-5:login', 'step-6:register', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-5:trade', 'step-6:payment', '537');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-6:comment', 'step-7:home', '123');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-6:comment', 'step-7:trade', '146');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-6:good_detail', 'step-7:cart', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-6:register', 'step-7:good_detail', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-7:cart', 'step-8:trade', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-7:good_detail', 'step-8:cart', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-7:trade', 'step-8:payment', '146');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-8:cart', 'step-9:trade', '553');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-8:trade', 'step-9:payment', '807');
INSERT INTO `ads_page_path` VALUES ('2024-09-19', '30', 'step-9:trade', 'step-10:payment', '553');

-- ----------------------------
-- Table structure for ads_repeat_purchase_by_tm
-- ----------------------------
DROP TABLE IF EXISTS `ads_repeat_purchase_by_tm`;
CREATE TABLE `ads_repeat_purchase_by_tm` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,7:最近7天,30:最近30天',
  `tm_id` varchar(16) NOT NULL COMMENT '品牌ID',
  `tm_name` varchar(32) DEFAULT NULL COMMENT '品牌名称',
  `order_repeat_rate` decimal(16,2) DEFAULT NULL COMMENT '复购率',
  PRIMARY KEY (`dt`,`recent_days`,`tm_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='各品牌复购率统计';

-- ----------------------------
-- Records of ads_repeat_purchase_by_tm
-- ----------------------------
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '1', '三星', '0.50');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '11', '香奈儿', '0.15');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '2', '苹果', '0.33');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '3', '华为', '0.63');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '4', 'TCL', '0.24');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '6', '长粒香', '0.72');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '7', '金沙河', '0.45');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '7', '9', 'CAREMiLLE', '0.26');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '1', '三星', '0.43');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '11', '香奈儿', '0.18');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '2', '苹果', '0.36');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '3', '华为', '0.73');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '4', 'TCL', '0.34');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '6', '长粒香', '0.50');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '7', '金沙河', '0.48');
INSERT INTO `ads_repeat_purchase_by_tm` VALUES ('2024-09-18', '30', '9', 'CAREMiLLE', '0.22');

-- ----------------------------
-- Table structure for ads_sku_cart_num_top3_by_cate
-- ----------------------------
DROP TABLE IF EXISTS `ads_sku_cart_num_top3_by_cate`;
CREATE TABLE `ads_sku_cart_num_top3_by_cate` (
  `dt` date NOT NULL COMMENT '统计日期',
  `category1_id` varchar(16) NOT NULL COMMENT '一级分类ID',
  `category1_name` varchar(64) DEFAULT NULL COMMENT '一级分类名称',
  `category2_id` varchar(16) NOT NULL COMMENT '二级分类ID',
  `category2_name` varchar(64) DEFAULT NULL COMMENT '二级分类名称',
  `category3_id` varchar(16) NOT NULL COMMENT '三级分类ID',
  `category3_name` varchar(64) DEFAULT NULL COMMENT '三级分类名称',
  `sku_id` varchar(16) NOT NULL COMMENT '商品id',
  `sku_name` varchar(128) DEFAULT NULL COMMENT '商品名称',
  `cart_num` bigint(20) DEFAULT NULL COMMENT '购物车中商品数量',
  `rk` bigint(20) DEFAULT NULL COMMENT '排名',
  PRIMARY KEY (`dt`,`sku_id`,`category1_id`,`category2_id`,`category3_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='各分类商品购物车存量TopN';

-- ----------------------------
-- Records of ads_sku_cart_num_top3_by_cate
-- ----------------------------
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '2', '手机', '13', '手机通讯', '61', '手机', '1', '小米10 至尊纪念版 双模5G 骁龙865 120HZ高刷新率 120倍长焦镜头 120W快充 8GB+128GB 陶瓷黑 游戏手机', '99', '1');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '2', '手机', '13', '手机通讯', '61', '手机', '13', '华为 HUAWEI P40 麒麟990 5G SoC芯片 5000万超感知徕卡三摄 30倍数字变焦 6GB+128GB亮黑色全网通5G手机', '88', '2');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '2', '手机', '13', '手机通讯', '61', '手机', '16', '华为 HUAWEI P40 麒麟990 5G SoC芯片 5000万超感知徕卡三摄 30倍数字变焦 8GB+128GB亮黑色全网通5G手机', '82', '3');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '3', '家用电器', '16', '大家电', '86', '平板电视', '17', 'TCL 65Q10 65英寸 QLED原色量子点电视 安桥音响 AI声控智慧屏 超薄全面屏 MEMC防抖 3+32GB 平板电视', '34', '3');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '3', '家用电器', '16', '大家电', '86', '平板电视', '18', 'TCL 75Q10 75英寸 QLED原色量子点电视 安桥音响 AI声控智慧屏 超薄全面屏 MEMC防抖 3+32GB 平板电视', '57', '2');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '14', '食品饮料、保健食品', '82', '粮油调味', '803', '米面杂粮', '22', '十月稻田 长粒香大米 东北大米 东北香米 5kg', '157', '3');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '14', '食品饮料、保健食品', '82', '粮油调味', '803', '米面杂粮', '23', '十月稻田 辽河长粒香 东北大米 5kg', '543', '1');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '14', '食品饮料、保健食品', '82', '粮油调味', '803', '米面杂粮', '25', '金沙河面条 银丝挂面900g*3包 爽滑 细面条 龙须面 速食面', '342', '2');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '8', '个护化妆', '54', '香水彩妆', '477', '唇部', '26', '索芙特i-Softto 口红不掉色唇膏保湿滋润 璀璨金钻哑光唇膏 Y01复古红 百搭气质 璀璨金钻哑光唇膏 ', '44', '2');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '8', '个护化妆', '54', '香水彩妆', '477', '唇部', '28', '索芙特i-Softto 口红不掉色唇膏保湿滋润 璀璨金钻哑光唇膏 Z03女王红 性感冷艳 璀璨金钻哑光唇膏 ', '35', '3');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '8', '个护化妆', '54', '香水彩妆', '477', '唇部', '31', 'CAREMiLLE珂曼奶油小方口红 雾面滋润保湿持久丝缎唇膏 M03赤茶', '52', '1');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '8', '个护化妆', '54', '香水彩妆', '473', '香水', '32', '香奈儿（Chanel）女士香水5号香水 粉邂逅柔情淡香水EDT 5号淡香水35ml', '14', '1');
INSERT INTO `ads_sku_cart_num_top3_by_cate` VALUES ('2024-09-18', '3', '家用电器', '16', '大家电', '86', '平板电视', '35', '华为智慧屏V65i 65英寸 HEGE-560B 4K全面屏智能电视机 多方视频通话 AI升降摄像头 4GB+32GB 星际黑', '65', '1');

-- ----------------------------
-- Table structure for ads_sku_favor_count_top3_by_tm
-- ----------------------------
DROP TABLE IF EXISTS `ads_sku_favor_count_top3_by_tm`;
CREATE TABLE `ads_sku_favor_count_top3_by_tm` (
  `dt` date NOT NULL COMMENT '统计日期',
  `tm_id` varchar(20) NOT NULL COMMENT '品牌ID',
  `tm_name` varchar(128) DEFAULT NULL COMMENT '品牌名称',
  `sku_id` varchar(20) NOT NULL COMMENT 'SKU_ID',
  `sku_name` varchar(128) DEFAULT NULL COMMENT 'SKU名称',
  `favor_count` bigint(20) DEFAULT NULL COMMENT '被收藏次数',
  `rk` bigint(20) DEFAULT NULL COMMENT '排名',
  PRIMARY KEY (`dt`,`tm_id`,`sku_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='各品牌商品收藏次数TopN';

-- ----------------------------
-- Records of ads_sku_favor_count_top3_by_tm
-- ----------------------------
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '1', '三星', '3', '小米10 至尊纪念版 双模5G 骁龙865 120HZ高刷新率 120倍长焦镜头 120W快充 8GB+128GB 透明版 游戏手机', '44', '3');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '1', '三星', '4', 'Redmi 10X 4G Helio G85游戏芯 4800万超清四摄 5020mAh大电量 小孔全面屏 128GB大存储 4GB+128GB 冰雾白 游戏智能手机 小米 红米', '55', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '1', '三星', '6', 'Redmi 10X 4G Helio G85游戏芯 4800万超清四摄 5020mAh大电量 小孔全面屏 128GB大存储 8GB+128GB 冰雾白 游戏智能手机 小米 红米', '65', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '11', '香奈儿', '32', '香奈儿（Chanel）女士香水5号香水 粉邂逅柔情淡香水EDT 5号淡香水35ml', '54', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '11', '香奈儿', '33', '香奈儿（Chanel）女士香水5号香水 粉邂逅柔情淡香水EDT 粉邂逅淡香水35ml', '88', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '2', '苹果', '11', 'Apple iPhone 12 (A2404) 64GB 白色 支持移动联通电信5G 双卡双待手机', '56', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '2', '苹果', '12', 'Apple iPhone 12 (A2404) 128GB 黑色 支持移动联通电信5G 双卡双待手机', '43', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '2', '苹果', '9', 'Apple iPhone 12 (A2404) 64GB 红色 支持移动联通电信5G 双卡双待手机', '38', '3');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '3', '华为', '14', '华为 HUAWEI P40 麒麟990 5G SoC芯片 5000万超感知徕卡三摄 30倍数字变焦 6GB+128GB冰霜银全网通5G手机', '74', '3');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '3', '华为', '15', '华为 HUAWEI P40 麒麟990 5G SoC芯片 5000万超感知徕卡三摄 30倍数字变焦 8GB+128GB冰霜银全网通5G手机', '125', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '3', '华为', '35', '华为智慧屏V65i 65英寸 HEGE-560B 4K全面屏智能电视机 多方视频通话 AI升降摄像头 4GB+32GB 星际黑', '88', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '4', 'TCL', '17', 'TCL 65Q10 65英寸 QLED原色量子点电视 安桥音响 AI声控智慧屏 超薄全面屏 MEMC防抖 3+32GB 平板电视', '45', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '4', 'TCL', '18', 'TCL 75Q10 75英寸 QLED原色量子点电视 安桥音响 AI声控智慧屏 超薄全面屏 MEMC防抖 3+32GB 平板电视', '32', '3');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '4', 'TCL', '19', 'TCL 85Q6 85英寸 巨幕私人影院电视 4K超高清 AI智慧屏 全景全面屏 MEMC运动防抖 2+16GB 液晶平板电视机', '39', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '5', '小米', '20', '小米电视E65X 65英寸 全面屏 4K超高清HDR 蓝牙遥控内置小爱 2+8GB AI人工智能液晶网络平板电视 L65M5-EA', '87', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '5', '小米', '21', '小米电视4A 70英寸 4K超高清 HDR 二级能效 2GB+16GB L70M5-4A 内置小爱 智能网络液晶平板教育电视', '69', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '6', '长粒香', '22', '十月稻田 长粒香大米 东北大米 东北香米 5kg', '199', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '6', '长粒香', '23', '十月稻田 辽河长粒香 东北大米 5kg', '235', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '7', '金沙河', '24', '金沙河面条 原味银丝挂面 龙须面 方便速食拉面 清汤面 900g', '87', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '7', '金沙河', '25', '金沙河面条 银丝挂面900g*3包 爽滑 细面条 龙须面 速食面', '74', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '8', '索芙特', '26', '索芙特i-Softto 口红不掉色唇膏保湿滋润 璀璨金钻哑光唇膏 Y01复古红 百搭气质 璀璨金钻哑光唇膏 ', '19', '3');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '8', '索芙特', '27', '索芙特i-Softto 口红不掉色唇膏保湿滋润 璀璨金钻哑光唇膏 Z02少女红 活力青春 璀璨金钻哑光唇膏 ', '32', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '8', '索芙特', '28', '索芙特i-Softto 口红不掉色唇膏保湿滋润 璀璨金钻哑光唇膏 Z03女王红 性感冷艳 璀璨金钻哑光唇膏 ', '25', '2');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '9', 'CAREMiLLE', '29', 'CAREMiLLE珂曼奶油小方口红 雾面滋润保湿持久丝缎唇膏 M01醉蔷薇', '345', '1');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '9', 'CAREMiLLE', '30', 'CAREMiLLE珂曼奶油小方口红 雾面滋润保湿持久丝缎唇膏 M02干玫瑰', '125', '3');
INSERT INTO `ads_sku_favor_count_top3_by_tm` VALUES ('2024-09-18', '9', 'CAREMiLLE', '31', 'CAREMiLLE珂曼奶油小方口红 雾面滋润保湿持久丝缎唇膏 M03赤茶', '284', '2');

-- ----------------------------
-- Table structure for ads_trade_stats
-- ----------------------------
DROP TABLE IF EXISTS `ads_trade_stats`;
CREATE TABLE `ads_trade_stats` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(255) NOT NULL COMMENT '最近天数,1:最近1日',
  `order_total_amount` decimal(16,2) DEFAULT NULL COMMENT '订单总额,GMV',
  `order_count` bigint(20) DEFAULT NULL COMMENT '订单数',
  `order_user_count` bigint(20) DEFAULT NULL COMMENT '下单人数',
  PRIMARY KEY (`dt`,`recent_days`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='交易统计';

-- ----------------------------
-- Records of ads_trade_stats
-- ----------------------------
INSERT INTO `ads_trade_stats` VALUES ('2024-09-20', '1', '199999.00', '231', '123');
INSERT INTO `ads_trade_stats` VALUES ('2024-09-21', '1', '153453.00', '333', '257');
INSERT INTO `ads_trade_stats` VALUES ('2024-09-22', '1', '134533.00', '278', '232');
INSERT INTO `ads_trade_stats` VALUES ('2024-09-23', '1', '146789.00', '367', '329');
INSERT INTO `ads_trade_stats` VALUES ('2024-09-24', '1', '167654.00', '432', '399');
INSERT INTO `ads_trade_stats` VALUES ('2024-09-25', '1', '159876.00', '412', '400');
INSERT INTO `ads_trade_stats` VALUES ('2024-09-26', '1', '132467.00', '321', '310');
INSERT INTO `ads_trade_stats` VALUES ('2024-09-27', '1', '117261.00', '232', '189');

-- ----------------------------
-- Table structure for ads_traffic_stats_by_channel
-- ----------------------------
DROP TABLE IF EXISTS `ads_traffic_stats_by_channel`;
CREATE TABLE `ads_traffic_stats_by_channel` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
  `channel` varchar(16) NOT NULL COMMENT '渠道',
  `uv_count` bigint(20) DEFAULT NULL COMMENT '访客人数',
  `avg_duration_sec` bigint(20) DEFAULT NULL COMMENT '会话平均停留时长，单位为秒',
  `avg_page_count` bigint(20) DEFAULT NULL COMMENT '会话平均浏览页面数',
  `sv_count` bigint(20) DEFAULT NULL COMMENT '会话数',
  `bounce_rate` decimal(16,2) DEFAULT NULL COMMENT '跳出率',
  PRIMARY KEY (`dt`,`recent_days`,`channel`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='各渠道流量统计';

-- ----------------------------
-- Records of ads_traffic_stats_by_channel
-- ----------------------------
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', '360', '111', '71', '6', '145', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', 'Appstore', '1089', '69', '6', '1423', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', 'huawei', '115', '66', '6', '138', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', 'oppo', '510', '69', '6', '580', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', 'vivo', '118', '61', '5', '143', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', 'wandoujia', '265', '63', '6', '345', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', 'web', '233', '65', '6', '267', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '1', 'xiaomi', '758', '67', '6', '800', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', '360', '111', '71', '6', '111', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', 'Appstore', '1089', '69', '6', '1090', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', 'huawei', '115', '66', '6', '115', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', 'oppo', '510', '69', '6', '510', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', 'vivo', '118', '61', '5', '118', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', 'wandoujia', '265', '63', '6', '265', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', 'web', '233', '65', '6', '233', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '7', 'xiaomi', '758', '67', '6', '758', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', '360', '111', '71', '6', '111', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', 'Appstore', '1089', '69', '6', '1090', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', 'huawei', '115', '66', '6', '115', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', 'oppo', '510', '69', '6', '510', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', 'vivo', '118', '61', '5', '118', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', 'wandoujia', '265', '63', '6', '265', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', 'web', '233', '65', '6', '233', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-19', '30', 'xiaomi', '758', '67', '6', '758', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', '360', '117', '65', '6', '117', '0.04');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', 'Appstore', '1083', '67', '6', '1086', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', 'huawei', '118', '63', '6', '118', '0.11');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', 'oppo', '489', '64', '6', '491', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', 'vivo', '114', '67', '6', '114', '0.05');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', 'wandoujia', '271', '68', '6', '271', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', 'web', '232', '66', '6', '232', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '1', 'xiaomi', '773', '66', '6', '773', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', '360', '228', '68', '6', '228', '0.06');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', 'Appstore', '2172', '68', '6', '2176', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', 'huawei', '233', '65', '6', '233', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', 'oppo', '999', '66', '6', '1001', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', 'vivo', '232', '64', '6', '232', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', 'wandoujia', '536', '66', '6', '536', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', 'web', '465', '66', '6', '465', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '7', 'xiaomi', '1531', '67', '6', '1531', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', '360', '228', '68', '6', '228', '0.06');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', 'Appstore', '2172', '68', '6', '2176', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', 'huawei', '233', '65', '6', '233', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', 'oppo', '999', '66', '6', '1001', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', 'vivo', '232', '64', '6', '232', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', 'wandoujia', '536', '66', '6', '536', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', 'web', '465', '66', '6', '465', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-20', '30', 'xiaomi', '1531', '67', '6', '1531', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', '360', '105', '66', '6', '105', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', 'Appstore', '912', '65', '6', '914', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', 'huawei', '100', '66', '6', '100', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', 'oppo', '394', '67', '6', '394', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', 'vivo', '134', '69', '6', '134', '0.04');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', 'wandoujia', '179', '65', '6', '179', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', 'web', '216', '70', '6', '217', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '1', 'xiaomi', '610', '67', '6', '610', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', '360', '333', '67', '6', '333', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', 'Appstore', '3082', '67', '6', '3090', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', 'huawei', '333', '65', '6', '333', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', 'oppo', '1392', '67', '6', '1395', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', 'vivo', '366', '66', '6', '366', '0.06');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', 'wandoujia', '715', '65', '6', '715', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', 'web', '681', '67', '6', '682', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '7', 'xiaomi', '2140', '67', '6', '2141', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', '360', '333', '67', '6', '333', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', 'Appstore', '3082', '67', '6', '3090', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', 'huawei', '333', '65', '6', '333', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', 'oppo', '1392', '67', '6', '1395', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', 'vivo', '366', '66', '6', '366', '0.06');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', 'wandoujia', '715', '65', '6', '715', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', 'web', '681', '67', '6', '682', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-21', '30', 'xiaomi', '2140', '67', '6', '2141', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', '360', '121', '64', '6', '121', '0.11');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', 'Appstore', '1086', '65', '6', '1090', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', 'huawei', '132', '61', '5', '132', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', 'oppo', '490', '68', '6', '490', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', 'vivo', '127', '66', '6', '127', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', 'wandoujia', '237', '66', '6', '238', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', 'web', '255', '64', '6', '255', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '1', 'xiaomi', '749', '66', '6', '750', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', '360', '454', '66', '6', '454', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', 'Appstore', '4167', '67', '6', '4180', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', 'huawei', '465', '64', '6', '465', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', 'oppo', '1882', '67', '6', '1885', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', 'vivo', '493', '66', '6', '493', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', 'wandoujia', '949', '65', '6', '953', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', 'web', '936', '66', '6', '937', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '7', 'xiaomi', '2888', '67', '6', '2891', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', '360', '454', '66', '6', '454', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', 'Appstore', '4167', '67', '6', '4180', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', 'huawei', '465', '64', '6', '465', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', 'oppo', '1882', '67', '6', '1885', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', 'vivo', '493', '66', '6', '493', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', 'wandoujia', '949', '65', '6', '953', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', 'web', '936', '66', '6', '937', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-22', '30', 'xiaomi', '2888', '67', '6', '2891', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', '360', '153', '67', '6', '153', '0.11');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', 'Appstore', '1412', '66', '6', '1413', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', 'huawei', '146', '67', '6', '146', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', 'oppo', '617', '66', '6', '617', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', 'vivo', '145', '66', '6', '145', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', 'wandoujia', '310', '65', '6', '311', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', 'web', '315', '68', '6', '315', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '1', 'xiaomi', '899', '65', '6', '902', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', '360', '607', '66', '6', '607', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', 'Appstore', '5574', '66', '6', '5593', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', 'huawei', '611', '65', '6', '611', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', 'oppo', '2498', '67', '6', '2502', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', 'vivo', '638', '66', '6', '638', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', 'wandoujia', '1258', '65', '6', '1264', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', 'web', '1251', '67', '6', '1252', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '7', 'xiaomi', '3783', '66', '6', '3793', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', '360', '607', '66', '6', '607', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', 'Appstore', '5574', '66', '6', '5593', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', 'huawei', '611', '65', '6', '611', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', 'oppo', '2498', '67', '6', '2502', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', 'vivo', '638', '66', '6', '638', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', 'wandoujia', '1258', '65', '6', '1264', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', 'web', '1251', '67', '6', '1252', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-23', '30', 'xiaomi', '3783', '66', '6', '3793', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', '360', '152', '71', '6', '152', '0.05');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', 'Appstore', '1247', '65', '6', '1247', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', 'huawei', '157', '67', '6', '157', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', 'oppo', '551', '68', '6', '551', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', 'vivo', '134', '66', '6', '134', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', 'wandoujia', '239', '67', '6', '239', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', 'web', '294', '65', '6', '295', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '1', 'xiaomi', '826', '65', '6', '826', '0.10');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', '360', '759', '67', '6', '759', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', 'Appstore', '6815', '66', '6', '6840', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', 'huawei', '768', '65', '6', '768', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', 'oppo', '3046', '67', '6', '3053', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', 'vivo', '772', '66', '6', '772', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', 'wandoujia', '1497', '66', '6', '1503', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', 'web', '1545', '66', '6', '1547', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '7', 'xiaomi', '4603', '66', '6', '4619', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', '360', '759', '67', '6', '759', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', 'Appstore', '6815', '66', '6', '6840', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', 'huawei', '768', '65', '6', '768', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', 'oppo', '3046', '67', '6', '3053', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', 'vivo', '772', '66', '6', '772', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', 'wandoujia', '1497', '66', '6', '1503', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', 'web', '1545', '66', '6', '1547', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-24', '30', 'xiaomi', '4603', '66', '6', '4619', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', '360', '132', '70', '6', '133', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', 'Appstore', '1264', '68', '6', '1265', '0.07');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', 'huawei', '158', '65', '6', '158', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', 'oppo', '554', '66', '6', '554', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', 'vivo', '143', '68', '6', '143', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', 'wandoujia', '252', '68', '6', '252', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', 'web', '263', '68', '6', '263', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '1', 'xiaomi', '833', '67', '6', '833', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', '360', '891', '68', '6', '892', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', 'Appstore', '8070', '67', '6', '8105', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', 'huawei', '926', '65', '6', '926', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', 'oppo', '3598', '67', '6', '3607', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', 'vivo', '915', '66', '6', '915', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', 'wandoujia', '1749', '66', '6', '1755', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', 'web', '1808', '66', '6', '1810', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '7', 'xiaomi', '5429', '66', '6', '5452', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', '360', '891', '68', '6', '892', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', 'Appstore', '8070', '67', '6', '8105', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', 'huawei', '926', '65', '6', '926', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', 'oppo', '3598', '67', '6', '3607', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', 'vivo', '915', '66', '6', '915', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', 'wandoujia', '1749', '66', '6', '1755', '0.08');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', 'web', '1808', '66', '6', '1810', '0.09');
INSERT INTO `ads_traffic_stats_by_channel` VALUES ('2024-09-25', '30', 'xiaomi', '5429', '66', '6', '5452', '0.09');

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
INSERT INTO `ads_user_action` VALUES ('2024-09-18', '1', '2341', '1254', '675', '532', '520');
INSERT INTO `ads_user_action` VALUES ('2024-09-18', '7', '2341', '1254', '675', '532', '520');
INSERT INTO `ads_user_action` VALUES ('2024-09-18', '30', '2341', '1254', '675', '532', '520');
INSERT INTO `ads_user_action` VALUES ('2024-09-19', '1', '3429', '2654', '1032', '879', '846');
INSERT INTO `ads_user_action` VALUES ('2024-09-20', '1', '2564', '1897', '754', '543', '532');
INSERT INTO `ads_user_action` VALUES ('2024-09-21', '1', '3128', '2287', '1023', '543', '490');
INSERT INTO `ads_user_action` VALUES ('2024-09-22', '1', '3672', '3198', '897', '880', '875');
INSERT INTO `ads_user_action` VALUES ('2024-09-23', '1', '2984', '2573', '1006', '787', '721');
INSERT INTO `ads_user_action` VALUES ('2024-09-24', '1', '2654', '2009', '546', '432', '380');

-- ----------------------------
-- Table structure for ads_user_change
-- ----------------------------
DROP TABLE IF EXISTS `ads_user_change`;
CREATE TABLE `ads_user_change` (
  `dt` varchar(16) NOT NULL COMMENT '统计日期',
  `user_churn_count` varchar(16) DEFAULT NULL COMMENT '流失用户数',
  `user_back_count` varchar(16) DEFAULT NULL COMMENT '回流用户数',
  PRIMARY KEY (`dt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户变动统计';

-- ----------------------------
-- Records of ads_user_change
-- ----------------------------
INSERT INTO `ads_user_change` VALUES ('2024-09-18', '34', '45');
INSERT INTO `ads_user_change` VALUES ('2024-09-19', '54', '63');
INSERT INTO `ads_user_change` VALUES ('2024-09-20', '62', '48');
INSERT INTO `ads_user_change` VALUES ('2024-09-21', '36', '52');
INSERT INTO `ads_user_change` VALUES ('2024-09-22', '25', '41');
INSERT INTO `ads_user_change` VALUES ('2024-09-23', '34', '75');
INSERT INTO `ads_user_change` VALUES ('2024-09-24', '25', '32');

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

-- ----------------------------
-- Table structure for ads_user_stats
-- ----------------------------
DROP TABLE IF EXISTS `ads_user_stats`;
CREATE TABLE `ads_user_stats` (
  `dt` date NOT NULL COMMENT '统计日期',
  `recent_days` bigint(20) NOT NULL COMMENT '最近n日,1:最近1日,7:最近7日,30:最近30日',
  `new_user_count` bigint(20) DEFAULT NULL COMMENT '新增用户数',
  `active_user_count` bigint(20) DEFAULT NULL COMMENT '活跃用户数',
  PRIMARY KEY (`dt`,`recent_days`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户新增活跃统计';

-- ----------------------------
-- Records of ads_user_stats
-- ----------------------------
INSERT INTO `ads_user_stats` VALUES ('2024-09-18', '1', '195', '4321');
INSERT INTO `ads_user_stats` VALUES ('2024-09-18', '7', '213', '3265');
INSERT INTO `ads_user_stats` VALUES ('2024-09-18', '30', '145', '3462');
INSERT INTO `ads_user_stats` VALUES ('2024-09-19', '1', '89', '3763');
INSERT INTO `ads_user_stats` VALUES ('2024-09-20', '1', '56', '3215');
INSERT INTO `ads_user_stats` VALUES ('2024-09-21', '1', '132', '4997');
INSERT INTO `ads_user_stats` VALUES ('2024-09-22', '1', '112', '2764');
INSERT INTO `ads_user_stats` VALUES ('2024-09-23', '1', '98', '3075');
INSERT INTO `ads_user_stats` VALUES ('2024-09-24', '1', '78', '3615');
