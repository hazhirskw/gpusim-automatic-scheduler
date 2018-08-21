#!/bin/bash
fileToCopy=$1
destFolder=$2
if [[ -z "$fileToCopy"  || -z "$destFolder" ]] 
then
	echo Error: Two few arguments!
	exit 1
fi

sourceList=$(find . -name $fileToCopy)
while read -r line; do
	destFileName=$(echo $line | rev | cut -d '/' -f 2 | rev)
	echo copying of $line to $destFolder/$destFileName
	cp $line $destFolder/$destFileName
done <<< "$sourceList"
exit 0
