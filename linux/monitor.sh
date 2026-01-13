#!/bin/bash
##############################################
#Description: 监控cpu、磁盘、内存使用率
##############################################
api=$1
function get_msg(){
    while true
    do
        #获得物理网卡
        machine_physics_net=$(ls /sys/class/net/ | grep -v "`ls /sys/devices/virtual/net/`");
        #先过滤网卡，在查找IP，不要再awk中过滤网卡
        local_ip=$(ip addr | grep $machine_physics_net | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | head -1);

        logFile=/tmp/jiankong.log
        #获取报警时间
        now_time=`date '+%F %T'`

        #获取CPU核数
        cpu_num=`grep -c "model name" /proc/cpuinfo`

        #获取cpu使用率
        cpu_used_percent=`top -b -n5 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' '{split($1, vs, ","); v=vs[length(vs)]; sub(/\s+/, "", v);sub(/\s+/, "", v); printf "%d", 100-v;}'`

        #统计内存使用率
        mem_used_percent=`free -m | awk -F '[ :]+' 'NR==2{printf "%d", ($3)/$2*100}'`

        #获取物理内存总量
        mem_total=`free | grep Mem | awk '{print $2/1024/1024}'`

        #获取操作系统已使用内存总量
        mem_sys_used=`free | grep Mem | awk '{print $3/1024/1024}'`

        #获取操作系统未使用内存总量
        mem_sys_free=`free | grep Mem | awk '{print $4/1024/1024}'`

        #磁盘总量：GB
        disk_total=`df | grep ^/dev/ | awk '{print $2}' | awk '{sum+=$1}END{print sum/1024/1024}'`
        
        #磁盘已使用量：GB
        disk_used=`df | grep ^/dev/ | awk '{print $3}' | awk '{sum+=$1}END{print sum/1024/1024}'`
        #获取磁盘使用率
        disk_used_percent=`echo "$disk_used $disk_total" | awk '{print ($1/$2)*100}' | awk '{printf "%.2f\n", $1}'`
		
        curl --location --request POST $api \
                --header 'Content-Type: application/json' \
                --data '{
                    "ip":"'$local_ip'",
                    "cpuNum":"'$cpu_num'",
                    "cpuUsedPercent":"'$cpu_used_percent'",
                    "memUsedPercent":"'$mem_used_percent'",
                    "memTotal":"'$mem_total'",
                    "memSysUsed":"'$mem_sys_used'",
                    "memSysFree":"'$mem_sys_free'",
                    "diskTotal":"'$disk_total'",
                    "diskUsed":"'$disk_used'",
                    "diskUsedPercent":"'$disk_used_percent'"
                }'
        sleep 5
    done
}

function main(){
        get_msg &
}
main
exit 0
