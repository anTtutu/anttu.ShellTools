#!/bin/bash

docker run \
-d \
-p 8081:8081 \
--name go-docker-v1 \
--network bridge \
--restart always \
--privileged=true \
docker-gs-ping:v1.0
