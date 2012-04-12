#!/bin/bash

argumentNum=1
killAfter=3

ftpUser="skyhigh"
ftpPass="melkikakao"
ftpHost="192.168.10.102"
ftpDir="/tests/"

if [[ $# -ne $argumentNum ]]; then echo "Usage of $0: $0 [outputfile]"; exit 0; fi

echo "Saving output from 'vmstat' to '$1'. Killing after $killAfter seconds"

vmstat 1 >> $1 &

sleep $killAfter

killall -9 vmstat

ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir $outputName
