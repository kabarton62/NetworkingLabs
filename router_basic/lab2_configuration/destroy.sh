#!/bin/bash
l=lab2
f=$l.yml

# Deploy the clab topology
sudo clab destroy --topo $f

# Remove containerlab topo file
sudo rm $f
