#!/bin/bash -ilex

webapp=$2

if [ "$1" = "" ];
then
    echo -e "you must use like this : ./publish.sh <start|stop|restart> <webapp>"
    exit 1
fi

if [ "$2" = "" ];
then
    echo -e "not webapp name"
    exit 1
fi

function start()
{
  count=`ps -ef |grep java|grep $webapp | grep -v grep | wc -l`
  if [ $count != 0 ];
  then
    echo "$webapp is running..."
  else
    echo "Start $webapp begin... please look at the access.log file. "
    nohup java -jar $webapp > access.log 2>&1 &
    sleep 30
    cat access.log
  fi
}

function stop()
{
  count=`ps -ef |grep java|grep $webapp | grep -v grep | wc -l`
  if [ $count != 0 ];
  then
    echo "Stop $webapp ..."
    pid=`ps -ef |grep java|grep $webapp | grep -v grep | awk '{print $2}'`
    kill -9 $pid
  else
   echo "$webapp is not running..."
  fi
}

function restart(){
  stop
  sleep 2
  start
}

case $1 in
  start)
  start;;
  stop)
  stop;;
  restart)
  restart;;
  *)
esac 
