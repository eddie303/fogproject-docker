#!/bin/sh
## Database user and password must be included in the variables DB_USER, DB_PASS and DB_NAME

DB_HOSTNAME=`echo $DB_PORT | cut -f3 -d/ | cut -f1 -d:`
DB_PORT_INT=`echo $DB_PORT | cut -f3 -d:`
DB_HOST_INT=${DB_HOSTNAME:-"localhost"}
DB_NAME_INT=${DB_NAME:-"fog"}
DB_USER_INT=${DB_USER:-"root"}
DB_ROOT_INT=${DB_ROOT:-"root"}
DB_PASS_INT=${DB_PASS:-""}
DB_EXISTS=`mysql -h $DB_HOST_INT -u $DB_USER_INT -p$DB_PASS_INT --skip-column-names -e "SHOW DATABASES LIKE '$DB_NAME_INT'"`

sed -i "s/define('DATABASE_HOST', 'localhost');/define('DATABASE_HOST', '$DB_HOSTNAME');/g" /var/www/fog/lib/fog/config.class.php
sed -i "s/define('DATABASE_NAME', 'fog');/define('DATABASE_NAME', '$DB_NAME_INT');/g" /var/www/fog/lib/fog/config.class.php
sed -i "s/define('DATABASE_USERNAME', 'root');/define('DATABASE_USERNAME', '$DB_USER_INT');/g" /var/www/fog/lib/fog/config.class.php
sed -i "s/define('DATABASE_PASSWORD', '');/define('DATABASE_PASSWORD', '$DB_PASS_INT');/g" /var/www/fog/lib/fog/config.class.php

/etc/init.d/rpcbind start
/etc/init.d/vsftpd start
/etc/init.d/tftpd-hpa start
/etc/init.d/mysql start
/etc/init.d/nfs-kernel-server start
/etc/init.d/php-fpm7.2 start
if [ !$DB_EXISTS ]; then
  if [ -n "$DB_ROOTPASS" ]; then 
    mysql -h $DB_HOST_INT -u root -p$DB_ROOTPASS -e "CREATE DATABASE $DB_NAME_INT;"
    mysql -h $DB_HOST_INT -u root -p$DB_ROOTPASS -e "GRANT ALL PRIVILEGES ON $DB_NAME_INT.* TO '$DB_USER_INT'@'%' IDENTIFIED BY '$DB_PASS'"
  else
    mysql -h $DB_HOST_INT -u root -e "CREATE DATABASE $DB_NAME_INT;"
    mysql -h $DB_HOST_INT -u root -e  "GRANT ALL PRIVILEGES ON $DB_NAME_INT.* TO '$DB_USER_INT'@'%' IDENTIFIED BY '$DB_PASS'"
fi
/usr/sbin/apachectl -D FOREGROUND
