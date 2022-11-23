#!/bin/bash

docker run \
-d \
-p 6379:6379 \
--name redis7 \
--network bridge \
--restart=always \
--privileged=true \
--log-opt max-size=100m \
--log-opt max-file=2 \
-v /Users/${USER}/Downloads/Docker/redis/config/redis.conf:/etc/redis/redis.conf \
-v /Users/${USER}/Downloads/Docker/redis/data:/data \
redis:7.0 \
redis-server /etc/redis/redis.conf \
--appendonly yes \
--requirepass test123456