# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Network Topology
### Challenge 1: Network Topology

This lab deploys eight routers organized into three networks (North, Central and South). 

IP addresses are correctly configured on the router interfaces and host H1 has the an IP address and default gateway correctly configured. However, the routers only know the default Kernel routes and directly connected routes. No other routes are configured or known.

<p align="center">
<img src="../images/protocols-practice2.png" width="450" height="700">
</p>
<p align="center">
<sub><i>Figure 1. Network Topology</i></sub>
</p>

<p></p>
<p></p>

--- 
## Operating the Lab Network
### Challenge 2: Deploy the Lab Network
Launch the topology by running the script deploy.sh.
```
  $ bash deploy.sh
```
--- 
## Testing Network Function
### Challenge 3: Test network operation

*Docker exec* will be used to gain shell access to the nodes in this lab.
```
docker exec syntax:
 sudo docker exec -it <CONTAINER-NAME or CONTAINER-ID> bash

Example (getting shell in host h1):
 $ sudo docker exec -it clab-lab1-h1 bash
```
Get a shell on H1 and run the following commands. 

Attempt to ping the following and note the results:
- r5:eth1
- r5:eth2
- r5:eth3
- r4:eth3
- r6:eth2

1. **Report the results from attempted pings from h1 to r4, r5 and r6 interfaces.** 
2. **Describe which pings failed and which succeeded.**
3. **Explain why some pings failed and others succeeded.**

--- 
### Challenge 4: Configure RIP on North network

RIP is a distance-vector routing protocol. *Distance* is measured by hops. A *hop* is any routing device. For example, hops include routers, firewalls, and inline network intrusion detection systems (IDS). Hops do not include switches or other Layer 1 or Layer 2 devices. Vyos supports RIPv2. More details about RIP and Vyos' implementation of the protocol can be learned [here](https://blog.vyos.io/the-night-of-living-dead-protocols-ripv2). 

RIP is configured on all interfaces where you want to send and receive advertisements (messages that share routes). Interfaces that have RIP configured will automatically be included in the RIP table. For example, add interface eth2 on r1 to the RIP table with the command:
```
set protocols rip interface eth2
```

Networks on other interfaces can be explicitly added with the **rip network** command.
```
set protocols rip network 10.100.1.0/24
```
**Configure RIP on links between all routers in the North network (N-Link1 and N-Link2). R3:eth3 is included in the North network, R3:eth1 and :eth2 are not in the North network. R3:eth1 and :eth2 are in the Central network.**
**Add N-LAN1 and N-LAN2 networks to the rip table using the *rip network* command**

### Challenge 5: Inspect North Network Routing.
Vyos **show ip route** command shows:
- Known routes (outbound interface and next-hop IP address to reach a destination network)
- How those routes were learned (**C**onnected, **K**ernel, **S**tatic, **R**IP, etc)
- Which routes are selected (**>**)

Inspect routes on R3. 
1. **Report the routes learned by RIP.**

Inspect routes on R1.
1. **Predict if R1 could successfully ping R3:eth1.**
2. **Explain why you think R1 could or could not ping R3:eth1.**

### Challenge 6: Configure OSPF on the Central and South networks
OSPF is a Link-State routing protocol. Link-state routing protocols construct a mathematical model of known networks and the links between nodes. Preferred routes are chosen by the lowest cost routes. Cost in link-state routing protocols generally reflects network performance or capacity, meaning that networks with the greatest network speed have the lowest cost. Routes with the lowest combined cost would be the preferred route to a destination network.

OSPF stores routing information in three tables:
- Neighbor table
- Topology table
- Routing table

In very large networks, the detailed information stored by each router can consume enough resources on the routers to impact OSPF protocol performance. Therefore, OSPF includes a mechanism to segment large networks into *Areas*.
