# This script allows you to automatize the launching of a number of virtual machines and allocate them floating IPs.
# It is especially useful in situations when 

#!/bin/bash

arguments=6

launchAmount=$1
IP=$2
name=$3
image=$4
flavor=$5
key=$6

instances=1

function usage() { 
 echo -e "Usage of $0:\n$0 [VMs to start] [first floating IP to allocate] [name of batch] [image] [flavor] [key]"
 exit 0 
}

function boot() {
 nova boot --image=$image --flavor=$flavor --key_name=$key "$name-$instances" &> /dev/null
}

function getMachines()   { 
 local machines=$(nova list | grep -E "$name.*$1" | awk {'print $2'})
 echo $machines
}

function countMachines() { 
 local count=$(nova list | grep -E "$name.*$1" | wc -l)
 echo $count
}

function nextIP()        { 
 local split=$(echo $IP | tr "." " ")
 local network=$(echo $split | awk {'print $1 "." $2 "." $3'})
 local ip=$(echo $split | awk {'print $4'})
 echo "$network.$(($ip+1))"
}

function allocateIP() {
 while [[ $(nova list | grep -E "$1.*192" | wc -l) -eq 0 ]]
 do
  nova add-floating-ip $(nova list | grep $1 | awk {'print $2'}) $IP &> /dev/null &
  sleep 3
 done

 let IPAllocated=$IPAllocated+1
 echo "Successfully allocated floating IP '$IP' to instance with ID '$1'."
}

function setFloatingIPs() { 
 while [[ $IPAllocated -lt $launchAmount ]]; do
  for i in $(getMachines ACTIVE); do allocateIP $i; IP=$(nextIP); done; 
 done 
}

function deployMachines() {
 j=0;

 while [[ $j -ne $launchAmount && $(countMachines ACTIVE) -ne $launchAmount ]]; 
  do 
   boot &
   let instances=$instances+1; 
   let j=$j+1
   if [[ $j%10 -eq 0 ]]; then sleep 5; fi
  done
  
  while [[ $(countMachines BUILD) -ge 0 && $(countMachines ACTIVE) -ne $launchAmount ]];
   do 
    sleep 1
  done
}

function deployWithFloat() { 
 echo "Attempting to start $launchAmount virtual machines of flavor '$flavor' running image '$image'."
 echo "Floating IPs will be added from '$IP'"

 deployMachines
 #setFloatingIPs

 echo -e "\nSuccessfully started $launchAmount machines with floating IPs."
}

if [[ $# -ne $arguments ]]; then usage; fi

deployWithFloat
