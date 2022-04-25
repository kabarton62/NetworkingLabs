#!/bin/bash
br1="clab-br1"
br2="clab-br2"
f=lab1.yml

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

# Create yml file and write to lab1.yml
cat << EOF > $f
name: lab1
topology:
  nodes:
    h1:
      kind: linux
      image: ghcr.io/hellt/network-multitool
    h2:
      kind: linux
      image: ghcr.io/hellt/network-multitool
    h3:
      kind: linux
      image: ghcr.io/hellt/network-multitool
    h4:
      kind: linux
      image: ghcr.io/hellt/network-multitool 
    clab-br1: 
      kind: bridge
    clab-br2: 
      kind: bridge
    r1:
      kind: linux
      image: frrouting/frr:v7.5.0
      binds:
        - daemons:/etc/frr/daemons
    r2:
      kind: linux
      image: frrouting/frr:v7.5.0
      binds:
        - daemons:/etc/frr/daemons
  links:
    - endpoints: ["h1:eth1", "clab-br1:eth13"]
    - endpoints: ["h2:eth1", "clab-br1:eth14"]
    - endpoints: ["h3:eth1", "clab-br2:eth15"]
    - endpoints: ["h4:eth1", "clab-br2:eth16"]
    - endpoints: ["r1:eth1", "clab-br1:eth10"]
    - endpoints: ["r2:eth1", "clab-br2:eth11"]
    - endpoints: ["r1:eth2", "r2:eth2"]
EOF

# Deploy the clab topology
sudo clab deploy --topo $f

# Configure IPs on hosts
d="sudo docker"
l=$(cat $f|grep name: | cut -d " " -f2)
a1=192.168.1.10/24
a2=192.168.1.200/24
a3=192.168.2.15/24
a4=192.168.2.215/24
b1="dev eth1"
b2="dev eth1"
h1="clab-$l-h1"
h2="clab-$l-h2"
h3="clab-$l-h3"
h4="clab-$l-h4"
$d exec -it $h1 ip addr add $a1 $b1
$d exec -it $h2 ip addr add $a2 $b2
$d exec -it $h3 ip addr add $a3 $b1
$d exec -it $h4 ip addr add $a4 $b2

# Configure default gateways on hosts
$d exec -it $h1 route add default gw 192.168.1.1 eth1
$d exec -it $h2 route add default gw 192.168.1.1 eth1
$d exec -it $h3 route add default gw 192.168.2.1 eth1
$d exec -it $h4 route add default gw 192.168.2.1 eth1
