#!/bin/sh
## Database user and password must be included in the variables DB_USER, DB_PASS and DB_NAME

DB_HOSTNAME=`echo $DB_PORT | cut -f3 -d/ | cut -f1 -d:`
DB_PORT_INT=`echo $DB_PORT | cut -f3 -d:`

/usr/sbin/apachectl -D FOREGROUND
