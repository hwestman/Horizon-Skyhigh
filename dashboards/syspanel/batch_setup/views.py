# vim: tabstop=4 shiftwidth=4 softtabstop=4

# Copyright 2012 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
# Copyright 2012 Nebula, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License"); you may
#   not use this file except in compliance with the License. You may obtain
#   a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#   WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#   License for the specific language governing permissions and limitations
#   under the License.
      
from horizon import tables
from django.http import HttpResponse
from horizon.dashboards.syspanel.images.tables import AdminImagesTable
from horizon import api
from .tables import BatchOverview, InstanceSetup, TenantOverview, ConfigOverview
from .forms import CreateBatch, AddInstance, Tmp_Instance, EditBatch, SaveConfig
from horizon import forms
import pprint, MySQLdb, gc
import logging
from horizon import api, exceptions
from datetime import datetime



LOG = logging.getLogger(__name__)

class IndexView(tables.MultiTableView):
	table_classes = (BatchOverview, InstanceSetup, ConfigOverview)
	template_name = 'syspanel/batch_setup/index.html'
	
	def get_batch_overview_data(self):
		list = []
		db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
		cursor = db.cursor()

		cursor.execute("SELECT id, navn FROM batch")
		data = cursor.fetchall()               
		for row in data :
                    tenant_list = []
                    cursor.execute("SELECT tenant_id FROM batch_tenants WHERE batch_id=%s"%row[0])
                    tid = cursor.fetchall()
                    for line in tid :
                        tenant_list.append(line[0])
                    list.append(Batch(self.request,str(row[0]),row[1],tenant_list))
                gc.collect()
 		return list

	def get_instance_setup_data(self):

		list = []
		if('cur_instances' in self.request.session):
			tmp_instance_list = self.request.session.get('cur_instances')
			list=tmp_instance_list

		else:
			self.request.session['cur_instances'] = []
			
 		return list
	def get_config_overview_data(self):
		list = []
		db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
		cursor = db.cursor(MySQLdb.cursors.DictCursor)

		cursor.execute("SELECT c.id, c.name, (SELECT count(*) FROM instance_config i WHERE i.config_id = c.id) AS instances FROM configs c;")
		data = cursor.fetchall()
		for row in data:
			list.append(Config(row["id"],row["name"],row["instances"]))
			LOG.info("rows in config = : %s"%row["name"])

 		return list

class Config():
	id=""
	name=""
	instance_count=0
	def __init__(self,id,name,instance_count):
		self.id = id
		self.name = name
		self.instance_count = instance_count

	
class Batch():
	id=""
	name =""
	tenant_list = []
        tenant_count = 0
        instance_count = 0
	def __init__(self,request,id,batch_name, tenant_list):
		self.id = id
		self.name = batch_name
		self.tenant_list = tenant_list
		self.tenant_count = len(tenant_list)
		self.instance_count = self.GetInstances(request)
	def GetInstances(self,request):
		db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="nova")
		cursor = db.cursor()

		for t in self.tenant_list :
                        cursor.execute("SELECT COUNT(*) FROM instances WHERE project_id = '%s' AND terminated_at IS NULL AND hostname IS NOT NULL"%t)
			data = cursor.fetchone()
			count = data[0]

		return count


class CreateBatchView(forms.ModalFormView):
	form_class = CreateBatch
	template_name = 'syspanel/batch_setup/create_batch.html'
        
        def get_context_data(self, **kwargs):
		context = super(CreateBatchView, self).get_context_data(**kwargs)
		try:
                    usage_list = api.nova.usage_list(self.request, datetime(1970,1,1), datetime.today())
                    totals = {
                        'vcpus' : 0,
                        'ram' : 0
                    }
                    for usage in usage_list:
                        totals['vcpus'] += usage.vcpus
                        totals['ram'] += usage.memory_mb
                    context['totals'] = totals
                                
		except:
                        exceptions.handle(self.request)
		return context

class SaveConfigView(forms.ModalFormView):
	form_class = SaveConfig
	template_name = 'syspanel/batch_setup/save_config.html'

	def get_context_data(self, **kwargs):
		context = super(SaveConfigView, self).get_context_data(**kwargs)
		
		return context


