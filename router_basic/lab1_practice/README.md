# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab 1 Practice
## Practicing with Vyos in containerlab
This lab uses a two-router topology built with Vyos router containers. The hosts h1 through h4 have basic IP address and default gateway configurations but routers r1 and r2 are not configured. The lab runs some basic network troubleshooting steps on the hosts and then walks through interface configurations on r1 and r2. Static routes are introduced as Stretch challenges.
### **Prerequisites**
Install docker-ce, containerlab, nmap, net-utils and bridge-utils by running the script [install.sh](../../install.sh)
```
$ bash install.sh
```
### **Understanding deploy.sh**
The script [deploy.sh](deploy.sh):
```
1. Creates and enables two Linux bridges, clab-br1 and clab-br2
2. Creates the containerlab topology configuration file, lab1.yml
3. Starts the lab network in containerlab
4. Configures IP addresses on interface eth1 on h1 through h4
```
### **Understanding destroy.sh**
The script [destroy.sh](destroy.sh) is simpler than deploy.sh. Destroy.sh:
```
1. Stops the lab network and deletes the Docker containers
2. Deletes the containerlab topology configuration file, lab1.yml
3. Deletes the two Linux bridges, clab-br1 and clab-br2
```
### **Lab Instructions**
Detailed lab instructions are in [Lab_Instructions.md](Lab_Instructions.md).
Lab submission requirements are in [Lab_Submission.md](Lab_Submission.md)
