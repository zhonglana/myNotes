#搜索docker的rabbitmq镜像
docker search rabbitmq

#下载镜像
docker pull docker.io/rabbitmq

#运行rabbitmq
docker run -d --hostname my-rabbit -p 5672:5672 -p 15672:15672 rabbitmq:3.7.3-management
docker run -d  -p 5671:5671 -p 5672:5672  -p 15672:15672 -p 15671:15671  -p 25672:25672  -v /data/rabbitmq-data/:/var/rabbitmq/lib --hostname=rabbitmqhostone  --name rabbitmq   93a7eefb0865
#运行时设置用户和密码
docker run -d --hostname my-rabbit --name rabbit -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin -p 15672:15672 -p 5672:5672 -p 25672:25672 -p 61613:61613 -p 1883:1883 rabbitmq:management

#rabbitmq的数据库名称规则是，NODENAME@hostname，Docker每次从Docker image启动容器的时候会自动生成hostname，
#这样一来，你保存在主机上的数据库就会没用了，包括之前创建的用户也会没有了。
#所以在创建容器的时候必须指定--hostname=rabbitmqhostone，这样docker环境启动后rabbitmq就会一直读取固定目录中的数据了