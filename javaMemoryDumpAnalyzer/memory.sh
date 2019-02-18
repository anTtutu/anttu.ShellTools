#! /bin/bash

#IBM的java heapdump图形分析工具，这个脚本是结合Xmanager一起使用，当办公电脑内存不够时可以借用服务器的内存，简单实现

#****更换成你的ip，启动内存可以调节，依赖java_home

export DISPLAY=****:0.0

java -Xmx8192M -jar jca457.jar
