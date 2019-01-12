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


