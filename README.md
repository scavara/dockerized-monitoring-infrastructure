 # Dockerized monitoring infrastructure 
### Content
* [**What is it?**](#what-is-it)
* [**How to use it?**](#installation)
* [**How do I...?**](#how-do-i)

### What is it?
Basic setup of services such as prometheus, grafana, saltstack and few tsdb's to chose from. 

### How to use it? 
After cloning, checkout the appropriate branch for configs. Using one VM per branch.
Use "git branch -a" to view all the branches. 

- prometheus(-slave): hierarchical federated setup of prometheus master/slave, alertmanager, externals that should be placed on host server.
- saltmaster: used for file-based service discovery. This is not properly tested but, in theory at least, every time new minion is added to saltmaster (salt-key -a new_minion), it should generate (JSON) list of targets that p8s-slave can use in its file_sd_config. Also goes trough all minions, tries to test.ping them, and if true, checks if they have telegraf up and running. If not, it configures it on the minion(s). 
- cratedb-master|slave: simple cratedb cluster.

### How do I...?
>How do I access...?

Prometheus web console:
```https://p8s-master.YOUR_DOMAIN```
or
```http://p8s-master.YOUR_DOMAIN:9090```

Alertmanager:
```https://p8s-master.YOUR_DOMAIN/alertmanager```
or
```http://p8s-master.YOUR_DOMAIN:9093```

Cratedb cluster:
```http://p8s-db01.YOUR_DOMAIN:4200```

>How do I force saltstack master to regenerate targets file used for SD without adding new minion (key)?

Modify or create something within minions' PKI directory. Beacon and reactor should do the rest.

>How do I use local docker registry?

First obtain credentials by going to https://p8s-registry.YOUR_DOMAIN and sign in with your Google account and follow the instructions on how to login in.
To upload image, first get it from docker hub, for example:
```docker pull grafana/grafana```
Then tag it:
``` docker tag grafana/grafana p8s-registry.YOUR_DOMAIN/grafana/grafana```
And push it:
```docker push !$```

