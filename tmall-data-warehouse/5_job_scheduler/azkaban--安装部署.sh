
# 任务调度引擎：
# 	【将项目中从数据采集开始，到最终主题指标导出结束，需要一整套任务调度执行】
# 		第1、定时调度
# 			每天何时开始执行任务程序（MR任务）
# 		第2、依赖调度
# 			必须等待前面任务执行完成，然后再执行后面任务。
# 	调度引擎：
# 		1. Azkaban 3.x（★★★★☆）
# 			使用很清爽，Web UI界面操作，尤其擅长调度Shell脚本，配置失败重试和预警机制。
# 		2. AirFlow
# 			基于Python调度任务，国外很多公司再使用
# 		3. DolphinScheduler（★★★★★）
# 			海豚调度
# 			国产开源框架，由易观发布的，很多很多公司使用，尤其任务数目和类型很多时。
# 			【耗内存】
# 		4. hera赫拉（★★★☆☆）
# 			基于阿里调度引擎Zeus宙斯二次开发框架
# 			https://github.com/scxwhite/hera
# 		5. Oozie
# 			Apache顶级项目，属于CDH中大数据调度框架，上手比较难，需要编写XML文件
# 			与Hue框架集成使用
#
# 		0. Linux系统Crontab
# 			minute   hour   day   month   week   command     顺序：分 时 日 月 周
#

# 1. 上传解压
(base) [bwie@node103 ~]$ cd /opt/module/
(base) [bwie@node103 module]$ rz
  azkaban.tar.gz

(base) [bwie@node103 module]$ chmod u+x azkaban.tar.gz
(base) [bwie@node103 module]$ tar -zxf azkaban.tar.gz
  azkaban


# 2. 启动Azakan单机服务
(base) [bwie@node103 module]$ cd azkaban/
(base) [bwie@node103 azkaban]$ bin/start-solo.sh
(base) [bwie@node103 azkaban]$ jps
  1877 AzkabanSingleServer


# 3. 登录Azkaban界面
# url地址
http://node103:8081/
# 用户名和密码
azkaban/azkaban


# 4. 关闭Azkaban服务
(base) [bwie@node103 azkaban]$ bin/shutdown-solo.sh


# 5. 配置邮箱信息
(base) [bwie@node103 ~]$ cd /opt/module/azkaban/conf
(base) [bwie@node103 conf]$ vim /opt/module/azkaban/conf/azkaban.properties
  修改内容：26行-29行
    mail.sender=bawei2024@126.com
    mail.host=smtp.126.com
    mail.user=bawei2024@126.com
    mail.password=FLVAZKABANPROPERTIES
# 其中启动服务
(base) [bwie@node103 ~]$ cd /opt/module/azkaban
(base) [bwie@node103 azkaban]$ bin/shutdown-solo.sh
(base) [bwie@node103 azkaban]$ bin/start-solo.sh



