#!/usr/bin/python
#scavara @2018
import sys
import salt.runner
import subprocess
import json
import re
import hashlib
from os import listdir

nodes_dir = '/etc/salt/pki/master/minions/'
store_file = '/srv/salt/p8s/files/targets.json'
store_hash = '/srv/salt/p8s/files/targets.sha1' 
target = {"targets": []}
targets = []
label = {}

for n in listdir(nodes_dir):
    # assigne telegraf port to target node
    np = n + ':9273'
    # add target with port to targets list
    target["targets"] = np.split()
    # target n must be fqdn, otherwise skip
    if re.match('(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)',n):
        # extract hostname from fqdn for env checking        
        host = n.split('.')[0]
        # exttract domain from fqdn used to named the job
        domain = n.split('.')[1]
        job = 'job-' + domain
        if re.match('.*staging', host) is not None:
            env = 'staging'
        else:
            env = 'prod'
        label["labels"] = { "env": env, "job": job }
        target.update(label)
        targets.append(target.copy())

f=open(store_file, 'w')
f.seek(0)
f.truncate()
f.write(json.dumps(targets,sort_keys=True, indent=2))
f.close()

r=open(store_file)
sha1 = hashlib.sha1(r.read()).hexdigest()

f=open(store_hash, 'w')
f.seek(0)
f.truncate()
f.write(sha1)
f.close()

