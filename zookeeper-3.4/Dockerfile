FROM jeanblanchard/busybox-java:8

ENV \
    ZK_DATA_DIR=/var/lib/zookeeper \
    ZK_LOG_DIR=/var/log/zookeeper \
    ZOOKEEPER_VERSION=3.4.6 \
    ZK_RELEASE="http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz" \
    EXHIBITOR_POM="https://raw.githubusercontent.com/Netflix/exhibitor/d911a16d704bbe790d84bbacc655ef050c1f5806/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml" \
    MVN_RELEASE="http://www.apache.org/dist/maven/maven-3/3.3.1/binaries/apache-maven-3.3.1-bin.tar.gz" \
    CONS_TMPL_VERSION=0.9.0 \
    CONS_TMPL_URL="https://github.com/hashicorp/consul-template/releases/download/v0.9.0/consul-template_0.9.0_linux_amd64.tar.gz" \
    EXHIBITOR_PORT=8181 \
    INSTALL_DIR=/opt/zookeeper


RUN mkdir -p /opt && mkdir -p /consul-template/templates/ && mkdir -p /usr/local/bin
ADD templates /consul-template/templates/

# Use one step so we can remove intermediate dependencies and minimize size
RUN \
    # Install dependencies
    opkg-install bash tar \

    # Default DNS cache TTL is -1. DNS records, like, change, man.
    && grep -q '^networkaddress.cache.ttl=' /opt/jdk/jre/lib/security/java.security || echo 'networkaddress.cache.ttl=60' >> /opt/jdk/jre/lib/security/java.security \

    # Install ZK
    && curl -Lo /tmp/zookeeper.tgz $ZK_RELEASE \
    && mkdir -p /opt/zookeeper \
    && tar -xzf /tmp/zookeeper.tgz -C /opt/zookeeper --strip=1 \
    && rm /tmp/zookeeper.tgz \

    # Install consule-template
    && curl -kLo /tmp/consul-template.tgz $CONS_TMPL_URL \
    && tar -xzf /tmp/consul-template.tgz -C /usr/local/bin/ --strip-components=1 \
    && mkdir -p /consul-template/templates \

    # Install Maven (just for building)
    && mkdir -p /opt/maven \
    && curl -Lo /tmp/maven.tgz $MVN_RELEASE \
    && tar -xzf /tmp/maven.tgz -C /opt/maven --strip=1 \
    && rm /tmp/maven.tgz \

    # Install Exhibitor
    && mkdir -p /opt/exhibitor \
    && curl -kLo /opt/exhibitor/pom.xml $EXHIBITOR_POM \
    && /opt/maven/bin/mvn -f /opt/exhibitor/pom.xml package \
    && ln -s /opt/exhibitor/target/exhibitor*jar /opt/exhibitor/exhibitor.jar \

    # Remove build-time dependencies
    && rm -rf ~/.m2 \
    && rm -rf /opt/maven \
    && opkg-cl remove tar bzip2 libbz2 libacl libattr\
    && rm -rf /tmp/*


USER root

COPY zk_config.sh /usr/local/bin/
COPY zk_launch.sh /usr/local/bin/
COPY setacl.sh /usr/local/bin/
COPY exhibitor.sh /usr/local/bin/
COPY zk_manage.sh /usr/local/bin/ 

WORKDIR /opt/exhibitor
EXPOSE 2181 2888 3888 8181

#VOLUME /opt/zookeeper/transactions
#VOLUME /opt/zookeeper/snapshots

VOLUME ["/var/lib/zookeeper", "/var/log/zookeeper"]

#ENTRYPOINT ["bash", "-ex", "/usr/local/bin/zk_config.sh"]
ENTRYPOINT ["bash", "-ex", "/usr/local/bin/exhibitor.sh"]
