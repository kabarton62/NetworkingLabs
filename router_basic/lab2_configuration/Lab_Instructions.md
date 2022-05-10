# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Vyos Router Configuration
### Challenge 1: Network Topology

This lab deploys a network with three routers (r1, r2 and r3), and three Linux hosts (h1 thru h3). Table 1, Node Details and Table 2, Links provide details about node configuration and links between nodes. Illustrate the network design. 

**Save the network diagram illustration to a file named lab2_topology.jpg or lab2_topology.png.** 

The network diagram must include:
* All nodes and links between nodes
* Interface number (i.e., eth1, eth2) for each link termination
* IP address for each link termination
* Node name (i.e., r1, h1)

---

|Node|Interface|IP Address/Mask|
|---|---|---|
|h1|eth1|192.168.10.15/24|
|h2|eth1|192.168.20.15/24|
|h3|eth1|192.168.30.15/24|
|r1|eth1|192.168.10.1/24|

**Table 1, Node Details**

---

|Links|
|---|
|h1:eth1 -> r1:eth1|
|h2:eth1 -> r2:eth1|
|h3:eth1 -> r3:eth1|
|r1:eth2 -> r2:eth2|
|r1:eth3 -> r3:eth2|
|r2:eth3 -> r3:eth3|

**Table 2, Links**

---


IP addresses and default gateways are configured on h1 through h4 when the network is deployed. At the time the network is deployed, routers r1 and r2 are not configured. The interfaces on r1 and r2 are not configured with IP addresses and there are no routes configured.

<img src="../images/router_basic_practice.png" width="900" height="600">
<sub><i>Figure 1. Network Topology</i></sub>
<p></p>
<p></p>

--- 
## Operating the Lab Network
### Challenge 2: Deploy the Lab Network
Launch the topology by running the script deploy.sh and **capture a screenshot of the results**.
```
  $ bash deploy.sh
```
--- 
## Testing Network Function
### Challenge 3: Examining host configuration

The host and router nodes in this lab do not have an SSH server running at start-up. *Docker exec* will be used to gain shell access to the nodes in this lab.
```
docker exec syntax:
 sudo docker exec -it <CONTAINER-NAME or CONTAINER-ID> bash

Example (getting shell in host h1):
 $ sudo docker exec -it clab-lab1-h1 bash
```
Get a shell on h1 and run the following commands. **Capture a screenshot of the results**. 

Examine the results of the **route** command. 
```
bash-5.1# ifconfig eth1
bash-5.1# route
```
Note interface eth1 has IP address 192.168.1.10 and Mask 255.255.255.0. This can also be annotated as 192.168.1.10/24. 

Note the *default route to Gateway 192.168.1.1*. As shown in the network topology, IP address 192.168.1.1 is r1 eth1. The destination IP address in a route is referred to as the **next-hop**, meaning that traffic forwarded to that route is sent to the next-hop router, in this case 192.168.1.1. A **route** is the series of hops (routers) used to forward a packet from the source to the destination.

--- 
