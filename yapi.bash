
#下载镜像
sudo docker push [image]

#启动yapi##
#1.启动yapi容器
sudo docker run -dit --name yapi -p 9090:9090 -p 3000:3000 -p 27017:27017 [image]

#2.进入容器
sudo docker exec -it yapi /bin/bash

#3.更新环境变量
source /etc/profile

#启动mongodb
/app/mongodb/bin/./mongod --dbpath=/app/mongodb/data/db &

#启动yapi服务
yapi server &
node /app/my-yapi/vendors/server/app.js &

#登陆 [ip]:3000
#ymfe.org
#Vanke@lms


####################################################################
数据备份：
#/app/mongodb/data/db/   mongodb数据目录
#/app/my-yapi/			 yapi配置目录

#删除容器时将数据备份
#sudo docker cp yapi:/app/mongodb/data/db/ /app/mongodb/data/
#sudo docker cp yapi:/app/my-yapi/ /app/

#1.备份后，删除yapi容器
#2.重启yapi容器
sudo docker run -dit --name yapi -p 9090:9090 -p 3000:3000 -p 27017:27017 -v /app/mongodb/data/db/:/app/mongodb/data/db/ -v /app/my-yapi/:/app/my-yapi/ [image]



#mongodb
show dbs
user db
show dbs






