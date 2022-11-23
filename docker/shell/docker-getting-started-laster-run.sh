#! /bin/bash

docker run \
-d \
-p 8001:80 \
-p 3000:3000 \
--name getting-started-latest \
--network bridge \
--restart=always \
--privileged=true \
docker/getting-started:latest
