#!/bin/bash
br1="clab-br1"
br2="clab-br2"
br3="clab-br3"
l=lab2
f=$l.yml
h='wbitt/network-multitool:alpine-extra'
router='kbartontx/vyos:1.4'

# Create and enable clab_br1
sudo brctl delbr $br1
sudo brctl addbr $br1
sudo ip link set $br1 up
sudo iptables -I FORWARD -i $br1 -j ACCEPT

# Create and enable clab_br2
sudo brctl delbr $br2
sudo brctl addbr $br2
sudo ip link set $br2 up
sudo iptables -I FORWARD -i $br2 -j ACCEPT

# Create and enable clab_br3
sudo brctl delbr $br3
sudo brctl addbr $br3
sudo ip link set $br3 up
sudo iptables -I FORWARD -i $br3 -j ACCEPT

# Create yml file
cat << EOF > $f
name: $l
topology:
  nodes:
    h101:
      kind: linux
      image: $h
    h102:
      kind: linux
      image: $h
    h201:
      kind: linux
      image: $h
    h301:
      kind: linux
      image: $h
    clab-br1: 
      kind: bridge
    clab-br2: 
      kind: bridge
    clab-br3: 
      kind: bridge
    r1:
      kind: linux
      image: $router
    r2:
      kind: linux
      image: $router
    r3:
      kind: linux
      image: $router

  links:
    - endpoints: ["h101:eth1", "clab-br1:eth15"]
    - endpoints: ["h102:eth1", "clab-br1:eth16"]
    - endpoints: ["h201:eth1", "clab-br2:eth17"]
    - endpoints: ["h301:eth1", "r3:eth1"]
    - endpoints: ["r1:eth1", "clab-br1:eth10"]
    - endpoints: ["r2:eth1", "clab-br2:eth11"]
    - endpoints: ["r2:eth2", "clab-br3:eth12"]
    - endpoints: ["r3:eth2", "clab-br3:eth13"]
    - endpoints: ["r1:eth2", "clab-br3:eth14"]
mgmt: 
  network: mgmt
  ipv4_subnet: 172.20.0.0/24
  ipv6_subnet: 2001:172:20::/80  
EOF

# Deploy the clab topology
sudo clab deploy --topo $f

# Configure IPs on hosts
d="sudo docker"
a1=192.168.1.5/24
a2=192.168.1.215/24
a3=172.16.1.5/24
a4=10.0.0.10/24
eth1="dev eth1"
h1="clab-$l-h101"
h2="clab-$l-h102"
h3="clab-$l-h201"
h4="clab-$l-h301"
r1="clab-$l-r1"
r2="clab-$l-r2"
r3="clab-$l-r3"
conf="/opt/vyatta/etc/config/config.boot"
gw=172.20.0.1

$d exec -it $h1 ip addr add $a1 $eth1
$d exec -it $h2 ip addr add $a2 $eth1
$d exec -it $h3 ip addr add $a3 $eth1
$d exec -it $h4 ip addr add $a4 $eth1

# Configure default gateways on hosts
$d exec -it $h1 route add default gw 192.168.1.254 eth1
$d exec -it $h2 route add default gw 192.168.1.254 eth1
$d exec -it $h3 route add default gw 172.16.1.1 eth1
$d exec -it $h4 route add default gw 10.0.0.1 eth1

# Delete Docker default gateways
$d exec -it $h1 route delete default gw $gw eth0
$d exec -it $h2 route delete default gw $gw eth0
$d exec -it $h3 route delete default gw $gw eth0
$d exec -it $h4 route delete default gw $gw eth0

# Copy router config files
$d cp r1.config.boot $r1:$conf
$d cp r2.config.boot $r2:$conf
$d cp r3.config.boot $r3:$conf

printf "Wait 60 seconds to reboot routers\n"
sleep 30

printf "30 seconds left ...\n"
sleep 30
