#!/bin/bash

tag=2.4.0RC2
MASTER="p8s-db01.YOUR_DOMAIN"

docker rm -f $MASTER

service docker stop
iptables -F
iptables -X
service docker start

echo "start master container..."
docker run -d -t --rm --net=host -v /mnt/root:/root --name $MASTER -h $MASTER -w /root YOUR_ORG/hadoop-hbase-opentsdb-master:$tag

iptables -N ssh

iptables -I DOCKER-USER -i eth0 -s YOUR_P8SDB02_IP/32 -m comment --comment "p8s-db02" -j ACCEPT
iptables -I DOCKER-USER -i eth0 -s YOUR P8SMASTER_IP -m comment --comment "p8s-master" -j ACCEPT
iptables -I DOCKER-USER -i eth0 -s YOUR_HAPROXY_IP_OR_WHATEVER_YOU_USE_FOR_LB/32 -m comment --comment "haproxy01" -j ACCEPT


iptables -A ssh -s YOUSHOULDKNOWTHIS/32 -m comment --comment "foo" -j ACCEPT
iptables -A ssh -m comment --comment "Drop all remaining traffic" -j REJECT --reject-with icmp-port-unreachable  

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m comment --comment "Related or established sessions" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m comment --comment "SSH traffic for port 22" -m tcp --dport 22 -j ssh

iptables -I DOCKER -i eth0 -j DROP

