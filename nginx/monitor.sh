#!/bin/bash

# 提取高频ip脚本

if [[ $# -lt 1 ]]; then
	echo "Usage: monitor.sh <logFile>"
	exit 1
fi

logFile=$1
IPListFile=`pwd`/ipList.log
if [[ ! -f $IPListFile ]]; then
	echo > $IPListFile
fi

sourceFile="/***/***_access.log"
distFile="/***/conf/vhost/lockip.conf"

ipList=`tail -1000 $sourceFile | awk '{print $1 " " $9}' | sort | uniq -c| sort -nr | awk '{if($1>60) print $2}'`

for ip in $ipList; do
	# 检查IP是否已经记录在文件中，若已经存在，则不需要重复添加
	checkFlag=`cat $IPListFile | grep $ip`
	echo $ip
	echo $checkFlag
	if [[ $checkFlag == "" ]]; then
		# 将该IP保存到文件中
		echo $ip >> $IPListFile

		if [[ ! -f $distFile ]]; then
			echo "123"
			# echo > $distFile
		fi
		# echo "deny $ip;" >> $distFile
	fi
done
