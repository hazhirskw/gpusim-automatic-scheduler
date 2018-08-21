#!/bin/bash
ps -u hazhir | grep -v bash | grep -v sshd | awk '{print $1;}' | grep -v PID | xargs kill
sleep 1
ps -u hazhir | grep euler | cut -d '?' -f 1 | xargs kill
sleep 1
ps -u hazhir | grep euler | cut -d '?' -f 1 | xargs kill
