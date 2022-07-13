#!/bin/bash
br1="clab-br1"
l=lab1
f=$l.yml
h='wbitt/network-multitool:alpine-extra'
router='kbartontx/vyos:1.4'
dns='ubuntu/bind9:latest'

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
    h2:
      kind: linux
      image: $h
    dns1:
      kind: linux
      image: $dns
    dns2:
      kind: linux
      image: $dns
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
    - endpoints: ["r1:eth1", "h1:eth1"]
    - endpoints: ["r2:eth1", "h2:eth1"]
    - endpoints: ["dns1:eth1", "clab-br1:eth10"]
    - endpoints: ["dns2:eth1", "clab-br1:eth11"]
    - endpoints: ["r3:eth1", "clab-br1:eth12"]
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
a1=172.31.1.2/24
b1="dev eth1"
h1="clab-$l-h1"
r1="clab-$l-r1"
r2="clab-$l-r2"
r3="clab-$l-r3"
r4="clab-$l-r4"
r5="clab-$l-r5"
r6="clab-$l-r6"
r7="clab-$l-r7"
r8="clab-$l-r8"
conf="/opt/vyatta/etc/config/config.boot"
gw=172.20.0.1

$d exec -it $h1 ip addr add $a1 $b1

# Configure default gateways on hosts
$d exec -it $h1 route add default gw 172.31.1.1 eth1

# Delete Docker default gateways
$d exec -it $h1 route delete default gw $gw eth0

# Copy router config files
$d cp r1.config.boot $r1:$conf
$d cp r2.config.boot $r2:$conf
$d cp r3.config.boot $r3:$conf
$d cp r4.config.boot $r4:$conf
$d cp r5.config.boot $r5:$conf
$d cp r6.config.boot $r6:$conf
$d cp r7.config.boot $r7:$conf
$d cp r8.config.boot $r8:$conf

printf "Wait 120 seconds to reboot routers\n"
sleep 30

printf "90 seconds left ...\n"
sleep 30

printf "60 seconds left ... I know, but please wait\n"
sleep 30

printf "30 seconds left ... almost done, I promise\n"
sleep 30