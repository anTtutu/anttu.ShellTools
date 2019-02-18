#! /bin/bash -x

#################################################################
#                                                               #
#                      ***自动部署脚本                           #
#                                                               #
# 切换平台（pc、wap、app、mp）注意修改如下参数：节点名称和包名        #
# NODE1="***";                                                  #
# NODE2="***1";                                                 #
# PKG_WAR_NAME="***.war";                                       #
#                                                               #
# 执行示例                                                       #
# eg: ./auto_deploy.sh ***                                      #
#                                                               #
# author:hk                                                     # 
#                                                               #
# 抽时间补充下回退脚本   2019.02.18    便于观察开了debug            #
#                                                               #
#################################################################

# 节点名称变量  ***, ***1, all
NODE_NAME="$1";
# 全部节点操作
ALL="all";
# 节点1
NODE1="***";
# 节点2
NODE2="***1";
# 全部节点名称
ALL_NODE="${NODE1} ${NODE2}";


# Tomcat路径
TOMCAT_PATH="/***/tomcat";
# Tomcat webapps目录
TOMCAT_WEB="${TOMCAT_PATH}/${NODE_NAME}/webapps";
# Tomcat bin目录
TOMCAT_BIN="${TOMCAT_PATH}/${NODE_NAME}/bin";


# 原始包名
PKG_WAR_NAME="***.war";
# 程序包目录
PKG_HOME="${TOMCAT_PATH}/package";


# 获取当天日期
VAR_DATE=`date +%Y%m%d`
# 部署日志
DEPLOY_LOG="${PKG_HOME}/deploy.log";

# 线上包名称
PROJECT_NAME="ROOT";
# 工程目录
PROJECT_PKG="${TOMCAT_WEB}/${PROJECT_NAME}";
# 工程war包
PROJECT_WAR="${TOMCAT_WEB}/${PROJECT_NAME}.war";

# 备份目录
BACKUP_PATH="${TOMCAT_PATH}/backup/${VAR_DATE}";


# 检查
function checkPKG()
{
    #检验是否有新上传安装包
    if [ -d "${PKG_HOME}/${VAR_DATE}" ]; then
        echo "[`date -d today +"%Y-%m-%d %T"`] pkg path is exist, pkg path is:${PKG_HOME}/${VAR_DATE}" >> ${DEPLOY_LOG}
        if [ -f "${PKG_HOME}/${VAR_DATE}/${PKG_WAR_NAME}" ]; then
            echo "[`date -d today +"%Y-%m-%d %T"`] pkg war is exist, pkg war path is:${PKG_HOME}/${VAR_DATE}/${PKG_WAR_NAME}" >> ${DEPLOY_LOG}

            #下一步再校验下安装包的时间，增加校验门槛

        else
            echo "[`date -d today +"%Y-%m-%d %T"`] check pkg war error, pkg war is not exist." >> ${DEPLOY_LOG}
            exit 1;
        fi
    else
        echo "[`date -d today +"%Y-%m-%d %T"`] check pkg error, pkg path is not exist." >> ${DEPLOY_LOG}
        exit 1;
    fi
}

# 停止节点
function stopNode()
{
    # 查找tomcat进程，并kill进程
    if [ $1 = "${NODE1}" ]; then
        PID=`ps -ef | grep ${TOMCAT_PATH}/${NODE1} | egrep -v "grep|${NODE2}" | awk '{print $2}'`
    elif [ $1 = "${NODE2}" ]; then
        PID=`ps -ef | grep ${TOMCAT_PATH}/${NODE2} | grep -v "grep" | awk '{print $2}'`
    else
        echo "[`date -d today +"%Y-%m-%d %T"`] ERROR NODE NAME.$1" >> ${DEPLOY_LOG}    
    fi

    # 判断Tomcat是否已经停止，如果没停止，则执行kill命令杀掉进程
    if [ $1 = "${NODE1}" ] || [ $1 = "${NODE2}" ]; then
        if [ -n "${PID}" ]; then
            kill -9 ${PID}
            echo "[`date -d today +"%Y-%m-%d %T"`] Kill $1 - ${PID} Success." >> ${DEPLOY_LOG}
        else
            echo "[`date -d today +"%Y-%m-%d %T"`] Tomcat_$1 has Stopped." >> ${DEPLOY_LOG}
        fi
    else 
        echo "[`date -d today +"%Y-%m-%d %T"`] ERROR NODE NAME $1." >> ${DEPLOY_LOG}   
    fi
}

