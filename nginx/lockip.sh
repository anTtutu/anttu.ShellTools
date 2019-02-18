#!/bin/bash

# 获取当前年月日，根据时间匹配下大量访问请求
DATE_LOG=`env LANG=en_US.UTF-8 date '+%d/%b/%Y'`;

# 攻击的用于nginx访问日志过滤日志信息的关键字
FILLTER_404_URL="***";
# 被攻击的服务器nginx日志
LOG_FILE="***/logs/***_access.log"

# 剔除自己的服务器ip
EXCLUDE_IP1="***";
EXCLUDE_IP2="***";
EXCLUDE_IP3="***";
EXCLUDE_IP4="***";
EXCLUDE_IP5="***";
EXCLUDE_IP6="***";
EXCLUDE_IP7="***";
EXCLUDE_IP8="***";
EXCLUDE_IP9="***";

# 生成黑名单配置文件
LOCK_FILE="***/conf/vhost/lockip.conf";

# 重启nginx生效
RELOAD_COMMAD="***/sbin/nginx -s reload";

# 根据时间统计访问频次较高的ip
grep "${DATA_LOG}" "${LOG_FILE}" |grep -i -v -E "${EXCLUDE_IP1}|${EXCLUDE_IP2}|${EXCLUDE_IP3}|${EXCLUDE_IP4}|${EXCLUDE_IP5}|${EXCLUDE_IP6}|${EXCLUDE_IP7}|${EXCLUDE_IP8}" | awk '{print $1,$12}' | awk '{print $1}'|sort|uniq -c|sort -rn |awk '{if($1>1000)print "deny "$2";"}' >> "${LOCK_FILE}" 

# 根据被攻击的接口统计访问频次较高的ip
grep "${FILLTER_404_URL}" "${LOG_FILE}" |grep -i -v -E "${EXCLUDE_IP1}|${EXCLUDE_IP2}|${EXCLUDE_IP3}|${EXCLUDE_IP4}|${EXCLUDE_IP5}|${EXCLUDE_IP6}|${EXCLUDE_IP7}|${EXCLUDE_IP8}" | awk '{print $1,$12}' | awk '{print $1}'|sort|uniq -c|sort -rn |awk '{if($1>1000)print "deny "$2";"}' >> "${LOCK_FILE}"

# 重启nginx，目前注释，也可以打开，重启不影响访问
#`${RELOAD_COMMAD}`
