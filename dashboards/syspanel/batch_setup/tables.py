from horizon import api
from horizon import tables
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
		list = request.session['cur_instances']

		for i in list:
			if(i.id == obj_id):
				list.remove(i)

		request.session['cur_instances'] = list

class DeleteBatch(tables.DeleteAction):
    data_type_singular = _("Batch")
    data_type_plural = _("Batches")

    def delete(self, request, obj_id):
        LOG.info("got back in deletebatch : %s"% obj_id)


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

