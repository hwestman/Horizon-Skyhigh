#!/bin/bash

API="192.168.10.2"	# CHANGE THIS TO THE RIGHT ADDRESS
error=0
login_details_dir="/root/login_details"
if [ ! -d $login_details_dir ]; then
	mkdir $login_details_dir
fi

function prompt()   {
	echo -n "batch> "; read $1
}

# Creates a random password. Provide amount of characters as only argument
function createPassword()   {
	pass=$(cat /dev/urandom | tr -cd "[:alnum:]" | head -c $1)
	echo $pass
}

# Fetches the id of a user, tenant or role. Specify one of those as first argument, name as the second
function getKeystoneId()   {
	echo $(keystone $1-list | grep -w $2 | awk '{ print $2 }')
}

# Wait until all instances has ACTIVE state. Param 1 = amount of instances to wait for
function waitForBoot()   {
	while [ $(nova list | grep ACTIVE | wc -l) != $1 ]; do
		sleep 3
	done
}

# Create crendentials, so you are able to launch instances in different tenants
# Param 1 = username; Param 2 = tenant name without number; Param 3 = project number; Param 4 = password
function create_rc()   {
	TID=`getKeystoneId tenant $2$3`
	ACCESS=$(keystone ec2-credentials-create --user $1 --tenant_id $TID | grep access | awk '{ print $4 }')
	SECRET=$(keystone ec2-credentials-get --access $ACCESS | grep secret | awk '{ print $4 }')
	FILE="$login_details_dir/$2/$3/$2$3rc"
	cat > $FILE << EOF
NOVA_API_HOST=$API
GLANCE_API=$API
KEYSTONE_API=$API
KEYSTONE_TENANT=$2$3
KEYSTONE_PASSWORD=$4
KEYSTONE_USERNAME=$1

NOVA_REGION="nova"

export OS_AUTH_USER=\$KEYSTONE_USERNAME
export OS_AUTH_KEY=\$KEYSTONE_PASSWORD
export OS_AUTH_TENANT=\$KEYSTONE_TENANT
export OS_AUTH_URL="http://\${KEYSTONE_API_HOST}:5000/v2.0/"
export OS_AUTH_STRATEGY="keystone"

export OS_USERNAME=\$KEYSTONE_USERNAME
export OS_TENANT_NAME=\$KEYSTONE_TENANT
export OS_PASSWORD=\$KEYSTONE_PASSWORD
export OS_REGION_NAME="RegionOne"

export NOVA_USERNAME=\$KEYSTONE_USERNAME
export NOVA_PROJECT_ID=\$KEYSTONE_TENANT
export NOVA_PASSWORD=\$KEYSTONE_PASSWORD
export NOVA_API_KEY=\$KEYSTONE_PASSWORD
export NOVA_REGION_NAME=\$NOVA_REGION
export NOVA_URL="http://\${NOVA_API_HOST}:5000/v2.0/"
export NOVA_VERSION="1.1"
export EC2_URL="http://\${NOVA_API_HOST}:8773/services/Cloud"
export EC2_ACCESS_KEY=$ACCESS
export EC2_SECRET_KEY=$SECRET
EOF
}

echo "####################################################"
echo "#### Welcome to interactive batch_setup script! ####" 
echo "####################################################"

echo "--- How many projects do you want to make? ---"
prompt tenants

echo "--- Give name prefix for your $tenants new projects ---"
prompt tenant_name_prefix
mkdir $login_details_dir/$tenant_name_prefix

echo "--- Do you want to add the admin user to your projects? [y/n] ---"
prompt addadmin

echo "--- Creating $tenants new projects with prefix $tenant_name_prefix ---"
for i in $(seq 1 $tenants); do
	tenant_ids[$i]=$(keystone tenant-create --name $tenant_name_prefix$i --enabled true | grep id | awk '{ print $4 }')
	if [ $? -ne 0 ]; then
		error=1
	fi
	if [ $error -eq 1 ]; then
		echo "Error when creating projects, aborting"
		exit 1
	fi
	if [ $addadmin == "y" ]; then
		keystone user-role-add --user `getKeystoneId user admin` --role `getKeystoneId role member` --tenant_id ${tenant_ids[$i]}
	fi
