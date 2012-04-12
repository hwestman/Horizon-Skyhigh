#./virtualFio.sh [ID of test] [key name] [last octet of first floating ip] [flavor=tiny/small]

iterations="2 3"
machines="192.168.10.10 192.168.10.11 192.168.10.12"
key=mykey
ip=30
flavor=tiny

scriptRoot="/root/scripts/virtualFio.sh"

function changeIscsi() {
 ssh root@192.168.10.185 '
 for machine in $machines; do
  ssh root@$

for run in $iterations; do
 if [[ $run == 2 ]]; then iscsi="fileio"; else fileio="blockio"; fi
 
 echo "$scriptRoot "5.$run" $key $ip $flavor"
done
