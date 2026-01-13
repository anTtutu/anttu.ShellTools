#!/bin/bash

############################################################
# dev环境数据量比较大，磁盘空间不太够，只能定期清理日志和持久化的数据
#
# 配置crontab 每周0点执行
# 0 0 */7 * *
############################################################

# Kafka安装目录
KAFKA_DIR="/usr/local/kafka_2.11-1.1.1/"

# Kafka日志目录
LOG_DIR="/data/kafka-logs/"

# ZooKeeper安装目录
ZK_DIR="/usr/local/kafka_2.11-1.1.1/"

# Kafka和ZooKeeper服务启动和停止命令
KAFKA_START="${KAFKA_DIR}/bin/kafka-server-start.sh ${KAFKA_DIR}/config/server.properties"
KAFKA_STOP="${KAFKA_DIR}/bin/kafka-server-stop.sh"
ZK_START="${ZK_DIR}/bin/zookeeper-server-start.sh ${ZK_DIR}/config/zookeeper.properties"
ZK_STOP="${ZK_DIR}/bin/zookeeper-server-stop.sh"

# 磁盘分区
DISK_PARTITION="/"

# 磁盘占用率阈值
DISK_USAGE_THRESHOLD=75

# 日志文件路径
SCRIPT_LOG="kafka_restart.log"

# 获取当前磁盘占用率
current_disk_usage=$(df -h ${DISK_PARTITION} | awk 'NR==2 {print $5}' | sed 's/%//')

# 带时间戳的日志输出
function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a ${SCRIPT_LOG}
}

# 停止Kafka服务
function kafka_stop() {
    if ps -ef | grep -v grep | grep kafka.Kafka > /dev/null; then
        log "Stopping Kafka service..."
        ${KAFKA_STOP}
        while ps -ef | grep -v grep | grep kafka.Kafka > /dev/null; do
            log "Waiting for Kafka to stop..."
            sleep 5
        done
        log "Kafka stopped."
    else
        log "Kafka service is not running."
    fi
}

# 停止ZooKeeper服务
function zk_stop() {
    if pgrep -f zookeeper > /dev/null; then
        log "Stopping ZooKeeper service..."
        ${ZK_STOP}
        while pgrep -f zookeeper > /dev/null; do
            log "Waiting for ZooKeeper to stop..."
            sleep 5
        done
        log "ZooKeeper stopped."
    else
        log "ZooKeeper service is not running."
    fi
}

# 检查磁盘占用率并清理日志文件
function check_disk_usage_delete () {
    if [ "${current_disk_usage}" -ge "${DISK_USAGE_THRESHOLD}" ]; then
        log "Disk usage is at ${current_disk_usage}%, which is above the threshold of ${DISK_USAGE_THRESHOLD}%. Cleaning up Kafka logs..."
        find ${LOG_DIR} -type d -mtime +7 -exec rm -f {} \;
    else
        log "Disk usage is at ${current_disk_usage}%, which is below the threshold of ${DISK_USAGE_THRESHOLD}%. No need to clean up logs."
    fi
}

# 启动ZooKeeper服务
function zk_start() {
    log "Starting ZooKeeper service..."
    nohup "${ZK_START}" &

    # 确保ZooKeeper已启动
    while ! pgrep -f zookeeper > /dev/null; do
        log "Waiting for ZooKeeper to start..."
        sleep 5
    done
    log "ZooKeeper started."
}

# 启动Kafka服务
function kafka_start() {
    log "Starting Kafka service..."
    nohup "${KAFKA_START}" &

    # 确保Kafka已启动
    while ! ps -ef | grep -v grep | grep kafka.Kafka > /dev/null; do
        log "Waiting for Kafka to start..."
        sleep 5
    done
    log "Kafka started."
}

function main() {

    # 检测并停kafka
    kafka_stop

    # 检测并停zk
    zk_stop

    # 检测并清理kafka日志
    check_disk_usage_delete

    # 启动zk
    zk_start

    # 启动kafka
    kafka_start

    log "Kafka and ZooKeeper maintenance completed."
}

main