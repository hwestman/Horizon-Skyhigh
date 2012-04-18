from horizon import api
from horizon import tables
import MySQLdb
import logging
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
    classes = ("ajax-modal", "btn-edit")

class DeleteInstance(tables.DeleteAction):
    data_type_singular = _("Instance")
    data_type_plural = _("Instances")

    def delete(self, request, obj_id):
        LOG.info("got back : %s"% obj_id)

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

	if instances:
            for tenant in tenants:									# For every project
                for inst in instances:								# Search every single instance
                    if inst.tenant_id == tenant[0]:					# Find those instances that belong to the project
                        LOG.info("Will delete instance %s" % inst.id)	
			#api.nova.server_delete(request, inst.id)	# Delete them
			users = api.keystone.user_list(request, tenant_id=tenant)	# Fetch all users in the project
			for user in users:											
                            LOG.info("will remove %s from %s" % (user.name, tenant) )				
				#api.keystone.remove_tenant_user(request, tenant, user.id)	# Remove their roles in the project
                            if not user.name == "admin":							# Delete all users but admin
                                LOG.info("Deleting user %s" % user.name)					
                                #api.keystone.user_delete(request, user.id)
			# Scrub project
			LOG.info("Deleting tenant %s" % tenant)			
			#api.keystone.tenant_delete(request, tenant)	# Delete tenant
        else:
            LOG.info("no instances..!")
                                


class BatchOverview(tables.DataTable):
	
	batch_name = tables.Column('name', verbose_name=_("Batch"))
	tenant_count = tables.Column('tenant_count', verbose_name=_("Number of tenants"))
	instance_count = tables.Column('instance_count', verbose_name=_("Number of instances"))

	class Meta:
		name = "batch_overview"
		verbose_name = _("Batches")
		table_actions = (DeleteBatch, )
		row_actions = (DeleteBatch, )

class InstanceSetup(tables.DataTable):

	name = tables.Column('name',verbose_name=_("Name"))
	flavor_name = tables.Column('flavor_name',verbose_name=_("Flavor"))
	image_name = tables.Column('image_name', verbose_name=_("Image"))

	class Meta:
		name = "instance_setup"
		verbose_name = _("Instance Setup")
		table_actions = (AddInstanceLink,CreateBatchLink)
		row_actions = (DeleteInstance, )

