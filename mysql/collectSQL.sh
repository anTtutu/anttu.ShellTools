#! /bin/bash

# 待查询的文件名
FILE="0319.sql";

# insert tbl_order往下78行
INSERT_FILLTER="Write_rows: table id 29061 flags: STMT_END_F";
# update tbl_order往下155行
UPDATE_FILLTER="Update_rows: table id 29061 flags: STMT_END_F";

grep -n "${INSERT_FILLTER}" ${FILE} | awk -F":#" '{print $1}' > insert.log

grep -n "${UPDATE_FILLTER}" ${FILE} | awk -F":#" '{print $1}' > update.log

while read line
do
    next=$(($line+78))
    str="$line,$next""p"
    sed -n "$str" ${FILE} >> insert.sql
done < insert.log

while read line
do
    next2=$(($line+155))
    str2="$line,$next2""p"
    sed -n "$str2" ${FILE} >> update.sql
done < update.log
