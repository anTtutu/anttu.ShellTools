#!/bin/bash

function start()
{
    container_name=$1

    if [ "${container_name}" == "all" ]; then
        # 获取所有状态为 exited 的容器 ID
        container_ids=$(docker ps -aqf "status=exited")

        # 如果没有容器处于停止状态，则输出提示信息并退出脚本
        if [ -z "${container_ids}" ]; then
            echo "No exited containers. Done."
            exit 0
        fi

        # 循环启动所有处于停止状态的容器
        for container in ${container_ids}; do
            docker start ${container}
        done
    else
        container_id=$(docker ps -a | grep ${container_name} | grep "Exited" | awk -F"${container_name}" {'print $1'})

        if [ ! -z ${container_id} ]; then
            docker start ${container_id}

            echo "start successful, container name[${container_name}]"
        else
            echo "container name[${container_name}] is not exist or started."    
        fi
    fi

} 

function main()
{
    if [ $# -eq 1 ]; then
        if [ "$1" == "all" ]; then
            start "all"
        else
            start "$1"    
        fi
    else
        echo "Error Parameter, egg: ./docker-start-container mysql or ./docker-start-container all "
        exit 1
    fi
}

main $1