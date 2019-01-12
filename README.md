# Dockerized monitoring infrastructure 
### Content
* [**What is it?**](#what-is-it)
* [**How to use it?**](#installation)
* [**How do I...?**](#how-do-i)

### What is it?
Basic setup of services such as prometheus, grafana, saltstack, haproxy and few tsdb's to chose from (OpenTSDB or CrateDB). 

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

### README dumps from other branches
cratedb-master
# tree
Go trough configs and adjust whereever you see CAPITALISED settings/values.
```
├── crate.yml
├── docker-compose.yml
├── externals
│   └── root
│       └── start.sh
└── README.md
```
cratedb-slave
# tree
Go trough configs and adjust whereever you see CAPITALISED settings/values.
```
├── crate.yml
├── docker-compose.yml
├── externals
│   └── root
│       └── start.sh
└── README.md
```
hadoop-hbase-opentsdb
# Thanks 
https://github.com/sebge2emasphere
https://github.com/krejcmat

#Building images
```sh
cd hadoop-hbase-base
docker build -t YOUR_ORG/hadoop-hbase-base:1.3.2.1 .
cd ..
cd hadoop-hbase-master
docker build -t YOUR_ORG/hadoop-hbase-master:1.3.2.1 .
cd ..
cd hadoop-hbase-slave
docker build -t YOUR_ORG/hadoop-hbase-slave:1.3.2.1 .
cd ..
hadoop-hbase-opentsdb-slave
docker build -t YOUR_ORG/hadoop-hbase-opentsdb-slave:2.4.0RC2 .
cd ..
cd hadoop-hbase-opentsdb-master
docker build -t YOUR_ORG/hadoop-hbase-opentsdb-master:2.4.0RC2 .
cd ..
```

#Taging images
```sh
docker tag YOUR_ORG/hadoop-hbase-base:1.3.2.1 p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-base:1.3.2.1
docker tag YOUR_ORG/hadoop-hbase-master:1.3.2.1 p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-master:1.3.2.1
docker tag YOUR_ORG/hadoop-hbase-slave:1.3.2.1 p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-slave:1.3.2.1
docker tag YOUR_ORG/hadoop-hbase-opentsdb-slave:2.4.0RC2 p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-slave:2.4.0RC2
docker tag YOUR_ORG/hadoop-hbase-opentsdb-master:2.4.0RC2 p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-master:2.4.0RC2
```

#Push images
```sh
docker login p8s-registry.YOUR_DOMAIN
docker push p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-slave:2.4.0RC2
docker push p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-base:1.3.2.1
docker push p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-master:1.3.2.1
docker push p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-slave:1.3.2.1
docker push p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-master:2.4.0RC2
```
#Pull images
```sh
docker pull p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-slave:2.4.0RC2
docker pull p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-master:2.4.0RC2
docker pull p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-master:1.3.2.1
docker pull p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-base:1.3.2.1
docker pull p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-slave:1.3.2.1

docker tag p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-slave:1.3.2.1 YOUR_ORG/hadoop-hbase-slave:1.3.2.1
docker tag p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-base:1.3.2.1 YOUR_ORG/hadoop-hbase-base:1.3.2.1
docker tag p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-master:1.3.2.1 YOUR_ORG/hadoop-hbase-master:1.3.2.1
docker tag p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-master:2.4.0RC2 YOUR_ORG/hadoop-hbase-opentsdb-master:2.4.0RC2
docker tag p8s-registry.YOUR_DOMAIN/YOUR_ORG/hadoop-hbase-opentsdb-slave:2.4.0RC2 YOUR_ORG/hadoop-hbase-opentsdb-slave:2.4.0RC2
```
#Create table on first run (hadoop-hbase-opentsdb-master)
```sh
env COMPRESSION=LZO HBASE_HOME=/usr/local/hbase /usr/share/opentsdb/tools/create_table.sh
touch /opt/opentsdb_tables_created.txt
```

#Start containers
./start-master.sh
OR
./start-slave.sh
#Tree
```
├── externals
│   └── etc
│       ├── haproxy
│       │   └── haproxy.cfg
│       └── varnish
│           └── default.vcl
├── hadoop-hbase-base
│   ├── Dockerfile
│   └── files
│       ├── bashrc
│       ├── hadoop-lzo.tar.gz
│       ├── hbase-env.cmd
│       └── hbase-env.sh
├── hadoop-hbase-master
│   ├── docker-entrypoint.sh
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── configure-members.sh
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── run-wordcount.sh
│       │   ├── start-hadoop.sh
│       │   ├── start-ssh-serf.sh
│       │   ├── stop-hadoop.sh
│       │   └── yarn-site.xml
│       └── hbase
│           ├── hbase-site.xml
│           ├── start-hbase.sh
│           └── stop-hbase.sh
├── hadoop-hbase-opentsdb-master
│   ├── Dockerfile
│   └── files
│       ├── config
│       ├── create_table.sh
│       ├── opentsdb
│       ├── opentsdb.conf
│       ├── rollup_config.json
│       └── start-opentsdb.sh
├── hadoop-hbase-opentsdb-slave
│   ├── Dockerfile
│   └── files
│       ├── config
│       ├── opentsdb
│       ├── opentsdb.conf
│       └── rollup_config.json
├── hadoop-hbase-slave
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── start-ssh-serf.sh
│       │   └── yarn-site.xml
│       └── hbase
│           └── hbase-site.xml
├── README.md
├── start-master.sh
└── start-slave.sh
```

prometheus
# tree
Go trough configs and adjust wherever you see CAPITALISED settings/values.
```
├── bins
│   └── oauth2_proxy
├── configs
│   ├── alerting-rules.d
│   │   └── first.rules
│   ├── alertmanager.yml
│   ├── nginx
│   │   ├── certs.d
│   │   │   ├── YOUR_PROPER.crt
│   │   │   └── YOUR_PROPER.key
│   │   ├── nginx.conf
│   │   └── sites.d
│   │       └── p8s-master
│   ├── oauth2_proxy.cfg
│   ├── prometheus.yml
│   ├── recording-rules.d
│   │   └── first.rules
│   ├── registry-auth.yml
│   └── registry.yml
├── docker-compose.yml
└── externals
    ├── etc
    │   ├── crate_adapter
    │   │   └── config.yml
    │   ├── postfix
    │   │   └── main.cf
    │   └── systemd
    │       └── system
    │           └── crate_adapter.service
    ├── root
    │   └── start.sh
    └── usr
        └── local
            └── sbin
                ├── amtool
                ├── crate_adapter
                └── promtool
```
prometheus-slave
# tree  
Go trough configs and adjust whereever you see CAPITALISED settings/values.
```
├── configs
│   ├── alerting-rules.d
│   │   └── first.rules
│   ├── prometheus.yml
│   └── recording-rules.d
│       └── first.rules
├── docker-compose.yml
├── externals
│   ├── root
│   │   └── start.sh
│   └── usr
│       └── local
│           └── sbin
│               ├── amtool
│               ├── crate_adapter
│               └── promtool
└── README.md
```
saltmaster
# tree
Go trough configs and adjust whereever you see CAPITALISED settings/values.
```
├── etc
│   └── salt
│       ├── master.d
│       │   └── reactor.conf
│       ├── minion.d
│       │   └── beacons.conf
│       └── pki
│           └── master
│               └── minions
│                   └── exclude_me
├── README.md
└── srv
    ├── reactor
    │   └── p8s-file_sd_config.sls
    └── salt
        ├── p8s
        │   ├── config.sls
        │   ├── files
        │   │   ├── p8s-telegraf.logrotate.jinja
        │   │   ├── targets.json
        │   │   ├── targets.sha1
        │   │   └── telegraf
        │   │       ├── etc
        │   │       │   └── telegraf
        │   │       │       └── telegraf.conf.jinja
        │   │       ├── scripts
        │   │       │   ├── init.sh
        │   │       │   ├── telegraf
        │   │       │   └── telegraf.service
        │   │       └── usr
        │   │           └── bin
        │   │               └── telegraf
        │   ├── generate-p8s-file_sd_config.sls
        │   ├── init.sls
        │   └── logging.sls
        └── _runners
            ├── p8s-file_sd_config.py
            └── p8s-file_sd_config.pyc
```
