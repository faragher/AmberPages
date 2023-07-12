#! /bin/python3

import RNS
import sqlite3
import time
import os

# modified from RNS/Utilities/rnx.py
def pretty_time(time, verbose=False):
    days = int(time // (24 * 3600))
    time = time % (24 * 3600)
    hours = int(time // 3600)
    time %= 3600
    minutes = int(time // 60)
    time %= 60
    seconds = round(time, 2)
    ss = "" if seconds == 1 else "s"
    sm = "" if minutes == 1 else "s"
    sh = "" if hours == 1 else "s"
    sd = "" if days == 1 else "s"

    components = []
    if days > 0:
        components.append(str(days)+" day"+sd if verbose else str(days)+"d")
    elif hours > 0:
        components.append(str(hours)+" hour"+sh if verbose else str(hours)+"h")
    elif minutes > 0:
        components.append(str(minutes)+" minute"+sm if verbose else str(minutes)+"m")
    elif seconds > 0:
        components.append(str(seconds)+" second"+ss if verbose else str(seconds)+"s")

    i = 0
    tstr = ""
    for c in components:
        i += 1
        if i == 1:
            pass
        elif i < len(components):
            tstr += ", "
        elif i == len(components):
            tstr += " and "
        tstr += c
    return tstr

print("`F999╔═══════════════════════════════════════════════════════════╗")
print("║┌─────────────────────────────────────────────────────────┐║")
print("║│`Ffb0████████╗██╗  ██╗███████╗                                `F999│║")
print("║│`Ffb0╚══██╔══╝██║  ██║██╔════╝                                `F999│║")
print("║│`Ffb0   ██║   ███████║█████╗                                  `F999│║")
print("║│`Ffb0   ██║   ██╔══██║██╔══╝                                  `F999│║")
print("║│`Ffb0   ██║   ██║  ██║███████╗                                `F999│║")
print("║│`Ffb0   ╚═╝   ╚═╝  ╚═╝╚══════╝                                `F999│║")
print("║│                                                         │║")
print("║│`Ffb0         █████╗ ███╗   ███╗██████╗ ███████╗██████╗       `F999│║")
print("║│`Ffb0        ██╔══██╗████╗ ████║██╔══██╗██╔════╝██╔══██╗      `F999│║")
print("║│`Ffb0        ███████║██╔████╔██║██████╔╝█████╗  ██████╔╝      `F999│║")
print("║│`Ffb0        ██╔══██║██║╚██╔╝██║██╔══██╗██╔══╝  ██╔══██╗      `F999│║")
print("║│`Ffb0        ██║  ██║██║ ╚═╝ ██║██████╔╝███████╗██║  ██║      `F999│║")
print("║│`Ffb0        ╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝      `F999│║")
print("║│                                                         │║")
print("║│`Ffb0                ██████╗  █████╗  ██████╗ ███████╗███████╗`F999│║")
print("║│`Ffb0                ██╔══██╗██╔══██╗██╔════╝ ██╔════╝██╔════╝`F999│║")
print("║│`Ffb0                ██████╔╝███████║██║  ███╗█████╗  ███████╗`F999│║")
print("║│`Ffb0                ██╔═══╝ ██╔══██║██║   ██║██╔══╝  ╚════██║`F999│║")
print("║│`Ffb0                ██║     ██║  ██║╚██████╔╝███████╗███████║`F999│║")
print("║│`Ffb0                ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝`F999│║")
print("║└─────────────────────────────────────────────────────────┘║")
print("║  `B444`Feef                `F999`b                                  ┌────┐ ║")
print("║  `B444`Feef  NomadNetwork  `F999`b                                  │`Ffaa░░░░`F999│ ║")
print("║  `B444`Feef                `F999`b                                  └────┘ ║")
print("╚═══════════════════════════════════════════════════════════╝")
print("``")
print("")

#print("The Amber Pages")
print("Hosted by Between the Borders")
print("")

userdir = os.path.expanduser("~")
configdir = userdir+"/.AmberPages"
if not os.path.isdir(configdir):
  os.makedirs(configdir)

storagepath = configdir+"/storage"
if not os.path.isdir(storagepath):
  os.makedirs(storagepath)
databasepath = storagepath+"/pages.db"
conn = sqlite3.connect(databasepath)
cur = conn.cursor()
query = "SELECT name, hash, lastseen from pages ORDER BY name ASC"
cur.execute(query)
oneline = cur.fetchone()
if not oneline:
  print("No entries found! Please contact SYSOP.")
else:
  while oneline:
    #print(oneline)
    lastseen = float(oneline[2])
    delta = time.time() - lastseen
    delta = pretty_time(delta)
    print("`Ffb0`["+oneline[0] +"`"+oneline[1]+":/page/index.mu]`f - Last seen "+delta+" ago")
    oneline = cur.fetchone()
    print("")

conn.close()



