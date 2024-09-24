
-- 创建表，采用CTAS方式创建表
CREATE TABLE IF NOT EXISTS gmall.tmp_dws_pageview_1d
AS
SELECT '2024-06-01' AS dt, 1000 AS pv, 234 AS uv
UNION
SELECT '2024-06-02' AS dt, 1200 AS pv, 456 AS uv
UNION
SELECT '2024-06-03' AS dt, 900 AS pv, 432 AS uv
UNION
SELECT '2024-06-04' AS dt, 880 AS pv, 245 AS uv
UNION
SELECT '2024-06-05' AS dt, 1300 AS pv, 564 AS uv
UNION
SELECT '2024-06-06' AS dt, 2400 AS pv, 678 AS uv
UNION
SELECT '2024-06-07' AS dt, 8000 AS pv, 345 AS uv
UNION
SELECT '2024-06-08' AS dt, 9000 AS pv, 432 AS uv
UNION
SELECT '2024-06-09' AS dt, 12000 AS pv, 1245 AS uv
UNION
SELECT '2024-06-10' AS dt, 890 AS pv, 564 AS uv
;

-- 查询表数据
SELECT * FROM gmall.tmp_dws_pageview_1d ;

-- 最近1日统计：2024-06-10,1,890,564
SELECT
    '2024-06-10' AS dt
    , 1 AS recent_days
    , sum(pv) AS pv
    , sum(uv) AS uv
FROM gmall.tmp_dws_pageview_1d
WHERE dt >= date_sub('2024-06-10', 1 - 1) AND dt <= '2024-06-10'
;

-- 最近7日统计：2024-06-10,7,34470,4073
SELECT
    '2024-06-10' AS dt
     , 7 AS recent_days
     , sum(pv) AS pv
     , sum(uv) AS uv
FROM gmall.tmp_dws_pageview_1d
WHERE dt >= date_sub('2024-06-10', 7 - 1) AND dt <= '2024-06-10'
;

-- 最近30日统计：2024-06-10,30,37570,5195
SELECT
    '2024-06-10' AS dt
     , 30 AS recent_days
     , sum(pv) AS pv
     , sum(uv) AS uv
FROM gmall.tmp_dws_pageview_1d
WHERE dt >= date_sub('2024-06-10', 30 - 1) AND dt <= '2024-06-10'
;

-- 使用exploded炸裂函数
WITH
    -- 1. 数据扩容
    tmp_data AS (
        SELECT
            dt, pv, uv, recent_days
        FROM gmall.tmp_dws_pageview_1d
                 LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
        WHERE dt >= date_sub('2024-06-10', 30 - 1) AND dt <= '2024-06-10'
    )
SELECT
    -- 2. 分组统计，使用sum-if
    '2024-06-10' AS dt
     , recent_days
     , sum(if(dt >= date_sub('2024-06-10', recent_days - 1) ,pv, 0)) AS pv
     , sum(if(dt >= date_sub('2024-06-10', recent_days - 1) ,uv, 0)) AS uv
FROM tmp_data
GROUP BY recent_days
;



-- 函数：explode  -- 列转行
DESC FUNCTION explode ;
/*
explode(a)
    - separates the elements of array a into multiple rows,
    or the elements of a map into multiple rows and columns
*/
-- 数组
SELECT explode(`array`(1, 7, 30)) AS recent_day ;

-- map集合
SELECT explode(str_to_map('id=1001,name=zhangsan,gender=male,age=24', ',', '=')) AS (name, value) ;

-- todo 爆炸函数，与偏视图整合使用
WITH
    tmp1 AS (
        SELECT 'hello' AS x1
    )
SELECT
    x1, recent_days
FROM tmp1
    LATERAL VIEW explode(array(1, 7, 30, 90, 180, 360)) tmp AS recent_days
;

-- 函数：array
DESC FUNCTION array ;
/*
array(n0, n1...) - Creates an array with the given elements
*/
SELECT `array`(1, 7, 30) AS recent_days ;


-- 函数：str_to_map
DESC FUNCTION str_to_map ;
/*
 str_to_map(text, delimiter1, delimiter2) - Creates a map by parsing text
*/
SELECT str_to_map('id=1001,name=zhangsan,gender=male,age=24', ',', '=') AS infos ;
