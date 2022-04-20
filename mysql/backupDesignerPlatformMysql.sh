#! /bin/bash

##########################################################
# 备份表
# code_history code_history_details mybatis_xml_history
# >>>>>>>>>>>注意账号信息安全<<<<<<<<<<<<
# Author: Anttu
# Date: 2021-12-30
#
# 配置crontab 每周日3点执行
# 0 3 * * 0
##########################################################

# 数据库信息
DESIGNER_MYSQL_URL="***.mysql.rds.aliyuncs.com"
DESIGNER_MYSQL_PORT="3306"
DESIGNER_MYSQL_USER="test"
DESIGNER_MYSQL_PWD="***"

# 数据库带全路径的命令
MYSQL_COMMAND="mysql"
MYSQL_DUMP_COMMAND="mysqldump"
MYSQL_IMPORT_COMMAND="mysqlimport"

# database name
DESIGNER_DATABASE_INSTANCE="designer-platform"

# 备份的表
BACKUP_TABLE[0]="code_history"
BACKUP_TABLE[1]="code_history_details"
BACKUP_TABLE[2]="mybatis_xml_history"

# 备份的文件名后缀
BACKUP_FILE_SUFFIX=".sql.gz"

# 备份的目录
BACKUP_DIR="/data/designer_platform_backup"

# 备份文件存放的次数
BACKUP_DAYS=28
OLD_BACKUP_DATE=$(date -d "${BACKUP_DAYS} days ago" +%Y-%m-%d | grep -v mail)

# 年月日时间戳
BACKUP_DATE=$(date +%Y-%m-%d | grep -v mail)

# log dir
LOG_PATH="/data/designer_platform_backup/logs"
LOG_FILE="designer_platform_backup.log"

######################################################
# mysqldump -h 192.168.1.100 -p 3306 -uroot -ppassword --database cmdb > /data/backup/cmdb.sql
# mysqldump -uroot -proot --databases db1 --tables a1 a2  > /tmp/db1.sql
# mysqlimport -h192.168.88.131 -umhauser -p888888 hellodb --local -C --fields-terminated-by='|' '/tmp/students1.sql'--columns='Name,ClassID,Gender'
######################################################

# 记录日志
function log()
{
    type=$1
    msg=$2
    logTime=$(date +%Y-%m-%d:%H:%M:%S | grep -v mail)

    if [ ! -d "${LOG_PATH}" ]; then
        mkdir -p ${LOG_PATH}
    fi

    echo "${logTime}-[${type}]-${msg}" >> "${LOG_PATH}/${LOG_FILE}"
}

# 备份
function backup()
{
    table=$1
    filePath="${BACKUP_DIR}/${BACKUP_DATE}"
    fileName="${table}${BACKUP_FILE_SUFFIX}"
    if [ ! -d "${filePath}" ]; then
        mkdir -p "${filePath}"
    fi
    if [ -f "${filePath}/${fileName}" ]; then
        rm -f "${filePath}/${fileName}"
    fi

    log "backup" "begin to backup ${table}, backup path[${filePath}], backup file[${fileName}]"

    "${MYSQL_DUMP_COMMAND}" -h "${DESIGNER_MYSQL_URL}" -P ${DESIGNER_MYSQL_PORT} -u${DESIGNER_MYSQL_USER} -p${DESIGNER_MYSQL_PWD} --database "${DESIGNER_DATABASE_INSTANCE}" --tables "${table}" | gzip > "${filePath}/${fileName}"

    log "backup" "end to backup ${table}, backup path[${filePath}], backup file[${fileName}]"
}

# 清理历史备份，只保留28天，也就是4次备份
function clean()
{
    table=$1
    filePath="${BACKUP_DIR}/${OLD_BACKUP_DATE}"
    fileName="${table}${BACKUP_FILE_SUFFIX}"

    log "clean" "begin to clean old backup..."
    cd ${BACKUP_DIR}
    find ./ -type d -mtime +28 | grep "-" | awk -F"./" '{print $2}' -exec rm -r {} \;
    log "clean" "end to clean old backup"
}

# 恢复, 万一恢复备用的函数
# 恢复有局限性，假如压缩文件结果后很大，可能因 my.cnf 的参数限制max_allowed_packet无法一次性导入完成
function restoreMysql()
{
    restoreDate=$1
    table=$2
    filePath="${BACKUP_DIR}/${restoreDate}"
    fileName="${table}${BACKUP_FILE_SUFFIX}"
    if [ "${restoreDate}" == "" ]; then
        echo "restore Date is null, egg: backupDesignerPlatformMysql.sh restore YYYYMMDD[20211230]"
        exit 1;
    fi
    log "restore" "begin to restore table..."
    if [ -f "${filePath}/${fileName}" ]; then
        cd "${filePath}"
        gunzip "${fileName}"
        "${MYSQL_IMPORT_COMMAND}" -h "${DESIGNER_MYSQL_URL}" -P ${DESIGNER_MYSQL_PORT} -u${DESIGNER_MYSQL_USER} -p${DESIGNER_MYSQL_PWD} "${DESIGNER_DATABASE_INSTANCE}" -local "${table}.sql"
        log "restore" "restore table[${table}], restore Date[${restoreDate}]"
    else
        log "restore" "file is not exist, file[${filePath}]"
    fi
    log "restore" "end to restore table"
}

# main
function main()
{
    if [ $# -eq 0 ]; then
        log "main" "************************* begin to backup designer platform db ... *************************"
        for table in "${BACKUP_TABLE[@]}"
        do
            # 备份
            backup "${table}"
            # 清理历史
            clean "${table}"
        done
        log "main" "************************* end to backup designer platform db *************************"
    elif [ $# -eq 2 ]; then
        if [ "$1" == "restore" ]; then
           for table in "${BACKUP_TABLE[@]}"
            do
                # 恢复
                restoreMysql "$2" "${table}"
            done
        fi
    else
        echo "Error Parameter, egg: backup->backupDesignerPlatformMysql.sh | retore->backupDesignerPlatformMysql.sh restore YYYYMMDD[20211230]"
        log "main" "ERROR Parameter[$1]. exit..."
        exit 1
    fi
}

main $1 $2