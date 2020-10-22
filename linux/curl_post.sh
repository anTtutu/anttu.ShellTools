#!/bin/bash

input=`awk '{printf("%s",$0)}' ./input_post.json | sed 's/ //g'`
output=`curl -H "Content-Type: application/json" -X POST -d "${input}" http://IP:PORT/$1`

if [ -f .output.json ]; then
   rm .output.json
fi
echo ${output} > .output.json
cat .output.json | jq .
