#!/bin/bash
l=lab1
f=$l.yml

# Deploy the clab topology
sudo clab destroy --topo $f

# Remove containerlab topo file
sudo rm $f
