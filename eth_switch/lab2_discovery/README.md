<img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="200" height="100"> 

# Lab 2 Discovery
## Discovering & Illustrating Network Topology in an Ethernet Switched Network
### **Understanding deploy.sh**
The script **deploy.sh** is similar to the deploy.sh in Lab 1. Script deploy.sh:
```
1. Creates and enables Linux bridges
2. Creates a containerlab topology configuration file, but hides that file
3. Starts the lab network in containerlab
4. Configures IP addresses on the hosts
```
### **Understanding destroy.sh**
Script destroy.sh:
```
1. Recreates the containerlab topology configuration file
1. Stops the lab network and deletes the Docker containers
2. Deletes the containerlab topology configuration file
3. Deletes the Linux bridges
```
### **Lab Instructions**
The overall goal of this lab is to use the skills developed in Lab 1 Practice to discover the network deployed by deploy.sh and illustrating that network in a network diagram. 

Detailed lab instructions are in [Lab_Instructions.md](Lab_Instructions.md).

Lab submission requirements are in [Lab_Submission.md](Lab_Submission.md)

