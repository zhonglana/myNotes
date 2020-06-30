#!/bin/bash

# 启动容器允许容器使用宿主机的 docker 命令
docker run −dit --name jenkins -v /etc/sysconfig/docker:/etc/sysconfig/docker −v /var/run/docker.sock:/var/run/docker.sock −v $(which docker):/usr/bin/docker -p 8050:8080 [image]

docker run −dit --name jenkins -v /etc/sysconfig/docker:/etc/sysconfig/docker −v /var/run/docker.sock:/var/run/docker.sock −v $(which docker):/usr/bin/docker -v /app/jenkins_home/:/app/jenkins_home/ -v /app/plugins/maven-rep/:/app/plugins/maven-rep/ -p 8050:8080 [image]

# 将容器打包成镜像
docker commit -m "" -a "zhonglana" db076c4f8402 docker.io/docker-repo.vanke.com:5000

# 通过Dockerfile构建镜像  默认找路径 /app/docker_file/ 下的 Dockerfile
docker build --build-arg app=userauth-0.0.1-SNAPSHOT.jar /app/docker_file/ 
docker build /app/docker_file/ 

# 启动容器
docker run -dit --name userauth -p 8060:8086 userauth:v1.0 # -v /app/:/app/ (将宿主机目录映射到容器中)

# 使用命令行方式进入容器
docker exec -it <CONTAINER_ID | NAMES> /bin/bash

# 启动容器 
docker start <CONTAINER_ID | NAMES>

# 停止容器
docker stop <CONTAINER_ID | NAMES>

# 删除容器
docker rm <CONTAINER_ID | NAMES>

# 删除镜像 REPOSITORY:TAG
docker rmi userauth:v1.0

# 删除镜像 IMAGE_ID
docker rmi userauth:v1.0

# 上传镜像
docker push <REPOSITORY:TAG | IMAGE_ID>

# 下载镜像
docker pull <REPOSITORY:TAG | IMAGE_ID>

# 容器与宿主机同时间
# build镜像时添加
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

#更新配置：
systemctl daemon-reload

#重启docker
systemctl restart docker

#查看容器IP
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <CONTAINER_ID | NAMES>

#docker run --privileged=true  -it   解决docker容器文件无权限问题
=====================
#docker swarm
#集群节点之间保证TCP 2377、TCP/UDP 7946和UDP 4789端口通信　
#firewall-cmd --add-port=2376/tcp --permanent
#firewall-cmd --add-port=2377/tcp --permanent
#firewall-cmd --add-port=7946/tcp --permanent
#firewall-cmd --add-port=7946/udp --permanent
#firewall-cmd --add-port=4789/udp --permanent

#firewall-cmd --reload
#firewall-cmd --zone=public --list-ports

#1.创建master
docker swarm init --advertise-addr 172.16.60.95
#2.加入集群
docker swarm join --token SWMTKN-1-3q80w0g2h5ocvkolsektodw32m60m7ojchvxs8deuv4tz8rc4x-a6txdcodqammeqrf7s2tpqg7j [ip]:2377

#Set environment variables
#设置容器实例的环境变量
例如：docker service create –name=redis –replicas=5 –env=GOROOT=/usr/local –env=GOPATH=/data/go  redis


======
docker  macvlan
http://collabnix.com/docker-17-06-swarm-mode-now-with-macvlan-support/

## 启动所有容器
sudo docker start $(sudo docker ps -a | awk '{ print $1}' | tail -n +2)

======
docker swarm新增节点

1.查看新增节点命令： docker swarm join-token manager
2.新增节点：
	docker swarm join \
    --token SWMTKN-1-4fne5fsi3zbxuevk3r89mm3dofya4y2piq74ixqzrrrzxzsd5g-0t4lpthhyxyxprr6mkna6eqmg \
    [ip]:2377

======









