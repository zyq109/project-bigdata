
USE hive_sql_zg6;
SHOW TABLES IN hive_sql_zg6;


-- todo: 1）、查询累积销量排名第二的商品
/*
查询订单明细表（order_detail）中销量（下单件数）排名第二的商品id，
	如果不存在返回null，如果存在多个排名第二的商品则需要全部返回
*/
/*
todo: 排序开窗函数
    row_number：不重复，连续，1、2、3、4、5、...
    rank：重复，跳跃，1、1、3、4、5、...
    dense_rank：重复，连续，，1、1、2、3、4、...
*/

WITH

    -- 各个商品的销量
    tmp1 AS(
    SELECT
        sku_id
        ,count(distinct order_id) as sku_num_sum
    FROM hive_sql_zg6.order_detail
    GROUP BY sku_id
    )
    ,tmp2 AS (
    SELECT
        sku_id,sku_num_sum
        ,dense_rank() over ())
    FROM tmp1
)

;

-- 添加序号




-- todo：2）、查询至少连续三天下单的用户
/*
查询订单信息表(order_info)中最少连续3天下单的用户id
*/
/*
todo 思路：连续登录几天，每天日期与序号差值相同
    step1. 去重（考虑1天可能多次下单）
    step2. 序号（用户id分组，日期升序排序，row_number开窗）
    step3. 差值（计算日期与序号差值）
    step4. 分组、计数、过滤
    step5. 去重
*/


-- todo: 3）、查询各品类销售商品的种类数及销量最高的商品
/*
从订单明细表(order_detail)统计各品类销售出的商品种类数及累积销量最好的商品
		品类ID（品类名称）、品类销售商品的种类数、销售量最好的商品、销售量
*/



-- todo: 4）、查询用户的累计消费金额及VIP等级
/*
从订单信息表(order_info)中统计每个用户截止其每个下单日期的累积消费金额，以及每个用户在其每个下单日期的VIP等级。
	用户vip等级根据累积消费金额计算，计算规则如下：设累积消费总额为X，
若0=<X<10000,则vip等级为普通会员
若10000<=X<30000,则vip等级为青铜会员
若30000<=X<50000,则vip等级为白银会员
若50000<=X<80000,则vip为黄金会员
若80000<=X<100000,则vip等级为白金会员
若X>=100000,则vip等级为钻石会员
*/
/*
    todo SQL函数中，2个判断函数:
        第1、if函数
            if(condition, true-value, false-value)
            单个条件判断
        第2、when函数
            多个条件判断
            case
                when condition1 then value1
                when condition2 then value2
                when condition3 then value3
                ...
                else value-false
            end
        SQL中聚合开窗函数，在聚合函数之上加上窗口，然后聚合计算
            sum、count、max、min、avg
            自定义udaf函数 = User Definition Aggregation Function
*/



-- todo: 5）、查询首次下单后第二天连续下单的用户比率
/*
从订单信息表(order_info)中查询首次下单后第二天仍然下单的用户占所有下单用户的比例，结果保留一位小数，使用百分数显示。
*/
/*
    todo 分析思路：
        step1. 去重
        step2. 加序号
        step3. 首次下单日期和第二次下单日期
        step4. 计数
*/



