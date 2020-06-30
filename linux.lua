
清屏
#clear

修改环境变量
#vim /etc/profile

重新编译文件
#source /etc/profile

立即关机
#shutdown now

重启linux
#reboot

查看防火墙状态
#systemctl status firewalld
关闭防火墙
#systemctl stop firewalld.service
停用防火墙
#systemctl disable firewalld.service

启用端口
#firewall-cmd --zone=public --add-port=6379/tcp --permanent
重新加载防火墙
#firewall-cmd --reload
查看端口
#firewall-cmd --zone=public --query-port=6379/tcp
删除端口
#firewall-cmd --zone=public --remove-port=6379/tcp --permanent
查看所有端口
#firewall-cmd --zone=public --list-ports

重启网络
#service network restart

安装插件
#yum -y install xxx

挂载
#mount /dev/cdrom /mnt

压缩：
jar -cvf lms-web.war ./*
解压：
jar -xvf game.war

解压tar包
#tar -zvxf xx.tar.gz


查看程序应用情况
#ps -ef | grep nginx

查找文件
#find [path] -name xxx

删除文件夹
#mv -rf xxx
#mv sourcedir destdir

编辑文件
#vi xx.log
#vim xx.log

编辑文件中显示行号
:set nu

编辑文件中查找内容
/admin

查看文件内容
#cat dir
查找文件中的内容
#cat log.sh | grep xxx

同步网络时间
#yum -y install ntp ntpdate     //安装ntp ntpdate插件
#ntpdate cn.pool.ntp.org		//同步网络时间
#hwclock --systohc 				//写入硬件

设置时间为北京时间 
#rm -rf /etc/localtime											//删除系统自带的localtime
#ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime      	//创建软链接到localtime 

监听文件数据 
#tail -n 100 -f access.log

显示当前目录
#pwd
显示当前用户
#whoami

授予权限
#chmod 777 dir

创建定时任务
#crontab -e
*/1 * * * * sh /usr/lz/nginx/sbin/log.sh

#crontab -u //设定某个用户的cron服务，一般root用户在执行这个命令的时候需要此参数  
#crontab -l //列出某个用户cron服务的详细内容
#crontab -r //删除没个用户的cron服务
#crontab -e //编辑某个用户的cron服务


设置firefox每次访问时缓存
1.地址栏输入：about:config
2.找到browser.cache.check_doc_frequency 将3改为1  
// 0:once per session 每个进程一次 每次启动Firefox时检查
// 1:Each time 每次访问时都检查 [开发人员建议设置这个]
// 2:Never
// 3:when appropriate/automatically

服务器之间传输文件
#scp [pathFile] ip:dir

查看端口进程
#netstat -anp | grap 8092
停止进程
#kill -9 进程号

#yum指定安装目录
yum install --installroot=/usr/src/ vim 

#
ps -ef|grep tail|grep access.log|awk '{print $2}'|xargs -i kill -9 {}

#查看tomcat端口进程ID
lsof -i :8082 | grep java | grep -v grep | awk '{print $2}'


## JAVA环境变量
sudo vim /etc/profile

export JAVA_HOME=/home/jrsj/jdk1.6.0_25
export JAVA_BIN=$JAVA_HOME/bin
export JAVA_LIB=$JAVA_HOME/lib
export CLASSPATH=.:$JAVA_LIB/tools.jar:$JAVA_LIB/dt.jar
export PATH=$JAVA_BIN:$PATH
##############################

##spring boot 启动项目
#java -jar xxx.jar --server.port=8081

------------------------------------------------------
##服务器之间免密登录
#ssh-keygen                //生成公钥私钥
1.
#ssh-copy-id user@[ip]    // vkapp为用户名 ，发送公钥到指定服务器
2.或
#scp ~/.ssh/id_rsa.pub user@[ip] :~/.ssh/
##将拷贝过去的id_rsa.pub文件里的内容追加到～/.ssh/authorized_keys文件里
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


#ssh user@[ip]  		  //免密连接指定服务器

---解决免密之后，登录提示：Enter passphrase for key '/root/.ssh/id_rsa':
#eval `ssh-agent`
#ssh-add
------------------------------------------------------

#ssh 远程登录
ssh -p 22 10.0.145.40

-- 安装 yarn
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install yarn -yarn

-- jdk
export JAVA_HOME=/app/jdk1.8.0_171
export JRE_HOME=$JAVA_HOME/jre

export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export CLASSPATH=:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
---
location /ehr-web-share/ {
    root   html;
    index  index.html index.htm;
}
---
cat access.log | grep profile
more access.log | grep profile

--

mongod --dbpath=/app/mongodb/data/db

v-lanz@vanke.com ymfe.org

-------------

curl -X POST -d '{"email":"@163.com","password":"6b1e620a922f8a3e4b6022adbd232145"}' http://external.testing2.ifchange.com/api/permission/getAccessToken
curl -X POST -d '{"email":"@.com","password":"2e1fd88c8a01674a646baa7995770e5a"}' http://external.ifchange.com/api/permission/getAccessToken

---
#!/bin/bash
echo $0    # 当前脚本的文件名（间接运行时还包括绝对路径）。
echo $n    # 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是 $1 。
echo $#    # 传递给脚本或函数的参数个数。
echo $*    # 传递给脚本或函数的所有参数。
echo $@    # 传递给脚本或函数的所有参数。被双引号 (" ") 包含时，与 $* 不同，下面将会讲到。
echo $?    # 上个命令的退出状态，或函数的返回值。
echo $$    # 当前 Shell 进程 ID。对于 Shell 脚本，就是这些脚本所在的进程 ID。
echo $_    # 上一个命令的最后一个参数
echo $!    # 后台运行的最后一个进程的 ID 号

===============
#执行
$ ./test.sh test test1 test2 test3 test4
#输出
./test.sh                      # $0
                               # $n
5                              # $#
test test1 test2 test3 test4   # $*
test test1 test2 test3 test4   # $@
0                              # $?
12305                          # $$
12305                          # $_
                               # $!
======================
windows 停止进程
netstat -aon|findstr "端口"
tasklist|findstr "进程IP"    
taskkill /f /t /im tor.exe

===================

sudo lsof |grep delete



