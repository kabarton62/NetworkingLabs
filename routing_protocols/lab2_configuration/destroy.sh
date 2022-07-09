#!/bin/bash
br1="clab-br1"
br2="clab-br2"
br3="clab-br3"
br4="clab-br4"
br5="clab-br5"
f=lab2.yml

# Deploy the clab topology
sudo clab destroy --topo $f

# Remove containerlab topo file
sudo rm $f

# Clean up bridges
sudo ip link set $br1 down
sudo ip link set $br2 down
sudo ip link set $br3 down
sudo ip link set $br4 down
sudo ip link set $br5 down
sudo brctl delbr $br1
sudo brctl delbr $br2
sudo brctl delbr $br3
sudo brctl delbr $br4
sudo brctl delbr $br5
