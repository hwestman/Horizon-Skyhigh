from keystoneclient.v2_0 import client

kst = client.Client(username="admin", password="melkikakao2012", tenant_name="openstackDemo", auth_url="http://192.168.10.2:5000/v2.0/")
for i in range(1,3):
	kst.tenants.create("jonas"+str(i))
