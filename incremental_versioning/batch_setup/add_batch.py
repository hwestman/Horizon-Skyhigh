#!/usr/bin/python
import MySQLdb
db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
cursor = db.cursor()

batch = "kari"
batch_id = 8
tenants = ["12"]
cursor.execute("INSERT INTO batch_tenants (batch_id,tenant_id) VALUES ('%s','%s')"%(batch_id, batch))
db.commit()
