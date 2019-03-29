#!/usr/bin/expect
set ipaddr [lindex $argv 0]
set username [lindex $argv 1]
set userpasswd [lindex $argv 2]
set rootpasswd [lindex $argv 3]
set timeout 10
spawn ssh $username@$ipaddr
expect {
 "yes/no" {send "$userpaddwd\r";exp_continue}
 "*password*" {send "$userpasswd\r";exp_cotinue}
 "*from*" {send "su - root\r"}
}
expect "Password"
send "$rootpasswd\r"
expect "*]#"
send "chmod 777 /tmp/checklinux.sh\r"
send "sh /tmp/checklinux.sh\r"
send "exit\r"
send "exit\r"
interact