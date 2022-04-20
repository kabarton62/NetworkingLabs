# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Discovering & Illustrating Network Topology in an Ethernet Switched Network
### Challenge 1: Deploy the Network
1. Clone the repository https://github.com/kabarton62/NetworkingLabs.git
2. Change directory to NetworkingLabs/eth_switch/lab2_discovery/
3. Change file permission to make lab2.x and destroy-lab2.x executable
```
$ chmod u+x *.x
```
4. Execute lab2.x
```
./lab2.x
```
---

### Challenge 2: Network Discovery
Use containerlab feedback and utilities such as brctl, ifconfig, ip a, and ping to discover hosts and configuration. Note that a shell can be opened in any of the hosts created by lab2.x using SSH. **The username and password for every host created in lab2.x is admin/admin**.

### Challenge 3: Illustrate Network Topology
Create a network diagram that accurately and completely illustrates the network topology. Node, network devices, links, and IP addresses must be explicitly reported in the network diagram.

### Challenge 4: Destroy the Network
Use destroy-lab2.x to destroy the network. Not sure how to destroy the network with destroy-lab2.x? Adapt information from Challenge 1 to complete this challenge.
