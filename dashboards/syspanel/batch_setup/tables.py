from horizon import api
from horizon import tables
import MySQLdb
import logging
import os
LOG=logging.getLogger(__name__)


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

class EditBatchLink(tables.LinkAction):
    name = "edit_batch"
    verbose_name = _("Edit Batch")
    url = "horizon:syspanel:batch_setup:edit_batch"
    classes = ("btn-edit",)

class DeleteInstance(tables.DeleteAction):
    data_type_singular = _("Instance")
    data_type_plural = _("Instances")

    def delete(self, request, obj_id):
		list = request.session['cur_instances']

		for i in list:
			if(i.id == obj_id):
				list.remove(i)

		request.session['cur_instances'] = list

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
                                


class BatchOverview(tables.DataTable):
	
	batch_name = tables.Column('name', verbose_name=_("Batch"))
	tenant_count = tables.Column('tenant_count', verbose_name=_("Number of tenants"))
	instance_count = tables.Column('instance_count', verbose_name=_("Number of instances"))

	class Meta:
		name = "batch_overview"
		verbose_name = _("Batches")
		table_actions = (DeleteBatch, )
		row_actions = (DeleteBatch,EditBatchLink, )

class InstanceSetup(tables.DataTable):

	name = tables.Column('name',verbose_name=_("Name"))
	flavor_name = tables.Column('flavor_name',verbose_name=_("Flavor"))
	image_name = tables.Column('image_name', verbose_name=_("Image"))

	class Meta:
		name = "instance_setup"
		verbose_name = _("Instance Setup")
		table_actions = (AddInstanceLink,CreateBatchLink, DeleteInstance)
		row_actions = (DeleteInstance,)

class TenantOverview(tables.DataTable):
	tenant_name = tables.Column('name', verbose_name=_("Tenant"))

	class Meta:
		name = "tenant_overview"
		verbose_name = _("Tenants")
