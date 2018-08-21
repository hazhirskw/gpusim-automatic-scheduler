#!/bin/bash 
myProcesses=`ps -u hazhir `
for i in "$myProcesses"; do
echo "$i" | grep  1- | cut -d ' ' -f 1 | xargs kill
done
read -p "Do you want to kill euler3d?" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ps -u hazhir | grep euler | cut -d '?' -f 1 | xargs kill
    sleep 2
    ps -u hazhir | grep euler | cut -d '?' -f 1 | xargs kill
fi