# 备份任意节点的war包和工程包，以节点1为例
function backupWar()
{
    # 备份目前正在运行的工程包，以当天日期进行命名
    if [ -d "${PROJECT_PKG}" ] && [ $1 = "${NODE2}" ]; then
        cd ${TOMCAT_WEB}
        tar -vczf ${PROJECT_NAME}_${VAR_DATE}.tar.gz ${PROJECT_NAME} ${PROJECT_NAME}.war
    else
        echo "[`date -d today +"%Y-%m-%d %T"`] ${TOMCAT_WEB}/${PROJECT_NAME} Not Found." >> ${DEPLOY_LOG}
        echo "[`date -d today +"%Y-%m-%d %T"`] Failed to deploy ${NODE2}." >> ${DEPLOY_LOG}
        exit 1;
    fi

    # 判断当前运行的工程是否备份成功
    if [ -f "${TOMCAT_WEB}/${PROJECT_NAME}_${VAR_DATE}.tar.gz" ] && [ $1 = "${NODE2}" ]; then
        echo "[`date -d today +"%Y-%m-%d %T"`] Backup ${PROJECT_NAME} Success." >> ${DEPLOY_LOG}

        if [ -d ${BACKUP_PATH} ]; then
            # 把备份包迁移到制定位置保存
            mv ${TOMCAT_WEB}/${PROJECT_NAME}_${VAR_DATE}.tar.gz  ${BACKUP_PATH}/${PROJECT_NAME}_${VAR_DATE}.tar.gz
        else
            mkdir -p ${BACKUP_PATH}    
            mv ${TOMCAT_WEB}/${PROJECT_NAME}_${VAR_DATE}.tar.gz  ${BACKUP_PATH}/${PROJECT_NAME}_${VAR_DATE}.tar.gz
        fi
    else
        echo "[`date -d today +"%Y-%m-%d %T"`] Backup ${PROJECT_NAME} Failed." >> ${DEPLOY_LOG}
        echo "[`date -d today +"%Y-%m-%d %T"`] Failed to deploy ${NODE2}." >> ${DEPLOY_LOG}
        exit 1;
    fi
}

# 部署节点
function deployNode()
{
    # 判断webapps目录下是否存在对应工程包，存在则删除工程包
    if [ $1 = "${NODE1}" ] || [ $1 = "${NODE2}" ]; then
        if [ -d "${PROJECT_PKG}" ]; then
            rm -rf ${PROJECT_PKG} 
            echo "[`date -d today +"%Y-%m-%d %T"`] Remove ${PROJECT_PKG} Success." >> ${DEPLOY_LOG}
        else
            echo "[`date -d today +"%Y-%m-%d %T"`] ${PROJECT_PKG} Not Found." >> ${DEPLOY_LOG}
        fi
    fi

    # 判断webapps目录下是否存在旧的工程war包，存在则删除旧的war包
    if [ $1 = "${NODE1}" ] || [ $1 = "${NODE2}" ]; then
        if [ -f "${PROJECT_WAR}" ]; then
            rm -rf ${PROJECT_WAR}
            echo "[`date -d today +"%Y-%m-%d %T"`] Remove ${PROJECT_WAR} Success." >> ${DEPLOY_LOG}
        else
            echo "[`date -d today +"%Y-%m-%d %T"`] ${PROJECT_WAR} Not Found." >> ${DEPLOY_LOG}
        fi
    fi    

    # 判断新的版本包是否存在，存在则拷贝到webapps目录下
    if [ $1 = "${NODE1}" ] || [ $1 = "${NODE2}" ]; then
        if [ -f "${PKG_HOME}/${VAR_DATE}/${PKG_WAR_NAME}" ]; then
            cp ${PKG_HOME}/${VAR_DATE}/${PKG_WAR_NAME} ${TOMCAT_WEB}/${PROJECT_NAME}.war
            echo "[`date -d today +"%Y-%m-%d %T"`] Copy ${PKG_HOME}/${VAR_DATE}/${PKG_WAR_NAME} to ${TOMCAT_WEB}/${PROJECT_NAME}.war Success." >> ${DEPLOY_LOG}
        else
            echo "[`date -d today +"%Y-%m-%d %T"`] ${PKG_HOME}/${VAR_DATE}/${PKG_WAR_NAME} Not Found." >> ${DEPLOY_LOG}
            echo "[`date -d today +"%Y-%m-%d %T"`] Failed to deploy $1." >> ${DEPLOY_LOG}
            exit 1;
        fi
    fi    
}

