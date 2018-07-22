#!/bin/bash
#Script have been written by Hazhir Bakhishi as extractor part of gpusim-automatic-scheduler-extractor project.
#The script is devided to 3 part

#First Part: Store all workloadName an all parameter value in allOccurance variable in the format of: workload1 val1 val2 val3 ... workload 2 val1 val2...workload n val1 val2.
param=$1
resultDir=$2
if [[ -z "$param" || -z "$resultDir" ]] 
then
	echo Error: Two few arguments!
	exit 1
fi
echo Executing grep command...
grepResult=$(grep -r $param $resultDir)
if [[ -z "$grepResult" ]]
then
	echo "No occurance of $param is found!"
	exit 1
fi
prevWorkload="empty"
echo Total number of grep output lines is $(echo "$grepResult" | wc -l)!
declare -i i=0
declare -i rem
RED='\033[0;31m'
NC='\033[0m' # No Color
while read -r line; do
	currentWorkload=$(echo $line | cut -d '/' -f 3 | cut -d ':' -f 1)
	if [ $currentWorkload != $prevWorkload ]; then
		allOccurance="$allOccurance $currentWorkload"
	fi
	paramValue=$(echo $line | awk -F $param '{print $2}' | cut -d '='  -f 2 | tr -d '[:space:]')
	allOccurance="$allOccurance $paramValue"
	prevWorkload=$currentWorkload
	i=$i+1
	rem=$i%100
	if [ $rem -eq 0 ];then
		echo -ne "Processing of ${RED}$i${NC} line is finished\033[0K\r"
	fi

done <<< "$grepResult"
echo ""
echo Calculating Min Max Average...
#Second Part: Determine the WMMA string which is in format WMMA="$WMMA $prevWorkload $min $max $lastElement"
WMMA=""
re='^[+-]?[0-9]+\.?[0-9]*$'
avg=""
prevWorkload=""
declare -i noc=0
for element in $allOccurance; do
	if [[ $element =~ $re ]]; then
		if (( $(echo "$element > $max" | bc -l) )); then
			max=$element
		fi
		if (( $(echo "$min > $element" | bc -l) )); then
			min=$element
		fi
		lastElement=$element
		noc=$noc+1
	else
		if [[ ! -z "${prevWorkload// }" ]]; then
			WMMA="$WMMA $prevWorkload $min $max $lastElement $noc"
		fi
		min="9999999999999999999999999999999999999"
		max="0"
		prevWorkload=$element
		noc=0
		echo -e extracting data for ${RED}$element${NC}...
	fi
done

WMMA="$WMMA $prevWorkload $min $max $lastElement $noc"
echo .
echo .
echo .
#Third Part: Print WMMA to a file in excel format
prevWorkload=""
excelEntry=""
outputFile="excels/$(echo $resultDir | cut -d '/' -f 2)-$param.xls"
echo Writing results to the $outputFile ...
echo -e "$param\tMin\tMax\tAVG\tN_OC" > $outputFile
for element in $WMMA; do
	if  [[ $element =~ $re ]]; then
		excelEntry="$excelEntry\t$element"
	else
		
		if [[ ! -z "${prevWorkload// }" ]]; then
			echo  -e $excelEntry >> $outputFile
			excelEntry=""
		fi
		prevWorkload=$element
		excelEntry=$prevWorkload

	fi
done
echo  -e $excelEntry >> $outputFile
gdrive upload -p 1sDGgkLqud9zFEHZIQbIHKAKKOc7RhIjv $outputFile 
