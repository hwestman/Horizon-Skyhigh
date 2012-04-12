#!/bin/bash

arguments=3

testnr=$1
dir=$2
runs=$3

ioping="~/scripts/ioping"

function usage() { echo -e "Usage of $0:\n$0 [test name] [directory] [runs]"; exit 0; }

function upload() {
 ftpUser="skyhigh"
 ftpPass="melkikakao2012"
 ftpHost="192.168.10.190"
 ftpDir="/tests/"

 ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir $1
}

if [[ $# -ne $arguments ]]; then usage; fi

iops=0
i=0

while [[ $i -lt $runs ]]
 do 
  hai=$(/root/scripts/ioping -R $dir)
  let iops=$iops+$(echo $hai | nawk '/iops/ {print $14}')
  let i=$i+1
 done

echo "Mean: $(($iops/$runs))" > $testnr.$HOSTNAME.iops

upload $testnr.$HOSTNAME.iops
