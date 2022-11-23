#!/bin/bash

docker run \
-d \
-p 2379:2379 \
-p 2380:2380 \
--name etcd \
--network bridge \
--restart=always \
--privileged=true \
--volume=/Users/${USER}/Downloads/Docker/etcd/data:/bitnami/etcd/data \
-e data-dir=/Users/${USER}/Downloads/Docker/etcd/data \
-e name=node1 \
-e ETCDCTL_API=3 \
-e initial-advertise-peer-urls=http://0.0.0.0:2380 \
-e listen-peer-urls=http://0.0.0.0:2380 \
-e advertise-client-urls=http://0.0.0.0:2379 \
-e listen-client-urls=http://0.0.0.0:2379 \
-e initial-cluster node1=http://0.0.0.0:2380 \
bitnami/etcd:latest
