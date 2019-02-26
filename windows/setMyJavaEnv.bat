@echo off

echo **********************************************
echo.
echo        一键安装jdk并配置环境变量(默认64位)
echo.
echo 1、安装jdk
echo 2、设置jdk环境变量和classpath环境变量
echo 3、设置maven环境变量
echo 4、设置tomcat环境变量
echo 5、设置xmlbeans环境变量
echo 6、设置axis2环境变量
echo 7、设置ant环境变量
echo.
echo **********************************************

rem 样例参考：换行方便观看
rem %JAVA_HOME%\bin;
rem %JAVA_HOME%\jre\bin;
rem %MAVEN_HOME%\bin;
rem %PYTHON_HOME%\;
rem %PYTHON_HOME%\Scripts;
rem C:\Program Files (x86)\Common Files\Oracle\Java\javapath;
rem %SystemRoot%\system32;
rem %SystemRoot%;
rem %SystemRoot%\System32\Wbem;
rem %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;
rem %SYSTEMROOT%\System32\OpenSSH\;
rem E:\Program Files (x86)\TortoiseSVN\bin;
rem E:\Program Files (x86)\TortoiseGit\bin;
rem %GIT_HOME%\bin;
rem %GO_HOME%\bin;
rem %NODE_HOME%\;
rem %AXIS2_HOME%\bin;
rem %XML_BEANS_HOME%\bin;
rem %TOMCAT_HOME%\bin;
rem %ANT_HOME%\bin;
rem E:\Program Files (x86)\Microsoft VS Code Insiders\bin;
rem C:\Program Files\SourceGear\Common\DiffMerge\

rem 定义环境变量的安装目录
set JAVA_HOME=E:\JAVA_HOME\jdk1.8
set MAVEN_HOME=E:\Dev\apache-maven-3.0.4
set TOMCAT_HOME=E:\Dev\apache-tomcat-7.0.53
set XMLBEANS_HOME=E:\XMLBEANS_HOME\xmlbeans-2.6.0
set AXIS2_HOME=E:\AXIS2_HOME\axis2-1.6.4
rem 旧项目打包的，也可以不要，个人习惯先加上
set ANT_HOME=E:\ANT_HOME\apache-ant-1.9.6

rem 获取操作系统版本和位数
set OsVersion=0
set OsProcessor=0

echo 操作系统版本:
ver|findstr /r /i " [版本 5.1.*]" > NUL && goto WindowsXP
ver|findstr /r /i " [版本 6.1.*]" > NUL && goto Windows7
ver|findstr /r /i " [版本 10.0.*]" > NUL && goto Windows10
goto UnknownVersion
 
:WindowsXP
set OsVersion="WindowsXP"
goto GetProcessor
 
:Windows7
set OsVersion="Windows7"
goto GetProcessor

:Windows10
set OsVersion="Windows10"
goto GetProcessor
 
:UnknownVersion
set OsVersion="UnknownVersion"
goto GetProcessor
 
:GetProcessor
echo 获取操作系统位数:
if "%PROCESSOR_ARCHITECTURE%"=="x86" ( 
set OsProcessor="x86"
) 
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( 
set OsProcessor="x64"
) else (
set OsProcessor="UnknownProcessor"
)

echo %OsVersion% %OsProcessor%
 
echo.
echo 1.正在安装jdk，请不要执行其他操作
echo.
echo 请稍等，这大约需要几分钟
echo.

rem 获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit

rem 安装JDK1.8
start /WAIT jdk-8u181-windows-x64.exe /qn INSTALLDIR=E:\JAVA_HOME\jdk1.8
echo JDK1.8安装完毕

echo 2.正在设置JAVA环境变量
echo.

rem 如果有的话，先删除JAVA_HOME、CLASSPATH、MAVEN_HOME、TOMCAT_HOME、XMLBEANS_HOME、AXIS2_HOME、ANT_HOME
wmic ENVIRONMENT where "name='JAVA_HOME'" delete
wmic ENVIRONMENT where "name='CLASSPATH'" delete
wmic ENVIRONMENT where "name='MAVEN_HOME'" delete
wmic ENVIRONMENT where "name='TOMCAT_HOME'" delete
wmic ENVIRONMENT where "name='XMLBEANS_HOME'" delete
wmic ENVIRONMENT where "name='AXIS2_HOME'" delete
wmic ENVIRONMENT where "name='ANT_HOME'" delete

set PATH=%%JAVA_HOME%%\bin;%%JAVA_HOME%%\jre\bin;%PATH%
set CLASSPATH=.;%%JAVA_HOME%%\lib\dt.jar;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\jre\lib

