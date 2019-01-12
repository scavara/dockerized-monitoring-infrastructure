#!/bin/bash
/etc/init.d/docker stop
iptables -F
iptables -X
/etc/init.d/docker start

cd /root/new-monitoring-service
docker-compose up --force-recreate --build -d

iptables -N ssh

iptables -I DOCKER-USER -i ens3 -s $IP_OF_SLAVE01/32 -m comment --comment "p8s-slave01" -j ACCEPT
iptables -I DOCKER-USER -i ens3 -s $IP_OF_SALTMASTER/32 -m comment --comment "saltmaster" -j ACCEPT
iptables -I DOCKER-USER -p tcp -m multiport --dports 80,443 -m comment --comment "web" -j ACCEPT


iptables -A ssh -s $IP_OF_YOUSHOULDKNOWTHIS/32 -m comment --comment "foo" -j ACCEPT
iptables -A ssh -m comment --comment "Drop all remaining traffic" -j REJECT --reject-with icmp-port-unreachable  

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m comment --comment "Related or established sessions" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m comment --comment "SSH traffic for port 22" -m tcp --dport 22 -j ssh

iptables -I DOCKER -i ens3 -j DROP

