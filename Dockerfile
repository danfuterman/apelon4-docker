# Version: 0.0.1

FROM ubuntu:trusty
MAINTAINER Daniel Futerman <daniel.futerman@jembi.org>

# Install packages
ENV REFRESHED_AT 2016-03-03
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --force-yes --no-install-recommends install \
	mysql-server-5.6 \
	wget unzip pwgen software-properties-common ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Java (important to use java 7, JBoss does not work with version 8)
RUN \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-7-jdk groovy && \
  rm -rf /var/lib/apt/lists/*


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN echo PATH=$JAVA_HOME/bin:$PATH:$HOME/bin >> ~/.bashrc
RUN echo export PATH JAVA_HOME >> ~/.bashrc

# Install JBoss server
ENV JBOSS_HOME /usr/local/jboss
RUN mkdir ${JBOSS_HOME}
RUN wget http://repo1.maven.org/maven2/org/jboss/as/jboss-as-dist/7.1.1.Final/jboss-as-dist-7.1.1.Final.zip && \
	unzip jboss-as-dist-7.1.1.Final.zip && \
	mv jboss-as-7.1.1.Final/* ${JBOSS_HOME}/ && \
	rm -rf jboss-as-7.1.1.Final && \
	rm jboss-as-dist-7.1.1.Final.zip
COPY files/standalone-apelondts-mysql.xml ${JBOSS_HOME}/standalone/configuration/
COPY files/standalone.conf ${JBOSS_HOME}/bin/
COPY files/updateConfig.groovy ${JBOSS_HOME}/updateConfig.groovy
COPY files/application-roles.properties ${JBOSS_HOME}/standalone/configuration/
RUN chmod +x ${JBOSS_HOME}/updateConfig.groovy

# DTS_HOME
ENV DTS_HOME /usr/local/apelon
RUN mkdir ${DTS_HOME}
ADD files/dts-linux_4.6.0-798.tar.gz ${DTS_HOME}/
COPY files/source-connection.xml ${DTS_HOME}/bin/kb/source-connection.xml
COPY files/target-connection-mysql.xml ${DTS_HOME}/bin/kb/target-connection.xml
COPY files/kbcreate.xml ${DTS_HOME}/bin/kb/create/kbcreate.xml
RUN sh ${DTS_HOME}/bin/makeScriptsExecutable.sh

# Deploy mysql connector
RUN mkdir -p ${JBOSS_HOME}/modules/com/mysql/main
RUN wget -q http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.30/mysql-connector-java-5.1.30.jar -O ${JBOSS_HOME}/modules/com/mysql/main/mysql-connector-java.jar
COPY files/module.xml ${JBOSS_HOME}/modules/com/mysql/main/module.xml

# Add MySQL configuration
COPY files/config_mysql.sh /config_mysql.sh
RUN chmod +x /config_mysql.sh
RUN /config_mysql.sh
RUN rm config_mysql.sh
COPY files/my.cnf /etc/mysql/my.cnf
# Deploy Apelon server
RUN cp ${DTS_HOME}/server/jboss/standalone/deployments/dtsjboss.ear ${JBOSS_HOME}/standalone/deployments/dtsjboss.ear

# Add image scripts
COPY files/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
COPY files/set_jboss_pass.sh /usr/local/bin/set_jboss_pass.sh
RUN chmod +x /usr/local/bin/set_jboss_pass.sh
RUN sh /usr/local/bin/set_jboss_pass.sh

# Expose ports
EXPOSE 4447
EXPOSE 9990
EXPOSE 8080

CMD ["/usr/local/bin/run.sh"]

