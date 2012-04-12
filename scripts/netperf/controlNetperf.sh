# This script controls the script runNetperf.sh
# You can use it to transfer to or from a machine running Netserver
# using one or more machines running Netperf.

# Example use:
# ./controlNetperf.sh 'manchester;newcastle' 10 100 TX 2_1 kingston 0
# The following example will contact server kingston, open two sessions of
# Netserver and have the hosts 'manchester' and 'newcastle' simultaneously
# run 100 transfers each lasting 10 seconds to the server.

#!/bin/bash

arguments=7

computers=$(echo $1 | tr ";" " ")
testLength=$2
runs=$3
mode=$4
testNr=$5
server=$6
key=$7

path="/root/scripts/netperf/runNetperf.sh"
iterate=1
portStart=12345

function usage() { 
 echo -e "Usage of $0:\n$0 [comma-separated list of hosts] [test length] [# number of test runs] [TX/RX] [test number] [server] [key /0]"
 exit 0 
}

if [[ $# -ne $arguments ]]; then usage; fi

ssh root@$server 'kill -9 $(pgrep -u root netserver)'

port=$portStart
for i in $computers; do
 ssh root@$server "netserver -p $port &> /dev/null"; sleep 1; let port=$port+1; 
done

cpuName="$testNr.$server-$mode.cpu"

ssh root@$server "sh -c 'vmstat 1 > '$cpuName' &'" &
ssh root@$server "sh -c 'sleep $(($testLength*$runs)) && killall -9 vmstat && scp '$cpuName' root@192.168.10.190:/tests/'" &

echo "Waiting for tests to finish" 

d=1
for i in $computers
 do
  if [[ $key == "0" ]]; then ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$i "sh -c 'sleep $d && $path $testLength $runs $testNr $server $portStart $mode &> /dev/null'" &
  else ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $key ubuntu@$i "sleep $d && /home/ubuntu/scripts/netperf/runNetperf.sh $testLength $runs '$testNr-$i' $server $portStart $mode &> /dev/null" &
  let d=$d+1
  fi
  let portStart=$portStart+1
done

echo "Sleeping till finished"

sleep $((($testLength*$runs)+$testLength))
