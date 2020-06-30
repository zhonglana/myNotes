#!/bin/bash
cd /usr/local/project/docker-test
rm -rf /root/test/*
#jenkins job Id
BUILD_ID=$1
# git commit id 
COMMIT_ID=$2
#container name use the project name
CONTAINER_NAME=springboot01
#image name 
IMAGES_NAME=ubuntu/$CONTAINER_NAME
# write log for build
echo "build_id:"$1" commit_id:"$2"  buildtime:"`date "+%Y-%m-%d %H:%M:%S"`>>build_version.log
# get file path and file name
FILENAME=$(find -name SpringBoot01**.jar)
JARNAME=${FILENAME##*/}
chmod  777 $JARNAME
if [ -z "$JARNAME" ]
then
    echo "not find :"$JARNAME
    exit
else
    echo "find app:"$JARNAME
fi
#stop and rm container and images 
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
# delete image
IMAGE_ID=$(docker images | grep "$IMAGES_NAME" | awk '{print $3}')
echo "iam:"$IMAGE_ID
if [ -z "$IMAGE_ID" ]
then
    echo no images need del
else
    echo "rm images:" $IMAGE_ID
    docker rmi -f $IMAGE_ID
fi
#编译docker file 并动态传入参数
docker build --build-arg app=$JARNAME .  -t  $IMAGES_NAME:$BUILD_ID
rm $JARNAME
# docker run  expose port 8181 
docker run -itd -p 8383:8181 --name $CONTAINER_NAME  $IMAGES_NAME:$BUILD_ID
# docker tag and push registry
docker tag $IMAGES_NAME:$BUILD_ID 10.32.20.31:5000/$IMAGES_NAME:$BUILD_ID
docker push 10.32.20.31:5000/$IMAGES_NAME:$BUILD_ID
