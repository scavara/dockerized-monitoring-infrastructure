FROM sebge2/hadoop-base:latest
MAINTAINER sgerard <sgerard@emasphere.com>

# move all configuration files into container
ADD files/* /usr/local/  

#install hbase 
RUN wget -q -o out.log -P /tmp https://apache.org/dist/hbase/1.3.2.1/hbase-1.3.2.1-bin.tar.gz && \
tar xzf /tmp/hbase-1.3.2.1-bin.tar.gz -C /usr/local && \
rm /tmp/hbase-1.3.2.1-bin.tar.gz && \
mv /usr/local/hbase-1.3.2.1 /usr/local/hbase && \
mv /usr/local/hbase-env.sh /usr/local/hbase/conf/hbase-env.sh  && \
mv /usr/local/hbase-env.cmd /usr/local/hbase/conf/hbase-env.cmd  && \
mv /usr/local/bashrc ~/.bashrc

COPY files/hadoop-lzo.tar.gz /tmp/
RUN cd /tmp/ && tar zxf hadoop-lzo.tar.gz && cp -rf native /usr/local/hbase/lib && cp hadoop-lzo-0.4.15.jar /usr/local/hbase/lib && rm -rf native hadoop-lzo*

RUN apt-get download manpages && dpkg -i --force-all *.deb
RUN apt-get -y update && apt-get -y install liblzo2-dev
