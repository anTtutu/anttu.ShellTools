#!/bin/bash



if 
container_name=$1

container_id=$(docker ps -a | grep ${container_name} | grep "Up" | awk -F"${container_name}" {'print $1'})

if [ ! -z ${container_id} ]; then
    docker stop ${container_id}
    echo "stop successful, container name[${container_name}]"
else
    echo "container name[${container_name}] is not exist or stopped."    
fi
