#!/bin/bash

docker run \
-d \
-p 5000:5000 \
--name python-docker-v1 \
--network bridge \
--restart always \
--privileged=true \
python-docker:v1.0
