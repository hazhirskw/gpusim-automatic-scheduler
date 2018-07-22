#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
benchmarkDir=$1
workloadsDir=$(pwd)
benchmarkName=$(echo $benchmarkDir | cut -d '/' -f 1)
if [ "$benchmarkName" = "ispass" ]; then
	runFile="README.GPGPU-Sim"
else

	runFile="run"
fi
configFile=$(ls -d $benchmarkDir*/ | head -n 1)gpgpusim.config
config=$(head -n 1 $configFile | cut -d "#" -f 2)
case $config in *\ *) echo "${RED} Error: Put the config name in ther first line of config File! ${NC}"
exit 1
;; esac

resultDir=~/workloads/result
if [[ -z "$benchmarkDir" ]]
then
        echo Error: Too few arguments!
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
if [ "$benchmarkName" = "parboil" ]; then
	cd parboil
fi
echo workloads=$workloads
while read -r line; do
	workload=$(echo "$line"|rev | cut -d '/' -f 2 |rev)
	echo Starting execution of $workload
	if [ ! "$benchmarkName" = "parboil" ]; then	
		cd $line
		bash $runFile  > $resultDir/$config/$workload &
	else
		bash $workload >  $resultDir/$config/$workload &

	fi
	processList="$processList $!"
	disown
	if [ ! "$benchmarkName" = "parboil" ]; then
		cd - > /dev/null
	fi
done <<< "$workloads"
#Print PID of every workload simulation to the PL.txt file
echo $processList > $resultDir/$config/PL-${benchmarkName}.txt
#Schedule a process for killing simulation processes after a certain time. e.g 48 hours
echo par=$resultDir/$config/PL-${benchmarkName}.txt
echo $config >$resultdir/lastRun
cd $workloadsDir
#echo "./3-3-3-sim-killer.sh $resultDir/$config/PL-${benchmarkName}.txt" | at now + 48 hours
