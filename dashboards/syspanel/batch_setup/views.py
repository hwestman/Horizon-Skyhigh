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

      
from horizon import tables
from horizon import api
from .tables import BatchOverview, InstanceSetup, ConfigOverview
from .forms import CreateBatch, AddInstance, EditBatch, SaveConfig
from horizon import forms
import gc
import logging
from horizon import api, exceptions
from datetime import datetime
from .Batch import Batch
from .Configuration import Config
from .db import Mydb
import MySQLdb

LOG = logging.getLogger(__name__)

"""
View that displays three tables:
- batches
- current batch configuration
- all batch configuration
presentet as tabledata
"""
class IndexView(tables.MultiTableView):
	table_classes = (BatchOverview, InstanceSetup, ConfigOverview)
	template_name = 'syspanel/batch_setup/index.html'


	"""
	Collects data for all batches from database
	returns for rendering as a list
	"""
	def get_batch_overview_data(self):
		list = []
		cursor = Mydb.db.cursor()

		cursor.execute("SELECT id, navn FROM batch")
		data = cursor.fetchall()               
		for row in data :
                    tenant_list = []
                    cursor.execute("SELECT tenant_id FROM batch_tenants \
					WHERE batch_id=%s"%row[0])
                    tid = cursor.fetchall()
                    for line in tid :
                        tenant_list.append(line[0])
                    list.append(Batch(self.request,str(row[0]),row[1],tenant_list))
                gc.collect()
 		return list
	
	"""
	Collects data for all instances that has been added from session
	Returns list for rendering
	"""
	def get_instance_setup_data(self):

		list = []
		if('cur_instances' in self.request.session):
			tmp_instance_list = self.request.session.get('cur_instances')
			list=tmp_instance_list

		else:
			self.request.session['cur_instances'] = []
			
 		return list

	"""
	Collects data for all configurations from database
	returns for rendering as a list
	"""
	def get_config_overview_data(self):
		list = []
		cursor = Mydb.db.cursor(MySQLdb.cursors.DictCursor)

		cursor.execute("SELECT c.id, c.name, (SELECT count(*) \
		FROM instance_config i WHERE i.config_id = c.id) AS instances FROM configs c;")
		data = cursor.fetchall()
		for row in data:
			list.append(Config(str(row["id"]),row["name"],row["instances"]))
			LOG.info("rows in config = : %s"%row["name"])

 		return list


"""
Form for creating batches
warns user for overloading the system based on usage
"""
class CreateBatchView(forms.ModalFormView):
	form_class = CreateBatch
	template_name = 'syspanel/batch_setup/create_batch.html'
        
        def get_context_data(self, **kwargs):
		context = super(CreateBatchView, self).get_context_data(**kwargs)
		try:
                    usage_list = api.nova.usage_list(self.request,
					datetime(1970,1,1), datetime.today())
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

"""
Form for saving a configuration of instances
"""
class SaveConfigView(forms.ModalFormView):
	form_class = SaveConfig
	template_name = 'syspanel/batch_setup/save_config.html'

	def get_context_data(self, **kwargs):
		context = super(SaveConfigView, self).get_context_data(**kwargs)
		
		return context

"""
The view for editing a specific batch
Collects data from database
"""
class EditBatchView(forms.ModalFormView):
	form_class = EditBatch
	template_name = 'syspanel/batch_setup/edit_batch.html'
	context_object_name = 'batch_setup'
	def get_initial(self):
		
		return {'batch_id': self.kwargs['batch_id']}

	def get_object(self, *args, **kwargs):

		cursor = Mydb.db.cursor()

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
View for adding instances to a configuration
"""
class AddInstanceView(forms.ModalFormView):
	form_class = AddInstance
	template_name = 'syspanel/batch_setup/add_instance.html'

	"""
	Specifies arguments for specific instances
	"""
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
	"""
	Following methods specifies options for all arguments in an instance
	"""
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

