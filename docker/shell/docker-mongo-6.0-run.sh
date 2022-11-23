#!/bin/bash

docker run \
-d \
-p 27017:27017 \
--name mongo6 \
--network bridge \
--restart=always \
--privileged=true \
-e MONGO_INITDB_ROOT_USERNAME=admin \
-e MONGO_INITDB_ROOT_PASSWORD=admin123456 \
-e TZ=Asia/Shanghai \
-v /Users/${USER}/Downloads/Docker/mongodb/data:/data/db \
-v /Users/${USER}/Downloads/Docker/mongodb/config:/data/mongo/conf \
-v /Users/${USER}/Downloads/Docker/mongodb/log:/data/logs \
mongo:6.0 \
-f /data/mongo/conf/mongod.conf