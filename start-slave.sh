#!/bin/bash

tag=2.4.0RC2
SLAVE="p8s-db02.YOUR_DOMAIN"

docker rm -f $MASTER

service docker stop
iptables -F
iptables -X
service docker start

# get the IP address of master container
MASTER_IP=$(host $MASTER | awk '{print $4}')
echo "start slave container..."
docker run -d -t --rm --net=host --name $SLAVE -h $SLAVE -e JOIN_IP=$MASTER_IP YOUR_ORG/hadoop-hbase-opentsdb-slave:$tag 

iptables -N ssh

iptables -I DOCKER-USER -i eth0 -s YOUR_P8SDB01_IP/32 -m comment --comment "p8s-db01" -j ACCEPT
iptables -I DOCKER-USER -i eth0 -s YOUR P8SMASTER_IP -m comment --comment "p8s-master" -j ACCEPT
iptables -I DOCKER-USER -i eth0 -s YOUR_HAPROXY_IP_OR_WHATEVER_YOU_USE_FOR_LB/32 -m comment --comment "haproxy" -j ACCEPT


iptables -A ssh -s YOUSHOULDKNOWTHIS/32 -m comment --comment "foo" -j ACCEPT
iptables -A ssh -m comment --comment "Drop all remaining traffic" -j REJECT --reject-with icmp-port-unreachable  

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m comment --comment "Related or established sessions" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m comment --comment "SSH traffic for port 22" -m tcp --dport 22 -j ssh

iptables -I DOCKER -i eth0 -j DROP

