def save_rc_file(user, batch, tenant, pw):
	try:
		path = "/root/login_details/%s/%src" % (batch, tenant)
		f = open(path, 'w')
		rc = "NOVA_API_HOST=192.168.10.2\n \
              GLANCE_API=192.168.10.2\n \
              KEYSTONE_API=192.168.10.2\n \
              KEYSTONE_TENANT=%s\n \
              KEYSTONE_PASSWORD=%s\n \
              KEYSTONE_USERNAME=%s\n \
              NOVA_REGION='nova'\n \
              export OS_AUTH_USER=$KEYSTONE_USERNAME\n \
              export OS_AUTH_KEY=$KEYSTONE_PASSWORD\n \
              export OS_AUTH_TENANT=$KEYSTONE_TENANT\n \
              export OS_AUTH_URL=\"http://${KEYSTONE_API_HOST}:5000/v2.0/\"\n \
              export OS_AUTH_STRATEGY='keystone'\n \
              export OS_USERNAME=$KEYSTONE_USERNAME\n \
              export OS_TENANT_NAME=$KEYSTONE_TENANT\n \
              export OS_PASSWORD=$KEYSTONE_PASSWORD\n \
              export OS_REGION_NAME='RegionOne'\n \
              export NOVA_USERNAME=$KEYSTONE_USERNAME\n \
              export NOVA_PROJECT_ID=$KEYSTONE_TENANT\n \
              export NOVA_PASSWORD=$KEYSTONE_PASSWORD\n \
              export NOVA_API_KEY=$KEYSTONE_PASSWORD\n \
              export NOVA_REGION_NAME=$NOVA_REGION\n \
              export NOVA_URL=\"http://\${NOVA_API_HOST}:5000/v2.0/\"\n \
              export NOVA_VERSION='1.1'\n \
              export EC2_URL=\"http://\${NOVA_API_HOST}:8773/services/Cloud\"\n" % (tenant, pw, user)
		f.write(rc)
		f.close()
	except IOError:
		msg = ("Unable to write creds for %s to file") % tenant
		print msg

save_rc_file("mordi", "fot", "fot1", "passord")
