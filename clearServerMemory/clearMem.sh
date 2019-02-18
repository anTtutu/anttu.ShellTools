#!/bin/sh

# crontab */30 * * * * /***/clearMem.sh /***

if [ $# -lt 1 ]
then
    echo "Usage:clearMem.sh <LogPath>"
    exit 1
fi
logPath=$1
logFile="clearMem.log"

freeMem=`free -m | awk 'NR==2' | awk '{print $4}'`

echo `date '+%Y-%m-%d %H:%M:%S'` >> $logPath/$logFile
echo "************ begin to run the clean shell ***********" >> $logPath/$logFile

if [ $freeMem -lt 500 ]
then
    echo "`date '+%Y-%m-%d %H:%M:%S'` start to clean cache memory....." >> $logPath/$logFile
    sync && echo 1 > /proc/sys/vm/drop_caches
    sync && echo 2 > /proc/sys/vm/drop_caches
    sync && echo 3 > /proc/sys/vm/drop_caches
    echo "`date '+%Y-%m-%d %H:%M:%S'` end to clean cache memory....." >> $logPath/$logFile
fi

echo "************ end to run the clean shell ***********" >> $logPath/$logFile
echo `date '+%Y-%m-%d %H:%M:%S'` >> $logPath/$logFile
