#!/bin/bash

arguments=5

testnr=$1
command=$2
vmstat=$3
key=$4

sleepAmount=5

storage="192.168.10.185"
router="128.39.80.76"
user="ubuntu"

#user="ubuntu"

ftpUser="skyhigh"
ftpPass="melkikakao2012"
ftpHost="192.168.10.2"
ftpDir="/tests/"

machines=$(echo $5 | tr ";" "\n")

usage() { echo -e "Usage of $0:\n$0 [testnr] [script name and arguments on remote hosts] [vmstat 0/1] [key 0/key] [machine n;machine n+1;machine..]"; }

if [[ $arguments -ne $# ]]; then usage; exit 0; fi

tmux new-session -d -s $testnr

echo -e "\nRunning command '$command' on machines specified! Please hold."

for machine in $machines; do
 tmux new-window -t $testnr -a -n $machine "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $key $user@$machine '$command; exit';exit"
done

tmux kill-window -t $testnr:0

if [[ $vmstat -eq 1 ]]; then
 ssh root@$storage "vmstat 1 > '$testnr.cpu' &"
fi

while tmux has-session -t $testnr; do sleep $sleepAmount; done 

if [[ "$vmstat" == 1 ]]; then 
 ssh root@$storage 'kill -9 $(pgrep -u root vmstat)'
 ssh root@$storage ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir "$testnr.cpu"
fi

echo "$runs finished on remote hosts."
