#!/bin/bash -e

cat <<- EOF > /opt/exhibitor/defaults.conf
	zookeeper-data-directory=$ZK_DATA_DIR
	zookeeper-log-directory=$ZK_LOG_DIR
	zookeeper-install-directory=/opt/zookeeper
	log-index-directory=$ZK_LOG_DIR
	backup-extra=directory\=${ZK_LOG_DIR}/backup
	cleanup-period-ms=300000
	check-ms=30000
	backup-period-ms=600000
	cleanup-max-files=20
	backup-max-store-ms=21600000
	observer-threshold=0
	zoo-cfg-extra=tickTime\=2000&initLimit\=10&syncLimit\=5&quorumListenOnAllIPs\=true
	auto-manage-instances-settling-period-ms=0
	auto-manage-instances=0
EOF


# Starting exhibitor
java -jar /opt/exhibitor/exhibitor.jar \
    --port $EXHIBITOR_PORT --defaultconfig /opt/exhibitor/defaults.conf \
    --configtype file --filesystembackup true &

sleep 3 && curl -XGET http://localhost:${EXHIBITOR_PORT}/exhibitor/v1/cluster/set/restarts/false

