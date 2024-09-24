

#
#关于导出update还是insert的问题
#    --update-mode：
#        updateonly 只更新，无法插入新数据
#        allowinsert 允许新增
#    --update-key：
#       允许更新的情况下，指定哪些字段匹配视为同一条数据，进行更新而不增加，多个字段用逗号分隔。
#    --input-null-string和--input-null-non-string：
#       分别表示，将字符串列和非字符串列的空串和“null”转义。
#

# ====================================================================
# todo 1 流量主题
# ====================================================================
# 1.1 各渠道流量统计
/opt/module/sqoop/bin/sqoop export \
--connect "jdbc:mysql://node101:3306/gmall_report?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password 123456 \
--table ads_traffic_stats_by_channel \
--export-dir /warehouse/gmall/ads/ads_traffic_stats_by_channel \
--input-fields-terminated-by "\t" \
--update-mode allowinsert \
--update-key "dt,recent_days,channel" \
--num-mappers 1 \
--input-null-string '\\N' \
--input-null-non-string '\\N'

# 1.2 用户路径分析

# ====================================================================
# todo 2 流用户主题
# ====================================================================
# 2.1 用户变动统计

# 2.2 用户留存率

# 2.3 用户新增活跃统计

# 2.4 用户行为漏斗分析

# 2.5 最近7日内连续3日下单用户数

# ====================================================================
# todo 3 商品主题
# ====================================================================
# 3.1 最近7/30日各品牌复购率

# 3.2 各品牌商品交易统计

# 3.3 各品类商品交易统计

# 3.4 各品类商品购物车存量top3

# 3.5 各品牌商品收藏次数Top3

# ====================================================================
# todo 4 交易主题
# ====================================================================
# 4.1 交易综合统计
/opt/module/sqoop/bin/sqoop export \
--connect "jdbc:mysql://node101:3306/gmall_report?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password 123456 \
--table ads_trade_stats \
--export-dir /warehouse/gmall/ads/ads_trade_stats \
--input-fields-terminated-by "\t" \
--update-mode allowinsert \
--update-key "dt,recent_days" \
--num-mappers 1 \
--input-null-string '\\N'    \
--input-null-non-string '\\N'


# 4.2 各省份订单统计


## ====================================================================
## todo 5 优惠卷主题
## ====================================================================
## 5.1 优惠券使用统计


