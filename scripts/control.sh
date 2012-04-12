arguments=2

if [[ $# -lt $arguments ]]; then echo -e "usage: [stop/start/restart] [machines]\n"; exit 0; fi

serv="api network compute cert"
action=$1
shift;
for i in "$@"
 do
   if [[ $action == "stop" ]]; then ssh root@$i "/etc/init.d/libvirt-bin stop; killall -9 libvirt"
   else ssh root@$i "killall -9 libvirt; /etc/init.d/libvirt-bin start"; ssh root@$i "/etc/init.d/libvirt-bin restart"; fi
   for x in $serv
   do
    ssh root@$i "$action nova-$x"
   done

 done
