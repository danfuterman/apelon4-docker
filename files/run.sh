#!/bin/bash

__updateJBossConfig(){
${JBOSS_HOME}/updateConfig.groovy
}

__start_mysql(){
/etc/init.d/mysql start
}

__start_jboss(){
cd ${JBOSS_HOME}/bin/; ./standalone.sh -c standalone-apelondts-mysql.xml
}

# Call all functions
__updateJBossConfig
__start_mysql
__start_jboss



