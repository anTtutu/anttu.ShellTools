#! /bin/bash

###########################################################
# please modify USER_DIR_PATH (1) and WECHAT_VERSION (3) value according to your macos 
###########################################################

# user cache dir
USER_DIR_PATH="f7e089c5b7a947410e0a7b1fc4990c7c d41d8cd98f00b204e9800998ecf8427e";

# wechat install dir
WECHAT_DIR_PATH="/Users/$(whoami)/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat";

# version
WECHAT_VERSION="2.0b4.0.9";

# user pic
USER_PIC_DIR="Avatar";

# user cache dir
USER_CACHE_DIR="Stickers";

# user message dir
USER_MESSAGE_DIR="Message";

#################### in Stickers
# big file or cache file
CACHE_FILE_DIR="Download File";

#################### in Message
# temp file
MESSAGE_FILE_DIR="MessageTemp";

function clear()
{
    if [ -d "${WECHAT_DIR_PATH}/${WECHAT_VERSION}" ]; then
        cd "${WECHAT_DIR_PATH}/${WECHAT_VERSION}"
        echo "into wechat dir. ${WECHAT_DIR_PATH}/${WECHAT_VERSION}"
    else
        echo "not install wechat."
        exit 1;
    fi

    for i in ${USER_DIR_PATH}
    do
        echo "wait to delete cache dir name : ${i}"
        if [ -d ${i} ]; then
            echo "into ${i}"
        else
            echo "not exist ${i}"
            return     
        fi

        # into cache dir
        cd ${i}
        if [ -d ${USER_PIC_DIR} ]; then
            echo "1 - delete ${USER_PIC_DIR} begin"
            
            find ./${USER_PIC_DIR} -type f -name "*" | xargs rm -r '*'
            
            echo "1 - delete ${USER_PIC_DIR} end"
        fi

        if [ -d ${USER_MESSAGE_DIR}/${MESSAGE_FILE_DIR} ]; then
            echo "2 - delete ${USER_MESSAGE_DIR}/${MESSAGE_FILE_DIR} begin"

            find ./${USER_MESSAGE_DIR}/${MESSAGE_FILE_DIR} -type f -name "*" | xargs rm -r '*'
            
            echo "2 - delete ${USER_MESSAGE_DIR}/${MESSAGE_FILE_DIR} end"
        fi

        if [ -d ${USER_CACHE_DIR} ]; then
            echo "3 - delete ${USER_CACHE_DIR} begin"

            for j in ${CACHE_FILE_DIR}
            do
                echo "${USER_CACHE_DIR}/${j}"

                find ./${USER_CACHE_DIR}/${j} -type f -name "*" | xargs rm -r '*'
            done

            echo "3 - delete ${USER_CACHE_DIR} end"
        fi

        # return wechat install dir
        cd "${WECHAT_DIR_PATH}/${WECHAT_VERSION}"
    done 	
}

# 二次确认
function checkYes()
{
		echo -n "are you sure to delete wechat cache file, please input y or Y :"
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
