
USE hive_sql_zg6;
SHOW TABLES IN hive_sql_zg6;


-- todo: 1）、每个商品销售首年的年份、销售数量和销售金额
/*
从订单明细表(order_detail)统计每个商品销售首年的年份，销售数量和销售总额。
*/
/*
    todo 思路分析:
        step1. 按照商品、年份分组，聚合统计数量和金额
        step2. 加序号：商品分组，年份排序
        step3. 过滤
*/

-- todo 日期函数
/*
    date_format(date, 'yyyy-MM-dd HH:mm:ss.SSS')
    year
    month
    day
*/



-- todo: 2）、筛选去年总销量小于100的商品
/*
从订单明细表(order_detail)中筛选出去年总销量小于100的商品及其销量，
	假设今天的日期是2022-01-10，不考虑上架时间小于一个月的商品
*/
/*
    分析思路：
        1. 去年交易数据
        2. 商品上架时间大于一个月
        【先过滤where、再分组group by、最后聚合aggregation】
    todo 函数：add_months、concat
*/

WITH
-- step1. 去重（考虑1天可能多次下单）
    order_data AS (
        SELECT
            user_id, create_date
        FROM hive_sql_zg6.order_info
        GROUP BY user_id, create_date
    )
-- step2. 序号（用户id分组，日期升序排序，row_number开窗）
   , rank_data AS (
    SELECT
        user_id, create_date
         , row_number() over (PARTITION BY user_id ORDER BY create_date) AS rk
    FROM order_data
)
-- step3. 差值（计算日期与序号差值）
   , diff_data AS (
    SELECT
        user_id, create_date, rk
         , date_sub(create_date, rk) AS date_diff
    FROM rank_data
)
-- step4. 分组、计数
   , cnt_data AS (
    SELECT
        user_id
         , date_diff
         , count(user_id) AS days
         , collect_list(create_date) AS date_list
    FROM diff_data
    GROUP BY user_id, date_diff
)
-- step5. 过滤、去重
SELECT
    DISTINCT user_id
--     user_id, days, date_list
FROM cnt_data
WHERE days >= 3
;





-- todo: 3）、查询每日新用户数
/*
从用户登录明细表（user_login_detail）中查询每天的新增用户数，
若一个用户在某天登录了，且在这一天之前没登录过，则认为该用户为这一天的新增用户。
*/
/*
    思路分析：
        找到每个用户最小登录时间，就是用户新增时间，统计个数即可
*/


-- todo: 4）、统计每个商品的销量最高的日期
/*
从订单明细表（order_detail）中统计出每种商品销售件数最多的日期及当日销量，
如果有同一商品多日销量并列的情况，取其中的最小日期。
*/



-- todo: 5）、查询销售件数高于品类平均数的商品
/*
从订单明细表（order_detail）中查询累积销售件数高于其所属品类平均数的商品
*/
