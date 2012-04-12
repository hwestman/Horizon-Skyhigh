#!/bin/bash

ARGUMENTS=2

if [ $# -ne $ARGUMENTS ]; then
	echo "Usage: keystone-get-id <user|role|tenant> <name>"
	exit 1
fi

if [ $1 == "user" ] || [ $1 == "role" ] || [ $1 == "tenant" ]; then
	RES=$(keystone $1-list | grep -w $2 | awk '{ print $2 }')
	if [ -z $RES ]; then
        	echo "No $1 with name $2"
               	exit 1
       	fi
	echo $RES
else
	echo "Unknown type $1"
	echo "Usage: keystone-get-id <user|role|tenant> <name>"
	exit 1
fi
