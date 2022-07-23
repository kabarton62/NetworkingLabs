#!/bin/bash
br1="clab-br1"
l=lab1
f=$l.yml
h='kbartontx/network-tools:latest'
router='kbartontx/vyos:1.4'
dhcp='kbartontx/dhclient:latest'
dns='kbartontx/bind9:latest'
web='kbartontx/apache2.4.49:cve-2021-41773'

# Create and enable clab_br1
sudo brctl delbr $br1
sudo brctl addbr $br1
sudo ip link set $br1 up
sudo iptables -I FORWARD -i $br1 -j ACCEPT

# Create yml file and write to lab1.yml
cat << EOF > $f
name: $l
topology:
  nodes:
    h1:
      kind: linux
      image: $h
      publish: tcp/2222
    h2:
      kind: linux
      image: $dhcp
    dns1:
      kind: linux
      image: $dns
    dns2:
      kind: linux
      image: $dns
    web:
      kind: linux
      image: $web
    r1:
      kind: linux
      image: $router
    r2:
      kind: linux
      image: $router
    r3:
      kind: linux
      image: $router
    clab-br1: 
      kind: bridge
  links:
    - endpoints: ["r1:eth1", "h1:eth2"]
    - endpoints: ["r2:eth1", "h2:eth1"]
    - endpoints: ["dns1:eth1", "clab-br1:eth10"]
    - endpoints: ["dns2:eth1", "clab-br1:eth11"]
    - endpoints: ["web:eth1", "clab-br1:eth12"]
    - endpoints: ["r3:eth1", "clab-br1:eth13"]
    - endpoints: ["r1:eth2", "r2:eth2"]
    - endpoints: ["r2:eth3", "r3:eth3"]
mgmt: 
  network: mgmt
  ipv4_subnet: 172.20.0.0/24
  ipv6_subnet: 2001:172:20::/80  
EOF

# Deploy the clab topology
sudo clab deploy --topo $f

# Configure IPs on hosts
d="sudo docker"
a1=10.200.1.11/24
a2=10.200.1.12/24
a3=10.200.1.20/24
a4=10.100.1.65/24
b1="dev eth1"
h1="clab-$l-h1"
h2="clab-$l-h2"
w="clab-$l-web"
dns1="clab-$l-dns1"
dns2="clab-$l-dns2"
r1="clab-$l-r1"
r2="clab-$l-r2"
r3="clab-$l-r3"
conf="/opt/vyatta/etc/config/config.boot"
gw=172.20.0.1

# Configure static IP addresses
$d exec -it $dns1 ip addr add $a1 $b1
$d exec -it $dns2 ip addr add $a2 $b1
$d exec -it $w ip addr add $a3 $b1
$d exec -it $h1 ip addr add $a4 $b1

# Configure default gateways on hosts
$d exec -it $h1 route add default gw 10.100.1.1 eth1
$d exec -it $dns1 route add default gw 10.200.1.1 eth1
$d exec -it $dns2 route add default gw 10.200.1.1 eth1
$d exec -it $w route add default gw 10.200.1.1 eth1

# Delete Docker default gateways
# $d exec -it $h1 route delete default gw $gw eth0
$d exec -it $h2 route delete default gw $gw eth0
$d exec -it $w route delete default gw $gw eth0

# Create /config directory on r1 and r2 to start dhcp servers
$d exec -it $r1 mkdir /config
$d exec -it $r2 mkdir /config

# Copy router config files
$d cp r1.config.boot $r1:$conf
$d cp r2.config.boot $r2:$conf
$d cp r3.config.boot $r3:$conf

# Prohibit password login for ssh
$d exec -it $h1 sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    sed -i 's/#UsePAM yes/UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PrintMotd yes/PrintMotd yes/g' /etc/ssh/sshd_config

# Create ssh host keys and start ssh server
$d exec -it $h1 ssh-keygen -A
$d exec -it $h1 /etc/init.d/ssh

printf "Wait 120 seconds to reboot routers\n"
sleep 30

printf "90 seconds left ...\n"
sleep 30

printf "60 seconds left ... I know, but please wait\n"
sleep 30

printf "30 seconds left ... almost done, I promise\n"
sleep 30