done
echo "--- Done creating projects! ---"

echo "--- I'll add some generic users with a random password for you. One per project ---"
for j in $(seq 1 $tenants); do
	source /root/openstack
	mkdir $login_details_dir/$tenant_name_prefix/$j
	pw=`createPassword 10`
	uname="admin_$tenant_name_prefix$j"
	keyname=$uname"key"
	thistenant=$tenant_name_prefix$j
	creds=$thistenant"rc"
	
	echo "--- Creating user $uname ---"
	user_ids[$j]=$(keystone user-create --name $uname --tenant_id ${tenant_ids[$j]} --pass $pw --enabled true | grep id | awk '{ print $4 }')
	echo -e "Username: $uname \nPassword: $pw" > "$login_details_dir/$tenant_name_prefix/$j/$thistenant.txt"
	
	echo "--- Adding member role ---"
	keystone user-role-add --user ${user_ids[$j]} --role `getKeystoneId role member` --tenant_id ${tenant_ids[$j]}
	
	echo "--- Creating rc-file ---"
	create_rc $uname $tenant_name_prefix $j $pw
	source $login_details_dir/$tenant_name_prefix/$j/$creds	

	echo "--- Creating keypair ---"
	nova keypair-add $keyname > $login_details_dir/$tenant_name_prefix/$j/$uname".pem"
	chmod 600 $login_details_dir/$tenant_name_prefix/$j/$uname".pem"

	echo "--- Adding ping and ssh access ---"
	nova secgroup-add-rule default tcp 22 22 0.0.0.0/0 > /dev/null
	nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0 > /dev/null
done
echo "--- Done adding users, the login details is stored in $login_details_dir ---"

echo "--- You are now ready to login to horizon with your new users. Do you want to proceed to spawn instances? [y/n]"
prompt addinst
if [ $addinst == "n" ]; then exit 0;
elif [ $addinst == "y" ]; then
	ok="n"
	while [ $ok != "y" ]; do
		echo "--- This is the list of images you can spawn instances of ---"
		nova image-list
		
		echo "--- This is the flavors you can choose ---"
		nova flavor-list
	
		echo "--- Now enter name, image and flavor for each machine. Separated by spaces and in that particular order. Please don't fuck up ---"
		more="y"
		idx=0
		while [ $more == "y" ]; do
			prompt info
			((idx++))			# start indexing at 1. When finished idx will contain the amount of instances you will spawn
			allinfo[$idx]=$info
			echo "--- More machines? [y/n] ---"
			prompt more
		done
		echo "--- Will now spawn theese instances in all of $tenants projects you've made. Okey? [y/n] ---"
		a=1
		while [ $a -le $idx ]; do
			attr=${allinfo[$a]}
			name[$a]=$(echo $attr | cut -d' ' -f1)
			image[$a]=$(echo $attr | cut -d' ' -f2)
			flavor[$a]=$(echo $attr | cut -d' ' -f3)
			echo "$a, ${name[$a]}, ${image[$a]}, ${flavor[$a]}"
			((a++))
		done
	read ok
	done
	
	echo "--- Booting shit up. Sit down and pray ---"
	for tenant in $(seq 1 $tenants); do
		source $login_details_dir/$tenant_name_prefix/$tenant/$creds
		thistenant=$tenant_name_prefix$tenant
      creds=$thistenant"rc"
      keyname=$uname"key"
		for instance in $(seq 1 $idx); do
			echo "--- Booting up ${name[$instance]} in project $thistenant ---"
			nova boot --flavor ${flavor[$instance]} --image ${image[$instance]} --key_name $keyname ${name[$instance]}
		done
		#waitForBoot $idx
	done
else 
	echo "Error in input. Exiting..." 
	exit 1
fi
