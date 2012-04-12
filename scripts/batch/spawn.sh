#!/bin/bash
RCFILE=$1
NAME=$2
FLAVOR=$3
IMAGE="$4"
TENANT=$5

CREDSDIR=$(dirname $RCFILE)
KEYFILE=$TENANT"_"$NAME".pem"
KEYNAME=$NAME"key"

if [ -e $RCFILE ]; then
	source $RCFILE
	nova keypair-add $KEYNAME > $CREDSDIR/$KEYFILE
	chmod 600 $CREDSDIR/$KEYFILE
	nova secgroup-add-rule default tcp 22 22 0.0.0.0/0 > /dev/null
   nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0 > /dev/null
	nova boot --flavor $FLAVOR --image $IMAGE --key_name $KEYNAME $NAME
	#nova list | grep active > /dev/null
	#while [ $? -ne 0 ]; do
#		sleep 2
#		nova list | grep active > /dev/null
#	done
	IP=$(nova floating-ip-create | egrep '[0-9]+' | cut -d '|' -f2)
	nova add-floating-ip $NAME $IP
else
	exit 1
fi
