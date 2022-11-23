#!/bin/bash

docker run \
-d \
-p 3306:3306 \
-p 33060:33060 \
--name mysql8 \
--network bridge \
--restart always \
--privileged=true \
-v /Users/${USER}/Downloads/Docker/mysql/config/my.cnf:/etc/mysql/my.cnf:rw \
-v /Users/${USER}/Downloads/Docker/mysql/data:/usr/data \
-v /Users/${USER}/Downloads/Docker/mysql/log:/logs \
-v /Users/${USER}/Downloads/Docker/mysql/localtime:/etc/localtime:ro \
-e MYSQL_ROOT_PASSWORD="root123456" \
-e MYSQL_USER="mysql" \
-e MYSQL_PASSWORD="test123456" \
-e character-set-server=utf8mb4 \
-e collation-server=utf8_general_ci \
mysql:8.0
