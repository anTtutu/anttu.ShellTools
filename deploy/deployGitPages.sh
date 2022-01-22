#!/bin/bash

##########################################
# deployGitPages.sh
# deploy the git pages service script
# sed command in Mac, linux please delete the ""
# 2020-09-17
#########################################

# deploy github
function hugoDeployGithub()
{
    # delete baseURL #
    sed -i "" '/^#.*baseURL/s/^#//g' config.toml

    # modify config.yml   github\coding\gitee
    sed -i "" '2,3s/^/#/g' config.toml

    gitAndhugo "$1" $2
}

# deploy coding me
function hugoDeployCoding()
{
    # delete baseURL #
    sed -i "" '/^#.*baseURL/s/^#//g' config.toml

    # modify config.yml   github\coding\gitee
    sed -i "" '1,1s/^/#/g' config.toml
    sed -i "" '3,3s/^/#/g' config.toml

    gitAndhugo "$1" $2
}

# deploy gitee
function hugoDeployGitee()
{
    # delete baseURL #
    sed -i "" '/^#.*baseURL/s/^#//g' config.toml

    # modify config.yml   github\coding\gitee
    sed -i "" '1,2s/^/#/g' config.toml

    gitAndhugo "$1" $2
}

# git and hugo command
function gitAndhugo()
{
    # hugo and copy public to project
    hugo
    cp -r ./public/*  ../GitCode/$2/

    # git pull
    cd ../GitCode/$2/
    git pull

    # git add
    git add .

    # git commit and push
    git commit -m "$1"
    git push

    # back to hugo dir
    cd ../../hugo_blog/ 
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
    # 检验入参，需要增加提交注释
    if [ $# != 1 ]; then
        echo "please input commit message."
        exit 1;
    fi

    # 二次确认 
    checkYes

    # deploy github pages
    hugoDeployGithub "$1" "anTtutu.github.io"

    # deploy coding me pages
    hugoDeployCoding "$1" "anttu.coding.me"

    # deploy gitee pages
    hugoDeployGitee "$1" "anttu.gitee.io"
}

main $1