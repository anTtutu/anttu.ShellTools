#!/bin/bash

docker run \
-d \
-p 8080:8080 \
--name java-docker-v1 \
--network bridge \
--restart always \
--privileged=true \
java-docker:v1.0
