#!/bin/bash

# stop the script at the first error
set -e

source /run/secrets/credentials

# creates folder because i don't use "service mariadb start"
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# we run mariadb first time to create databases etc ...
mariadbd --user=mysql --skip-networking &
pid=$!

# waiting server 
until mariadb-admin ping --silent; do
    sleep 1
done

mariadb <<EOF
create database if not exists $DB_NAME;
create user if not exists '$DB_USER'@'%' identified by '$DB_PASSWORD'; 
grant all privileges on $DB_NAME.* to '$DB_USER'@'%';
flush privileges;
EOF

echo -e "\nShow Databases"
mariadb -e "SHOW DATABASES;"

echo -e "\nShow if user is correctly created"
mariadb -e "select user, host from mysql.user;"

echo -e "\nShow grants for created user"
mariadb -e "show grants for $DB_USER@'%';"
echo -e "\n"

# reloading mariadb ...
mariadb-admin shutdown
wait $pid

# ... and now we execute mariadb on PID1 (necessary for bash signals)
exec mariadbd --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock
