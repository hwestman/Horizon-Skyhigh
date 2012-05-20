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

from django.conf.urls.defaults import patterns, url
from .views import IndexView, CreateBatchView, AddInstanceView, EditBatchView, SaveConfigView

urlpatterns = patterns('horizon.dashboards.syspanel.batch_setup.views',
    url(r'^$', IndexView.as_view(), name='index'),
	url(r'^create_batch/$', CreateBatchView.as_view(), name='create_batch'),
    url(r'^save_config/$', SaveConfigView.as_view(), name='save_config'),
	url(r'^add_instance/$', AddInstanceView.as_view(), name='add_instance'),
	url(r'^(?P<batch_id>[^/]+)/edit_batch/$', EditBatchView.as_view(), name='edit_batch'),)


	