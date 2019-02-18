#/bin/bash

# 05 0 * * * /***/log_backup.sh >> /***/logs/backup.log 2>&1

logpath=/***/logs
function Print_TimeNow()
{
TIME=`date +%Y-%m-%d:%H:%M:%S | grep -v mail`
echo $TIME
}

echo '--------start-------'
Print_TimeNow
OLD=`date -d last-day +%Y%m%d | grep -v mail`
mv $logpath/app_access.log /data/nginx_log_bak/app_$OLD.log
mv $logpath/m_access.log /data/nginx_log_bak/wap_$OLD.log
mv $logpath/res_access.log /data/nginx_log_bak/res_$OLD.log
mv $logpath/mp_access.log /data/nginx_log_bak/mp_$OLD.log
mv $logpath/www_access.log /data/nginx_log_bak/www_$OLD.log
cat $logpath/nginx.pid |xargs kill -USR1
echo '--------end-------'
Print_TimeNow
