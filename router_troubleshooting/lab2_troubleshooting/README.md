# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab 1 Practice
## Troubleshooting routing
This lab uses a three-router topology built with Vyos router containers and four hosts. Routers and hosts have basic configurations. The network design is functional, but there are configuration errors on the routers. Troubleshoot and correct the router configuration errors. All hosts will be able to communicate 
### **Prerequisites**
Install docker-ce, containerlab, nmap, net-utils and bridge-utils by running the script [install.sh](../../install.sh)
```
$ bash install.sh
```
### **Understanding deploy.sh**
The script [deploy.sh](deploy.sh):
```
1. Creates and enables three Linux bridges, clab-br1, clab-br2, and clab-br3
2. Creates the containerlab topology configuration file, lab2.yml
3. Starts the lab network in containerlab
4. Configures IP addresses on interface eth1 on h101, h102 and h201
5. Copies router configuration files to r1 through r3
```
### **Understanding destroy.sh**
The script [destroy.sh](destroy.sh) is simpler than deploy.sh. Destroy.sh:
```
1. Stops the lab network and deletes the Docker containers
2. Deletes the containerlab topology configuration file, lab2.yml
3. Deletes the three Linux bridges
```
### **Lab Instructions**
Detailed lab instructions are in [Lab_Instructions.md](Lab_Instructions.md).
Lab submission requirements are in [Lab_Submission.md](Lab_Submission.md)
