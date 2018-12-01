#!/bin/bash
/etc/init.d/docker stop
iptables -F
iptables -X
/etc/init.d/docker start

cd /root/new-monitoring-service
docker-compose up --force-recreate --build -d

iptables -N ssh
iptables -N crate

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m comment --comment "Related or established sessions" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m comment --comment "SSH traffic for port 22" -m tcp --dport 22 -j ssh
iptables -A INPUT -m comment --comment "traffic to cratedbcluster" -j crate 

# ssh
iptables -A ssh -s X.X.X.X/32 -m comment --comment "p8s-db02" -j ACCEPT #slave 1
#...
iptables -A ssh -m comment --comment "Drop all remaining traffic" -j REJECT --reject-with icmp-port-unreachable  

iptables -A crate -s X.X.X.X/32 -i eth0 -m comment --comment "access from slave01" -j ACCEPT
# ...
iptables -A crate -s X.X.X.X/32 -i eth0 -m comment --comment "access from p8s-master" -j ACCEPT
#...
iptables -A crate -i eth0 -j REJECT

