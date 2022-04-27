# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Network Topology and Reading deploy.sh
### **Challenge 1: Network Topology**

This lab deploys a simple network with two routers (r1 and r2), two Ethernet switches (clab-br1 and clab-br2) and four Linux hosts (h1 thru h4). Hosts h1 and h2 are in the same network (192.168.1.0/24), and r1 eth1 is the **default gateway** for that network. **A default gateway is the designated first hop for all traffic out of a network when no higher priority route is configured. In essence, traffic destined to hosts outside of the local network are forwarded to the default gateway. The default gateway is responsible for forwarding traffic to other networks.** Hosts h3 and h4 are in 192.168.2.0/24 and r2 eth1 is the default gateway for h3 and h4. Routers r1 and r2 are connected via an Ethernet link. The link connects to interface eth2 on each router.

IP addresses and default gateways are configured on h1 through h4 when the network is deployed. At the time the network is deployed, routers r1 and r2 are not configured. The interfaces on r1 and r2 are not configured with IP addresses and there are no routes configured.

<img src="../images/router_basic_practice.png" width="900" height="600">
<sub><i>Figure 1. Network Topology</i></sub>
<p></p>
<p></p>

--- 
## Operating the Lab Network
### **Challenge 2: Deploy the Lab Network**
Launch the topology by running the script deploy.sh and **capture a screenshot of the results**.
```
  $ bash deploy.sh
```
--- 
### **Challenge 3: Examining host configuration**

The host and router nodes in this lab do not have an SSH server running. *Docker exec* will be used to gain shell access to the nodes in this lab.
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
### **Challenge 4: Examining network traffic**

Start network testing from h1. We know IP addresses on the hosts are configured, so test network connectivity from h1 to h2, h3 and h4 using the ping command. Note the results.
```
bash-5.1# ping 192.168.1.200
bash-5.1# ping 192.168.2.15
bash-5.1# ping 192.168.2.215
```
Pings were successful from h1 to h2, but failed to h3 and h4. Although we know r1 is not configured, try to ping 192.168.1.1 and note the response. Are the responses different from the failed pings to h3/h4 and r1?

---
### **Challenge 5: Configure Default Gateway Interfaces**
Interface eth1 on r1 and r2 are used as the default gateways to networks 192.168.1.0/24 and 192.168.2.0/24. However, those interfaces are not configured. This challenge introduces you interface configuration on FRRouting routers. Routers r1 and r2 are Linux containers. FRRouting runs inside those containers. The containers do not have an SSH server installed or running, so use **docker exec** to obtain a shell in r1. 
```
$ sudo docker exec -it clab-lab1-r1 bash
bash-5.0# 
```
With a shell in r1, use the command **vtysh** to get a shell in FRRouting. This will enter VTY View & Enable Mode (VTY view/enable).
```
bash-5.0# vtysh
% Can't open configuration file /etc/frr/vtysh.conf due to 'No such file or directory'.

Hello, this is FRRouting (version 7.5_git).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

r1# 
```
Examine the running configuration.
```
r1# show running
Building configuration...
Current configuration:
!
frr version 7.5_git
frr defaults traditional
hostname r1
no ipv6 forwarding
!
line vty
!
end
```
Note that there currently are no interfaces configured. So, configure eth1 (the default gateway). To configure an interface, go to configure mode (**configure terminal**). Note, FRRouting supports truncated commands (conf t in place of configure terminal), the select an interface to configure (**interface eth1** or int eth1).

Use the **ip address** command to configure the interface. For example, **ip add 192.168.1.1/24**.
```
r1# conf t
r1(config)# int eth1
r1(config-if)# ip add 192.168.1.1/24
```
Use the **exit** command twice to return to VTY view/enable mode and run the **show run** command again.
```
r1(config-if)# exit
r1(config)# exit
r1# show run
Building configuration...
Current configuration:
!
frr version 7.5_git
frr defaults traditional
hostname r1
no ipv6 forwarding
!
interface eth1
 ip address 192.168.1.1/24
!
line vty
!
end
```
Note interface eth1 has the IP address and subnet mask configured. Test network operation again.

---
### **Challenge 6: Test the Default Gateway

Challenge 5 modified the network topology illustrated in Challenge 1. Use diagramming software, such as [Lucidchart](https://www.lucidchart.com/pages/) or Visio or whatever you like to illustrate the network you created in Challenge 6. The diagram should:
1. Name switches and hosts
2. Provide host IP addresses
3. Accruately illustrate the organization of network devices (switches/bridges and hosts)

Both Lucidchart and Visio allow the use of various stencils or shapes. In Lucidcharts, start a drawing, select **Shapes** and **Cisco Network Icons**. In Visio, select **More Shapes** and **Open Stencils**. Open a stencil. You can download Cisco icons from [Cisco](https://www.cisco.com/c/en/us/about/brand-center/network-topology-icons.html).

**Save the network diagram as a pdf, png, or jpg file.** 
