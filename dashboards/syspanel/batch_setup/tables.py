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

from horizon import api
from horizon import tables
from .forms import Tmp_Instance
import MySQLdb
import logging
import os
LOG=logging.getLogger(__name__)

"""
Following Classes are designed navigation and action links
Names are self explanatory
"""

class AddInstanceLink(tables.LinkAction):
    name = "add_instance"
    verbose_name = _("Add Instance")
    url = "horizon:syspanel:batch_setup:add_instance"
    classes = ("ajax-modal", "btn-create")

class CreateBatchLink(tables.LinkAction):
    name = "create_batch"
    verbose_name = _("Create Batch")
    url = "horizon:syspanel:batch_setup:create_batch"
    classes = ("ajax-modal", "btn-create")

class SaveConfig(tables.LinkAction):
    name = "save_config"
    verbose_name = _("Save Config")
    url = "horizon:syspanel:batch_setup:save_config"
    classes = ("ajax-modal", "btn-create")

class LoadConfig(tables.BatchAction):
    name = "load"
    action_present = (_("Load"), _("Unload"))
    action_past = (_("Loaded"), _("Unloaded"))
    data_type_singular = _("Config")
    data_type_plural = _("Configs")
    classes = ("btn-pause")

    def action(self, request, obj_id):
		LOG.info("from session %s"% obj_id)

		db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
		cursor = db.cursor(MySQLdb.cursors.DictCursor)
		cursor.execute("SELECT * FROM instance_config WHERE config_id='%s'" % obj_id)
		rows = cursor.fetchall()
		
		list = []
		for data in rows:
			list.append(Tmp_Instance(str(len(list)+1),data['name'], data['image_id'],data["image_name"],data['flavor_id'],data["flavor_name"]))

		request.session['cur_instances'] = list

class DeleteConfig(tables.DeleteAction):
	data_type_singular = _("Config")
	data_type_plural = _("Configs")

	def delete(self, request, obj_id):
		db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
		cursor = db.cursor()
		cursor.execute("DELETE FROM configs WHERE id='%s'" % obj_id)
		db.commit()
		cursor.close()

class EditBatchLink(tables.LinkAction):
    name = "edit_batch"
    verbose_name = _("Edit Batch")
    url = "horizon:syspanel:batch_setup:edit_batch"
    classes = ("ajax-modal", "btn-edit")

class DeleteInstance(tables.DeleteAction):
    data_type_singular = _("Instance")
    data_type_plural = _("Instances")

    def delete(self, request, obj_id):
		list = request.session['cur_instances']

		for i in list:
			if(i.id == obj_id):
				list.remove(i)

		request.session['cur_instances'] = list

"""
Extra documentation for this class is required, see the bachelor thesis for
complete understanding
https://github.com/hwestman/Horizon-Skyhigh
"""
class DeleteBatch(tables.DeleteAction):
    data_type_singular = _("Batch")
    data_type_plural = _("Batches")

    def delete(self, request, obj_id):
        db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
        cursor = db.cursor()
        cursor.execute( "SELECT tenant_id FROM batch_tenants WHERE batch_id='%s'" % obj_id )
        tenants = cursor.fetchall()
        instances = []
	try:
            instances = api.nova.server_list(request, all_tenants=True)
	except:
            LOG.info("Unable to retrive instance list")

        for tenant in tenants:				# For every project
            if instances:                               # If there is instnces in the tenant
                for inst in instances:			# Search every single instance
                    if inst.tenant_id == tenant[0]:	# Find those instances that belong to the project
                        LOG.info("Will delete instance %s" % inst.id)	
                        api.nova.server_delete(request, inst.id)                # Delete them
            else:
                LOG.info("No instances, will delete the other stuff")
                        
            users = api.keystone.user_list(request, tenant_id=tenant[0])	# Fetch all users in the project
            for user in users:								
                LOG.info("will remove %s from %s" % (user.name, tenant[0]) )	
                api.keystone.remove_tenant_user(request, tenant[0], user.id)	# Remove their roles in the project
                if not user.name == "admin":					# Delete all users but admin
                    LOG.info("Deleting user %s" % user.name)					
                    api.keystone.user_delete(request, user.id)
            os.system("/usr/bin/nova-manage project scrub %s" % tenant[0])  # Scrub project
            LOG.info("Deleting tenant %s" % tenant[0])			
            api.keystone.tenant_delete(request, tenant[0])	# Delete tenant
        cursor.execute("DELETE FROM batch WHERE id='%s'" % obj_id)
        db.commit()
        cursor.close()
                                
"""
Following classes configures their respective tables as views
"""
class BatchOverview(tables.DataTable):
	
	batch_name = tables.Column('name', verbose_name=_("Batch"))
	tenant_count = tables.Column('tenant_count', verbose_name=_("Number of tenants"))
	instance_count = tables.Column('instance_count', verbose_name=_("Number of instances"))

	class Meta:
		name = "batch_overview"
		verbose_name = _("Batches")
		table_actions = (DeleteBatch, )
		row_actions = (EditBatchLink,DeleteBatch, )

class ConfigOverview(tables.DataTable):
	
	config_name = tables.Column('name', verbose_name=_("Config"))
	instance_count = tables.Column('instance_count', verbose_name=_("Number of instances"))

	class Meta:
		name = "config_overview"
		verbose_name = _("Config Overview")
		row_actions = (LoadConfig, DeleteConfig, )

class InstanceSetup(tables.DataTable):

	name = tables.Column('name',verbose_name=_("Name"))
	flavor_name = tables.Column('flavor_name',verbose_name=_("Flavor"))
	image_name = tables.Column('image_name', verbose_name=_("Image"))

	class Meta:
		name = "instance_setup"
		verbose_name = _("Instance Setup")
		table_actions = (AddInstanceLink,CreateBatchLink, DeleteInstance, SaveConfig,)
		row_actions = (DeleteInstance,)

class TenantOverview(tables.DataTable):
	tenant_name = tables.Column('name', verbose_name=_("Tenant"))

	class Meta:
		name = "tenant_overview"
		verbose_name = _("Tenants")
