
-- 1空值检
SELECT count(*) AS cnt FROM gmall.dim_sku_full WHERE dt = '2024-09-11' AND id IS NULL ;

-- 2重复值检查
SELECT
	count(*) AS cnt
FROM (
	SELECT id FROM gmall.dim_sku_full WHERE dt = '2024-09-11' GROUP BY id HAVING count(id) >= 2
) t ;

-- 3值域检查
SELECT
	count(*) AS cnt
FROM gmall.ods_order_info_inc
WHERE dt = '2024-09-11'
	AND (final_amount < 0 OR final_amount > 100000)
;

-- 4环比增长: 天环比

SELECT '2024-09-11' AS dt, count(*) AS today_cnt FROM gmall.dim_sku_full WHERE dt = '2024-09-11' ;
SELECT '2024-09-11' AS dt, count(*) AS yesterday_cnt FROM gmall.dim_sku_full WHERE dt = date_sub('2024-09-11', 1) ;

--环比 day_to_day_rate = (today_cnt - yesterday_cnt) / yesterday_cnt * 100%


-- 5同比增长: 周同比

SELECT '2024-09-11' AS dt, count(*) AS today_cnt FROM gmall.dim_sku_full WHERE dt = '2024-09-11' ;
SELECT '2024-09-11' AS dt, count(*) AS week_cnt FROM gmall.dim_sku_full WHERE dt = date_sub('2024-09-11', 7) ;

--同比 week_to_week_rate = (today_cnt - week_cnt) / week_cnt * 100%

