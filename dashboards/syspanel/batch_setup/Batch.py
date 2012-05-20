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


"""
Batch
"""

import MySQLdb
#from db import Mydb

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