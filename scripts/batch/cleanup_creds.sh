#!/bin/bash
for x in $@; do
	rm -rf /root/login_details/$x
done
