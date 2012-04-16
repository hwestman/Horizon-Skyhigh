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
from .tables import BatchOverview, InstanceSetup
from .forms import CreateBatch, AddInstance, Tmp_Instance
from horizon import forms
import pprint, MySQLdb, gc
import logging
from horizon import api


LOG = logging.getLogger(__name__)

class IndexView(tables.MultiTableView):
	table_classes = (BatchOverview, InstanceSetup)
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
                    list.append(Batch(self.request,row[0],row[1],tenant_list))
                gc.collect()
 		return list
	def get_instance_setup_data(self):

		list = []
		if('cur_instances' in self.request.session):
			tmp_instance_list = self.request.session.get('cur_instances')
			LOG.info("tmp_instance_list is set: ")
			list=tmp_instance_list

		else:
			self.request.session['cur_instances'] = []
			LOG.info("placed a new list in session")
		#f = open('/root/list-test-ye.txt','w')
		#f.write(tmp_instance_list[0])
		#f.close()

		
		#em = Tmp_Instance("yeye","yeye","yeye")
		#list.append(em)
 		return list

class Batch():
	id
	batch_name =""
	tenant_list = []
        tenant_count = 0
        instance_count = 0
	def __init__(self,request,id,batch_name, tenant_list):
		self.id = id
		self.batch_name = batch_name
		self.tenant_list = tenant_list
		self.tenant_count = len(tenant_list)
		self.instance_count = self.GetInstances(request)
	def GetInstances(self,request):
		db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="nova")
		cursor = db.cursor()

		for t in self.tenant_list :
			LOG.info(t)
			#cursor.execute("SELECT COUNT(*) FROM instances WHERE project_id = '%s' AND vm_state = 'active'"%t)
                        cursor.execute("SELECT COUNT(*) FROM instances WHERE project_id = '%s' AND terminated_at IS NULL AND hostname IS NOT NULL"%t)
			data = cursor.fetchone()
			count = data[0]

		return count


class CreateBatchView(forms.ModalFormView):
	form_class = CreateBatch
	template_name = 'syspanel/batch_setup/create_batch.html'

	
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
