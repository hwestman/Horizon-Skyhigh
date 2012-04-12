# The following script runs Netperf on an already started
# Netserver for the amount of times specified by parameters.  

# Example: 
# ./runNetperf.sh 10 100 2_1 kingston 12345 TX

# The above parameters will start 100 tests,
# each lasting 10 seconds, transferring to the
#n the server 'kingston'

#!/bin/bash

arguments=6

testLength=$1
runs=$2
testNr=$3
remoteHost=$4
remotePort=$5
mode=$6

iterate=1

if [[ $mode == "RX" ]]; then output="$testNr-$HOSTNAME-$mode-fra-$remoteHost"; else output="$testNr-$HOSTNAME-$mode-til-$remoteHost"; fi

function upload() {
 ftpUser="skyhigh"
 ftpPass="melkikakao2012"
 ftpHost="192.168.10.190"
 ftpDir="/tests/"

 ncftpput -u $ftpUser -p $ftpPass $ftpHost $ftpDir $1
}

function usage() {
 echo -e "Usage of $0:\n$0 [each test's length (=> 10sec)] [# number of runs] [test number] [remote host] [port] [TX/RX]"
 exit 0
}

if [[ $# -ne $arguments ]]; then usage; fi

if [[ -e $output ]]; then rm $output; fi

if [[ $mode == "TX" ]]; then mode="TCP_STREAM"; else mode="TCP_MAERTS"; fi

while [ $iterate -le $runs ]
 do 
  echo "Test in progress: [$iterate/$runs]"
  netperf -l $testLength -P 0 -c -C -t $mode -H $remoteHost -p $remotePort >> $output
  let iterate=$iterate+1
 done

echo "Finished with $runs runs. Consult '$output' for result data."

upload $output
