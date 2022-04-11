#!/bin/bash
br1="clab-br1"
br2="clab-br2"
f=/tmp/.s.yml

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

# Create and yml file and write to /tmp/.s.yml
cat << EOF > $f
name: lab1
topology:
  defaults:
    kind: linux
  kinds:
    linux:
      image: docker.io/akpinar/alpine 
  nodes:
    h1:
      kind: linux
      mgmt_ipv4: 172.20.0.21
    h2:
      kind: linux      
      mgmt_ipv4: 172.20.0.22
    h3:
      kind: linux
      mgmt_ipv4: 172.20.0.23
    h4:
      kind: linux
      mgmt_ipv4: 172.20.0.24    
    h5:
      kind: linux
      mgmt_ipv4: 172.20.0.25  
    h6:
      kind: linux
      mgmt_ipv4: 172.20.0.26
    h7:
      kind: linux
      mgmt_ipv4: 172.20.0.27
    clab-br1: 
      kind: bridge
    clab-br2: 
      kind: bridge
  links:
    - endpoints: ["h1:eth1", "clab-br1:eth3"]
    - endpoints: ["h2:eth1", "clab-br1:eth4"]
    - endpoints: ["h3:eth1", "clab-br1:eth5"]
    - endpoints: ["h4:eth1", "clab-br1:eth6"]
    - endpoints: ["h5:eth1", "clab-br1:eth7"]
    - endpoints: ["h6:eth1", "clab-br1:eth8"]
    - endpoints: ["h7:eth1", "clab-br1:eth9"]
    - endpoints: ["h1:eth2", "clab-br2:eth3"]
    - endpoints: ["h2:eth2", "clab-br2:eth4"]
    - endpoints: ["h3:eth2", "clab-br2:eth5"]
    - endpoints: ["h4:eth2", "clab-br2:eth6"]
    - endpoints: ["h5:eth2", "clab-br2:eth7"]
    - endpoints: ["h6:eth2", "clab-br2:eth8"]
    - endpoints: ["h7:eth2", "clab-br2:eth9"]

mgmt: 
  network: srl-mgmt
  ipv4_subnet: 172.20.0.0/24
  ipv6_subnet: 2001:172:20::/80  
EOF

# Deploy the clab topology
sudo clab deploy --topo $f
