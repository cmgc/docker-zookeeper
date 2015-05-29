#!/bin/bash

set -e 
set -x 

#Environment file containing ZK host definitions
# You can override this with a volume mounted zoo.env
#ZOO_ENV=${ZOO_ENV:-"/opt/zookeeper/conf/zoo.env"}
#touch $ZOO_ENV
#source ${ZOO_ENV} 

export ZK_DATA_DIR=${ZK_DATA_DIR:-/var/lib/zookeeper}
export ZK_LOG_DIR=${ZK_LOG_DIR:-/var/log/zookeeper}

#For log4j:
export ZOO_LOG_DIR=${ZOO_LOG_DIR:-${ZK_LOG_DIR}}

ZK_ID=${ZK_ID:-1}
MYID_FILE=${MYID_FILE:-/var/lib/zookeeper/myid}


write_zkid() {
  echo $ZK_ID > ${MYID_FILE}
}



#Sanity check. If no hosts are defined, assume a 1-node cluster
#If a password was set, add it to the start args
#if [ ! -z "${ZK_SUPER_PW}" ]; then
#   digest=$(create_digest_pw)
#   JVMFLAGS="${ZK_SUPER_CLASS}=$digest "
#   echo "JVMFLAGS+=\" -D${JVMFLAGS}\"" >> /opt/zookeeper/conf/java.env
#fi

#write_settings
#check_vars
write_zkid


#/opt/zookeeper/bin/zkServer.sh restart 
#/usr/local/bin/zk_manage.sh restart > /dev/null 2>&1 
/usr/local/bin/zk_manage.sh restart
