#!/usr/bin/python
import MySQLdb

db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="melkikakao2012", db="dash")
cursor = db.cursor()
cursor.execute("SELECT COUNT(*) FROM batch")
data = cursor.fetchone()

print data[0]

#cursor.execute("INSERT INTO batch_tenants (batch_id,tenant_id) VALUES ('11', 'hgrr')")
#cursor.execute("INSERT INTO batch_tenants (batch_id,tenant_id) VALUES ('12','huff')")

#db.commit()

