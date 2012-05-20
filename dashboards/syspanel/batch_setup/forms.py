# vim: tabstop=4 shiftwidth=4 softtabstop=4
#	Code by: SkyHigh
#	Bachelor Thesis written at Gjovik University College
#	http://hovedprosjekter.hig.no/v2012/imt/in/skyhighadm/
#
#	This sourcecode has been written as an extension of the Horizon module
#	in the OpenStack project and is greatly inspired by this.
#	http://horizon.openstack.org/
#
#   Licensed under the Apache License, Version 2.0 (the "License"); you may
#   not use this file except in compliance with the License. You may obtain
#   a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0

import logging

from django import shortcuts
from django.contrib import messages
from django.utils.translation import ugettext as _

from horizon import forms
from horizon import api
from horizon.views.auth_forms import Login, LoginWithTenant, _set_session_data
#from .views import Batch
import random
from .db import Mydb
from .TmpInstance import Tmp_Instance
import thread

LOG = logging.getLogger(__name__)

"""
Following classes defines and configures the forms used for data input for
their respective classes.

- Variables represent fields in forms as long as their specified by parent.
- Handle is selfexplanatory
- Other methods have been specified to keep with conventions.
"""
class SaveConfig(forms.SelfHandlingForm):
	name = forms.CharField(max_length=80, label=_("Config Name"))


	def handle(self, request, data):
                self.save(request, data)
		msg = _('%s was successfully saved to configs' % data['name'])
		LOG.info(msg)
		messages.success(request, msg)
		return shortcuts.redirect("horizon:syspanel:batch_setup:index")
            
        def save(self, request, data):
            cursor = Mydb.db.cursor()
            cursor.execute("INSERT INTO configs(name) VALUES('%s')" % data['name']) # Store config
            Mydb.db.commit()
            cursor.execute("SELECT LAST_INSERT_ID() AS id FROM configs") # Get id of new config
            res = cursor.fetchone()
            config_id = int(res[0]) 
            instances = request.session['cur_instances'] # Get instances
            
            for instance in instances:              # Iterate trough every instance
                cursor.execute("INSERT INTO instance_config(config_id, name, image_id, image_name, flavor_id, flavor_name) \
                                VALUES(%d, '%s', '%s', '%s', %d, '%s')" % (config_id, 
                                                                   instance.name, 
                                                                   instance.image_id,
                                                                   instance.image_name,
                                                                   int(instance.flavor_id),
                                                                   instance.flavor_name))
                Mydb.db.commit()
            cursor.close()