rem 设置环境变量
set RegV=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
 
reg add "%RegV%" /v "JAVA_HOME" /d "%JAVA_HOME%" /f
reg add "%RegV%" /v "Path" /t REG_EXPAND_SZ /d "%PATH%" /f
reg add "%RegV%" /v "CLASSPATH" /d "%CLASSPATH%" /f
echo JDK环境变量设置成功 

taskkill /im explorer.exe /f
echo ================================================
echo 下面开始重启“explorer.exe”进程
pause
start explorer.exe

echo 安装完毕，测试下看看
echo.
call java -version
echo.

If %Errorlevel% == 0 (
    echo JDK测试安装成功
    echo.
) else (
    echo JDK貌似安装不成功，您得自己想想办法检查下
    echo.
)

echo 3.设置maven环境变量
echo.
set PATH=%%MAVEN_HOME%%\bin;%PATH%
reg add "%RegV%" /v "MAVEN_HOME" /d "%MAVEN_HOME%" /f
reg add "%RegV%" /v "Path" /t REG_EXPAND_SZ /d "%PATH%" /f
echo maven环境变量设置完毕

taskkill /im explorer.exe /f
echo ================================================
echo 下面开始重启“explorer.exe”进程
pause
start explorer.exe

echo 安装完毕，测试下看看
echo.
call mvn -version
echo.

If %Errorlevel% == 0 (
    echo maven测试安装成功
    echo.
) else (
    echo maven貌似安装不成功，您得自己想想办法检查下
    echo.
)

echo 4.设置tomcat环境变量
echo.
set PATH=%%TOMCAT_HOME%%\bin;%PATH%
reg add "%RegV%" /v "TOMCAT_HOME" /d "%TOMCAT_HOME%" /f
reg add "%RegV%" /v "Path" /t REG_EXPAND_SZ /d "%PATH%" /f
echo tomcat环境变量设置完毕

taskkill /im explorer.exe /f
echo ================================================
echo 下面开始重启“explorer.exe”进程
pause
start explorer.exe

echo 安装完毕，测试下看看
echo.
call version
echo.

If %Errorlevel% == 0 (
    echo tomcat测试安装成功
    echo.
) else (
    echo tomcat貌似安装不成功，您得自己想想办法检查下
    echo.
)

echo 5.设置xmlbeans环境变量
echo.
set PATH=%%XMLBEANS_HOME%%\bin;%PATH%
reg add "%RegV%" /v "XMLBEANS_HOME" /d "%XMLBEANS_HOME%" /f
reg add "%RegV%" /v "Path" /t REG_EXPAND_SZ /d "%PATH%" /f
echo xmlbeans环境变量设置完毕

taskkill /im explorer.exe /f
echo ================================================
echo 下面开始重启“explorer.exe”进程
pause
start explorer.exe

echo 安装完毕，测试下看看
echo.
call scomp -version
echo.

If %Errorlevel% == 0 (
    echo xmlbeans测试安装成功
    echo.
) else (
    echo xmlbeans貌似安装不成功，您得自己想想办法检查下
    echo.
)

echo 6.设置axis2环境变量
echo.
set PATH=%%AXIS2_HOME%%\bin;%PATH%
reg add "%RegV%" /v "AXIS2_HOME" /d "%AXIS2_HOME%" /f
reg add "%RegV%" /v "Path" /t REG_EXPAND_SZ /d "%PATH%" /f
echo axis2环境变量设置完毕

taskkill /im explorer.exe /f
echo ================================================
echo 下面开始重启“explorer.exe”进程
pause
start explorer.exe

echo 安装完毕，测试下看看
echo.
call axis2 -version
echo.

If %Errorlevel% == 0 (
    echo axis2测试安装成功
    echo.
) else (
    echo axis2貌似安装不成功，您得自己想想办法检查下
    echo.
)

echo 7.设置ant环境变量
echo.
set PATH=%%ANT_HOME%%\bin;%PATH%
reg add "%RegV%" /v "ANT_HOME" /d "%ANT_HOME%" /f
reg add "%RegV%" /v "Path" /t REG_EXPAND_SZ /d "%PATH%" /f
echo ant环境变量设置完毕

taskkill /im explorer.exe /f
echo ================================================
echo 下面开始重启“explorer.exe”进程
pause
start explorer.exe

echo 安装完毕，测试下看看
echo.
call ant -version
echo.

If %Errorlevel% == 0 (
    echo ant测试安装成功
    echo.
) else (
    echo ant貌似安装不成功，您得自己想想办法检查下
    echo.
)

mshta vbscript:msgbox("环境已成功注册！",64,"成功")(window.close)

exit