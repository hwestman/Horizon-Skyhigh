#!/bin/bash

# This is a script that lets you test sequential read and/or write performance
# on a block device / file system. If you are to test only read speed, you need
# to specify a file you have already created.

# In order to get accurate results, specify to create a sizeable file,
# at least twice the size of the amount of RAM your system has.

# Run it in a terminal and specify arguments, or create a file with arguments and use xargs:
# cat configfile | xargs ./runDD.sh

arguments=6

ttype=$1
bs=$2
count=$3
dir=$4
runs=$5
testnr=$6
outfile="ddtest-$HOSTNAME-$testnr"
testfile="$dir/ddtest-$testnr.testfile"

usage() { echo -e "Usage of $0:\n$0 [read or write] [block size] [count] [directory] [number of runs] [test number]"; }

if [[ $# -ne $arguments ]]; then usage; exit 0; fi

iterate=1
last=0

while [[ $iterate -le $runs ]]; do
 echo "[$iterate/$runs] - test in progress!"
 if [[ "$ttype" == "read" ]]; then 
  if [ -e "$testfile" ]; then
   if [[ $iterate -eq 1 ]]; then 
    if [ -e "$outfile.read.cpu" ]; then rm "$outfile.read.cpu"; fi
    `vmstat 2 >> "$outfile.read.cpu" &`
    if [ -e "$outfile.read" ]; then rm "$outfile.read"; fi; 
   fi
   results=`((dd of=/dev/null if=$testfile bs=$bs count=$count && sync) 2>&1)`
   last=`echo $results | awk '{print $14;}' >> "$outfile.read"`
  else echo -e "'$testfile' doesn't exist.\n"; usage; exit 0
  fi
 else
  rm=$iterate+1
  if [ $iterate -eq 1 ]; then
   if [ -e "$outfile.write.cpu" ]; then rm "$outfile.write.cpu"; fi
   `vmstat 2 >> "$outfile.write.cpu" &`
   if [[ -e "$testfile" && $rm -lt $runs ]]; then rm $testfile; fi
   if [ -e "$outfile.write" ]; then rm "$outfile.write"; fi
  fi
  results=`((dd if=/dev/zero of=$testfile bs=$bs count=$count && sync) 2>&1)`
  last=`echo $results | awk '{print $14;}' >> "$outfile.write"`
 fi
 let iterate=$iterate+1
done

killall -9 vmstat
if [[ $iterate -eq 1 && $runs -gt $iterate ]]; then rm "$outfile.write"; rm "$outfile.read"; rm "$outfile.cpu"; fi

echo -e "\n$runs runs complete."
