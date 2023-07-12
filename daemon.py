#! /bin/python3

import RNS
import os
#import RNS.vendor.umsgpack as msgpack
import time
import sqlite3


class APAnnounceHandler:
  def __init__(self, aspect_filter=None):
    self.aspect_filter = aspect_filter

  def received_announce(self, destination_hash, announced_identity, app_data):
    global databasepath
    con = sqlite3.connect(databasepath)
    c = con.cursor()
    print("Rc'd Announce")
    dirtyhash = (RNS.prettyhexrep(destination_hash))
    print("Destination Hash:   "+dirtyhash)
    cleanhash = dirtyhash.replace("<","")
    cleanhash = cleanhash.replace(">","")
#    print("Announced Identity: "+str(announced_identity))
    if app_data:
      print("Attached App_Data "+app_data.decode("utf-8"))
    query = "SELECT name from pages WHERE hash='"+cleanhash+"'"
    c.execute(query)
    if not c.fetchone():
      print("Making new entry")
      flags = 0
      blacklist = 0
      lastseen = time.time()
      cleanname = (app_data.decode("utf-8")).replace("`","")
      c.execute("INSERT INTO pages VALUES ('"+cleanname+"', '"+cleanhash+"', '"+str(lastseen)+"', "+str(blacklist)+", "+str(flags)+")")
      con.commit()
      con.close()
    else:
      print("Entry exists")





userdir = os.path.expanduser("~")
configdir = userdir+"/.AmberPages"
if not os.path.isdir(configdir):
  os.makedirs(configdir)

#identitypath = configdir+"/storage/identity"


reticulum = RNS.Reticulum()
identity = RNS.Identity()

destination_1 = RNS.Destination(
  identity,
  RNS.Destination.IN,
  RNS.Destination.SINGLE,
  "nomadnetwork", "node"
  )
RNS.log("Server addess: "+RNS.prettyhexrep(destination_1.hash))



storagepath = configdir+"/storage"
if not os.path.isdir(storagepath):
  os.makedirs(storagepath)
databasepath = storagepath+"/pages.db"
print(databasepath)
conn = sqlite3.connect(databasepath)
cur = conn.cursor()
query = "SELECT name from sqlite_master WHERE type = 'table' and name='pages'"
cur.execute(query)
if not cur.fetchone():
  print("Making new table")
  cur.execute("""CREATE TABLE pages (name TEXT, hash TEXT, lastseen TEXT, blacklist INT, flags INT)""")
  conn.commit()
else:
  print("Table exists")


announce_handler = APAnnounceHandler(aspect_filter="nomadnetwork.node")

RNS.Transport.register_announce_handler(announce_handler)

#cleanhash = "DEADBEEF"
#query = "SELECT name from pages WHERE hash='"+cleanhash+"'"
#cur.execute(query)
#if not cur.fetchone():
#  print("Making new entry")
#  flags = 0
#  blacklist = 0
#  lastseen = time.time()
#  cleanname = (app_data.decode("utf-8")).replace("`","")
#  cur.execute("INSERT INTO pages VALUES ('"+clean+"', '"+cleanhash+"', '"+lastseen+"', "+str(blacklist)+", "+str(flags)+")")
#  conn.commit()
#  conn.close()
#else:
#  print("Entry exists")



print(storagepath)

while True:
  time.sleep(10000)

#file = open(storagepath+"/known_destinations","rb")
#loaded_known_destinations = msgpack.load(file)
#file.close()

#print(type(loaded_known_destinations))

#known_destinations = {}
#for known_destination in loaded_known_destinations:
#  print(known_destination)
#  print(RNS.prettyhexrep(known_destination))
#  if len(known_destination) == RNS.Reticulum.TRUNCATED_HASHLENGTH//8:
#    known_destinations[known_destination] = loaded_known_destinations[known_destination]
#    print(loaded_known_destinations[known_destination][0])
#    print(time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(loaded_known_destinations[known_destination][0])))
#    print(loaded_known_destinations[known_destination][1])
#    print(loaded_known_destinations[known_destination][2])
#    if loaded_known_destinations[known_destination][3] != None:
#      print(loaded_known_destinations[known_destination][3].decode("UTF-8",errors="ignore"))



#RNS.log("Loaded "+str(len(known_destinations))+" known destination from storage")



#print(loaded_known_destinations)
print("Whee!")

