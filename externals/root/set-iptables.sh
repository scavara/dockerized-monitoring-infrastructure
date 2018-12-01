#!/bin/bash
/etc/init.d/docker stop
iptables -F
iptables -X
/etc/init.d/docker start

cd /TO/CLONE/LOCATION #(where you docker compose is)
docker-compose up --force-recreate --build -d

iptables -N ssh

iptables -I DOCKER-USER -i ens3 -s X.X.X.X/32 -m comment --comment "access from p8s-slave01" -j ACCEPT
iptables -I DOCKER-USER -i ens3 -s X.X.X.X/32 -m comment --comment "access from some other location such as VPN..." -j ACCEPT
iptables -I DOCKER-USER -p tcp -m multiport --dports 80,443 -m comment --comment "web access" -j ACCEPT

# ssh access 
iptables -A ssh -s X.X.X.X/32 -m comment --comment "p8s-db01" -j ACCEPT
#...and so on.
iptables -A ssh -m comment --comment "Drop all remaining traffic" -j REJECT --reject-with icmp-port-unreachable  

# common rules
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m comment --comment "Related or established sessions" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m comment --comment "SSH traffic for port 22" -m tcp --dport 22 -j ssh

iptables -I DOCKER -i ens3 -j DROP

