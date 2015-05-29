#!/bin/bash -e

cat <<- EOF > /opt/exhibitor/defaults.conf
	zookeeper-data-directory=/var/lib/zookeeper
	zookeeper-install-directory=/opt/zookeeper
	zookeeper-log-directory=/var/log/zookeeper
	log-index-directory=/var/log/zookeeper
	backup-extra=directory\=/var/log/zookeeper/backup
	cleanup-period-ms=300000
	check-ms=30000
	backup-period-ms=600000
	client-port=2181
	cleanup-max-files=20
	backup-max-store-ms=21600000
	connect-port=2888
	observer-threshold=0
	election-port=3888
	zoo-cfg-extra=tickTime\=2000&initLimit\=10&syncLimit\=5&quorumListenOnAllIPs\=true
	auto-manage-instances-settling-period-ms=0
	auto-manage-instances=1
EOF



# Did we ask for a super user?
ZK_SUPER_USER=${ZK_SUPER_USER:-super}
ZK_SUPER_PW=${ZK_SUPER_PW:-}

JAVA_ENV_PATH=/opt/zookeeper/conf/java.env

ZK_SUPER_CLASS="zookeeper.DigestAuthenticationProvider.superDigest"
super_args=""

create_digest_pw() {
    java -cp "/opt/zookeeper/*:/opt/zookeeper/lib/*"  org.apache.zookeeper.server.auth.DigestAuthenticationProvider ${ZK_SUPER_USER}:${ZK_SUPER_PW} | awk -F '->' '{print $2}'
}

if [ ! -z "${ZK_SUPER_PW}" ]; then
   digest=$(create_digest_pw)
   export JVMFLAGS+=" -D${ZK_SUPER_CLASS}=$digest "
   echo "JVMFLAGS+=\" -D${JVMFLAGS}\"" >> $JAVA_ENV_PATH
   echo "JVMFLAGS+=\"-Xms512m -Xmx512m\"" >> $JAVA_ENV_PATH
   chmod +x $JAVA_ENV_PATH
fi

# Starting exhibitor
java -jar /opt/exhibitor/exhibitor.jar \
    --port $EXHIBITOR_PORT --defaultconfig /opt/exhibitor/defaults.conf \
    --configtype file --filesystembackup true --hostname $ZK_HOSTNAME

