#!/bin/bash 
processList=$(cat $1)
for process in $processList; do
	processGroup=$(ps x -o  "%p %r %y %x %c " |grep $process |awk '{print $2}')
	if [[ ! -z $processGroup ]];then
		kill -TERM -- -$processGroup
		break
	fi
done
