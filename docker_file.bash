FROM 5182e96772bf
MAINTAINER v-lanz
ARG project
RUN mkdir /app/spring_boot -p
ADD /jdk/* /app/
ADD publish.sh /app/
ARG jar
ADD $jar /app/spring_boot/webapp.jar
ENV JAVA_HOME /app/jdk1.8.0_171
ENV JRE_HOME $JAVA_HOME/jre
ENV CLASSPATH :$JAVA_HOME/lib:$JRE_HOME/lib
ENV PATH $PATH:$JAVA_HOME/bin

ENTRYPOINT ["/app/publish.sh"]





### publish.sh :
nohup java -Djava.security.egd=file:/dev/./urandom -jar /app/spring_boot/webapp.jar > /app/spring_boot/access.log