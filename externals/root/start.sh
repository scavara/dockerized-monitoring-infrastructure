#!/bin/bash
/etc/init.d/docker stop
iptables -F
iptables -X
/etc/init.d/docker start

cd /TO/LOCATION/OF/DOCKER_COMPOSE_FILE
docker-compose up --force-recreate --build -d

iptables -N ssh
iptables -N p8s

#commons
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m comment --comment "Related or established sessions" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m comment --comment "SSH traffic for port 22" -m tcp --dport 22 -j ssh
iptables -A INPUT -m comment --comment "container traffic" -j p8s 

#ssh rules
iptables -A ssh -s X.X.X.X/32 -m comment --comment "access from other location" -j ACCEPT
#...
iptables -A ssh -m comment --comment "Drop all remaining traffic" -j REJECT --reject-with icmp-port-unreachable  

#docker
iptables -A p8s -s 172.17.0.0/16 -i docker0 -m comment --comment "access between containers" -j ACCEPT
iptables -A p8s -s X.X.X.X/32 -i ens3 -m comment --comment "access from other location" -j ACCEPT
#...
iptables -A p8s -i ens3 -j REJECT

