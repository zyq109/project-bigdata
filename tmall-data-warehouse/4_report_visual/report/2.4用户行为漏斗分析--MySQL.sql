
-- todo：用户行为漏斗分析--SQL语句，在Superset中执行SQL，结果基于报表展示

SELECT dt, recent_days, '浏览首页人数' AS category_name, home_count AS category_value
FROM gmall_report.ads_user_action
union
SELECT dt, recent_days, '浏览商品详情页人数' AS category_name, good_detail_count AS category_value
FROM gmall_report.ads_user_action
union
SELECT dt, recent_days, '加购物车人数' AS category_name, cart_count AS category_value
FROM gmall_report.ads_user_action
union
SELECT dt,recent_days,  '下单人数' AS category_name, order_count AS category_value
FROM gmall_report.ads_user_action
union
SELECT dt, recent_days, '支付人数' AS category_name, payment_count AS category_value
FROM gmall_report.ads_user_action
;

/*
2024-04-18,浏览首页人数,2800
2024-04-18,浏览商品详情页人数,1800
2024-04-18,加购物车人数,600
2024-04-18,下单人数,350
2024-04-18,支付人数,300
*/

