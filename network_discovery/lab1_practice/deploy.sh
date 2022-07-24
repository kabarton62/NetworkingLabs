#!/bin/bash
br1="clab-br1"
l=lab1
f=$l.yml
h='kbartontx/network-tools:latest'
router='kbartontx/vyos:1.4'
z35='kbartontx/bind9:latest'
web='kbartontx/apache2.4.49:cve-2021-41773'
wes='silvade/ngnix-static:latest'
duc='kbartontx/vs-ft-pd:latest'
flx='kbartontx/deb-tomc:latest'

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
      publish: 
      - tcp/2222
    t1:
      kind: linux
      image: $flx
    zin:
      kind: linux
      image: $duc
    zan:
      kind: linux
      image: $z35
    zue:
      kind: linux
      image: $wes
    dav:
      kind: linux
      image: $router
    mar:
      kind: linux
      image: $router
    alp:
      kind: linux
      image: $router
    clab-br1: 
      kind: bridge
  links:
    - endpoints: ["dav:eth1", "h1:eth2"]
    - endpoints: ["mar:eth1", "t1:eth1"]
    - endpoints: ["zan:eth1", "clab-br1:eth10"]
    - endpoints: ["zue:eth1", "clab-br1:eth11"]
    - endpoints: ["zin:eth1", "clab-br1:eth12"]
    - endpoints: ["alp:eth1", "clab-br1:eth13"]
    - endpoints: ["dav:eth2", "mar:eth2"]
    - endpoints: ["mar:eth3", "alp:eth3"]
mgmt: 
  network: mgmt
  ipv4_subnet: 172.20.0.0/24
  ipv6_subnet: 2001:172:20::/80  
EOF

# Deploy the clab topology
sudo clab deploy --topo $f

# Configure IPs on hosts
d="sudo docker"
a1=10.200.1.16/24
a2=10.200.1.22/24
a3=10.200.1.88/24
a4=10.100.1.65/24
a5=10.150.1.99/24
b1="dev eth1"
h1="clab-$l-h1"
t1="clab-$l-t1"
w="clab-$l-zue"
n="clab-$l-zan"
f="clab-$l-zin"
davi="clab-$l-dav"
marf="clab-$l-mar"
alpi="clab-$l-alp"
conf="/opt/vyatta/etc/config/config.boot"
gw=172.20.0.1

# Configure static IP addresses
$d exec -it $f ip addr add $a1 $b1
$d exec -it $n ip addr add $a2 $b1
$d exec -it $w ip addr add $a3 $b1
$d exec -it $h1 ip addr add $a4 dev eth2
$d exec -it $t1 ip addr add $a5 $b1

# Configure default gateways on hosts
$d exec -it $h1 route add default gw 10.100.1.1 eth2
$d exec -it $n route add default gw 10.200.1.1 eth1
$d exec -it $f route add default gw 10.200.1.1 eth1
$d exec -it $w route add default gw 10.200.1.1 eth1
$d exec -it $t1 route add default gw 10.150.1.1 eth1

# Copy router and h1 config files
$d cp r1.config.boot $davi:$conf
$d cp r2.config.boot $marf:$conf
$d cp r3.config.boot $alpi:$conf
$d cp hosts.sh $h1:/hosts.sh
$d exec -it $h1 bash hosts.sh

printf "Wait 120 seconds to reboot routers\n"
sleep 30

printf "90 seconds left ...\n"
sleep 30

printf "60 seconds left ... I know, but please wait\n"
sleep 30

printf "30 seconds left ... almost done, I promise\n"
sleep 30
