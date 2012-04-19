# vim: tabstop=4 shiftwidth=4 softtabstop=4

# Copyright 2012 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
# Copyright 2012 Nebula, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

from django.conf.urls.defaults import patterns, url
from .views import IndexView, CreateBatchView, AddInstanceView, EditBatchView

urlpatterns = patterns('horizon.dashboards.syspanel.batch_setup.views',
    url(r'^$', IndexView.as_view(), name='index'),
	url(r'^create_batch/$', CreateBatchView.as_view(), name='create_batch'),
	url(r'^add_instance/$', AddInstanceView.as_view(), name='add_instance'),
	url(r'^(?P<batch_id>[^/]+)/edit_batch/$', EditBatchView.as_view(), name='edit_batch'),)


	