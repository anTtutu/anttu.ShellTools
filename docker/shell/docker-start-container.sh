#!/bin/bash

container_name=$1

container_id=$(docker ps -a | grep "${container_name}" | grep "Exited" | awk -F"${container_name}" {'print $1'})

if [ ! -z "${container_id}" ]; then
    docker start "${container_id}"

    echo "start successful, container name[${container_name}]"
else
    echo "container name[${container_name}] is not exist or started."    
fi
