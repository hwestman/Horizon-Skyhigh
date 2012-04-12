function usage() { echo -e "Usage of $0:\n$0 [machines='1 2 4'] [ID of test] [key] [last octet of first floating ip] [flavor]"; exit 0; }

arguments=5

testID=$2
key=$3
IPStart=$4
flavor=$5

provisionPath="/root/scripts/provisioning/provisionMachines.sh"
autoPath="/root/scripts/tmux/automatedTests.sh"
fioPath="/home/ubuntu/scripts/fio/"
testPath="/home/ubuntu"

numMachines=$1
sleepShort=5
network=192.168.10
image="newfio"       
fioJobfile="belastning"
memory="4g"
blocksize="4k"
vmstat=1
runs=50

declare -a runtime=(0 0 60 60)
#declare -a runtime=(0)
declare -a work=(write read randwrite randread)
#declare -a work=(read)

if [[ $# -ne $arguments ]]; then usage; fi

function delete() {
 while [[ $(nova list | egrep 'ACTIVE|BUILD|ERROR' | wc -l) -gt 0 ]]; do
  for instance in $(nova list | egrep 'ACTIVE|BUILD|ERROR' | awk {'print $2'}); 
   do nova delete $instance; sleep 1; done
 done
}

iteration=0

for startMachines in $numMachines; do
 iter=0; j=0; nextIP=$IPStart
 while [[ $j -lt $startMachines ]]; do IPs[$j]=$network.$nextIP; let nextIP=$nextIP+1; let j=$j+1; done

# $provisionPath $startMachines $network.$IPStart testmachines $image $flavor $key


 IP=$(echo ${IPs[@]} | tr " " ";"); thisID="$testID.$(($iteration+1))"
 
 sleep 15

  while [[ $iter -lt 4 ]]; do
 $autoPath "$thisID.${work[$iter]}" "cd $fioPath;./runFio.sh $fioJobfile $thisID $memory $blocksize ${runtime[$iter]} ${work[$iter]} $testPath $runs" $vmstat /root/$key.priv "$IP"
  let iter=$iter+1
 done

 sleep $sleepShort
 
 sleep 30
 delete

 sleep $sleepShort

 let iteration=$iteration+1

done
