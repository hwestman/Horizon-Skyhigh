for i in $(nova list | egrep 'ACTIVE|ERROR|BUILD' | awk {'print $2'}); do 
 nova delete $i 
done
