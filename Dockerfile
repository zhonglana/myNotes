# VERSION 0.0.1
# Author: zhonglana
# 基础镜像使用java
FROM java:8

# 作者
MAINTAINER zhonglana <zhong.lan@nx-engine.com>

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
ENV JAVA_OPTS="\
-server \
-Xmx1024m \
-Xms1024m \
-XX:MetaspaceSize=256m \
-XX:MaxMetaspaceSize=256m"

# 将jar包添加到容器中并更名为app.jar
ADD target/vehiclecontrol-0.0.1-SNAPSHOT.jar /data/app/tsp-vehiclecontrol/vehiclecontrol-0.0.1-SNAPSHOT.jar

# 暴漏端口号
EXPOSE 13000

# 启动命令 运行jar包
# --spring.config.location 启动命令的配置文件地址
# -Xmx1024m -Xms1024m, 在集群pod界面指定
ENTRYPOINT java ${JAVA_OPTS} -jar /data/app/tsp-vehiclecontrol/vehiclecontrol-0.0.1-SNAPSHOT.jar --spring.config.location=/data/config/tsp-vehiclecontrol/application.yml