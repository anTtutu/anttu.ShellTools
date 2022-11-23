#!/bin/bash

docker run \
-d \
-p 80:80 \
-p 443:443 \
--name nginx1.22.0 \
--network bridge \
--restart=always \
--privileged=true \
-v /Users/${USER}/Downloads/Docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:rw \
-v /Users/${USER}/Downloads/Docker/nginx/conf.d:/etc/nginx/conf.d \
-v /Users/${USER}/Downloads/Docker/nginx/cert:/etc/nginx/certs \
-v /Users/${USER}/Downloads/Docker/nginx/html:/etc/nginx/html \
-v /Users/${USER}/Downloads/Docker/nginx/log:/var/log/nginx \
-e LANG=C.UTF-8 \
-e LC_ALL=C.UTF-8 \
nginx:1.22.0