# 启动节点
function startNode()
{
    if [ $1 = "${NODE1}" ] || [ $1 = "${NODE2}" ]; then
        # 启动Tomcat服务
        echo "[`date -d today +"%Y-%m-%d %T"`] Startup Tomcat_$1..." >> ${DEPLOY_LOG}
        sh ${TOMCAT_BIN}/startup.sh >> ${DEPLOY_LOG}

        if [ $? = 0 ]; then
            echo "[`date -d today +"%Y-%m-%d %T"`] Start Tomcat_$1 Success." >> ${DEPLOY_LOG}
            echo "[`date -d today +"%Y-%m-%d %T"`] Success to deploy $1." >> ${DEPLOY_LOG}
        else
            echo "[`date -d today +"%Y-%m-%d %T"`] Start Tomcat_$1 Failed." >> ${DEPLOY_LOG}
            echo "[`date -d today +"%Y-%m-%d %T"`] Failed to deploy $1." >> ${DEPLOY_LOG}
            exit 1;
        fi
    fi    
}

# check parameters
function main()
{
    if [ $# != 1 ]; then
        echo "input parameter is null."
        exit 1;
    else
        if [ $1 != "${NODE1}" ] && [ $1 != "${NODE2}" ] && [ $1 != "${ALL}" ]; then
            echo "only three parameters: [${NODE1}]|[${NODE2}]|[${ALL}]"
            exit 1;
        else
            # 下一步，增加二次确认，生产环境防止误操作
	        confirm  	    
          
            if [ $1 = "${NODE1}" ] || [ $1 = "${NODE2}" ]; then
                NODE_NAME=$1

                echo "[`date -d today +"%Y-%m-%d %T"`] ============== Start to deploy ${NODE1} ==============" >> ${DEPLOY_LOG}
    
                # 检测是否有当天的待部署包 后续再补充上传日期
                checkPKG

                # 停止节点
                stopNode ${NODE_NAME}

                if [ ${NODE_NAME} = ${NODE2} ]; then
                    # 备份任一节点，比如node1
                    backupWar ${NODE_NAME}
                fi        

                # 部署新包
                deployNode ${NODE_NAME}

                # 启动节点
                startNode ${NODE_NAME}

                echo "[`date -d today +"%Y-%m-%d %T"`] ============== End to deploy ${NODE1} ==============" >> ${DEPLOY_LOG}
            elif [ $1 = "${ALL}" ]; then
                echo "[`date -d today +"%Y-%m-%d %T"`] ============== Start to deploy ${NODE1} ==============" >> ${DEPLOY_LOG}

                for i in "${ALL_NODE}"
                do
                    NODE_NAME=$i

                    # 检测是否有当天的待部署包 后续再补充上传日期
                    checkPKG

                    # 停止节点
                    stopNode ${NODE_NAME}

                    if [ ${NODE_NAME} = ${NODE2} ]; then
                        # 备份任一节点，比如node1
                        backupWar ${NODE_NAME}
                    fi

                    # 部署新包
                    deployNode ${NODE_NAME}

                    # 启动节点
                    startNode ${NODE_NAME}
                done

                echo "[`date -d today +"%Y-%m-%d %T"`] ============== End to deploy ${NODE1} ==============" >> ${DEPLOY_LOG}
            else
                echo "do you want to reload [${NODE1}]|[${NODE2}]|[${ALL}]"
                exit 1;
            fi
        fi
    fi
}

# 二次确认
function confirm()
{
		echo -n "are you sure to restart $1, please input y or Y :"
		read input
		
		if [ ${input} == "y" ] || [ ${input} == "Y" ]; then
			echo "begin to restart $1..."	
		else
		  echo "exit to this script. bye..."	
			exit 1
		fi
}

main $1
