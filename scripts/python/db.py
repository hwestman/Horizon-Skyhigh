#!/usr/bin/python

import MySQLdb

db = MySQLdb.connect("localhost","nova","melkikakao2012","nova")
cursor = db.cursor()
sql = "UPDATE instances SET project_id='615f89019f6a44bba476ec372b3a5a4a' WHERE id=1988"
try:
	cursor.execute(sql)
	db.commit()
except:
	db.rollback()

db.close()
