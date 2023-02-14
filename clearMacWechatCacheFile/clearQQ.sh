#! /bin/bash

###########################################################
# please modify USER_DIR_PATH (1) value according to your macos 
###########################################################

# /Users/${whoami}/Library/Containers/com.tencent.qq/Data/Library/Application Support/QQ/{QQ_NUM}

# user cache dir  please modift your QQ_NUM
USER_DIR_PATH="QQ_NUM";

# qq install dir
WECHAT_DIR_PATH="/Users/$(whoami)/Library/Containers/com.tencent.qq/Data";

# user cache dir
USER_CACHE_DIR="Library/Caches";

# user message dir
USER_MESSAGE_DIR="Documents/contents";

#################### in Cache
# big file or cache file
CACHE_FILE_DIR="Avatar Images Videos";

#QQ.db
#QQ.db-shm
#QQ.db-wal

#Cache1.1.db
#Cache1.1.db-shm
#Cache1.1.db-wal

function clear()
{
    if [ -d "${WECHAT_DIR_PATH}" ]; then
        cd "${WECHAT_DIR_PATH}"
        echo "into qq dir. ${WECHAT_DIR_PATH}"
    else
        echo "not install qq."
        exit 1;
    fi

    if [ -d ${USER_CACHE_DIR} ]; then
        echo "1 - delete ${USER_CACHE_DIR} begin"

        for j in ${CACHE_FILE_DIR}
        do
            echo "${USER_CACHE_DIR}/${j}"

            find ./${USER_CACHE_DIR}/${j} -type f -name "*" | xargs rm -r '*'
        done

        echo "1 - delete ${USER_CACHE_DIR} end"
    fi

    # return wechat install dir
    cd "${WECHAT_DIR_PATH}"
}

# 二次确认
function checkYes()
{
		echo -n "are you sure to delete QQ cache file, please input y or Y :"
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