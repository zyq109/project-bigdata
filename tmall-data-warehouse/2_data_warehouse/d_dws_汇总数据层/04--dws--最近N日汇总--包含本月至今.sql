

/*
    todo 需求：
        对交易域-省份粒度-下单-最近N日汇总
        最近N日汇总表，包含最近7日、本月至今、最近30日数据汇总
*/
SELECT
    province_id, province_name, area_code, iso_code, iso_3166_2
    -- 最近7日统计
    ,sum(if(dt >= date_sub('2024-06-18', 6), order_count_1d, 0)) AS order_count_7d
    ,sum(if(dt >= date_sub('2024-06-18', 6), order_original_amount_1d, 0)) AS order_original_amount_7d
    ,sum(if(dt >= date_sub('2024-06-18', 6), activity_reduce_amount_1d, 0)) AS activity_reduce_amount_7d
    ,sum(if(dt >= date_sub('2024-06-18', 6), coupon_reduce_amount_1d, 0)) AS coupon_reduce_amount_7d
    ,sum(if(dt >= date_sub('2024-06-18', 6), order_total_amount_1d, 0)) AS order_total_amount_7d
     -- 本月至今统计， todo：使用函数trunc
    ,sum(if(dt >= trunc('2024-06-18', 'MM'), order_count_1d, 0)) AS order_count_md
    ,sum(if(dt >= trunc('2024-06-18', 'MM'), order_original_amount_1d, 0)) AS order_original_amount_md
    ,sum(if(dt >= trunc('2024-06-18', 'MM'), activity_reduce_amount_1d, 0)) AS activity_reduce_amount_md
    ,sum(if(dt >= trunc('2024-06-18', 'MM'), coupon_reduce_amount_1d, 0)) AS coupon_reduce_amount_md
    ,sum(if(dt >= trunc('2024-06-18', 'MM'), order_total_amount_1d, 0)) AS order_total_amount_md
    -- 最近30日统计
    ,sum(if(dt >= date_sub('2024-06-18', 29), order_count_1d, 0)) AS order_count_30d
    ,sum(if(dt >= date_sub('2024-06-18', 29), order_original_amount_1d, 0)) AS order_original_amount_30d
    ,sum(if(dt >= date_sub('2024-06-18', 29), activity_reduce_amount_1d, 0)) AS activity_reduce_amount_30d
    ,sum(if(dt >= date_sub('2024-06-18', 29), coupon_reduce_amount_1d, 0)) AS coupon_reduce_amount_30d
    ,sum(if(dt >= date_sub('2024-06-18', 29), order_total_amount_1d, 0)) AS order_total_amount_30d
FROM gmall.dws_trade_province_order_1d
-- 由于考虑奇数月有31天，所以要获取最近31天数据
WHERE dt >= date_sub('2024-06-18', 30) AND dt <= '2024-06-18'
GROUP BY province_id, province_name, area_code, iso_code, iso_3166_2
;


-- todo 函数：trunc 依据日期获取本月第一天日期
DESC FUNCTION trunc;
/*
trunc(date, fmt) / trunc(N,D)
    - Returns If input is date returns date with the time portion of the day truncated to the unit specified by the format model fmt.
If you omit fmt, then date is truncated to the nearest day.
It currently only supports 'MONTH'/'MON'/'MM', 'QUARTER'/'Q' and 'YEAR'/'YYYY'/'YY' as format.
If input is a number group returns N truncated to D decimal places.
If D is omitted, then N is truncated to 0 places.D can be negative to truncate (make zero) D digits left of the decimal point.
*/
SELECT
    trunc('2024-06-18', 'MM') AS m1
    , trunc('2024-05-31', 'MM') AS m2
    , trunc('2024-02-29', 'MM') AS m3
;


/*
    函数trunc 使用：https://www.cnblogs.com/sx66/p/16851503.html

一、日期TRUNC函数为指定元素而截去的日期值。
    其具体的语法格式：TRUNC（date[,fmt]）
    其中：
        date 一个日期值
        fmt 日期格式
        如果当日日期是：2022-11-02

    select trunc('2022-11-02','MM')　　　　　　　　--2022-11-01　　　　 　　　返回当月第一天
    select trunc('2022-11-02','YY')　　　　　　　　--2022-01-01　　　　 　　　返回当年第一天
    select trunc('2022-11-02','YYYY')　　　　　　 --2022-01-01　　　　 　　　返回当年第一天
    select trunc('2022-11-02','Q')　　　　　　　　 --2022-10-01　　　　　　　 返回当前季度第一天
二、数字TRUNC（number,num_digits）
    Number 需要截尾取整的数字。
        Num_digits 用于指定取整精度的数字。Num_digits 的默认值为 0。
        TRUNC()函数截取时不进行四舍五入
*/
SELECT trunc(123.458);  --123
SELECT trunc(123.458,0) ; --123
SELECT trunc(123.458,1);   --123.4
SELECT trunc(123.458,-1) ;  --120
SELECT trunc(123.458,-4);  --0
SELECT trunc(123.458,4) ; --123.458
SELECT trunc(123); --123
SELECT trunc(123,1) ; --123

