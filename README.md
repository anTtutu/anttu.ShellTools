# anttu.ShellTools
个人工作碰到的脚本，出于懒就整理成了脚本方便操作，感觉还是有搜集下的必要。

已经替换工作中的敏感信息和目录

# batchRenameFileSuffix
脚本名称|说明
|-|-|
batchRenameFileSuffix.sh|批量修改文件名后缀，同一个目录下的同一个格式的后缀修改成另外一个后缀，来源是因为百度网盘里面有些文件把后缀批量修改成了另外一种格式，下载后需要还原使用

# clearServerMemory
脚本名称|说明
|-|-|
clearMemory.sh|清理linux服务器cache内存不释放

# clearWechatMacCacheFile
脚本名称|说明
|-|-|
clearWechat.sh|清理mac版本微信的缓存文件<br>Avatar-好友图像缓存<br>Stickers-表情包附件缓存<br>Message-Downlad File 群视频、文件、附件等缓存  
clearQQ.sh|清理mac版本QQ的缓存文件<br>Avator-图像缓存<br>Images-图片、表情包等<br>Videos-视频等  
clearWXWork.sh|清理mac版本企业微信的缓存文件<br>Avator-图像缓存<br>File-附件缓存文件<br>Image-图片等缓存<br>Video-视频等缓存<br>Voice-语音缓存<br>ScreenCapture-截图，自己或者别人发的截图等<br>Log-日志

# cloud_daily_check
脚本名称|说明
|-|-|
dailyCheck.sh|搜集网络上的阿里云巡检脚本，比较细致，有参考价值

# docker
脚本名称|说明
-|-
elasticsearch|es配置
etcd|etcd配置
kafka|kafka配置
minio|minio配置
mongodb|mongodb配置
mysql|mysql配置
nginx|nginx配置
redis|redis配置
zookeeper|zk配置
shell|docker容器脚本
├── demo.sh|demo脚本|
├── docker-es-8.0.0-run.sh|es启动脚本
├── docker-etcd-latest-run.sh|etcd启动脚本
├── docker-getting-started-laster-run.sh|docker官方示例脚本
├── docker-go-demo-v1.0-run.sh|docker官方go demo脚本
├── docker-inspect-port.sh|docker容器信息查看
├── docker-java-demo-v1.0-run.sh|docker官方java demo脚本
├── docker-minio-latest-run.sh|minio启动脚本
├── docker-mongo-6.0-run.sh|mongo启动脚本
├── docker-mysql-8.0-run.sh|mysql启动脚本
├── docker-nginx-1.22.0-run.sh|nginx启动脚本
├── docker-nodejs-demo-v1.0-run.sh|docker官方nodejs demo脚本
├── docker-nsenter-run.sh|docker mac的虚拟容器脚本
├── docker-python-demo-v1.0-run.sh|docker官方python demo脚本
├── docker-redis-7.0-run.sh|redis启动脚本
├── docker-show-repo-tag.sh|查看镜像版本脚本
├── docker-start-container.sh|docker启动某容器脚本
└── docker-stop-container.sh|docker停止某容器脚本

# deploy
脚本名称|说明
|-|-|
auto_deploy.sh|部署war包脚本
deployGitPages.sh|部署gitpages静态blog的脚本，github.io,gitee.io,coding.me

# go
脚本名称|说明
|-|-|
golanginstall.sh|安装golang.org/x包的脚本

# itunes  
脚本名称|说明
|-|-|
deleteiTunes.sh|手工删除iTunes的脚本
itunesDeleteInstall.scpt|卸载系统自带的itunes并安装12.6.5版本itunes，需要提前下载itunes12.6.5  
modifyiTunesVersion.scpt|修改itunes版本号12.6.5，因为有逻辑检测12.6.5无法在高版本macos运行  

# javaMemoryDumpAnalyzer
脚本名称|说明
|-|-|
memory.sh|IBM java heapdump分析工具

# kafka
脚本名称|说明
|-|-|
kafka_dev_env_delete_log_restart.sh|开发环境，因kafka数据量较大每周清理下

# linux
脚本名称|说明
|-|-|
exp.sh|远程ssh批量管理脚本
curl_post.sh|linux下测试post请求，入参和出参都是json结构，需要安装下yum install jq,input_post.json是入参json样例
monitor.sh|linux下的资源监控脚本，并通过接口发送，供内部使用

# mysql
脚本名称|说明
|-|-|
backupDesignerPlatformMysql.sh|定期备份和手工恢复指定表的脚本
collectSQL.sh|搜集解析后的mysql binlog日志中的某张表的语句信息

# nginx
脚本名称|说明
|-|-|
lockip.sh|抓取cc攻击接口或者高频访问的ip  
log_backup.sh|日志备份工具，每天备份一次
log_clean.sh|每天生成一分nginx日志，类似滚动日志
monitor.sh|根据nginx access日志提取cc攻击高频次访问接口ip
nginx.sh|nginx启、停、重启操作的脚本

# windows
脚本名称|说明
|-|-|
setMyJavaEnv.bat|设置新电脑java开发需要的一些环境变量-个人的