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
│   └── etc
│       ├── haproxy
│       │   └── haproxy.cfg
│       └── varnish
│           └── default.vcl
├── hadoop-hbase-base
│   ├── Dockerfile
│   └── files
│       ├── bashrc
│       ├── hadoop-lzo.tar.gz
│       ├── hbase-env.cmd
│       └── hbase-env.sh
├── hadoop-hbase-master
│   ├── docker-entrypoint.sh
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── configure-members.sh
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── run-wordcount.sh
│       │   ├── start-hadoop.sh
│       │   ├── start-ssh-serf.sh
│       │   ├── stop-hadoop.sh
│       │   └── yarn-site.xml
│       └── hbase
│           ├── hbase-site.xml
│           ├── start-hbase.sh
│           └── stop-hbase.sh
├── hadoop-hbase-opentsdb-master
│   ├── Dockerfile
│   └── files
│       ├── config
│       ├── create_table.sh
│       ├── opentsdb
│       ├── opentsdb.conf
│       ├── rollup_config.json
│       └── start-opentsdb.sh
├── hadoop-hbase-opentsdb-slave
│   ├── Dockerfile
│   └── files
│       ├── config
│       ├── opentsdb
│       ├── opentsdb.conf
│       └── rollup_config.json
├── hadoop-hbase-slave
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── start-ssh-serf.sh
│       │   └── yarn-site.xml
│       └── hbase
│           └── hbase-site.xml
├── README.md
├── start-master.sh
└── start-slave.sh
```

