from horizon import api
from horizon import tables


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


class BatchOverview(tables.DataTable):
	
	batch_name = tables.Column('batch_name', verbose_name=_("Batch"))
	tenant_count = tables.Column('tenant_count', verbose_name=_("Number of Tenants"))
	instance_count = tables.Column('instance_count')

	class Meta:
		name = "batch_overview"
		verbose_name = _("Batches")

class InstanceSetup(tables.DataTable):

	name = tables.Column('name',verbose_name=_("Name"))
	flavor_name = tables.Column('flavor_name',verbose_name=_("Flavor"))
	image_name = tables.Column('image_name', verbose_name=_("Image"))

	class Meta:
		name = "instance_setup"
		verbose_name = _("Instance Setup")
		table_actions = (AddInstanceLink,CreateBatchLink)

