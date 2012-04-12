#!/bin/bash

arguments=8

input=$1
testname=$2
filesize=$3
bs=$4
runtime=$5
work=$6
directory=$7
runs=$8

output="$testname-$HOSTNAME.$work"
iterate=1

programPath="/usr/bin/fio"
vmstatInterval=5

ftpUser="skyhigh"
ftpPass="melkikakao2012"
ftpHost="192.168.10.190"
ftpDir="/tests/"

function usage() { echo -e "Usage of $0:\n$0 [input jobfile] [test name] [file size] [block size] [run time] [work] [directory] [number of runs]"; exit 0; }

if [[ $# -ne $arguments ]]; then usage; fi

files="$output.raw $output.vmstat $output"

for file in $files; do
 if [[ -e $file ]]
  then rm $file
 fi
done

`vmstat $vmstatInterval >> "$output.vmstat" &`

while [[ $iterate -le $runs ]] 
 do
  clear
  echo "Test in progress: [$iterate/$runs]"
  WORK=$work RUNS=$runtime SIZE=$filesize BS=$bs DIRECTORY=$directory $programPath $input --minimal >> "$output.raw"
  let iterate=$iterate+1
 done

if [[ $work == "read" || $work == "randread" ]]; then
 grep "belastning" "$output.raw" | tr ";" " " | awk {'print $6'} >> $output
else 
 grep "belastning" "$output.raw" | tr ";" " " | awk {'print $26'} >> $output
fi

kill -9 $(pidof vmstat)

echo "Finished with $runs runs. Consult '$output.raw', '$output' and '$output.vmstat' for result data."

ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir "$output.raw"
ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir "$output.vmstat"
ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir $output
