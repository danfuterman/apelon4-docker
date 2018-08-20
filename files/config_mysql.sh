#!/bin/bash

__mysql_config() {
echo "Running the mysql_config function."
chown -R mysql:mysql /var/lib/mysql
/etc/init.d/mysql start
sleep 10
}

__start_mysql() {
echo "Running the start_mysql function."
mysqladmin -u root password mysqlPassword
mysql -uroot -pmysqlPassword -e "CREATE USER 'dts4user'@'%' IDENTIFIED BY 'dts4password'"
mysql -uroot -pmysqlPassword -e "CREATE DATABASE dts4"
mysql -uroot -pmysqlPassword -e "GRANT ALL PRIVILEGES ON dts4.* TO dts4user"
mysql -uroot -pmysqlPassword -e "FLUSH PRIVILEGES"
mysql -uroot -pmysqlPassword -e "COMMIT"
}

__create_dts_schema(){
echo "Create DTS Knowledgebase schema"
cd ${DTS_HOME}/bin/kb/create/; ./kbcreate.sh
killall mysqld
sleep 10
}

# Call all functions
__mysql_config
__start_mysql
__create_dts_schema


