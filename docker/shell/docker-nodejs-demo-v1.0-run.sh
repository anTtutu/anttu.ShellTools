#!/bin/bash

docker run \
-d \
-p 8000:8000 \
--name nodejs-docker-v1 \
--network bridge \
--restart always \
--privileged=true \
node-docker:v1.0
