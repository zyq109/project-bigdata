

# ======================================================================
#                   todo：1. ：sku_attr_value（每日，全量）
# ======================================================================
# sku 平台属性表

#sqoop 导入数据的参数
# 1.连接数据库
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
# 2. 表信息
--target-dir /origin_data/gmall/sku_attr_value/2024-06-18 \
--delete-target-dir \
#可以query 参数指定select 语句，但是必须添加
--query "SELECT
  id,
  attr_id,
  value_id,
  sku_id,
  attr_name,
  value_name
FROM sku_attr_value
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
# 4.压缩设置
--compress \
--compression-codec gzip \
# 5.导入空值处理
--null-string '\\N' \
--null-non-string '\\N'
# 6.map 任务数设置
#--split-by id


===============================================================
sku_image
===============================================================

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_image/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  sku_id,
  img_name,
  img_url,
  spu_img_id,
  is_default
FROM sku_image
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'





===============================================================
sku_info
===============================================================

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_attr_value/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  price,
  sku_name,
  sku_desc,
  weight,
  tm_id,
  category3_id,
  sku_default_img,
  is_sale,
  create_time
FROM sku_info
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'



===============================================================
sku_sale_attr_value
===============================================================

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_sale_attr_value/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  sku_id,
  spu_id,
  sale_attr_value_id,
  sale_attr_id,
  sale_attr_name,
  sale_attr_value_name
FROM sku_sale_attr_value
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


************************************************************************************
#todo   spu

===============================================================
spu_image
===============================================================


/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_image/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  img_name,
  img_url
FROM spu_image
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'




===============================================================
spu_info
===============================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_info/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_name,
  description,
  category3_id,
  tm_id
FROM spu_info
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'







===============================================================
spu_poster
===============================================================

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_poster/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  img_name,
  img_url,
  create_time,
  update_time,
  is_deleted
FROM spu_poster
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'




===============================================================
spu_sale_attr
===============================================================

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_sale_attr/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  base_sale_attr_id,
  sale_attr_name
FROM spu_sale_attr
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'




===============================================================
spu_sale_attr_value
===============================================================


/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_sale_attr_value/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  base_sale_attr_id,
  sale_attr_value_name,
  sale_attr_name
FROM spu_sale_attr_value
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'



# ======================================================================
#                   todo：1. ：cart_info_full（每日，全量）
# ======================================================================
# sku 平台属性表

#sqoop 导入数据的参数
# 1.连接数据库
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
# 2. 表信息
--target-dir /origin_data/gmall/cart_info/2024-06-18 \
--delete-target-dir \
#可以query 参数指定select 语句，但是必须添加
--query "SELECT
                 id,
                 user_id,
                 sku_id,
                 cart_price,
                 sku_num,
                 img_url,
                 sku_name,
                 is_checked,
                 create_time,
                 operate_time,
                 is_ordered,
                 order_time,
                 source_type,
                 source_id
         FROM cart_info
         WHERE
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
# 4.压缩设置
--compress \
--compression-codec gzip \
# 5.导入空值处理
--null-string '\\N' \
--null-non-string '\\N'
# 6.map 任务数设置
#--split-by id





SELECT
        id,
        user_id,
        sku_id,
        cart_price,
        sku_num,
        img_url,
        sku_name,
        is_checked,
        create_time,
        operate_time,
        is_ordered,
        order_time,
        source_type,
        source_id
FROM cart_info
WHERE (date_format(create_time, '%Y-%m-%d') = '${do_date}'
           OR date_format(operate_time, '%Y-%m-%d') = '${do_date}')