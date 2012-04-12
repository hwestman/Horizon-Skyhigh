# This is a script which measures the total amount of time  in seconds it takes to get "n"
# virtual machines of flavor "m" with image "o" operational on "p" compute nodes.

# Heavy use of "novaclient" is employed. Use "nova image-list" and "nova flavor-list" if you are
# unsure about the image type and instance type arguments.

# The format of the output file follow below:
# seconds passed;instances building;instances running

# Example of output file contents - each run ends with a #:
# 1;4;0;2;4;0;3;3;1

#!/bin/bash

arguments=5

machines=$1
runs=$2
image=$3
flavor=$4
testnr=$5

output="$testnr-provisioning"

iterateRuns=1
sleepAmount=5

if [[ $# -ne $arguments ]]
 then
  echo -e "Usage of $0:\n$0 [number of virtual machines to start] [number of tests] [image type] [flavor] [test number]"
  exit 0
 fi

echo "Starting $machines virtual machines $runs times."

function boot() { 
 #local i=1; curACTIVE=0; curBUILD=$machines
 #while [[ $i -le $machines ]]
 # do
 #  nova boot "provision-$i" --image $image --flavor $flavor --key_name mykey &> /dev/null
 #  let i=$i+1
 # done
 euca-run-instances ami-00000005 --key mykey -n $machines -t $flavor
}

function delete() { 
 for i in $(nova list | egrep 'ACTIVE|BUILD' | awk {'print $2'})
  do nova delete $i; sleep 1; done
 sleep $sleepAmount; 
}

function checkStatus() { 
 unset provisioning
 totalSeconds=1
 curACTIVE=0
 curBUILD=$machines

 while [[ $(mysql -uroot -pmelkikakao2012 -Dnova -N -e "select count(*) from instances where vm_state='active';")  -ne $machines ]]; do update; done
 update
 for second in ${provisioning[@]}
  do
   echo "$second" >> $output
  done
}

function update() {
 checkACTIVE=$(mysql -uroot -pmelkikakao2012 -Dnova -N -e "select count(*) from instances where vm_state='active';")
 checkBUILD=$(($machines-$checkACTIVE))

 if [[ $checkACTIVE -gt $curACTIVE ]]; then curACTIVE=$checkACTIVE; fi
 if [[ $checkBUILD  -lt $curBUILD ]]; then curBUILD=$checkBUILD; fi
 tmp="$totalSeconds;$curBUILD;$curACTIVE"
 provisioning[$totalSeconds]=$tmp
 sleep 1
 let totalSeconds=$totalSeconds+1
}

while [[ $iterateRuns -le $runs ]]
 do
  clear
  echo "[$iterateRuns/$runs]"
  boot &
  checkStatus
  delete 
  let iterateRuns=$iterateRuns+1
 done

echo "Consult '$output' for results."
