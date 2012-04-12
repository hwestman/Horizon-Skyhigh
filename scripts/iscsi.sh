machines="manchester cardiff newcastle"

for i in $machines
 do
  ssh root@$i '/root/iscsi.sh'
 done
