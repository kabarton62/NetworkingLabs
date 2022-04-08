#!/bin/bash
bridge="clab-br"
sudo brctl delbr $bridge
sudo brctl addbr $bridge
sudo ip link set $bridge up
sudo iptables -I FORWARD -i $bridge -j ACCEPT
