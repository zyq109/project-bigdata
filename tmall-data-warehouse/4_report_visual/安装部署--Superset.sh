
# 1. 上传软件
[bwie@node103 ~]$ rz
  Miniconda3-latest-Linux-x86_64.sh

# 给与执行权限
[bwie@node103 ~]$ chmod u+x Miniconda3-latest-Linux-x86_64.sh

# 2. 执行
[bwie@node103 ~]$ sh Miniconda3-latest-Linux-x86_64.sh
    Please, press ENTER to continue
    >>>
    直接回车

    Do you accept the license terms? [yes|no]
    [no] >>> yes
    输入yes

    [/home/bwie/miniconda3] >>> /opt/module/miniconda3
    输入安装路径/opt/module/miniconda3

    Do you wish the installer to initialize Miniconda3
    by running conda init? [yes|no]
    [no] >>> yes
    输入yes

    最后一句话：取消激活base环境
      conda config --set auto_activate_base false

# 3. 激活Python基础环境
[bwie@node103 ~]$ source ~/.bashrc
(base) [bwie@node103 ~]$


# 4. 设置国内镜像
(base) [bwie@node103 ~]$ conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
(base) [bwie@node103 ~]$ conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
(base) [bwie@node103 ~]$ conda config --set show_channel_urls yes
(base) [bwie@node103 ~]$ conda config --show channels

# 5. 创建Python3.8环境
(base) [bwie@node103 ~]$ conda create --name superset python=3.8.16
  Proceed ([y]/n)? y
  输入y

  安装完成，最后输出
    # To activate this environment, use
    #
    #     $ conda activate superset
    #
    # To deactivate an active environment, use
    #
    #     $ conda deactivate


# 6. 激活superset环境
(base) [bwie@node103 ~]$ conda activate superset
(superset) [bwie@node103 ~]$
# 查看版本
(superset) [bwie@node103 ~]$ python -V
Python 3.8.16


# 7. 安装依赖
(superset) [bwie@node103 ~]$ sudo yum install -y gcc gcc-c++ libffi-devel python-devel python-pip python-wheel python-setuptools openssl-devel cyrus-sasl-devel openldap-devel

  补充说明：
    如果上述命令执行失败，显示连接不到默认镜像地址，可以更改国内CentOS7镜像地址
      阿里云国内镜像地址修改：https://blog.csdn.net/shiguabg123/article/details/134864082
      163国内镜像地址修改：https://www.cnblogs.com/zhangkaimin/p/6898444.html
      # step1. 备份原来的镜像源
        sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
      # step2. 下载新的阿里镜像到yum.repos.d下
        sudo curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
      # step3. 生成缓存
        yum clean all
        yum makecache

# 8.安装Superset
## 8.1 更新pip
(superset) [bwie@node103 ~]$ pip install --upgrade pip -i https://pypi.douban.com/simple/

# 8.2 上传base.txt文件至任意路径
(superset) [bwie@node103 ~]$ rz
  base.txt

# 8.3 安装SuperSet
(superset) [bwie@node103 ~]$ pip install apache-superset==2.0.0 -i https://pypi.tuna.tsinghua.edu.cn/simple -r base.txt

# 8.4 配置Superset元数据库
### 登录数据库
[bwie@node101 ~]$ mysql -uroot -p123456
mysql> CREATE DATABASE superset DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
mysql> create user superset@'%' identified WITH mysql_native_password BY 'superset';
mysql> grant all privileges on *.* to superset@'%' with grant option;
mysql> flush privileges;

### 修改superset配置文件
(superset) [bwie@node103 ~]$ vim /opt/module/miniconda3/envs/superset/lib/python3.8/site-packages/superset/config.py
  ### 修改内容如下：（184、185行）
  # SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(DATA_DIR, "superset.db")
  SQLALCHEMY_DATABASE_URI = 'mysql://superset:superset@node101:3306/superset?charset=utf8'

