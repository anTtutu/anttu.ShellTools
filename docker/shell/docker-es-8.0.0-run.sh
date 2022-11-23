#!/bin/bash

docker run \
-d \
-p 9200:9200 \
-p 9300:9300 \
--name elasticsearch8 \
--network bridge \
--restart always \
--privileged=true \
-v /Users/${USER}/Downloads/Docker/elasticsearch/config/elasticsearch.yml:/etc/mysql/elasticsearch.yml:rw \
-v /Users/${USER}/Downloads/Docker/elasticsearch/data:/usr/share/elasticsearch/data \
-v /Users/${USER}/Downloads/Docker/elasticsearch/log:/logs \
-v /Users/${USER}/Downloads/Docker/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
-e "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms64m -Xmx512m" \
elasticsearch:8.0.0 