"""
Complex class, see sequence diagram in thesis:https://github.com/hwestman/Horizon-Skyhigh

"""
class CreateBatch(forms.SelfHandlingForm):
	name = forms.CharField(max_length=80, label=_("Batch Name"))
	tenant_count = forms.IntegerField(label=_("Tenant Count"),
                            required=True,
                            min_value=1,
                            initial=1,
                            help_text=_("Number of tenants to launch."))
	"""
	Generates a pseudorandom password alphanumeric string
	:param 'length' length of pseudorandom password
	"""
	def gen_pass(self, length):
		from random import choice
		import string
		chars = string.letters + string.digits
		pw = ''
		for i in range(length):
			pw = pw + choice(chars)
		return pw

	"""
	Saves the generated username and password to a separate file
	for each created tenant
	"""
	def save_creds_to_file(self, request, batch_name, tenant_name, username, password):
		import os
		d = "/root/login_details/%s" % batch_name
		if not os.path.exists(d):
			try:
				os.mkdir(d, 0700)
			except OSError:
				msg =_('Error creating creds directory in %s') % d
				LOG.info(msg)
				messages.warning(request, msg)

		path = "/root/login_details/%s/%s" % (batch_name, tenant_name)
		try:
			f = open(path, 'w')
			creds = ("Username: %s \nPassword: %s") % (username, password)
			f.write(creds)
			f.close()
		except IOError:
			msg = _("Unable to write creds for %s to file") % tenant_name
			LOG.info(msg)
			messages.warning(request, msg)

		return self.save_rc_file(username, batch_name, tenant_name, password)


	def save_rc_file(self, user, batch, tenant, pw):
		try:
			path = "/root/login_details/%s/%src" % (batch, tenant)
			f = open(path, 'w')
			rc = "NOVA_API_HOST=192.168.10.2\n \
				  GLANCE_API=192.168.10.2\n \
				  KEYSTONE_API_HOST=192.168.10.2\n \
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
			return path
		except IOError:
			msg = _("Unable to write creds for %s to file") % tenant
		LOG.info(msg)

	def create_instances(self, rcfile, instances, tenant):
		import os
		for instance in instances:
			os.system("/bin/bash /root/scripts/batch/spawn.sh %s %s %s %s %s" % (rcfile, instance.name, instance.flavor_name, instance.image_name, tenant))



	def lots_of_tenants(self, request, name,batchid, amount):

		tenant_list = []

		for i in range (amount):

			t_name = name+str(i+1)
			uname = "admin_"+t_name
			l = api.keystone.role_list(request)
			for role in l:
				if role.name == "member":
					role_id=role.id
					break
			tmpTenant = api.keystone.tenant_create(request, t_name, "", True)
			tenant_list.append(tmpTenant.id)
			pw = self.gen_pass(10)
			tmpUsr = api.keystone.user_create(request,
							  uname,
							  "",
							  pw,
							  tmpTenant.id,
							  True)
			#				Add the new user to the new tenant
			api.keystone.add_tenant_user_role(request,
							  tmpTenant.id,
							  tmpUsr.id,
							  role_id)
			#				Add admin to the new tenant
			api.keystone.add_tenant_user_role(request,
							  tmpTenant.id,
							  request.user.id,
							  role_id)


			rcpath = self.save_creds_to_file(request, name, t_name, uname, pw)
			instances = request.session['cur_instances']
			self.create_instances(rcpath, instances, t_name)

		self.batch_to_db(request,name,batchid,tenant_list)


	def batch_to_db(self,request,name,batchid,tenant_list):

		cursor = Mydb.db.cursor()

		#cursor.execute("SELECT COUNT(*) FROM batch")
		#data = cursor.fetchone()
		#batchid = data[0]+1

		#LOG.info("batchid %s"% batchid)
		#cursor.execute("INSERT INTO batch (id,navn) VALUES ('%s','%s')"%(batchid, name))
		#Mydb.db.commit()

		for tenant in tenant_list:
			cursor.execute("INSERT INTO batch_tenants (batch_id,tenant_id) VALUES ('%s','%s')"%(batchid, tenant))
			Mydb.db.commit()
			LOG.info("tenant: %s"% tenant)

	def handle(self, request, data):

		cursor = Mydb.db.cursor()

		cursor.execute("SELECT COUNT(*) FROM batch")
		result = cursor.fetchone()
		batchid = result[0]+1

		LOG.info("batchid %s"% batchid)
		cursor.execute("INSERT INTO batch (id,navn) VALUES ('%s','%s')"%(batchid, data['name']))
		Mydb.db.commit()


		def runCreate(threadName):
			self.lots_of_tenants(request, data['name'],batchid, data['tenant_count'])

		try:
			thread.start_new_thread(runCreate,("TheThread",))
		except:
			LOG.info("thread couldnt fork")

		msg = _('%s was successfully added to batches.') % data['name']
		LOG.info(msg)
		messages.success(request, msg)
		return shortcuts.redirect('horizon:syspanel:batch_setup:index')
        


class AddInstance(forms.SelfHandlingForm):
	name = forms.CharField(max_length=80, label=_("Server Name"))
	image = forms.ChoiceField(label=_("Image"),
								help_text=_("Which image to launch from"))
								
	image = forms.ChoiceField(label=_("Image"),
								help_text=_("Type of image."))
	flavor = forms.ChoiceField(label=_("Flavor"),
								help_text=_("Size of image to launch."))
	
	security_groups = forms.MultipleChoiceField(
								label=_("Security Groups"),
								required=True,
								initial=["default"],
								widget=forms.CheckboxSelectMultiple(),
								help_text=_("Launch instance in these "
											"security groups."))
	
	def __init__(self, *args, **kwargs):
		flavor_list = kwargs.pop('flavor_list')
		image_list = kwargs.pop('image_list')
		security_group_list = kwargs.pop('security_group_list')
		
		super(AddInstance, self).__init__(*args, **kwargs)

		self.fields['flavor'].choices = flavor_list
		self.fields['image'].choices = image_list
		self.fields['security_groups'].choices = security_group_list
	
	def handle(self, request, data):

		image_name = api.glance.image_get_meta(request, self.data['image']).name
		flavor_name = api.nova.flavor_get(request, self.data['flavor']).name
		LOG.info("Here comes the flavor_name %s"%flavor_name)
		list = request.session['cur_instances']
		list.append(Tmp_Instance(str(len(list)+1),data['name'], data['image'],image_name,data['flavor'],flavor_name))
		request.session['cur_instances'] = list


		msg = _('%s was successfully added to instances.'% data['name'])
		LOG.info(msg)
		messages.success(request, msg)
		return shortcuts.redirect("horizon:syspanel:batch_setup:index")

class EditBatch(forms.SelfHandlingForm):
	name = forms.CharField(max_length=80, label=_("blabla"))

	#def __init__(self, *args, **kwargs):


	def handle(self, request, data):

		msg = _('%s was successfully added to instances.'% data['name'])
		LOG.info(msg)
		messages.success(request, msg)
		return shortcuts.redirect("horizon:syspanel:batch_setup:index")


