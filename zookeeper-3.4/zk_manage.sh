#!/bin/bash

PORT=8181

case "$1" in 
    start)
       curl -s localhost:$PORT/exhibitor/v1/start
       ;;

    stop)
       curl -s localhost:$PORT/exhibitor/v1/stop
       ;;

    status)
       curl -s localhost:$PORT/exhibitor/v1/state
       ;;
    
     restart)
       curl -s localhost:$PORT/echibitor/v1/restart
       ;;

     *)
       echo $"Usage: $0 {start|stop|status|restart}"
       exit 1

esac
