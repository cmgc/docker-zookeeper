FROM netflixoss/java:7
# from Netflix Open Source Development <talent@netflix.com>

ENV ZOOKEEPER_VERSION 3.4.6
ENV ZK_DATA_DIR /var/lib/zookeeper
ENV ZK_LOG_DIR /var/log/zookeeper
ENV ZK_URL="http://apache.mirrors.pair.com/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz"
ENV EXHIBITOR_POM="https://raw.github.com/Netflix/exhibitor/master/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml"
ENV CONS_TMPL_VERSION=0.9.0
ENV CONS_TMPL_URL="https://github.com/hashicorp/consul-template/releases/download/v${CONS_TMPL_VERSION}/consul-template_${CONS_TMPL_VERSION}_linux_amd64.tar.gz"

RUN mkdir -p /opt

# Install zookeeper
RUN apt-get update &&\
    apt-get -y install ca-certificates &&\
    wget -q -O - $ZK_URL | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$ZOOKEEPER_VERSION /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper 
  
# Install consul-template
RUN wget -q -O - $CONS_TMPL_URL | tar -xzf - -C /usr/local/bin/ --strip-components=1

# Install exhibitor
RUN apt-get -y install curl maven &&\
    mkdir /opt/exhibitor &&\
    cd /opt/exhibitor &&\
    curl -Lo /opt/exhibitor/pom.xml $EXHIBITOR_POM &&\
    mvn -f /opt/exhibitor/pom.xml package &&\
    ln -s /opt/exhibitor/target/exhibitor*jar /opt/exhibitor/exhibitor.jar \

COPY zk_config.sh /usr/local/bin/
COPY zk_launch.sh /usr/local/bin/
COPY setacl.sh /usr/local/bin/
COPY exhibitor.sh /usr/local/bin/
COPY zk_manage.sh /usr/local/bin/ 

#ADD exhibitor.properties /opt/exhibitor/exhibitor.properties

EXPOSE 2181 2888 3888 8181

WORKDIR /opt/zookeeper

ENTRYPOINT ["zk_config.sh"]
