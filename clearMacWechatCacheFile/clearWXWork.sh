#! /bin/bash

###########################################################
# please modify USER_DIR_PATH (1) value according to your macos 
###########################################################

# user cache dir
USER_DIR_PATH="1688850168325888 1688850739633530 1688851933982571 1688852913970578 2251802520709764";

# wechat install dir
WECHAT_DIR_PATH="/Users/$(whoami)/Library/Containers/com.tencent.WeWorkMac/Data/Library/Application Support/WXWork";

### 截图
# WXWork/Temp/ScreenCapture
# 企业微信截图_ffc74885-5750-4a1f-86e0-dd6c8eb5aadb.png

### 日志
# WXWork/Log
# 2020-09-05_09-26-35_102(3.0.12.2113)_encrypt.log

# WXWork/Log/MobileFramework
# 20200905_encrypt.log

### 图像
# WXWork/Data/1688851933982571/Avator/2020-09
# faf3f802e91e461a5cb8a48f287d56b5.jpg


### 接收的文件
# WXWork/Data/1688851933982571/Cache/File/2020-08
# 附件文件

### 接收的视频
# WXWork/Data/1688851933982571/Cache/Video/2020-08
# 视频文件

### 截图和接收的图片
# WXWork/Data/1688851933982571/Cache/Image/2020-08
# 企业微信截图_159673132876.jpg   企业微信截图_15967631089272.png  
# 企业微信截图_7b00f179-a064-44fa-bd7c-2160a4c63c96.jpg  企业微信截图_7f7486e4-1bf5-49fe-bf9a-0b9df0b310d4.png


# user tmp dir
USER_TEMP_DIR="Temp/ScreenCapture";

# user log dir
USER_LOG_DIR="Log";

# user Data dir
USER_DATA_DIR="Data";

# user cache dir
USER_CACHE_DIR="Cache";

#################### in Log
# log file
LOG_MOBILE_DIR="MobileFramework";

#################### in Data
# header img
DATA_IMG_DIR="Avator";
# header img
DATA_GIF_DIR="Emotion";

#################### in Cache
# big file or cache file
CACHE_FILE_DIR="File Image Video Voice";

function clear()
{
    if [ -d "${WECHAT_DIR_PATH}" ]; then
        cd "${WECHAT_DIR_PATH}"
        echo "into wxwork dir. ${WECHAT_DIR_PATH}"
    else
        echo "not install wxwork."
        exit 1;
    fi

    # delete tmp dir
    if [ -d ${USER_TEMP_DIR} ]; then
        echo "1 - delete ${USER_TEMP_DIR} begin"
        
         find ./${USER_TEMP_DIR} -type f -name "*企业微信截图*.*" | xargs rm -r '*'
        #find ./${USER_TEMP_DIR} -type f -name "*企业微信截图*.*"
        echo "1 - delete ${USER_TEMP_DIR} end"
    fi

    # delete log dir
    if [ -d ${USER_LOG_DIR} ]; then
        echo "2 - delete ${USER_LOG_DIR} begin"
        
        find ./${USER_LOG_DIR} -type f -name "*_encrypt.log" | xargs rm -r '*'
        #find ./${USER_LOG_DIR} -type f -name "*_encrypt.log"
        echo "2 - delete ${USER_LOG_DIR} end"

        if [ -d ${USER_LOG_DIR}/${LOG_MOBILE_DIR} ]; then
            echo "2.1 - delete ${USER_LOG_DIR}/${LOG_MOBILE_DIR} begin"
            
            find ./${USER_LOG_DIR}/${LOG_MOBILE_DIR} -type f -name "*_encrypt.log" | xargs rm -r '*'
            #find ./${USER_LOG_DIR}/${LOG_MOBILE_DIR} -type f -name "*_encrypt.log"
            echo "2.1 - delete ${USER_LOG_DIR}/${LOG_MOBILE_DIR} end"
        fi
    fi

    # delete data dir 
    if [ -d ${USER_DATA_DIR} ]; then
        echo "3 - delete ${USER_DATA_DIR} begin"

        for j in ${USER_DIR_PATH}
        do
            echo "wait to delete cache dir name : ${j}"
            if [ -d ${USER_DATA_DIR}/${j} ]; then
                echo "into ${j}"
            else
                echo "not exist ${j}"
                return     
            fi
            echo "${USER_DATA_DIR}/${j}"

            # Avator dir
            if [ -d ${USER_DATA_DIR}/${j}/${DATA_IMG_DIR} ]; then
                echo "3.1 - delete ${USER_DATA_DIR}/${j}/${DATA_IMG_DIR} begin"    
                
                find ./${USER_DATA_DIR}/${j}/${DATA_IMG_DIR} -type d -name "202*" | xargs rm -r '*'
                #find ./${USER_DATA_DIR}/${j}/${DATA_IMG_DIR} -type d -name "202*"
                find ./${USER_DATA_DIR}/${j}/${DATA_IMG_DIR}/Temp -type f -name "*" | xargs rm -r '*'
                echo "3.1 - delete ${USER_DATA_DIR}/${j}/${DATA_IMG_DIR} end"
            fi

            # Emotion dir
            if [ -d ${USER_DATA_DIR}/${j}/${DATA_GIF_DIR} ]; then
                echo "3.2 - delete ${USER_DATA_DIR}/${j}/${DATA_GIF_DIR} begin"    
                
                find ./${USER_DATA_DIR}/${j}/${DATA_GIF_DIR} -type d -name "202*" | xargs rm -r '*'
                #find ./${USER_DATA_DIR}/${j}/${DATA_GIF_DIR} -type d -name "202*"
                find ./${USER_DATA_DIR}/${j}/${DATA_GIF_DIR}/Temp -type f -name "*" | xargs rm -r '*'
                echo "3.2 - delete ${USER_DATA_DIR}/${j}/${DATA_GIF_DIR} end"
            fi

            # Cache dir
            for i in ${CACHE_FILE_DIR}
            do
                echo "${USER_DATA_DIR}/${j}/${USER_CACHE_DIR}/${i}"
                if [ -d ${USER_DATA_DIR}/${j}/${USER_CACHE_DIR}/${i} ]; then
                    echo "3.3 - delete ${USER_DATA_DIR}/${j}/${USER_CACHE_DIR}/${i} begin"
                    
                    find ./${USER_DATA_DIR}/${j}/${USER_CACHE_DIR}/${i} -type d -name "202*" | xargs rm -r '*'
                    #find ./${USER_DATA_DIR}/${j}/${USER_CACHE_DIR}/${i} -type d -name "202*"
                    find ./${USER_DATA_DIR}/${j}/${USER_CACHE_DIR}/${i}/Temp -type f -name "*" | xargs rm -r '*'
                    echo "3.3 - delete ${USER_DATA_DIR}/${j}/${USER_CACHE_DIR}/${i} end"
                fi
            done
        done

        echo "3 - delete ${USER_DATA_DIR} end"
    fi

    # return wxwork install dir
    cd "${WECHAT_DIR_PATH}"
}

# 二次确认
function checkYes()
{
		echo -n "are you sure to delete wxwork cache file, please input y or Y :"
		read input
		
		if [ ${input} == "y" ] || [ ${input} == "Y" ]; then
			echo "begin to delete..."	
		else
		    echo "exit to this script. bye..."	
		    exit 1
		fi
}

function main()
{
    checkYes

    clear

    if [ $? = 0 ]; then
        echo "end to delete..." 
    fi
}

# mian
main