#!/bin/bash 
myProcesses=`ps -u hazhir `
for i in "$myProcesses"; do
echo "$i" | grep  1- | cut -d ' ' -f 1 | xargs kill
done

