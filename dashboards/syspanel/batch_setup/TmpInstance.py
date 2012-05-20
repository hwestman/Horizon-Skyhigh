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
Class for instances that is used temporary while defining configurations
"""

class Tmp_Instance():
	id = ""
	name=""
	flavor = ""
	image_name = ""
	image_id = ""
	flavor_id = ""
	flavor_name=""
	def __init__(self,id,instance_name,image_id,image_name,flavor_id,flavor_name):

		self.id = id
		self.name = instance_name
		self.image_id = image_id
		self.image_name = image_name
		self.flavor_id = flavor_id
		self.flavor_name = flavor_name