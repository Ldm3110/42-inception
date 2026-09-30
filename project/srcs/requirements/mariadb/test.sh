#!/bin/bash

# we run mariadb first time to create databases etc ...
service mariadb start

mariadb -e "CREATE DATABASE IF NOT EXISTS testDB;"
mariadb -e "SHOW DATABASES;"

# we close mariadb after working ...
service mariadb stop

# ... and now we execute mariadb on PID1 (necessary for bash signals)
exec mariadbd --user=mysql
