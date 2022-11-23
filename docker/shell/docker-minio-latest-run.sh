#!/bin/bash

REGISTRY=quay.io/minio/minio

docker run \
-d \
-p 9000:9000 \
-p 9090:9090 \
--name minio \
--network bridge \
--restart=always \
--privileged=true \
-v /Users/${USER}/Downloads/Docker/minio/data:/data \
--user $(id -u):$(id -g) \
-e "MINIO_ROOT_USER=admin" \
-e "MINIO_ROOT_PASSWORD=admin123456" \
${REGISTRY}:latest \
server /data --console-address ":9090"
