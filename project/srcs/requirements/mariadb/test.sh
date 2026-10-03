#!/bin/bash

# stop the script at the first error
set -e

# export all env variables
set -a
source .env
set +a

# we run mariadb first time to create databases etc ...
service mariadb start

mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
create user if not exists '$DB_USER'@'%' identified by '$DB_PASSWORD'; 
grant all privileges on $DB_NAME.* to '$DB_USER'@'%';
flush privileges;
EOF

mariadb -e "SHOW DATABASES;"
mariadb -e "select user, host from mysql.user;"
mariadb -e "show grants for $DB_USER@'%';"

# reloading mariadb ...
service mariadb stop

# ... and now we execute mariadb on PID1 (necessary for bash signals)
exec mariadbd --user=mysql
