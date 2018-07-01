#!/bin/bash
configDir=$1
benchmarkDir=$2
if [[ -z "$configDir" || -z "$benchmarkDir" ]] 
then
	echo Error: Two few arguments!
	exit 1
fi

workloads=$(ls -d $benchmarkDir*/)

while read -r line; do
	cp -r $configDir/* $line
done <<< "$workloads"
BLUE='\033[0;34m'
NC='\033[0m'
echo -e "${BLUE}Config files copied to all workload direcotories successfully!${NC}"
exit 0
