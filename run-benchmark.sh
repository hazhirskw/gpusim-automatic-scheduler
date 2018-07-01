#!/bin/bash
benchmarkDir=$1
runFile="run"
config="GTX480"
resultDir=~/workspace/result
if [[ -z "$benchmarkDir" ]]
then
        echo Error: Two few arguments!
        exit 1
fi

if [ ! -d "$resultDir" ]; then
	echo Error! Result directory deos not exist!
	exit 1
fi

if [ ! -d "$resultDir/$config" ]; then
#	echo Error! Directory for this config is already exist!
#	exit 1
	mkdir $resultDir/$config
fi
workloads=$(ls -d $benchmarkDir*/)
while read -r line; do
	workload=$(echo "$line"|rev | cut -d '/' -f 2 |rev)
	echo $line
	cd $line
	bash run  > $resultDir/$config/$workload &
	processList="$processList $!"
	echo $processList
	disown
	cd - > /dev/null
done <<< "$workloads"