class EditBatchView(forms.ModalFormView):
	form_class = EditBatch
	template_name = 'syspanel/batch_setup/edit_batch.html'
	context_object_name = 'batch_setup'
	def get_initial(self):
		
		return {'batch_id': self.kwargs['batch_id']}

	def get_object(self, *args, **kwargs):

		db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
		cursor = db.cursor()

		cursor.execute("SELECT * FROM batch where id = %s"%kwargs["batch_id"])
		data = cursor.fetchone()
		#LOG.info("i logged: %s"%str(data[1]))
		cursor.execute("SELECT tenant_id FROM batch_tenants WHERE batch_id=%s"%data[0])

		tenants = cursor.fetchall()
		list = []
		for line in tenants :
			LOG.info("tenants is: %s"%str(line[0]))
			list.append(line[0])

		return list
		
"""
class EditBatchView(tables.DataTableView):
	table_class = TenantOverview
	template_name = 'syspanel/batch_setup/edit_batch.html'

	def get_data(self):
        
		tenants = [Tenant(2)]

		return tenants

	#def handle_form(self):

		#tenant_id = self.request.user.tenant_id
		#security_groups = [(group.id, group.name)
		#					for group in api.security_group_list(self.request)]

		#initial = {'tenant_id': tenant_id,
		#		   'security_group_id': self.kwargs['security_group_id'],
		#		   'security_group_list': security_groups}
		#return AddRule.maybe_handle(self.request, initial=initial)
	def get(self, request, *args, **kwargs):
		# Form handling
		#form, handled = self.handle_form()
		#if handled:
		#    return handled
		# Table action handling
		#handled = self.construct_tables()
		#if handled:
		#    return handled
		#if not self.object:
		#    return shortcuts.redirect("horizon:nova:access_and_security:index")
		#context = self.get_context_data(**kwargs)
		#context['form'] = form
		#context['edit_batch'] = self.object
		if request.is_ajax():
			#context['hide'] = True
			self.template_name = ('syspanel/batch_setup'
								 '/_edit_batch.html')
		return self.render_to_response("context")
"""


class Tenant():
	id = ""
	name = "kaare"
	def __init__(self,id):
		self.id = str(id)
	
class AddInstanceView(forms.ModalFormView):
	form_class = AddInstance
	template_name = 'syspanel/batch_setup/add_instance.html'

	def get_form_kwargs(self):
		kwargs = super(AddInstanceView, self).get_form_kwargs()
		kwargs['flavor_list'] = self.flavor_list()
		kwargs['image_list'] = self.image_list()
		kwargs['security_group_list'] = self.security_group_list()
		return kwargs

	def get_context_data(self, **kwargs):
		context = super(AddInstanceView, self).get_context_data(**kwargs)
		try:
			context['usages'] = api.tenant_quota_usages(self.request)
		except:
			exceptions.handle(self.request)
		return context

	def flavor_list(self):
		display = '%(name)s (%(vcpus)sVCPU / %(disk)sGB Disk / %(ram)sMB Ram )'
		try:
			flavors = api.flavor_list(self.request)
			flavor_list = [(flavor.id, display % {"name": flavor.name,
                                                  "vcpus": flavor.vcpus,
                                                  "disk": flavor.disk,
                                                  "ram": flavor.ram})
                                                for flavor in flavors]
		except:
			flavor_list = []
			exceptions.handle(self.request,
								_('Unable to retrieve instance flavors.'))
		return sorted(flavor_list)
	def security_group_list(self):
		try:
			groups = api.security_group_list(self.request)
			security_group_list = [(sg.name, sg.name) for sg in groups]
		except:
			exceptions.handle(self.request,
                              _('Unable to retrieve list of security groups'))
			security_group_list = []
		return security_group_list

	def image_list(self):
		try:
			all_images = api.image_list_detailed(self.request)
			images = [(image.id,image.name)for image in all_images]

		except:
			images = []
			exceptions.handle(self.request, _("Unable to retrieve images."))
		
		
		return images

