#!/bin/bash


function stop()
{
    container_name=$1

    if [ "${container_name}" == "all" ]; then
        # 获取所有状态为 running 的容器 ID
        container_ids=$(docker ps -aqf "status=running")

        # 如果没有容器处于运行状态，则输出提示信息并退出脚本
        if [ -z "${container_ids}" ]; then
            echo "No running containers. Done."
            exit 0
        fi

        # 循环停止所有处于运行状态的容器
        for container in ${container_ids}; do
            docker stop ${container}
        done
    else
        container_id=$(docker ps -a | grep "${container_name}" | grep "Up" | awk -F"${container_name}" {'print $1'})

        if [ ! -z ${container_id} ]; then
            docker stop ${container_id}
            echo "stop successful, container name[${container_name}]"
        else
            echo "container name[${container_name}] is not exist or stopped."    
        fi
    fi
}


function main()
{
    if [ $# -eq 1 ]; then
        if [ "$1" == "all" ]; then
            stop "all"
        else
            stop "$1"    
        fi
    else
        echo "Error Parameter, egg: ./docker-stop-container mysql or ./docker-stop-container all "
        exit 1
    fi
}

main $1