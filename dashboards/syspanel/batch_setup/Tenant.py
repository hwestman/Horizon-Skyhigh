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
Tenats
"""
class Tenant():
	id = ""
	name = "kaare"
	def __init__(self,id):
		self.id = str(id)