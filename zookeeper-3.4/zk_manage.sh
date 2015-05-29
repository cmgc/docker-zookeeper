#!/bin/bash

PORT=$EXHIBITOR_PORT

case "$1" in 
    start)
       curl -s localhost:$PORT/exhibitor/v1/cluster/start
       ;;

    stop)
       curl -s localhost:$PORT/exhibitor/v1/cluster/stop
       ;;

    status)
       curl -s localhost:$PORT/exhibitor/v1/cluster/state
       ;;
    
    restart)
      curl -s localhost:$PORT/echibitor/v1/cluster/restart
       ;;

     *)
       echo $"Usage: $0 {start|stop|status|restart}"
       exit 1
esac
    
