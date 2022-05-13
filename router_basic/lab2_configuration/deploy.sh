#!/bin/bash
l=lab2
f=$l.yml
h='wbitt/network-multitool:alpine-extra'
router='kbartontx/vyos:1.4'

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
    h3:
      kind: linux
      image: $h
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
    - endpoints: ["h1:eth1", "r1:eth1"]
    - endpoints: ["h2:eth1", "r2:eth1"]
    - endpoints: ["h3:eth1", "r3:eth1"]
    - endpoints: ["r1:eth2", "r2:eth2"]
    - endpoints: ["r1:eth3", "r3:eth2"]
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
a1=192.168.17.50/25
a2=192.168.17.150/26
a3=192.168.17.200/27
b1="dev eth1"
h1="clab-$l-h1"
h2="clab-$l-h2"
h3="clab-$l-h3"
gw=172.20.0.1

$d exec -it $h1 ip addr add $a1 $b1
$d exec -it $h2 ip addr add $a2 $b1
$d exec -it $h3 ip addr add $a3 $b1

# Configure default gateways on hosts
$d exec -it $h1 route add default gw 192.168.17.1 eth1
$d exec -it $h2 route add default gw 192.168.17.129 eth1
$d exec -it $h3 route add default gw 192.168.17.193 eth1

# Delete Docker default gateways
$d exec -it $h1 route delete default gw $gw eth0
$d exec -it $h2 route delete default gw $gw eth0
$d exec -it $h3 route delete default gw $gw eth0

