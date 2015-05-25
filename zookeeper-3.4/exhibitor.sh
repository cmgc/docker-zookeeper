#!/bin/bash -e

cat <<- EOF > /opt/exhibitor/defaults.conf
	zookeeper-data-directory=/var/lib/zookeeper/version-2
	zookeeper-install-directory=/opt/zookeeper
	zookeeper-log-directory=/var/log/zookeeper/version-2
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


java -jar /opt/exhibitor/exhibitor.jar \
    --port 8181 --defaultconfig /opt/exhibitor/defaults.conf \
    --configtype file --filesystembackup true
