#!/bin/bash

# This script runs bonnie++ a number of times with certain parameters, 
# saves the output and uploads it to an FTP server.

numRuns=$1
fileSize="$2G"
user=$3
directoryToTest=$4
testNumber=$5

argumentCount=5
ftpUser="skyhigh"
ftpPass="melkikakao"
ftpHost="192.168.10.102"
ftpDir="/tests/"

DATE=$(date +'%d_%m')
outputName="$testNumber-$HOSTNAME-$DATE"

start=1

if [ $# -lt $argumentCount ]
 then
  echo -e "Usage of $0:\n$0 [# runs] [size of file(s) in # of G] [user to run as] [directory to test] [test number]"
  exit 0
 fi

if [ -f $outputName ]
 then
  rm $outputName
  echo "Deleted $outputName, writing to a clean file."
 fi

clear

#vmstat 2 >> "$outputName.cpu" &

while [ $start -le $numRuns ]
 do
  echo -e "Test in progress: [$start/$numRuns]"
  /usr/sbin/bonnie++ -u $user -q -d $directoryToTest -s $fileSize -f -q -b -n 0 >> $outputName
  clear
  let start=start+1
 done

killall -9 vmstat

echo "Finished! Raw test data will be found in '$outputName'."
echo "Uploading results!"

#`tar -czf "$outputName.tar.gz" "$outputName*"`

#ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir "$outputName.tar.gz"
