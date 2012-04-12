#!/bin/bash
for x in "$@"; do
keystone user-role-remove --user $(keystone-get-id user admin_$x) --role $(keystone-get-id role member) --tenant_id $(keystone-get-id tenant $x)
keystone user-role-remove --user $(keystone-get-id user admin) --role $(keystone-get-id role member) --tenant_id $(keystone-get-id tenant $x)
keystone user-delete $(keystone-get-id user admin_$x)
nova-manage project scrub $(keystone-get-id tenant $x)
keystone tenant-delete $(keystone-get-id tenant $x)
done
