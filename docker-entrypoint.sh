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

# Change database access info
sed -i "s/define('DATABASE_HOST', 'localhost');/define('DATABASE_HOST', '$DB_HOSTNAME');/g" /var/www/fog/lib/fog/config.class.php
sed -i "s/define('DATABASE_NAME', 'fog');/define('DATABASE_NAME', '$DB_NAME_INT');/g" /var/www/fog/lib/fog/config.class.php
sed -i "s/define('DATABASE_USERNAME', 'root');/define('DATABASE_USERNAME', '$DB_USER_INT');/g" /var/www/fog/lib/fog/config.class.php
sed -i "s/define('DATABASE_PASSWORD', '');/define('DATABASE_PASSWORD', '$DB_PASS_INT');/g" /var/www/fog/lib/fog/config.class.php

# Try to get IP Address and active network interface on the specific subnet
if [ -n "$EXTIP" ]; then
  ACTIVE_ETH=`ip addr show | grep $EXTIP | awk -- '{ print $7 }'`
else
  ACTIVE_ETH=`ip route get 1.1.1.1 | awk -- '{ print $5 }'`
  export EXTIP=`ip addr show $ACTIVE_ETH | grep inet\ | awk -- '{print $2 }' | cut -f1 -d/`
fi
export ACTIVE_ETH
touch /opt/fog/.fogsettings
python3 /usr/local/bin/fixChain.py

# Touch .mntcheck files before we get kicked out because the client does not see the file and thinks NFS cannot be mounted
touch /images/.mntcheck
touch /images/dev/.mntcheck

#Start services
/etc/init.d/rpcbind start
/etc/init.d/vsftpd start
/etc/init.d/tftpd-hpa start
/etc/init.d/nfs-kernel-server start
/etc/init.d/php7.2-fpm start
if [ !$DB_EXISTS ]; then
  if [ -n "$DB_ROOTPASS" ]; then 
    mysql -h $DB_HOST_INT -u root -p$DB_ROOTPASS -e "CREATE DATABASE $DB_NAME_INT;"
    mysql -h $DB_HOST_INT -u root -p$DB_ROOTPASS -e "GRANT ALL PRIVILEGES ON $DB_NAME_INT.* TO '$DB_USER_INT'@'%' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;"
    mysql -h $DB_HOST_INT -u root -p$DB_ROOTPASS -e "GRANT CREATE USER ON *.* TO $DB_USER_INT WITH GRANT OPTION;"
  else
    mysql -h $DB_HOST_INT -u root -e "CREATE DATABASE $DB_NAME_INT;"
    mysql -h $DB_HOST_INT -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME_INT.* TO '$DB_USER_INT'@'%' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;"
    mysql -h $DB_HOST_INT -u root -e "GRANT CREATE USER ON *.* TO $DB_USER_INT WITH GRANT OPTION;"
  fi
fi
/etc/init.d/mysql start
/usr/sbin/apachectl -D FOREGROUND
