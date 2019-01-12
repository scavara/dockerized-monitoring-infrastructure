FROM YOUR_ORG/hadoop-hbase-master:1.3.2.1

ENV TSDB_VERSION 2.4.0RC2
ENV HBASE_VERSION 1.3.2.1
ENV HBASE_HOME /usr/local/hbase

RUN apt-get update -y && apt-get install -y --fix-missing gnuplot net-tools netcat vim less && \
apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN wget https://github.com/OpenTSDB/opentsdb/releases/download/v${TSDB_VERSION}/opentsdb-${TSDB_VERSION}_all.deb && \
dpkg -i opentsdb-${TSDB_VERSION}_all.deb && rm -rf opentsdb-${TSDB_VERSION}_all.deb 

RUN sed -i 's/^JAVA.*/JAVA=\/opt\/jdk\/bin\/java/' /usr/share/opentsdb/bin/tsdb 
RUN sed -i 's/TSD_USER=opentsdb/TSD_USER=root/' /etc/init.d/opentsdb
RUN sed -i 's/TSD_GROUP=opentsdb/TSD_GROUP=root/' /etc/init.d/opentsdb
RUN chown root:root /etc/init.d/opentsdb

COPY files/config /root/.ssh/config
COPY files/opentsdb /etc/default/opentsdb
COPY files/opentsdb.conf /etc/opentsdb/opentsdb.conf
COPY files/rollup_config.json /etc/opentsdb/rollup_config.json
COPY files/create_table.sh /usr/share/opentsdb/tools/create_table.sh
COPY files/start-opentsdb.sh /root/start-opentsdb.sh
RUN chmod +x /root/start-opentsdb.sh

EXPOSE 4242 2818 60000 60010
