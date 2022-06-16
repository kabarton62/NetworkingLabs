#!/bin/bash
br1="clab-br1"
br2="clab-br2"
f=/tmp/.s.yml

# Create and yml file and write to /tmp/.s.yml
cat << EOF > $f
name: lab2
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
    - endpoints: ["h1:eth1", "clab-br1:eth13"]
#    - endpoints: ["h2:eth1", "clab-br1:eth14"]
    - endpoints: ["h3:eth1", "clab-br1:eth15"]
#    - endpoints: ["h4:eth1", "clab-br1:eth16"]
    - endpoints: ["h5:eth1", "clab-br1:eth17"]
#    - endpoints: ["h6:eth1", "clab-br1:eth18"]
    - endpoints: ["h7:eth1", "clab-br1:eth19"]
#    - endpoints: ["h1:eth2", "clab-br2:eth23"]
    - endpoints: ["h2:eth2", "clab-br2:eth24"]
#    - endpoints: ["h3:eth2", "clab-br2:eth25"]
    - endpoints: ["h4:eth2", "clab-br2:eth26"]
#    - endpoints: ["h5:eth2", "clab-br2:eth27"]
    - endpoints: ["h6:eth2", "clab-br2:eth28"]
#    - endpoints: ["h7:eth2", "clab-br2:eth29"]
mgmt: 
  network: srl-mgmt
  ipv4_subnet: 172.20.0.0/24
  ipv6_subnet: 2001:172:20::/80  
EOF

# Deploy the clab topology
sudo clab destroy --topo $f

# Remove containerlab topo file
sudo rm $f

# Clean up bridges
sudo ip link set $br1 down
sudo ip link set $br2 down
sudo brctl delbr $br1
sudo brctl delbr $br2
