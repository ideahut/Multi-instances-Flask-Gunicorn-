#!/bin/bash

#
# https://medium.com/building-the-system/gunicorn-3-means-of-concurrency-efbb547674b7
#
PYTHON=/opt/engine/venv/bin/python3
GUNICORN=/opt/engine/new-venv/bin/gunicorn
WORKER=10
THREAD=10

declare PORTS=(
   34001
   34002
   34003
   34004
)

getpid() {
   echo `ps aux | grep "$1" | grep -v grep | awk '{ print $2 }'`    
}

getappid() {
   echo "flask-api-sample-$1"
}

getappname() {
   echo "Flask API Sample (port: $1)"
}

gethomedir() {
   dir=`dirname $0`
   pwd=`pwd`
   if [[ ${dir:0:1} == "/" ]] ;
   then  
      home="$dir"
   else  
      if [[ $dir == "." ]];
      then
         home="$pwd"
      else
         home="$pwd/$dir"
      fi
   fi
   echo "$home"
}

_start() {
   name=$(getappname $1)
   appid=$(getappid $1)
   pid=$(getpid $appid)
   if [ -n "$pid" ];
   then
      echo "$name is RUNNING (pid: $pid)"
   else
      echo "Starting $name"
      $GUNICORN --workers=$WORKER --threads=$THREAD --worker-class=gthread -b 0.0.0.0:$1 sample:app $appid &
   fi
}

_stop() {
   name=$(getappname $1)
   appid=$(getappid $1)
   pid=$(getpid $appid)
   if [ -n "$pid" ];
   then
      echo "Stoping $name (pid: $pid)"
      kill -9 $pid
      echo "$name is SHUTDOWN"
   else
      echo "$name is SHUTDOWN"
   fi
}

_status() {
   name=$(getappname $1)
   appid=$(getappid $1)
   pid=$(getpid $appid)
   if [ -n "$pid" ];
   then
      echo "$name is RUNNING (pid: $pid)"
   else
      echo "$name is SHUTDOWN"
   fi
}


start() {
    if [ "$1" ];
    then
	for port in ${PORTS[*]}
        do
           if [ "$port" == "$1" ]; 
           then
	      echo
              _start $port
              echo
              break
           fi
        done
    else
	echo
       	for port in ${PORTS[*]}
        do
           _start $port
        done
        echo
    fi
}

stop() {
    if [ "$1" ];
    then
	for port in ${PORTS[*]}
        do
           if [ "$port" == "$1" ]; 
           then
              echo 
              _stop $port
              echo
              break
           fi
        done
    else
        echo 
       	for port in ${PORTS[*]}
        do
           _stop $port
        done
        echo
    fi
}

status() {
   if [ "$1" ];
   then
      for port in ${PORTS[*]}
      do
         if [ "$port" == "$1" ]; 
         then
            echo 
            _status $port
            echo
            break
         fi
      done
   else
      echo 
      for port in ${PORTS[*]}
      do
         _status $port
      done
      echo
    fi
}

case $1 in
    start)
        start $2
        ;;
    stop)
        stop $2
        ;;
    restart)
        stop $2
        start $2
        ;;
    status)
        status $2
        ;;
    clear)
        homedir=$(gethomedir)
        echo
        echo "Deleting $homedir/logs/*.log"
        rm -rf $homedir/logs/*.log
        echo
        ;;
    *)
        echo "Usage: [ start | stop | restart | status ] [port]"
        exit 1
esac

exit 0
