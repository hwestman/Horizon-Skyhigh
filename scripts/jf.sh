arguments=1

if [[ $# -lt $arguments ]]; then echo -e "usage: [mtu]\n"; exit 0; fi

echo "Doing 'ifconfig eth0 mtu $1'"

servers="manchester cardiff newcastle kingston"

for i in $servers
 do
  ssh root@$i "ifconfig eth0 mtu $1 &"
 done

ifconfig eth0 mtu $1

echo "Pls remember 2 switch"
