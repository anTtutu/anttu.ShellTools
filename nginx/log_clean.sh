#/bin/bash
logpath=/***/logs
function Print_TimeNow()
{
TIME=`date +%Y-%m-%d:%H:%M:%S | grep -v mail`
echo $TIME
}

echo '--------start-------'
Print_TimeNow
OLD=`date -d last-day +%Y%m%d | grep -v mail`
#rm -rf $logpath/app_access.log
#rm -rf $logpath/m_access.log
#rm -rf $logpath/res_access.log
#rm -rf $logpath/res0_access.log
#rm -rfmv $logpath/www_access.log
cat $logpath/nginx.pid |xargs kill -USR1
echo '--------end-------'
Print_TimeNow
