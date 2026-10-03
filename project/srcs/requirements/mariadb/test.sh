#!/bin/bash

# we run mariadb first time to create databases etc ...
service mariadb start

mariadb -e "CREATE DATABASE IF NOT EXISTS testDB;"
mariadb -e "SHOW DATABASES;"
# create a user
mariadb -e "create user if not exists 'user'@'%' identified by 'admin';" 
# add privileges to this user
mariadb -e "grant all privileges on testDB.* to 'user'@'%' identified by 'user';"
mariadb -e "flush privileges;"
mariadb -e "select user, host from mysql.user;"
mariadb -e "show grants for 'user'@'%';"

# reloading mariadb ...
service mariadb stop

# ... and now we execute mariadb on PID1 (necessary for bash signals)
exec mariadbd --user=mysql