### 安装python msyql驱动
(superset) [bwie@node103 ~]$ conda install mysqlclient
  Proceed ([y]/n)? y
  输入y

### 初始化superset元数据
(superset) [bwie@node103 ~]$ export FLASK_APP=superset
(superset) [bwie@node103 ~]$ superset db upgrade

# 8.5 SupersetSet初始化
### 创建管理员用户
(superset) [bwie@node103 ~]$ superset fab create-admin
  Username [admin]: root
    登录账号
  User first name [admin]: xuan
  User last name [user]: yu
  Email [admin@fab.org]: xuanyu@126.com
  Password: 123456
    登录密码
  Repeat for confirmation:123456
    登录密码，再次输入

### 初始化superset
(superset) [bwie@node103 ~]$ superset init

# 8.6 启动Supterset
### 安装gunicorn
(superset) [bwie@node103 ~]$ pip install gunicorn -i https://pypi.douban.com/simple/

# 8.7 2）启动Superset
(superset) [bwie@node103 ~]$ gunicorn --workers 5 --timeout 120 --bind node103:8787  "superset.app:create_app()" --daemon
(superset) [bwie@node103 ~]$ ps -ef|grep superset

# 8.8 登录Superset
http://node103:8787/login/
  界面输入用户名和密码
  root/123456
# 8.9 停止superset
(superset) [bwie@node103 ~]$ ps -ef | awk '/superset/ && !/awk/{print $2}' | xargs kill -9


# 9. 编写启停脚本
(superset) [bwie@node103 ~]$ vim superset.sh
(superset) [bwie@node103 ~]$ chmod u+x superset.sh
(superset) [bwie@node103 ~]$ mv superset.sh bin

# 10. 每次启动SuperSet服务
(base) [bwie@node103 ~]$ conda activate superset
(superset) [bwie@node103 ~]$ superset.sh start
启动Superset
(superset) [bwie@node103 ~]$ superset.sh status
superset正在运行

# 11. superset改中文
(superset) [bwie@node103 ~]$ cd /opt/module/miniconda3/envs/superset/
(superset) [bwie@node103 superset]$ vim superset_config.py
  内容：
LANGUAGES = {
    "en": {"flag": "us", "name": "English"},
    "zh": {"flag": "cn", "name": "Chinese"},
}
(superset) [bwie@node103 superset]$ superset.sh restart


# 12. 解决地图中文
# 参考网页文档
https://blog.csdn.net/csncd/article/details/124559112
# 进入目录
(superset) [bwie@node103 ~]$ cd /opt/module/miniconda3/envs/superset/lib/python3.8/site-packages/superset/static/assets
# 查找文件
(superset) [bwie@node103 assets]$ ll | grep geojson | grep -rl 'Beijing'
0737a7c549c0ef9ba0f9.geojson
#



## ======================================== 脚本内容 ==============================================

#!/bin/bash

# 函数：查看状态
superset_status(){
    result=`ps -ef | awk '/gunicorn/ && !/awk/{print $2}' | wc -l`
    if [[ $result -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

# 函数：启动服务
superset_start(){
        source ~/.bashrc
        superset_status >/dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            conda activate superset ; gunicorn --workers 5 --timeout 120 --bind node103:8787 --daemon 'superset.app:create_app()'
        else
            echo "superset正在运行"
        fi

}

# 函数：停止服务
superset_stop(){
    superset_status >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "superset未在运行"
    else
        ps -ef | awk '/gunicorn/ && !/awk/{print $2}' | xargs kill -9
    fi
}

# 多条件判断，类似case...when...
case $1 in
    start )
        echo "启动Superset"
        superset_start
    ;;
    stop )
        echo "停止Superset"
        superset_stop
    ;;
    restart )
        echo "重启Superset"
        superset_stop
        superset_start
    ;;
    status )
        superset_status >/dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo "superset未在运行"
        else
            echo "superset正在运行"
        fi
esac


