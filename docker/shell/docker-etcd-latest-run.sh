#!/bin/bash

NODE1=0.0.0.0

REGISTRY=quay.io/coreos/etcd

docker run \
-d \
-p 2379:2379 \
-p 2380:2380 \
--name etcd \
--network bridge \
--restart=always \
--privileged=true \
--volume=/Users/${USER}/Downloads/Docker/etcd/data:/etcd/data \
${REGISTRY}:latest \
/usr/local/bin/etcd \
--data-dir=/etcd/data --name node1 \
--initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://0.0.0.0:2380 \
--advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://0.0.0.0:2379 \
--initial-cluster node1=http://${NODE1}:2380